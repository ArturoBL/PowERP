program PowERP;

uses
  Vcl.Forms,
  sysutils,
  Main in 'Units\Main.pas' {frmMain},
  Splash in 'Units\Splash.pas' {frmSplash},
  Login in 'Units\Login.pas' {FrmLogin},
  XMLDoc,
  XMLIntf,
  dialogs, controls,
  system.StrUtils,
  system.Classes,
  uDMRoot;

{$R *.res}

var
  initParams : record
    splashFile,
    DBMAN:string;
  end;

  r : string;
  i : integer;


Procedure LoadInitConfig;
var
  d : IXMLDocument;
  e : IXMLNode;
begin
  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\config.xml');
  e := d.DocumentElement;
  with initparams do
  begin
    if trim(e.ChildNodes['SPLASH'].Text) <> '' then
    begin
      splashFile :=extractfilepath(application.ExeName) + 'MEDIA\' + trim(e.ChildNodes['SPLASH'].Text);
      if not fileexists(splashfile) then
        splashfile := '';
    end
    else splashfile := '';
    DBMAN := e.ChildNodes['DBManager'].ChildNodes['DBMNAME'].Text;
  end;
end;

Procedure ShowSplash;
begin
  if initparams.splashfile <> '' then
  begin
    //Show splash screen
    frmSplash := TfrmSplash.Create(application,initparams.splashfile);
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
  case AnsiIndexStr(AnsiString(initparams.DBMAN),
        [  'FIREBIRD'
          ,'ORACLE'
        ]) of
    0 : DMFile := 'DMFirebird.BPL';
    1 : DMFile := 'DMOracle.BPL';
  end;
  DMFILE := extractfilepath(application.ExeName) + '\LIB\' + DMFILE;

  DM := nil;

  PackageModule := LoadPackage(DMFile);
  if PackageModule <> 0 then
  begin
    AClass := GetClass('TDMData');
    if AClass <> nil then
      DM := TDMRoot(TComponentClass(AClass).Create(Application));
  end;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  //Load Init parameters
  LoadInitConfig;

  //Show SplashScreen
  ShowSplash;

  //Load DM Library
  LoadDMLib;

  if dm <> nil then
    if dm.LoginPrompt then
    begin
      frmlogin := tfrmlogin.Create(application);
      i := 1;
      repeat
        r := '';
        if frmlogin.ShowModal = mrok then
        begin
          screen.Cursor := crhourglass;
          r := dm.Conectar(frmlogin.cteUser.Text,frmlogin.ctePassword.Text);
          screen.Cursor := crDefault;
        end
        else
          break;
        inc(i);

        if r <> '' then
          showmessage('Error al iniciar sesi?n: ' + #13 + r);
      until (i > dm.LoginAttempts)or(r = '');
    end;

  if dm.Connected then
    Application.CreateForm(TfrmMain, frmMain)
  else
  if r <> '' then
    showmessage('No fue posible iniciar sesi?n, consulte al administrador del sistema');
  Application.Run;
end.
