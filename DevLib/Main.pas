unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDMFirebird, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    ds2: TDataSource;
    dbgrd2: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    dm : TDMData;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var d1, d2 : TDataSet;
begin

  if dm.Connected  then
  begin
    d1 := dm.DSET('select * from pow_forms',[], true).ds;
    ds1.DataSet := d1;

    d2 := dm.DSET('select * from pow_params where id_form = ?id_form',[],ds1,'id_forms',true).ds;
    ds2.DataSet := d2;
//    dm.ExecSQL('update pow_params set param_value = ?pval where param_name = ''TABS_VISIBLE'' ',['opq']);
//    ShowMessage(dm.GetParam(Self,'TABS_VISIBLE'));
ShowMessage(dm.DSCount.ToString);
  end
  else
    ShowMessage('No');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  dm := TDMData.Create(Self);
  dm.Connect('SYSDBA','masterkey');
end;

end.
