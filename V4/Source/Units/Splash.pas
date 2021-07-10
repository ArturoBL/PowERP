unit Splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GR32_Image, jpeg, uDMRoot;

type
  TfrmSplash = class(TForm)
    imgSplash: TImage32;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent;splashFile : string ); overload;
  end;

var
  frmSplash: TfrmSplash;


Procedure ShowSplash;

implementation

{$R *.dfm}

Procedure ShowSplash;
begin
  if AppHeader.SplashFile <> '' then
  begin
    //Show splash screen
    frmSplash := TfrmSplash.Create(application,AppHeader.splashfile);
    frmsplash.Show;
    application.ProcessMessages;
    sleep(3000);
    frmsplash.Close;
  end;
end;


constructor TfrmSplash.Create(AOwner: TComponent; splashFile: string);
begin
  inherited Create(aOwner);
  if splashfile <> ''then
  imgsplash.Bitmap.LoadFromFile(SplashFile);
end;

end.
