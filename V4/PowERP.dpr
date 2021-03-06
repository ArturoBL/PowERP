program PowERP;

uses
  Vcl.Forms,
  vcl.Dialogs,
  vcl.Controls,
  System.SysUtils,
  system.Classes,
  uDMRoot,
  Main in 'Source\Units\Main.pas' {frmMain},
  Splash in 'Source\Units\Splash.pas' {frmSplash},
  Login in 'Source\Units\Login.pas' {FrmLogin},
  BarEditor in 'Source\Units\BarEditor.pas' {frmBarEditor};

{$R *.res}




begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  AppHeader := LoadHeader;    // Load application intit config
  ShowSplash;                 // Show SplashScreen if configured
  LoadDMLib;                  // Load DataModule

  if Conectar then            // If connected to database show aplication
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
