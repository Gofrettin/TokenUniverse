unit NtUtils.ApiExtension;

interface
{$WARN SYMBOL_PLATFORM OFF}

uses
  Winapi.WinNt, Ntapi.ntdef, Ntapi.ntobapi, Ntapi.ntseapi, NtUtils.Exceptions;

{ -------------------------------- Objects --------------------------------- }

// NtClose without exceptions on protected handles
function NtxSafeClose(hObject: THandle): NTSTATUS;

// NtQueryObject with ObjectNameInformation
function NtxQueryNameObject(hObject: THandle; out Name: String): NTSTATUS;

// NtDuplicateObject that supports MAXIMUM_ALLOWED
function NtxDuplicateObject(SourceProcessHandle: THandle;
  SourceHandle: THandle; TargetProcessHandle: THandle;
  out TargetHandle: THandle; DesiredAccess: TAccessMask;
  HandleAttributes: Cardinal; Options: Cardinal): NTSTATUS;

{ -------------------------------- Tokens ---------------------------------- }

// NtQueryInformationToken for variable-sized buffers without race conditions
function NtxQueryBufferToken(hToken: THandle; InfoClass: TTokenInformationClass;
  out Status: NTSTATUS; ReturnedSize: PCardinal = nil): Pointer;

// NtCompareObjects for comparing tokens on all versions of Windows
function NtxCompareTokens(hToken1, hToken2: THandle): NTSTATUS;

// NtDuplicateToken
function NtxDuplicateToken(hExistingToken: THandle;
  DesiredAccess: TAccessMask; TokenType: TTokenType;
  ImpersonationLevel: TSecurityImpersonationLevel; EffectiveOnly: LongBool;
  out hNewToken: THandle): NTSTATUS;

// NtSetInformationThread that doesn't duplicate tokens to Identification level
function NtxSafeSetThreadToken(hThread: THandle; hToken: THandle): NTSTATUS;

// NtSetInformationThread + NtOpenThreadTokenEx
function NtxImpersonateToken(hToken: THandle; out hOldToken: THandle):
  TNtxStatus;

{ ---------------------------------- RTL ----------------------------------- }

// RtlConvertSidToUnicodeString that uses delphi strings
function RtlxConvertSidToString(SID: PSid): String;

implementation

uses
  Ntapi.ntstatus, Ntapi.ntpsapi, Ntapi.ntrtl,
  NtUtils.Snapshots.Handles, NtUtils.DelayedImport, System.SysUtils;

{ Objects }

function NtxSafeClose(hObject: THandle): NTSTATUS;
begin
  if hObject = NtCurrentProcess then
    Exit(STATUS_INVALID_HANDLE);

  if hObject = NtCurrentThread then
    Exit(STATUS_INVALID_HANDLE);

  Result := STATUS_UNSUCCESSFUL;
  try
    // NtClose can raise errors, we should capture them
    Result := NtClose(hObject);
  except
    on E: EExternalException do
      if Assigned(E.ExceptionRecord) then
        Result := E.ExceptionRecord.ExceptionCode;
  end;
end;

function NtxQueryNameObject(hObject: THandle; out Name: String): NTSTATUS;
var
  Buffer: PUNICODE_STRING;
  BufferSize: Cardinal;
begin
  BufferSize := 0;
  Result := NtQueryObject(hObject, ObjectNameInformation, nil, 0, @BufferSize);

  if not NtxTryCheckBuffer(Result, BufferSize) then
    Exit;

  Buffer := AllocMem(BufferSize);
  try
    Result := NtQueryObject(hObject, ObjectNameInformation, Buffer, BufferSize,
      nil);

    if NT_SUCCESS(Result) then
      Name := Buffer.ToString;
  finally
    FreeMem(Buffer);
  end;
end;

function NtxDuplicateObject(SourceProcessHandle: THandle;
  SourceHandle: THandle; TargetProcessHandle: THandle;
  out TargetHandle: THandle; DesiredAccess: TAccessMask;
  HandleAttributes: Cardinal; Options: Cardinal): NTSTATUS;
var
  hSameAccess, hTemp: THandle;
  objInfo: TObjectBasicInformaion;
  handleInfo: TObjectHandleFlagInformation;
  bit: Integer;
