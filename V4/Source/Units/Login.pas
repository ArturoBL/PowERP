unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.Menus, Vcl.StdCtrls, cxButtons, cxTextEdit, uDMRoot,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinTheBezier,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light;

type
  TFrmLogin = class(TForm)
    cteUser: TcxTextEdit;
    ctePassword: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

function Conectar : Boolean;

implementation

{$R *.dfm}

function Conectar : Boolean;
Var
  i : Integer;
  r : string;
begin
  if DM = nil then
  begin
    MessageDlg('Error: No se pudo crear la plataforma de datos. '+#13+#10+''+#13+#10+'Consúltelo con el administrador del sistema.', mtError, [mbOK], 0);
    result := false;
    exit;
  end;
  if DM.LoginPrompt then
  begin
    frmlogin := tfrmlogin.Create(application);
    i := 1;
    repeat
      r := '';
      if frmlogin.ShowModal = mrok then
      begin
        screen.Cursor := crhourglass;
        r := dm.Connect(frmlogin.cteUser.Text,frmlogin.ctePassword.Text);
        screen.Cursor := crDefault;
      end
      else
        break;
      inc(i);
      if r <> '' then
        showmessage('Error al iniciar sesión: ' + #13 + r);
    until (i > dm.LoginAttempts)or(r = '');
    result := DM.Connected;
  end
  else
    result := True;
end;


end.
