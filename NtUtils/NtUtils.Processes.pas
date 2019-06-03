unit NtUtils.Processes;

interface

uses
  Winapi.WinNt, NtUtils.Exceptions;

// Open the process. Always succeeds for current process.
function NtxOpenProcess(out hProcess: THandle; DesiredAccess: TAccessMask;
  PID: NativeUInt): TNtxStatus;

// Open the thread. Always succeeds for current thread.
function NtxOpenThread(out hThread: THandle; DesiredAccess: TAccessMask;
  TID: NativeUInt): TNtxStatus;

// Reopen a handle to the current process with the specific access
function NtxOpenCurrentProcess(out hProcess: THandle;
  DesiredAccess: TAccessMask; HandleAttributes: Cardinal): TNtxStatus;

// Reopen a handle to the current thread with the specific access
function NtxOpenCurrentThread(out hThread: THandle;
  DesiredAccess: TAccessMask; HandleAttributes: Cardinal): TNtxStatus;

// Query process's image name in Win32 format
function NtxQueryImageProcess(hProcess: THandle;
  out FileName: String): TNtxStatus;
function NtxTryQueryImageProcessById(PID: NativeUInt): String;

// Fail if the current process is running under WoW64
function NtxAssertNotWoW64: TNtxStatus;

implementation

uses
  Ntapi.ntdef, Ntapi.ntstatus, Ntapi.ntpsapi, Ntapi.ntobapi,
  DelphiUtils.Strings, NtUtils.AccessMasks;

function NtxpOpenProcess(out hProcess: THandle; DesiredAccess: TAccessMask;
  PID: NativeUInt): NTSTATUS;
var
  ClientId: TClientId;
  ObjAttr: TObjectAttributes;
begin
  if PID = NtCurrentProcessId then
  begin
    hProcess := NtCurrentProcess;
    Result := STATUS_SUCCESS;
  end
  else
  begin
    InitializeObjectAttributes(ObjAttr);
    ClientId.Create(PID, 0);
    Result := NtOpenProcess(hProcess, DesiredAccess, ObjAttr, ClientId);
  end;
end;

function NtxOpenProcess(out hProcess: THandle; DesiredAccess: TAccessMask;
  PID: NativeUInt): TNtxStatus;
begin
  Result.Location := 'NtOpenProcess for ' + FormatAccess(DesiredAccess,
    ObjProcess);
  Result.Status := NtxpOpenProcess(hProcess, DesiredAccess, PID);
end;


function NtxOpenThread(out hThread: THandle; DesiredAccess: TAccessMask;
  TID: NativeUInt): TNtxStatus;
var
  ClientId: TClientId;
  ObjAttr: TObjectAttributes;
begin
  if TID = NtCurrentThreadId then
  begin
    hThread := NtCurrentThread;
    Result.Status := STATUS_SUCCESS;
  end
  else
  begin
    InitializeObjectAttributes(ObjAttr);
    ClientId.Create(0, TID);
    Result.Status := NtOpenThread(hThread, DesiredAccess, ObjAttr, ClientId);

    if not Result.IsSuccess then
      Result.Location := 'NtOpenThread for ' +
        FormatAccess(DesiredAccess, objThread);
  end;
end;

function NtxOpenCurrentProcess(out hProcess: THandle;
  DesiredAccess: TAccessMask; HandleAttributes: Cardinal): TNtxStatus;
var
  Flags: Cardinal;
begin
  // Duplicating the pseudo-handle is more reliable then opening process by PID

  if DesiredAccess = MAXIMUM_ALLOWED then
  begin
    Flags := DUPLICATE_SAME_ACCESS;
    DesiredAccess := 0;
  end
  else
    Flags := 0;

  Result.Location := 'NtDuplicateObject';
  Result.Status := NtDuplicateObject(NtCurrentProcess, NtCurrentProcess,
    NtCurrentProcess, hProcess, DesiredAccess, HandleAttributes, Flags);
end;

function NtxOpenCurrentThread(out hThread: THandle;
  DesiredAccess: TAccessMask; HandleAttributes: Cardinal): TNtxStatus;
var
  Flags: Cardinal;
begin
  // Duplicating the pseudo-handle is more reliable then opening thread by TID

  if DesiredAccess = MAXIMUM_ALLOWED then
  begin
    Flags := DUPLICATE_SAME_ACCESS;
    DesiredAccess := 0;
  end
  else
    Flags := 0;

  Result.Location := 'NtDuplicateObject';
  Result.Status := NtDuplicateObject(NtCurrentProcess, NtCurrentThread,
    NtCurrentProcess, hThread, DesiredAccess, HandleAttributes, Flags);
end;

function NtxQueryImageProcess(hProcess: THandle;
  out FileName: String): TNtxStatus;
const
  MAX_NAME = SizeOf(UNICODE_STRING) + High(Word) + 1 + SizeOf(WideChar);
var
  Buffer: PUNICODE_STRING;
begin
  Buffer := AllocMem(MAX_NAME);

  try
    // Requires PROCESS_QUERY_LIMITED_INFORMATION
    Result.Location := 'NtQueryInformationProcess [ProcessImageFileNameWin32]';
    Result.Status := NtQueryInformationProcess(hProcess,
      ProcessImageFileNameWin32, Buffer, MAX_NAME, nil);

    FileName := Buffer.ToString;
  finally
    FreeMem(Buffer);
  end;
end;

function NtxTryQueryImageProcessById(PID: NativeUInt): String;
var
  hProcess: THandle;
begin
  Result := '';

  if NT_SUCCESS(NtxpOpenProcess(hProcess, PROCESS_QUERY_LIMITED_INFORMATION,
    PID)) then
    NtxQueryImageProcess(hProcess, Result);
end;

function NtxAssertNotWoW64: TNtxStatus;
var
  IsWoW64: NativeUInt;
begin
  Result.Location := 'NtQueryInformationProcess [ProcessWow64Information]';
  Result.Status := NtQueryInformationProcess(NtCurrentProcess,
    ProcessWow64Information, @IsWoW64, SizeOf(IsWoW64), nil);

  if NT_SUCCESS(Result.Status) and (IsWoW64 <> 0) then
  begin
    Result.Location := '[WoW64 assertion]';
    Result.Status := STATUS_ASSERTION_FAILURE;
  end;
end;

end.
