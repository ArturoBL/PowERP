unit uDMFirebird;

interface

uses
  System.SysUtils, System.Classes, uDMRoot, vcl.dialogs, XMLDoc,XMLIntf, vcl.forms,
  FIBDatabase, pFIBDatabase, variants, db, pFIBDataSet, FIBQuery, pFIBQuery,pFIBProps;

type
  TDMData = class(TDMRoot)
    fbDB: TpFIBDatabase;
    fbt: TpFIBTransaction;
    fbtU: TpFIBTransaction;

  private
    { Private declarations }
    FBlibrary, FBFile, fhost : string;
    FBDialect, fport : integer;
    fUsuario, fpassword : string;
    procedure DBBeforeConnect(Database: TFIBDatabase;LoginParams: TStrings; var DoConnect: Boolean);
    Procedure DDBAfterConnect(Sender : TObject);
  public
    { Public declarations }
    Function Conectar(pUsuario, pPassword : string) : string;  override;
    constructor Create(AOwner : tcomponent); override;
    Function Connected : boolean; override;
    Function DSET(pSQL : string) : tDataset; override;
    function GetVariant(pSQL : string) : variant; override;
    function GetInt(pSQL : string) : integer; override;
    function GetString(pSQL : string) : string; override;
    Function Parametro(pParName : string) : string; override;
    function ExecSQL(pSQL : string) : string; override;
  end;

var
  DMData: TDMData;

implementation

{ TDMData }

function TDMData.Conectar(pUsuario, pPassword: string): string;
begin
  result := '';
  try
    fUsuario := pUsuario;
    fPassword := pPassword;
    fbdb.Connected := true;

  except on e: exception do
    result := e.Message;
  end;
end;



function TDMData.Connected: boolean;
begin
  result := fbdb.Connected;
end;

constructor TDMData.Create(AOwner: tcomponent);
var
  d : IXMLDocument;
  e : IXMLNode;
begin
  inherited;
  fbDB := TpFIBDatabase.Create(self.Owner);
  fbt := TpFIBTransaction.Create(self.Owner);
  fbtU := TpFIBTransaction.Create(self.Owner);

  fAdminUser := false;

  fbdb.DefaultTransaction := fbt;
  fbdb.DefaultUpdateTransaction := fbtu;
  fbdb.BeforeConnect := DBBeforeConnect;
  fbdb.AfterConnect := DDBAfterConnect;

  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\config.xml');
  e := d.DocumentElement;
  with e.ChildNodes['DBManager'] do
  begin
    fDBMAN := ChildNodes['DBMNAME'].Text;     //Inherited
    fVersion := ChildNodes['DBMVERSION'].Text;  //Inherited
    fMainParTable := ChildNodes['MAINPAR_TABLE'].Text;
    with ChildNodes['DBSETTINGS'] do
    begin
       FBlibrary := Attributes['FBLIBRARY'];
       FBFile := Attributes['FBFILE'];
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
end;

procedure TDMData.DBBeforeConnect(Database: TFIBDatabase; LoginParams: TStrings;
  var DoConnect: Boolean);
begin
  with Database.ConnectParams do
  begin
    username := fUsuario;
    Password := fPassword;
  end;
  Database.DBNAME := fhost + '/' + inttostr(fport) + ':' + FBFile;
  Database.LibraryName := FBlibrary;
end;

procedure TDMData.DDBAfterConnect(Sender: TObject);
begin
  fAdminUser := true;
end;

function TDMData.DSET(pSQL: string): tDataset;
var
  ds : TpFIBDataSet;
begin
  ds := TpFIBDataSet.Create(self);
  with ds do
  begin
    Database := fbDB;
    SQLs.SelectSQL.Text := pSQL;
    AutoCommit := true;
    result := ds;
    Open;
  end;
end;

Function TDMData.ExecSQL(pSQL : string) : string;
var
  qry : TpFIBQuery;
  t : TpFIBTransaction;
begin
  inherited;
  qry := TpFIBQuery.Create(self);

  t := TpFIBTransaction.Create(self.Owner);
  t.DefaultDatabase := fbdb;
  t.Active := true;
  qry.Transaction := t;

  with qry do
  begin
    Database := fbDB;
    SQL.Text := pSql;
    Options := [qoStartTransaction,qoAutoCommit];
    try
      ExecQuery;
      //t.Free;
      Free;
    except
      on e: exception do
      begin
        result := 'Error: ' + e.Message;
        Free;
      end;
    end;

  end;
end;

function TDMData.GetInt(pSQL: string): integer;
begin
  with dset(psql) do
  begin
    result := Fields[0].AsInteger;
    close;free;
  end;
end;

function TDMData.GetString(pSQL: string): string;
begin
  with dset(psql) do
  begin
    result := Fields[0].AsString;
    close;free;
  end;
end;

function TDMData.GetVariant(pSQL: string): variant;
begin
  with dset(psql) do
  begin
    result := Fields[0].Value;
    close;free;
  end;
end;

function TDMData.Parametro(pParName: string): string;
var csql : string;
begin
  csql := 'select valor from ' + fMainParTable + ' where parametro = ''' + pParName + '''';
  result := getString(csql);
  //result := 'N';
end;

initialization
  RegisterClass(TDMData);
finalization
 UnRegisterClass(TDMData);

end.