label
  MaskExpandingDone;
begin
  // NtDuplicateObject does not support MAXIMUM_ALLOWED (it returns zero
  // access instead). We will implement this feature by probing additional
  // access masks.

  if (DesiredAccess = MAXIMUM_ALLOWED) and
    (Options and DUPLICATE_SAME_ACCESS = 0) then
  begin
    // To prevent race conditions we duplicate the handle to the current process
    // with the same access and attributes to perform all further probing on it.
    // This operation might close the source handle if DUPLICATE_CLOSE_SOURCE is
    // specified.

    Result := NtDuplicateObject(SourceProcessHandle, SourceHandle,
      NtCurrentProcess, hSameAccess, 0, HandleAttributes,
      Options or DUPLICATE_SAME_ACCESS);

    // If we can't do it we are finished
    if not NT_SUCCESS(Result) then
      Exit;

    // Start probing. Try full access first.
    DesiredAccess := STANDARD_RIGHTS_ALL or SPECIFIC_RIGHTS_ALL;

    Result := NtDuplicateObject(NtCurrentProcess, hSameAccess, NtCurrentProcess,
      hTemp, DesiredAccess, 0, 0);

    // Was the guess correct?
    if NT_SUCCESS(Result) then
    begin
      NtxSafeClose(hTemp);
      goto MaskExpandingDone;
    end;

    // Did something else happen?
    if Result <> STATUS_ACCESS_DENIED then
      Exit;

    // Query what access we already have based on DUPLICATE_SAME_ACCESS flag
    if NT_SUCCESS(NtQueryObject(hSameAccess, ObjectBasicInformation, @objInfo,
      SizeOf(objInfo), nil)) then
      DesiredAccess := objInfo.GrantedAccess and not ACCESS_SYSTEM_SECURITY
    else
      DesiredAccess := 0;

    // Try each one standard or specific access right that is not granted yet
    for bit := 0 to 31 do
      if ((STANDARD_RIGHTS_ALL or SPECIFIC_RIGHTS_ALL) and (1 shl bit)
        and not DesiredAccess) <> 0 then
        if NT_SUCCESS(NtDuplicateObject(NtCurrentProcess, hSameAccess,
          NtCurrentProcess, hTemp, (1 shl bit), 0, 0)) then
        begin
          // Yes, this access can be granted, add it
          DesiredAccess := DesiredAccess or (1 shl bit);
          NtxSafeClose(hTemp);
        end;

    // Finally, duplicate the handle to the target process with the requested
    // attributes and expanded maximum access
    MaskExpandingDone:

    Result := NtDuplicateObject(NtCurrentProcess, hSameAccess,
      TargetProcessHandle, TargetHandle, DesiredAccess, HandleAttributes,
      Options and not DUPLICATE_CLOSE_SOURCE);

    // Make sure our copy is closable by clearing protection
    if (Options and DUPLICATE_SAME_ATTRIBUTES <> 0) or
      (HandleAttributes and OBJ_PROTECT_CLOSE <> 0) then
    begin
      handleInfo.Inherit := False;
      handleInfo.ProtectFromClose := False;

      NtSetInformationObject(hSameAccess, ObjectHandleFlagInformation,
        @handleInfo, SizeOf(handleInfo));
    end;

    // Close local copy
    NtxSafeClose(hSameAccess);
  end
  else
  begin
    // Usual case
    Result := NtDuplicateObject(SourceProcessHandle, SourceHandle,
      TargetProcessHandle, TargetHandle, DesiredAccess, HandleAttributes,
      Options);
  end;
end;

{ Tokens }

function NtxQueryBufferToken(hToken: THandle; InfoClass: TTokenInformationClass;
  out Status: NTSTATUS; ReturnedSize: PCardinal): Pointer;
var
  BufferSize, RequiredSize: Cardinal;
