unit NtUtils.Svc.Security;

interface

uses
  Winapi.WinNt, Winapi.Svc, NtUtils.Exceptions, NtUtils.Security.Acl,
  NtUtils.Security.Sid;

type
  TAce = NtUtils.Security.Acl.TAce;
  IAcl = NtUtils.Security.Acl.IAcl;
  TAcl = NtUtils.Security.Acl.TAcl;
  ISid = NtUtils.Security.Sid.ISid;

{ Query security }

// Security descriptor
function ScmxQuerySecurityObject(ScmHandle: TScmHandle; SecurityInformation:
  TSecurityInformation; out SecDesc: PSecurityDescriptor): TNtxStatus;

// Owner
function ScmxQueryOwnerObject(ScmHandle: TScmHandle; out Owner: ISid):
  TNtxStatus;

// Primary group
function ScmxQueryPrimaryGroupObject(ScmHandle: TScmHandle;
  out PrimaryGroup: ISid): TNtxStatus;

// DACL
function ScmxQueryDaclObject(ScmHandle: TScmHandle; out Dacl: IAcl): TNtxStatus;

// SACL
function ScmxQuerySaclObject(ScmHandle: TScmHandle; out Sacl: IAcl): TNtxStatus;

// Mandatory label
function ScmxQueryLabelObject(ScmHandle: TScmHandle; out Sacl: IAcl):
  TNtxStatus;

{ Set security }

// Security descriptor
function ScmxSetSecurityObject(ScmHandle: TScmHandle; SecInfo:
  TSecurityInformation; const SecDesc: TSecurityDescriptor): TNtxStatus;

// Owner
function ScmxSetOwnerObject(ScmHandle: TScmHandle; Owner: ISid): TNtxStatus;

// Primary group
function ScmxSetPrimaryGroupObject(ScmHandle: TScmHandle; Group: ISid):
  TNtxStatus;

// DACL
function ScmxSetDaclObject(ScmHandle: TScmHandle; Dacl: IAcl): TNtxStatus;

// SACL
function ScmxSetSaclObject(ScmHandle: TScmHandle; Sacl: IAcl): TNtxStatus;

// Mandatory label
function ScmxSetLabelObject(ScmHandle: TScmHandle; Sacl: IAcl): TNtxStatus;

implementation

uses
  Ntapi.ntrtl;

// Security descriptor
function ScmxQuerySecurityObject(ScmHandle: TScmHandle; SecurityInformation:
  TSecurityInformation; out SecDesc: PSecurityDescriptor): TNtxStatus;
var
  RequiredSize, RequiredSize2: Cardinal;
begin
  Result.Location := 'QueryServiceObjectSecurity';
  Result.Win32Result := QueryServiceObjectSecurity(ScmHandle,
    SecurityInformation, nil, 0, RequiredSize);

  if not NtxTryCheckBuffer(Result.Status, RequiredSize) then
    Exit;

  SecDesc := AllocMem(RequiredSize);

  Result.Win32Result := QueryServiceObjectSecurity(ScmHandle,
    SecurityInformation, SecDesc, RequiredSize, RequiredSize2);

  if not Result.IsSuccess then
  begin
    FreeMem(SecDesc);
    SecDesc := nil;
  end;
end;

// Owner
function ScmxQueryOwnerObject(ScmHandle: TScmHandle; out Owner: ISid):
  TNtxStatus;
var
  pSD: PSecurityDescriptor;
begin
  Result := ScmxQuerySecurityObject(ScmHandle, OWNER_SECURITY_INFORMATION, pSD);

  if not Result.IsSuccess then
    Exit;

  Result := RtlxGetOwnerSD(pSD, Owner);
  FreeMem(pSD);
end;

// Primary group
function ScmxQueryPrimaryGroupObject(ScmHandle: TScmHandle;
  out PrimaryGroup: ISid): TNtxStatus;
var
  pSD: PSecurityDescriptor;
