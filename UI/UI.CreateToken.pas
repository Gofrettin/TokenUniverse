unit UI.CreateToken;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UI.Prototypes.ChildForm, Vcl.StdCtrls,
  UI.Prototypes, UI.ListViewEx, Vcl.ComCtrls, UI.MainForm, Vcl.Menus, TU.Tokens;

type
  TDialogCreateToken = class(TChildForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    TabGroups: TTabSheet;
    TabPrivileges: TTabSheet;
    ListViewGroups: TListViewEx;
    ListViewPrivileges: TListViewEx;
    ButtonAddSID: TButton;
    StaticLogonID: TStaticText;
    StaticOwner: TStaticText;
    StaticPrimaryGroup: TStaticText;
    StaticDacl: TStaticText;
    ComboLogonSession: TComboBox;
    ComboUser: TComboBox;
    ButtonPickUser: TButton;
    ButtonLoad: TButton;
    PopupMenuGroups: TPopupMenu;
    MenuEdit: TMenuItem;
    MenuRemove: TMenuItem;
    ComboOwner: TComboBox;
    ComboPrimary: TComboBox;
    CheckBoxUserState: TCheckBox;
    GroupBoxUser: TGroupBox;
    TabAdvanced: TTabSheet;
    GroupBoxExpires: TGroupBox;
    CheckBoxInfinite: TCheckBox;
    DateExpires: TDateTimePicker;
    TimeExpires: TDateTimePicker;
    GroupBoxSource: TGroupBox;
    EditSourceName: TEdit;
    StaticSourceName: TStaticText;
    StaticSourceLuid: TStaticText;
    EditSourceLuid: TEdit;
    ButtonAllocLuid: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonAddSIDClick(Sender: TObject);
    procedure ButtonPickUserClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure CheckBoxInfiniteClick(Sender: TObject);
    procedure MenuEditClick(Sender: TObject);
    procedure MenuRemoveClick(Sender: TObject);
    procedure ButtonAllocLuidClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ComboUserChange(Sender: TObject);
  private
    LogonIDSource: TLogonSessionSource;
    GroupsSource: TGroupsSource;
    PrivilegesSource: TPrivilegesSource;
    procedure ObjPickerUserCallback(UserName: String);
    procedure UpdatePrimaryAndOwner;
  end;

var
  DialogCreateToken: TDialogCreateToken;

implementation

uses
  TU.LsaApi, TU.Tokens.Types, UI.Modal.PickUser, TU.ObjPicker, TU.Winapi,
  TU.Common, UI.Settings;

{$R *.dfm}

procedure TDialogCreateToken.ButtonAddSIDClick(Sender: TObject);
var
  NewGroup: TGroup;
begin
  NewGroup := TDialogPickUser.PickNew(Self);

  GroupsSource.AddGroup(NewGroup);

  if NewGroup.Attributes.Contain(GroupOwner) then
    ComboOwner.Items.Add(NewGroup.SecurityIdentifier.ToString);

  ComboPrimary.Items.Add(NewGroup.SecurityIdentifier.ToString);
end;

procedure TDialogCreateToken.ButtonAllocLuidClick(Sender: TObject);
var
  NewLuid: Int64;
begin
  if Winapi.Windows.AllocateLocallyUniqueId(NewLuid) then
    EditSourceLuid.Text := Format('0x%x', [NewLuid]);
end;

procedure TDialogCreateToken.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDialogCreateToken.ButtonOKClick(Sender: TObject);
var
  Token: TToken;
  Expires: Int64;
  OwnerGroupName, PrimaryGroupName: String;
begin
  if CheckBoxInfinite.Checked then
    Expires := Int64.MaxValue
  else if TimeExpires.Checked then
    Expires := DateTimeToNative(DateExpires.Date + TimeExpires.Time)
  else
    Expires := DateTimeToNative(DateExpires.Date);

  // ComboOwner may contain '< Same as user >' value
  if ComboOwner.ItemIndex = 0 then
    OwnerGroupName := ComboUser.Text
  else
    OwnerGroupName := ComboOwner.Text;

  // ComboPrimary may contain '< Same as user >' value
  if ComboPrimary.ItemIndex = 0 then
    PrimaryGroupName := ComboUser.Text
  else
    PrimaryGroupName := ComboPrimary.Text;

  Token := TToken.CreateNtCreateToken(
    TSecurityIdentifier.CreateFromString(ComboUser.Text),
    CheckBoxUserState.Checked,
    GroupsSource.Groups,
    PrivilegesSource.Privileges,
    LogonIDSource.SelectedLogonSession,
    TSecurityIdentifier.CreateFromString(OwnerGroupName),
    TSecurityIdentifier.CreateFromString(PrimaryGroupName),
    CreateTokenSource(EditSourceName.Text,
      StrToUInt64Ex(EditSourceLuid.Text, 'Source LUID')),
    Expires
  );

  FormMain.Frame.AddToken(Token);

  if not TSettings.NoCloseCreationDialogs then
    Close;
end;

procedure TDialogCreateToken.ButtonPickUserClick(Sender: TObject);
begin
  CallObjectPicker(Handle, ObjPickerUserCallback);
end;

procedure TDialogCreateToken.CheckBoxInfiniteClick(Sender: TObject);
begin
  DateExpires.Enabled := not CheckBoxInfinite.Checked;
  TimeExpires.Enabled := not CheckBoxInfinite.Checked;
end;

procedure TDialogCreateToken.ComboUserChange(Sender: TObject);
var
  NewUser: String;
  SavedOwnerIndex, SavedPrimaryIndex: Integer;
begin
  NewUser := ComboUser.Text;
  if NewUser = '' then
    NewUser := '< Same as user >';

  // Save selected indexes since changes will reset it
  SavedOwnerIndex := ComboOwner.ItemIndex;
  SavedPrimaryIndex := ComboPrimary.ItemIndex;

  if ComboOwner.Items.Count > 0 then
    ComboOwner.Items[0] := NewUser;

  if ComboPrimary.Items.Count > 0 then
    ComboPrimary.Items[0] := NewUser;

  // Forcibly update the Text field
  ComboOwner.ItemIndex := SavedOwnerIndex;
  ComboPrimary.ItemIndex := SavedPrimaryIndex;
end;

procedure TDialogCreateToken.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PrivilegesSource.Free;
  GroupsSource.Free;
  LogonIDSource.Free;
end;

procedure TDialogCreateToken.FormCreate(Sender: TObject);
begin
  LogonIDSource := TLogonSessionSource.Create(ComboLogonSession);
  GroupsSource := TGroupsSource.Create(ListViewGroups);
  PrivilegesSource := TPrivilegesSource.Create(ListViewPrivileges);
  ButtonAllocLuidClick(Self);
end;

procedure TDialogCreateToken.MenuEditClick(Sender: TObject);
begin
  GroupsSource.UiEditSelected(Self);
  UpdatePrimaryAndOwner;
end;

procedure TDialogCreateToken.MenuRemoveClick(Sender: TObject);
begin
  if Assigned(ListViewGroups.Selected) then
  begin
    ComboPrimary.Items.Delete(ListViewGroups.Selected.Index + 1);
    GroupsSource.RemoveGroup(ListViewGroups.Selected.Index);
  end;
end;

procedure TDialogCreateToken.ObjPickerUserCallback(UserName: String);
begin
  ComboUser.Text := TSecurityIdentifier.CreateFromString(UserName).ToString;
  ComboUserChange(ButtonPickUser);
end;

procedure TDialogCreateToken.UpdatePrimaryAndOwner;
var
  i: Integer;
  SavedPrimaryIndex: Integer;
  SavedOwner: String;
begin
  SavedOwner := ComboOwner.Text;
  SavedPrimaryIndex := ComboPrimary.ItemIndex;

  // Refresh potential owners list
  begin
    ComboOwner.Items.BeginUpdate;

    for i := ComboOwner.Items.Count - 1 downto 1 do
      ComboOwner.Items.Delete(i);

    // Only groups with Owner flag can be assigned as owners
    for i := 0 to ListViewGroups.Items.Count - 1 do
      if GroupsSource.Group[i].Attributes.Contain(GroupOwner) then
        ComboOwner.Items.Add(ListViewGroups.Items[i].Caption);

    // Restore selection
    for i := 1 to ComboOwner.Items.Count - 1 do
      if ComboOwner.Items[i] = SavedOwner then
        ComboOwner.ItemIndex := i;

    ComboOwner.Items.EndUpdate;
  end;

  // Refresh potential primary group list
  begin
    ComboPrimary.Items.BeginUpdate;
    for i := ComboPrimary.Items.Count - 1 downto 1 do
      ComboPrimary.Items.Delete(i);

    // Any group present in the token can be assigned as a primary
    for i := 0 to ListViewGroups.Items.Count - 1 do
      ComboPrimary.Items.Add(ListViewGroups.Items[i].Caption);

    // Restore selection using the fact that editing does not change their count
    ComboPrimary.ItemIndex := SavedPrimaryIndex;
    ComboPrimary.Items.EndUpdate;
  end;
end;

end.