begin
  Result := nil;
  BufferSize := 0;
  RequiredSize := 0;

  // The requested information length might change between calls. Prevent
  // the race condition with a loop.
  while True do
  begin
    Status := NtQueryInformationToken(hToken, InfoClass, Result, BufferSize,
      RequiredSize);

    // Quit the loop on success
    if NT_SUCCESS(Status) then
    begin
      if Assigned(ReturnedSize) then
        ReturnedSize^ := BufferSize;
      Exit;
    end;

    // Quit on errors that are not related to the buffer size
    if not NtxTryCheckBuffer(Status, RequiredSize) then
      Exit(nil);

    // Free previous buffer and allocate a new one
    FreeMem(Result);

    BufferSize := RequiredSize;
    Result := AllocMem(BufferSize);
  end;
end;

function NtxpQueryStatisticsToken(hToken: THandle;
  out Statistics: TTokenStatistics): NTSTATUS;
var
  Returned: Cardinal;
  hTemp: THandle;
begin
  Result := NtQueryInformationToken(hToken, TokenStatistics, @Statistics,
    SizeOf(Statistics), Returned);

  // Process the case of a handle with no QUERY access
  if Result = STATUS_ACCESS_DENIED then
  begin
    Result := NtDuplicateObject(NtCurrentProcess, hToken, NtCurrentProcess,
      hTemp, TOKEN_QUERY, 0, 0);

    if NT_SUCCESS(Result) then
    begin
      Result := NtQueryInformationToken(hTemp, TokenStatistics, @Statistics,
        SizeOf(Statistics), Returned);

      NtxSafeClose(hTemp);
    end;
  end;
end;

function NtxCompareTokens(hToken1, hToken2: THandle): NTSTATUS;
var
  Statistics1, Statistics2: TTokenStatistics;
begin
  if hToken1 = hToken2 then
    Exit(STATUS_SUCCESS);

  // Win 10 TH+ makes things way easier
  if NtxCheckNtDelayedImport('NtCompareObjects').IsSuccess then
    Exit(NtCompareObjects(hToken1, hToken2));

  // Try to perform a comparison based on TokenIDs. NtxpQueryStatisticsToken
  // might be capable of handling it even without TOKEN_QUERY access.

  Result := NtxpQueryStatisticsToken(hToken1, Statistics1);
  if NT_SUCCESS(Result) then
  begin
    Result := NtxpQueryStatisticsToken(hToken2, Statistics2);

    if NT_SUCCESS(Result) then
    begin
      if Statistics1.TokenId = Statistics2.TokenId then
        Exit(STATUS_SUCCESS)
      else
        Exit(STATUS_NOT_SAME_OBJECT);
    end;
  end;

  if Result <> STATUS_ACCESS_DENIED then
    Exit;

  // The only way to proceed is via a handle snaphot
  Result := THandleSnapshot.Compare(hToken1, hToken2);
end;

function NtxDuplicateToken(hExistingToken: THandle;
  DesiredAccess: TAccessMask; TokenType: TTokenType;
  ImpersonationLevel: TSecurityImpersonationLevel; EffectiveOnly: LongBool;
  out hNewToken: THandle): NTSTATUS;
var
  ObjAttr: TObjectAttributes;
  QoS: TSecurityQualityOfService;
begin
  InitializaQoS(QoS, ImpersonationLevel, EffectiveOnly);
  InitializeObjectAttributes(ObjAttr, nil, 0, 0, @QoS);

  Result := NtDuplicateToken(hExistingToken, DesiredAccess, @ObjAttr,
    EffectiveOnly, TokenType, hNewToken);
end;

{ Some notes about impersonation...

 * In case of absence of SeImpersonatePrivilege some security contexts
   might cause the system to duplicate the token to Identification level
   which fails all access checks. The result of NtSetInformationThread
   does not provide information whether it happened.
   The goal is to detect and avoid such situations.

 * NtxSafeSetThreadToken sets the token, queries it back, and compares them.
   Anything but success causes the routine to revoke the token.

 * Although it tries to, the function does not guarantee the secutity
   context of the target thread to return to the state before the call.
   It is potentially possible to user NtImpersonateThread to retrive a copy
   of the original security context if NtOpenThreadTokenEx fails with
   ACCESS_DENIED.

 * Remark: NtImpersonateThread fails with BAD_IMPERSONATION_LEVEL when we
   request Impersonation-level token while the thread's token is Identification
   and less. This in another way to implement the check.
}

