unit uDMFirebird;

interface

uses uDMRoot, classes, FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery, pFIBStoredProc,
  DB, FIBDataSet, pFIBDataSet, dateutils, sysutils, vcl.dialogs, pFIBProps,Vcl.Forms,
  SQLBuilder4D.Parser,SQLBuilder4D.Parser.GaSQLParser, XMLDoc,XMLIntf, variants ;

type
  TDMDATA = class(TDMRoot)
  private
    DB : tpFibDatabase;
    fTR, fTRU : tpFibTransaction;
    procedure loadConfig;
    function GetInt(pSQL: string; pParamList: array of Variant): integer;
    function GetVariant(pSQL: string; pParamList: array of Variant): variant;
  protected
    fbDialect : integer;
    fHost : string;
    fPort : integer;
    fDBFile : string;
    fBLibrary : string;
    procedure DeclareAndSetVars(ds : TpFIBDataSet; params : array of variant);
    procedure DDBAfterConnect(Sender: TObject);
  public
    { Public declarations }
    Function Connect(pUsuario, pPassword : string) : string; override;
    Function Connected : boolean; override;
    function dset(pSQL : string; pParams : array of variant; pReadonly : boolean): TDataSet; overload;override;
    function dset(pSQL : string; pParams : array of variant; pSource : tdatasource; pKeyFields : string; pReadonly : boolean): TDataSet;overload;override;
    Function GetParam(pidform:integer; pParName : string) : string; override;
    Function ExecSQL(pSQL : string; pParamList: array of Variant) : string; override;
    procedure ExecProc(pProcname : string; pParamList : array of Variant); override;
    function ExecFunc(pFunctName : string; pParamList : array of Variant): variant; override;
    procedure ChangeParam(pIDForm : integer; pParamName, value : string); override;
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TDMFirebird }

procedure TDMDATA.ChangeParam(pIDForm : integer; pParamName, value: string);
begin
  inherited;
  ExecProc('POW_CHANGEPARAM',[pIDForm,pParamName, value]);
end;

function TDMDATA.Connect(pUsuario, pPassword: string): string;
begin
  result := '';
  try
    with DB do
    begin
      LibraryName := fBLibrary;
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

function TDMDATA.Connected: boolean;
begin
  result := DB.Connected;
end;

constructor TDMDATA.create(aOwner: TComponent);
begin
  inherited;
  LoadConfig;

  //Create DB objects
  DB := tpFibDatabase.Create(self);
  fTR := tpFibTransaction.Create(self);
  fTRU := tpFibTransaction.Create(self);

  with DB do
  Begin
    DefaultTransaction := fTR;
    DefaultUpdateTransaction := fTRU;
  end;
end;

procedure TDMDATA.DDBAfterConnect(Sender: TObject);
begin
  fAdminUser := true;
end;

procedure TDMDATA.DeclareAndSetVars(ds: TpFIBDataSet;
  params: array of variant);
begin
  ds.SetParamValues(params);
end;

destructor TDMDATA.Destroy;
var
  i : integer;
  d : TDataSet;
begin

  for i := 0 to DSCount - 1 do
  begin
    d := DSList[i];
    if d <> nil then
    with d do
    begin
      if Active then
        Close;
      Free;
    end;
  end;


  if db.Connected then
    db.Connected := false;
  db.Free;
  inherited;
end;





function TDMDATA.dset(pSQL: string; pParams: array of variant;
  pSource: tdatasource; pKeyFields: string; pReadonly: boolean): TDataSet;
var
  d : TpFIBDataSet;
  s : TDataSource;
  t, tu : TpFIBTransaction;
  tablelist, tablename : string;
  vSQLParserSelect: ISQLParserSelect;
begin
  d := TpFIBDataSet.Create(self);
  s := TDataSource.Create(self);
  s.DataSet := d;

  t := TpFIBTransaction.Create(self);
  tu := TpFIBTransaction.Create(self);
  t.DefaultDatabase := db;
  tu.DefaultDatabase := db;

  d.Database := db;
  d.SQLs.SelectSQL.Text := pSQL;
  d.AutoCommit := true;

  vSQLParserSelect := TGaSQLParserFactory.Select(pSQL);
  tablelist := vSQLParserSelect.From;
  tablename := uppercase(trim(token(tablelist,',')));

  with d.AutoUpdateOptions do
  begin
    UpdateTableName := tablename;
    AutoParamsToFields := true;
    AutoRewritesqls := true;
    keyfields := pKeyfields;
  end;
  d.DataSource := psource;

  d.Open;

  if not pReadonly
  then d.GenerateSQLs
  else d.AllowedUpdateKinds := [];

  SetLength(DSList,High(dslist) + 2);
  DSList[High(DSList)] := d;

  result := DSList[High(DSList)];

end;

function TDMDATA.dset(pSQL: string; pParams: array of variant;
  pReadonly: boolean): TDataSet;
