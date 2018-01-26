object frmConfirmationDlg: TfrmConfirmationDlg
  Left = 434
  Top = 421
  BorderStyle = bsDialog
  Caption = 'Confirmation'
  ClientHeight = 93
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    396
    93)
  PixelsPerInch = 96
  TextHeight = 16
  object imIcon: TImage
    Left = 8
    Top = 8
    Width = 48
    Height = 48
  end
  object lblConfirmation: TLabel
    Left = 62
    Top = 8
    Width = 326
    Height = 46
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'lblConfirmation'
    WordWrap = True
  end
  object btnYes: TBitBtn
    Left = 63
    Top = 60
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkYes
    NumGlyphs = 2
    TabOrder = 0
  end
  object btnNo: TBitBtn
    Left = 145
    Top = 60
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&No'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333FFFFF333333000033333388888833333333333F888888FFF333
      000033338811111188333333338833FFF388FF33000033381119999111833333
      38F338888F338FF30000339119933331111833338F388333383338F300003391
      13333381111833338F8F3333833F38F3000039118333381119118338F38F3338
      33F8F38F000039183333811193918338F8F333833F838F8F0000391833381119
      33918338F8F33833F8338F8F000039183381119333918338F8F3833F83338F8F
      000039183811193333918338F8F833F83333838F000039118111933339118338
      F3833F83333833830000339111193333391833338F33F8333FF838F300003391
      11833338111833338F338FFFF883F83300003339111888811183333338FF3888
      83FF83330000333399111111993333333388FFFFFF8833330000333333999999
      3333333333338888883333330000333333333333333333333333333333333333
      0000}
    ModalResult = 7
    NumGlyphs = 2
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 229
    Top = 60
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
  object btnTesToAll: TBitBtn
    Left = 313
    Top = 60
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkAll
    NumGlyphs = 2
    TabOrder = 3
  end
end
