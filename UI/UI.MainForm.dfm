object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Token Universe :: Main Window'
  ClientHeight = 303
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 750
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 3
      Top = 4
      Width = 86
      Height = 25
      Caption = 'Open Process'
      TabOrder = 0
      OnClick = ActionOpenProcess
    end
  end
  inline Frame: TFrameTokenList
    Left = 0
    Top = 32
    Width = 750
    Height = 271
    Align = alClient
    TabOrder = 1
    ExplicitTop = 32
    ExplicitHeight = 271
    inherited ListViewTokens: TListView
      Height = 242
      PopupMenu = PopupMenu
      OnDblClick = FrameListViewTokensDblClick
      OnSelectItem = ListViewTokenSelectItem
      ExplicitHeight = 242
    end
    inherited SearchButtons: TImageList
      Bitmap = {
        494C010104001800580010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
        0000000000003600000028000000400000002000000001002000000000000020
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000ADD6D600ADD6
        D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6
        D600ADD6D600ADD6D600000000000000000000000000000000009CC6CE009CC6
        CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6
        CE009CC6CE009CC6CE00000000000000000000000000000000009CC6CE009CC6
        CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6
        CE009CC6CE009CC6CE0000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000ADD6D600CEE7E700CEE7
        E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7
        E700CEE7E700CEE7E700ADD6D60000000000000000009CC6CE00CEE7E700CEE7
        E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7
        E700CEE7E700CEE7E7009CC6CE0000000000000000009CC6CE00CEE7E700CEE7
        E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7E700CEE7
        E700CEE7E700CEE7E7009CC6CE00000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000ADD6D600CEE7E700DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00CEE7E700CEE7E700ADD6D6009CC6CE00CEE7E700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700CEE7E700CEE7E7009CC6CE009CC6CE00CEE7E700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700CEE7E700CEE7E7009CC6CE000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000000000427B
        8400427B8400000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700427B8400427B8400EFF7F700EFF7F700EFF7F700427B8400427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000427B8400427B
        8400427B8400000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00427B8400427B8400DEEFEF00DEEFEF00DEEFEF00427B8400427B8400DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400427B8400EFF7F700EFF7F700EFF7F700427B8400427B8400EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00427B8400EFF7F700427B8400FFFFFF00FFFF
        FF00427B8400EFF7F700CEE7E7009CC6CE000000000000000000000000000000
        00000000000000000000000000000000000000000000427B8400427B8400427B
        840000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00427B
        8400FFFFFF00FFFFFF00427B8400DEEFEF00427B8400FFFFFF00FFFFFF00427B
        8400DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700427B
        8400FFFFFF00FFFFFF00427B8400EFF7F700427B8400FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFF
        FF00427B8400EFF7F700CEE7E7009CC6CE00000000000000000000000000427B
        8400427B8400427B8400427B8400427B8400427B8400427B8400427B84000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00427B
        8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFFFF00427B
        8400DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700427B
        8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE000000000000000000427B8400427B
        8400000000000000000000000000427B8400427B8400427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B8400DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B8400EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700427B8400FFFFFF00FFFFFF00FFFFFF00427B8400EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE0000000000427B8400427B84000000
        000000000000000000000000000000000000427B8400427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00427B8400FFFFFF00FFFFFF00FFFFFF00427B8400DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700427B8400FFFFFF00FFFFFF00FFFFFF00427B8400EFF7F700EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE0000000000427B8400000000000000
        00000000000000000000000000000000000000000000427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B8400DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00427B8400EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFF
        FF00427B8400EFF7F700CEE7E7009CC6CE0000000000427B8400000000000000
        00000000000000000000000000000000000000000000427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00427B
        8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFFFF00427B
        8400DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700427B
        8400FFFFFF00FFFFFF00FFFFFF00427B8400FFFFFF00FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400FFFFFF00FFFFFF00427B8400EFF7F700427B8400FFFFFF00FFFF
        FF00427B8400EFF7F700CEE7E7009CC6CE0000000000427B8400000000000000
        00000000000000000000000000000000000000000000427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00427B
        8400FFFFFF00FFFFFF00427B8400DEEFEF00427B8400FFFFFF00FFFFFF00427B
        8400DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700427B
        8400FFFFFF00FFFFFF00427B8400EFF7F700427B8400FFFFFF00FFFFFF00427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700427B8400427B8400EFF7F700EFF7F700EFF7F700427B8400427B
        8400EFF7F700EFF7F700CEE7E7009CC6CE0000000000427B8400427B84000000
        000000000000000000000000000000000000427B8400427B8400000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00427B8400427B8400DEEFEF00DEEFEF00DEEFEF00427B8400427B8400DEEF
        EF00DEEFEF00DEEFEF00CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700427B8400427B8400EFF7F700EFF7F700EFF7F700427B8400427B8400EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700CEE7E7009CC6CE000000000000000000427B8400427B
        8400000000000000000000000000427B8400427B840000000000000000000000
        000000000000000000000000000000000000ADD6D600DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
        EF00DEEFEF00CEE7E700CEE7E700ADD6D6009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700CEE7E700CEE7E7009CC6CE009CC6CE00EFF7F700EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700EFF7F700CEE7E700CEE7E7009CC6CE00000000000000000000000000427B
        8400427B8400427B8400427B8400427B84000000000000000000000000000000
        00000000000000000000000000000000000000000000ADD6D600DEEFEF00DEEF
        EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
        EF00CEE7E700CEE7E700ADD6D60000000000000000009CC6CE00EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700CEE7E700CEE7E7009CC6CE0000000000000000009CC6CE00EFF7F700EFF7
        F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7
        F700CEE7E700CEE7E7009CC6CE00000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000ADD6D600ADD6
        D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6D600ADD6
        D600ADD6D600ADD6D600000000000000000000000000000000009CC6CE009CC6
        CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6
        CE009CC6CE009CC6CE00000000000000000000000000000000009CC6CE009CC6
        CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6CE009CC6
        CE009CC6CE009CC6CE000000000000000000424D3E000000000000003E000000
        2800000040000000200000000100010000000000000100000000000000000000
        000000000000000000000000FFFFFF0000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000FFFFC003C003C003FFFF800180018001
        FFFF000000000000FFE7000000000000FFC7000000000000FF8F000000000000
        E01F000000000000CE3F0000000000009F3F000000000000BFBF000000000000
        BFBF000000000000BFBF0000000000009F3F000000000000CE7F000000000000
        E0FF800180018001FFFFC003C003C00300000000000000000000000000000000
        000000000000}
    end
  end
  object MainMenu: TMainMenu
    Left = 96
    Top = 112
    object Program1: TMenuItem
      Caption = 'Program'
      object RunAsAdmin: TMenuItem
        Caption = 'Restart as Administrator'
        OnClick = RunAsAdminClick
      end
      object RunasSYSTEM1: TMenuItem
        Caption = 'Restart as SYSTEM'
      end
      object RunasSYSTEM2: TMenuItem
        Caption = 'Restart as SYSTEM+'
      end
    end
    object View1: TMenuItem
      Caption = 'Settings'
      object Propmtonhandleclose1: TMenuItem
        Caption = 'Propmt on handle close'
      end
      object Showiconsinprocesslist1: TMenuItem
        Caption = 'Show icons in process list'
        Checked = True
      end
      object Displayallsearchresults1: TMenuItem
        Caption = 'Display all search results'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
    end
  end
  object PopupMenu: TPopupMenu
    Left = 168
    Top = 112
    object TokenOpenInfo: TMenuItem
      Caption = 'Open information'
      Default = True
      Enabled = False
      ShortCut = 13
      OnClick = ActionOpen
    end
    object TokenRename: TMenuItem
      Caption = 'Rename'
      Enabled = False
      ShortCut = 113
      OnClick = ActionRename
    end
    object TokenClose: TMenuItem
      Caption = 'Close handle'
      Enabled = False
      ShortCut = 46
      OnClick = ActionClose
    end
    object HLine1: TMenuItem
      Caption = '-'
    end
    object TokenDuplicate: TMenuItem
      Caption = 'Duplicate token'
      Enabled = False
      ShortCut = 16452
      OnClick = ActionDuplicate
    end
    object TokenDuplicateHandle: TMenuItem
      Caption = 'Duplicate handle'
      Enabled = False
      ShortCut = 24644
      OnClick = ActionDuplicateHandle
    end
    object TokenRun: TMenuItem
      Caption = 'Run program with this token'
      Enabled = False
      ShortCut = 16453
      OnClick = ActionRunWithToken
    end
    object TokenRestrict: TMenuItem
      Caption = 'Create restricted token'
      Enabled = False
      ShortCut = 16466
    end
    object TokenOpenLinked: TMenuItem
      Caption = 'Open linked token'
      Enabled = False
      ShortCut = 24652
      OnClick = ActionOpenLinked
    end
    object TokenImpersonate: TMenuItem
      Caption = 'Impersonate'
      Enabled = False
      ShortCut = 16457
    end
    object TokenSendHandle: TMenuItem
      Caption = 'Copy handle to another process'
      Enabled = False
      OnClick = ActionSendHandle
    end
    object HLine2: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
    object NewMenu: TMenuItem
      Caption = 'New'
      object NewOpenSelf: TMenuItem
        Caption = 'Open current process'
        ShortCut = 24655
        OnClick = ActionOpenSelf
      end
      object NewOpenProcess: TMenuItem
        Caption = 'Open other process'
        ShortCut = 16463
        OnClick = ActionOpenProcess
      end
      object NewOpenThread: TMenuItem
        Caption = 'Open other thread'
        Enabled = False
      end
      object HLine3: TMenuItem
        Caption = '-'
      end
      object NewLogonUser: TMenuItem
        Caption = 'Logon user'
        Enabled = False
        ShortCut = 16460
      end
      object NewQueryUserToken: TMenuItem
        Caption = 'WTSQueryUserToken'
        Enabled = False
      end
      object NewSaferApi: TMenuItem
        Caption = 'Create using Safer API'
        Enabled = False
      end
      object NewNtCreateToken: TMenuItem
        Caption = 'Create using NtCreateToken'
        Enabled = False
        ShortCut = 16462
      end
      object HLine4: TMenuItem
        Caption = '-'
      end
      object NewCopyHandle: TMenuItem
        Caption = 'Copy handle from other process'
        Enabled = False
        ShortCut = 24643
      end
      object NewSearchHandle: TMenuItem
        Caption = 'Search for token handles'
        ShortCut = 16454
        OnClick = ActionSearch
      end
    end
    object ProgramRun: TMenuItem
      Caption = 'Run program'
      object MenuItem21: TMenuItem
        Caption = 'CreateProcess'
        Enabled = False
      end
      object MenuItem22: TMenuItem
        Caption = 'ShellExecuteEx'
        Enabled = False
      end
      object RunTaskAsInteractiveUser1: TMenuItem
        Caption = 'RunTaskAsInteractiveUser'
        Enabled = False
      end
      object MenuItem23: TMenuItem
        Caption = 'CreateProcessWithLogonW'
        Enabled = False
      end
    end
  end
end
