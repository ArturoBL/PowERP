unit uDMFirebird;

interface

uses uDMRoot, classes, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, pFIBStoredProc,
  DB, FIBDataSet, pFIBDataSet, dateutils, sysutils, vcl.dialogs, pFIBProps,Vcl.Forms ;

type
  TDMFirebird = class(TDMRoot)
  private
    DB : tpFibDatabase;
    TR, TRU : tpFibTransaction;
    procedure loadConfig;
  protected
    fDBMAN: string;
    fVersion: string;
    fDialect : integer;
    fHost : string;
    fPort : integer;
    fDBFile : string;
    fLibrary : string;
    fLoginPrompt: boolean;
    fLoginAttempts: integer;
    fAdminUser: boolean;
    procedure DeclareAndSetVars(ds : TpFIBDataSet; params : array of variant);
  public
    { Public declarations }
    Property DBMAN : string read fDBMAN;
    Property VERSION : string read fVersion;
    Property LoginPrompt : boolean read fLoginPrompt;
    Property LoginAttempts : integer read fLoginAttempts;
    Property AdminUser : boolean read fAdminUser;
    Function Conectar(pUsuario, pPassword : string) : string; override;
    Function Connected : boolean; override;
    Function DSET(pSQL : string; pParamList : array of Variant) : tDataset; override;
    function GetVariant(pSQL : string; pParamList : array of Variant) : variant; override;
    function GetInt(pSQL : string; pParamList : array of Variant) : integer; override;
    function GetString(pSQL : string; pParamList : array of Variant) : string; override;
    function GetDate(pSQL : string; pParamList : array of Variant) : tdatetime; override;
    function GetFloat(pSQL : string; pParamList : array of Variant) : single; override;
    Function Parametro(sender: TObject; pParName : string) : string; override;
    Function ExecSQL(pSQL : string; pParamList: array of Variant) : string; override;
    procedure ExecProc(pProcname : string; pParamList : array of Variant); override;
    procedure ChangeParam(sender: TObject; pParamName, value : string); override;
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TDMFirebird }

procedure TDMFirebird.ChangeParam(sender: TObject; pParamName, value: string);
begin
  inherited;
  ExecProc('POW_CHANGEPARAM',[tform(sender).Name,pParamName, value]);
end;

function TDMFirebird.Conectar(pUsuario, pPassword: string): string;
begin
  result := '';
  try
  with DB do
  begin
    LibraryName := fLibrary;
    ConnectParams.UserName := pUsuario;
    ConnectParams.Password := pPassword;
    DBName := format('%s/%d:%S',[fhost, fport, fdbfile]);
    connected := true;
  end;
  except
    on e: exception do
    begin
      result := e.Message;
    end;
  end;
end;

function TDMFirebird.Connected: boolean;
begin
  result := DB.Connected;
end;

constructor TDMFirebird.create(aOwner: TComponent);
begin
  inherited;
  LoadConfig;

  //Create DB objects
  DB := tpFibDatabase.Create(self);
  TR := tpFibTransaction.Create(self);
  TRU := tpFibTransaction.Create(self);

  with DB do
  Begin
    DefaultTransaction := TR;
    DefaultUpdateTransaction := TRU;
  end;
end;

procedure TDMFirebird.DeclareAndSetVars(ds: TpFIBDataSet;
  params: array of variant);
begin
  ds.SetParamValues(params);
end;

destructor TDMFirebird.Destroy;
begin
  if db.Connected then
    db.Connected := false;
  db.Free;
  inherited;
end;

function TDMFirebird.DSET(pSQL: string; pParamList: array of Variant): tDataset;
var
  ds : TpFIBDataSet;
  TR, TRU : tpFibTransaction;
begin
  result := nil;
  ds := TpFIBDataSet.Create(self);
  TR := tpFibTransaction.Create(self);
  TRU := tpFibTransaction.Create(self);
  with ds do
  begin
    Database := DB;
    Transaction := tr;
    UpdateTransaction := tru;
    SQLs.SelectSQL.Text := pSQL;
    //AutoUpdateOptions.UpdateTableName :=
    ds.Open;
    //ds.GenerateSQLs;
  end;
end;

procedure TDMFirebird.ExecProc(pProcname: string; pParamList: array of Variant);
var
  i : integer;
  sp : TpFIBStoredProc;
  t : tpFibTransaction;
begin
  inherited;
  sp := TpFIBStoredProc.Create(self);
  t := tpFibTransaction.Create(self);
  t.DefaultDatabase := db;
  t.Active := true;
  sp.Database := db;
  sp.Transaction := t;
  sp.Options := [qoStartTransaction,qoAutoCommit];
  sp.StoredProcName := pProcName;
  sp.SetParamValues(pParamList);

  sp.ExecProc;
  sp.Free;
end;

function TDMFirebird.ExecSQL(pSQL: string;pParamList: array of Variant): string;
begin

end;

function TDMFirebird.GetDate(pSQL: string;
  pParamList: array of Variant): tdatetime;
begin
  result := now;
end;

function TDMFirebird.GetFloat(pSQL: string;
  pParamList: array of Variant): single;
begin
  result := 0;
end;

function TDMFirebird.GetInt(pSQL: string;
  pParamList: array of Variant): integer;
begin
  result := 0;
end;

function TDMFirebird.GetString(pSQL: string;
  pParamList: array of Variant): string;
begin

end;

function TDMFirebird.GetVariant(pSQL: string;
  pParamList: array of Variant): variant;
begin

end;

procedure TDMFirebird.loadConfig;
begin
  fdbman := 'FIREBIRD';
  fVersion := '2.5';
  fLoginPrompt := true;
  fLoginAttempts := 3;
  fAdminUser := true;
  fDialect := 3;
  fHost := 'LOCALHOST';
  fPort := 3050;
  fDBFile := 'E:\backup 2013\MisDocs\pruebas\pow\BIN\DATA\data.fdb';
  fLibrary := 'fbclient.dll';
end;

function TDMFirebird.Parametro(sender: TObject; pParName: string): string;
begin

end;


initialization
  RegisterClass(TDMFirebird);
finalization
  UnRegisterClass(TDMFirebird);

end.