var
  d : TpFIBDataSet;
  s : TDataSource;
  t, tu : TpFIBTransaction;
  tablelist, tablename : string;
  vSQLParserSelect: ISQLParserSelect;
begin
  Result := nil;
  d := TpFIBDataSet.Create(self);
  s := TDataSource.Create(self);
  s.DataSet := d;
  t := TpFIBTransaction.Create(self);
  tu := TpFIBTransaction.Create(self);
  t.DefaultDatabase := db;
  tu.DefaultDatabase := db;

  d.Database := db;
  d.SQLs.SelectSQL.Text := pSQL;
  d.AutoCommit := true;



  vSQLParserSelect := TGaSQLParserFactory.Select(pSQL);
  tablelist := vSQLParserSelect.From;
  tablename := uppercase(trim(token(tablelist,',')));
  d.AutoUpdateOptions.UpdateTableName := tablename;

  d.SetParamValues(pParams);
  d.Open;


  if not pReadonly
  then d.GenerateSQLs
  else d.AllowedUpdateKinds := [];

  SetLength(DSList,High(dslist) + 2);
  DSList[High(DSList)] := d;

  result := DSList[High(DSList)];
end;



function TDMDATA.ExecFunc(pFunctName: string;
  pParamList: array of Variant): variant;
var
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
  sp.StoredProcName := pFunctName;
  sp.SetParamValues(pParamList);

  sp.ExecProc;
  result := sp.Fields[0].Value;
  sp.Free;

end;

procedure TDMDATA.ExecProc(pProcname: string; pParamList: array of Variant);
var
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

function TDMDATA.ExecSQL(pSQL: string;pParamList: array of Variant): string;
var
  q : TpFIBQuery;
  t : tpFibTransaction;
begin
  q := TpFIBQuery.Create(self);
  t := tpFibTransaction.Create(self);
  t.DefaultDatabase := db;
  t.Active := true;
  q.Database := db;
  q.Transaction := t;
  q.Options := [qoStartTransaction,qoAutoCommit];
  q.SQL.Text := pSQL;
  q.SetParamValues(pParamList);
  q.ExecQuery;
  q.Free;
end;


procedure TDMDATA.loadConfig;
var
  d : IXMLDocument;
  e : IXMLNode;
begin
  inherited;
  DB := TpFIBDatabase.Create(self);
  ftr := TpFIBTransaction.Create(self);
  fTRU := TpFIBTransaction.Create(self);

  fAdminUser := false;

  db.DefaultTransaction := ftr;
  db.DefaultUpdateTransaction := ftru;
  //db.BeforeConnect := DBBeforeConnect;
  db.AfterConnect := DDBAfterConnect;

  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\config.xml');
  e := d.DocumentElement;
  with e.ChildNodes['DBManager'] do
  begin
    fDBMAN := ChildNodes['DBMNAME'].Text;     //Inherited
    fVersion := ChildNodes['DBMVERSION'].Text;  //Inherited
    //fMainParTable := ChildNodes['MAINPAR_TABLE'].Text;
    with ChildNodes['DBSETTINGS'] do
    begin
       FBlibrary := Attributes['FBLIBRARY'];
       fDBFile := Attributes['FBFILE'];
       FBDialect := strtoint(Attributes['FBDIALECT']);
       FLoginPrompt := Attributes['LOGINPROMPT'] = 'S';  //Inherited
       fHost := Attributes['HOST'];

       if (Attributes['LOGINATTEMPTS'] = null)or(Attributes['LOGINATTEMPTS'] = '')
       then fLoginAttempts := 3
       else fLoginAttempts := Attributes['LOGINATTEMPTS'];

       if fhost = '' then fhost := 'localhost';

       if Attributes['PORT'] <> ''
       then fPort := strtoint(Attributes['PORT'])
       else fPort := 3050;
    end;
  end;
//  fdbman := 'FIREBIRD';
//  fVersion := '2.5';
//  fLoginPrompt := true;
//  fLoginAttempts := 3;
//  fAdminUser := true;
//  fDialect := 3;
//  fHost := 'LOCALHOST';
//  fPort := 3050;
//  fDBFile := 'E:\Proyectos\PowERP\V2\Bin\Data\data3.fdb';
//  fLibrary := 'fbclient.dll';
end;

function TDMDATA.GetInt(pSQL: string; pParamList: array of Variant): integer;
begin

end;

function TDMDATA.GetParam(pidform:integer; pParName: string): string;
var
  nm, par, val : string;
begin
  val := ExecFunc('POW_GETPARAM',[pidform,pParName]);
  Result := val;
end;


function TDMDATA.GetVariant(pSQL: string;
  pParamList: array of Variant): variant;
begin

end;

initialization
  RegisterClass(TDMDATA);
finalization
  UnRegisterClass(TDMDATA);

end.
