program ConnectionManager;

uses
  Vcl.Forms,
  uMainCM in 'uMainCM.pas' {frmMainCM};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainCM, frmMainCM);
  Application.Run;
end.