begin
  Result := ScmxQuerySecurityObject(ScmHandle, GROUP_SECURITY_INFORMATION, pSD);

  if not Result.IsSuccess then
    Exit;

  Result := RtlxGetPrimaryGroupSD(pSD, PrimaryGroup);
  FreeMem(pSD);
end;

// DACL
function ScmxQueryDaclObject(ScmHandle: TScmHandle; out Dacl: IAcl): TNtxStatus;
var
  pSD: PSecurityDescriptor;
begin
  Result := ScmxQuerySecurityObject(ScmHandle, DACL_SECURITY_INFORMATION, pSD);

  if not Result.IsSuccess then
    Exit;

  Result := RtlxGetDaclSD(pSD, Dacl);
  FreeMem(pSD);
end;

// SACL
function ScmxQuerySaclObject(ScmHandle: TScmHandle; out Sacl: IAcl): TNtxStatus;
var
  pSD: PSecurityDescriptor;
begin
  Result := ScmxQuerySecurityObject(ScmHandle, SACL_SECURITY_INFORMATION, pSD);

  if not Result.IsSuccess then
    Exit;

  Result := RtlxGetSaclSD(pSD, Sacl);
  FreeMem(pSD);
end;

// Mandatory label
function ScmxQueryLabelObject(ScmHandle: TScmHandle; out Sacl: IAcl):
  TNtxStatus;
var
  pSD: PSecurityDescriptor;
begin
  Result := ScmxQuerySecurityObject(ScmHandle, LABEL_SECURITY_INFORMATION, pSD);

  if not Result.IsSuccess then
    Exit;

  Result := RtlxGetSaclSD(pSD, Sacl);
  FreeMem(pSD);
end;

{ Set security }

// Security descriptor
function ScmxSetSecurityObject(ScmHandle: TScmHandle; SecInfo:
  TSecurityInformation; const SecDesc: TSecurityDescriptor): TNtxStatus;
begin
  Result.Location := 'SetServiceObjectSecurity';
  Result.Win32Result := SetServiceObjectSecurity(ScmHandle, SecInfo, SecDesc);
end;

// Owner
function ScmxSetOwnerObject(ScmHandle: TScmHandle; Owner: ISid): TNtxStatus;
var
  SD: TSecurityDescriptor;
begin
  Result := RtlxPrepareOwnerSD(SD, Owner);

  if Result.IsSuccess then
    Result := ScmxSetSecurityObject(ScmHandle, OWNER_SECURITY_INFORMATION, SD);
end;

// Primary group
function ScmxSetPrimaryGroupObject(ScmHandle: TScmHandle; Group: ISid):
  TNtxStatus;
var
  SD: TSecurityDescriptor;
begin
  Result := RtlxPreparePrimaryGroupSD(SD, Group);

  if Result.IsSuccess then
    Result := ScmxSetSecurityObject(ScmHandle, GROUP_SECURITY_INFORMATION, SD);
end;

// DACL
function ScmxSetDaclObject(ScmHandle: TScmHandle; Dacl: IAcl): TNtxStatus;
var
  SD: TSecurityDescriptor;
begin
  Result := RtlxPrepareDaclSD(SD, Dacl);

  if Result.IsSuccess then
    Result := ScmxSetSecurityObject(ScmHandle, DACL_SECURITY_INFORMATION, SD);
end;

// SACL
function ScmxSetSaclObject(ScmHandle: TScmHandle; Sacl: IAcl): TNtxStatus;
var
  SD: TSecurityDescriptor;
begin
  Result := RtlxPrepareSaclSD(SD, Sacl);

  if Result.IsSuccess then
    Result := ScmxSetSecurityObject(ScmHandle, SACL_SECURITY_INFORMATION, SD);
end;

// Mandatory label
function ScmxSetLabelObject(ScmHandle: TScmHandle; Sacl: IAcl): TNtxStatus;
var
  SD: TSecurityDescriptor;
begin
  Result := RtlxPrepareSaclSD(SD, Sacl);

  if Result.IsSuccess then
    Result := ScmxSetSecurityObject(ScmHandle, LABEL_SECURITY_INFORMATION, SD);
end;

end.
