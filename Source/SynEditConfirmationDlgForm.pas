(**
  
  This module contains a class whivh represents a form for confirming the replacement of text in the
  synedit editor.

  @Version 1.0
  @Author  David Hoyle
  @Date    21 Jan 2018

**)
Unit GitEditor.ConfirmationDlgForm;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ExtCtrls;

Type
  (** A class to represent a form for confirming replacement of text in the editor **)
  TfrmConfirmationDlg = Class(TForm)
    imIcon: TImage;
    lblConfirmation: TLabel;
    btnYes: TBitBtn;
    btnNo: TBitBtn;
    btnCancel: TBitBtn;
    btnTesToAll: TBitBtn;
    Procedure FormCreate(Sender: TObject);
  Strict Private
  Public
    Class Function Execute(Const Editor: TRect; Const strFind, strReplace: String; Const X, Y1,
      Y2: Integer): TModalResult;
  End;

Implementation

{$R *.dfm}

Var
  (** A private variable to hold the instance of the confirmation form. **)
  FormInstance : TfrmConfirmationDlg;


ResourceString
  (** A resource string which represents the text to be displayed to the user
      when text needs to the replaced. **)
  strReplaceText = 'Are you sure you want to replace this occurance of "%s" with "%s"?';

(**

  This method is the forms main interface method and positions the dialogue next to the text being 
  replaced.

  @precon  Editor should be the display rectangle of the editor.
  @postcon Positions the dialogue next to the text being replaced.

  @param   Editor     as a TRect as a constant
  @param   strFind    as a String as a constant
  @param   strReplace as a String as a constant
  @param   X          as an Integer as a constant
  @param   Y1         as an Integer as a constant
  @param   Y2         as an Integer as a constant
  @return  a TModalResult

**)
Class Function TfrmConfirmationDlg.Execute(Const Editor: TRect; Const strFind, strReplace: String;
  Const X, Y1, Y2: Integer): TModalResult;

Const
  iBorderWidth = 4;
  iDivisor = 2;
  iMultiplier = 3;

  (**

    This function calculates the horizontal position of the dialogue.

    @precon  None.
    @postcon The horizontal posistion of the dialogue is returned.

    @param   iW     as an Integer as a constant
    @param   iWidth as an Integer as a constant
    @return  an Integer

  **)
  Function CalcX(Const iW, iWidth : Integer) : Integer;

  Begin
    Result := X;
    If iW <= iWidth Then
      Result := Editor.Left - (iWidth - iW) Div 2
    Else
      If Result + iWidth > Editor.Right Then
        Result := Editor.Right - iWidth;
  End;

  (**

    This function calculates the vertcical position of the dialogue.

    @precon  None.
    @postcon The vertical posistion of the dialogue is returned.

    @param   iY1     as an Integer as a constant
    @param   iY2     as an Integer as a constant
    @param   iH      as an Integer as a constant
    @param   iHeight as an Integer as a constant
    @return  an Integer

  **)
  Function CalcY(Const iY1, iY2, iH, iHeight : Integer) : Integer;

  Begin
    Result := iY2;
    If Result > Editor.Top + MulDiv(iH, iDivisor, iMultiplier) Then
      Result := iY1 - iHeight - iBorderWidth
    Else
      Inc(Result, iBorderWidth);
  End;
  
Var
  W, H: Integer;

Begin
  FormInstance.lblConfirmation.Caption := Format(strReplaceText, [strFind, strReplace]);
  W := Editor.Right - Editor.Left;
  H := Editor.Bottom - Editor.Top;
  FormInstance.SetBounds(CalcX(W, FormInstance.Width), CalcY(Y1, Y2, H, FormInstance.Height),
    FormInstance.Width, FormInstance.Height);
  Result := FormInstance.ShowModal;
End;

(**

  This is the forms on create event handler.

  @precon  None.
  @postcon Loads an icon into the image control.

  @param   Sender as a TObject

**)
Procedure TfrmConfirmationDlg.FormCreate(Sender: TObject);
Begin
  imIcon.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
End;

(** Creates an instance of the confirmation dialogue. **)
Initialization
  FormInstance := TfrmConfirmationDlg.Create(Application.MainForm);
(** Frees the confirmation dialogue instance. **)
Finalization
  FormInstance.Free;
End.