function NtxSafeSetThreadToken(hThread: THandle; hToken: THandle): NTSTATUS;
var
  hOldStateToken, hNewToken: THandle;
begin
  // Backup old state
  if not NT_SUCCESS(NtOpenThreadTokenEx(hThread, TOKEN_IMPERSONATE, False, 0,
    hOldStateToken)) then
    hOldStateToken := 0;

  // Set our token
  Result := NtSetInformationThread(hThread, ThreadImpersonationToken, @hToken,
    SizeOf(hToken));

  if not NT_SUCCESS(Result) then
    Exit;

  // Query what was actually set
  Result := NtOpenThreadTokenEx(hThread, MAXIMUM_ALLOWED,
    (hThread = NtCurrentThread), 0, hNewToken);

  if not NT_SUCCESS(Result) then
  begin
    // Reset and exit
    NtSetInformationThread(hThread, ThreadImpersonationToken, @hOldStateToken,
      SizeOf(hOldStateToken));
    Exit;
  end;

  if hThread = NtCurrentThread then
  begin
    // Revert to self to perform comparison
    NtSetInformationThread(hThread, ThreadImpersonationToken, @hOldStateToken,
      SizeOf(hOldStateToken));
  end;

  // Compare
  Result := NtxCompareTokens(hToken, hNewToken);
  NtxSafeClose(hNewToken);

  // STATUS_SUCCESS => Impersonation works fine, use it.
  // STATUS_NOT_SAME_OBJECT => Duplication happened, reset and exit
  // Oher errors => Reset and exit

  // SeImpersonatePrivilege can help
  if Result = STATUS_NOT_SAME_OBJECT then
    Result := STATUS_PRIVILEGE_NOT_HELD;

  if Result = STATUS_SUCCESS then
  begin
    // Repeat in case of current thread
    if hThread = NtCurrentThread then
      Result := NtSetInformationThread(hThread, ThreadImpersonationToken,
        @hToken, SizeOf(hToken));
  end
  else
  begin
    // Reset impersonation
    NtSetInformationThread(hThread, ThreadImpersonationToken, @hOldStateToken,
      SizeOf(hOldStateToken));
  end;

  if hOldStateToken <> 0 then
    NtxSafeClose(hOldStateToken);
end;

function NtxImpersonateToken(hToken: THandle; out hOldToken: THandle):
  TNtxStatus;
var
  hTokenDuplicate: THandle;
begin
  Result.Status := STATUS_SUCCESS;

  // Save old token
  if not NT_SUCCESS(NtOpenThreadTokenEx(NtCurrentThread, TOKEN_IMPERSONATE,
    True, 0, hOldToken)) then
    hOldToken := 0;

  // Impersonate
  Result.Location := 'NtSetInformationThread';
  Result.Status := NtSetInformationThread(NtCurrentThread,
    ThreadImpersonationToken, @hToken, SizeOf(hToken));

  if Result.Status = STATUS_BAD_TOKEN_TYPE then
  begin
    // This was a primary token, duplicate it
    Result.Location := 'NtDuplicateToken';
    Result.Status := NtxDuplicateToken(hToken, TOKEN_IMPERSONATE,
      TokenImpersonation, SecurityImpersonation, False, hTokenDuplicate);

    if not NT_SUCCESS(Result.Status) then
      Exit;

    // Impersonate, second attempt
    Result.Location := 'NtSetInformationThread';
    Result.Status := NtSetInformationThread(NtCurrentThread,
      ThreadImpersonationToken, @hTokenDuplicate, SizeOf(hTokenDuplicate));

    NtClose(hTokenDuplicate);
  end;
end;

{ RTL }

function RtlxConvertSidToString(SID: PSid): String;
var
  SDDL: UNICODE_STRING;
  Buffer: array [0 .. SECURITY_MAX_SID_STRING_CHARACTERS] of WideChar;
begin
  SDDL.Length := 0;
  SDDL.MaximumLength := SECURITY_MAX_SID_STRING_CHARACTERS;
  SDDL.Buffer := PWideChar(@Buffer);

  if NT_SUCCESS(RtlConvertSidToUnicodeString(SDDL, SID, False)) then
    Result := SDDL.ToString
  else
    Result := '';
end;

end.
