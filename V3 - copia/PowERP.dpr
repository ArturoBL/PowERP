program PowERP;

uses
  Vcl.Forms,
  vcl.Dialogs, vcl.Controls,
  System.SysUtils,
  system.Classes,
  uDMRoot,
  Main in 'Source\Units\Main.pas' {frmMain},
  Splash in 'Source\Units\Splash.pas' {frmSplash},
  Login in 'Source\Units\Login.pas' {FrmLogin};

{$R *.res}

Procedure ShowSplash;
begin
  if AppHeader.SplashFile <> '' then
  begin
    //Show splash screen
    frmSplash := TfrmSplash.Create(application,AppHeader.splashfile);
    frmsplash.Show;
    application.ProcessMessages;
    sleep(1000);
    frmsplash.Close;
  end;
end;

Procedure LoadDMLib;
var
  DMFile : string;
  PackageModule: HModule;
  AClass: TPersistentClass;
begin
  DMFILE := extractfilepath(application.ExeName) + '\LIB\' + DBMFilename(AppHeader.DBMName);

  DM := nil;

  PackageModule := LoadPackage(DMFile);
  if PackageModule <> 0 then
  begin
    AClass := GetClass('TDMDATA');
    if AClass <> nil then
      DM := TDMRoot(TComponentClass(AClass).Create(Application));
  end;
end;

Var
  i : Integer;
  r : string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  AppHeader := LoadHeader;

  ShowSplash;

  LoadDMLib;

  if DM = nil then
  begin
    MessageDlg('Error: No se pudo crear la plataforma de datos. '+#13+#10+''+#13+#10+'Consúltelo con el administrador del sistema.', mtError, [mbOK], 0);
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
  end;
  if not DM.Connected then Exit;

  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
