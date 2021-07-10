program PruebaLib;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  uDMRoot in 'uDMRoot.pas',
  uDMFirebird in 'uDMFirebird.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
