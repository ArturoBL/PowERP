unit uDMRoot;

interface

uses classes, db, sysutils, Variants, XMLDoc, vcl.Forms, Vcl.Dialogs,
  XMLIntf;

type
  TDSetNode = record ds : tdataset; src : TDataSource; end;
  TDMRoot = class(TComponent)
  protected
    fDBMAN: string;
    fVersion: string;
    fLoginPrompt: boolean;
    fLoginAttempts: integer;
    fAdminUser: boolean;
    function getDSCount: Integer;
    function token(var cad:string;sep:string):string;
  public
    { Public declarations }
    DSList : array of TDataSet;
    property DSCount : Integer read getDSCount;
    Property DBMAN : string read fDBMAN;
    Property VERSION : string read fVersion;
    Property LoginPrompt : boolean read fLoginPrompt;
    Property LoginAttempts : integer read fLoginAttempts;
    Property AdminUser : boolean read fAdminUser;
    Function Connect(pUsuario, pPassword : string) : string; virtual;
    Function Connected : boolean; virtual;
    function dset(pSQL : string; pParams : array of variant; pReadonly : boolean): TDataSet; overload; virtual;
    function dset(pSQL : string; pParams : array of variant; pSource : tdatasource; pKeyFields : string; pReadonly : boolean): TDataSet;overload;virtual;
    function GetVariant(pSQL : string; pParamList : array of Variant) : variant;
    function GetInt(pSQL : string; pParamList : array of Variant) : integer;
    function GetString(pSQL : string; pParamList : array of Variant) : string;
    function GetDate(pSQL : string; pParamList : array of Variant) : tdatetime;
    function GetFloat(pSQL : string; pParamList : array of Variant) : single;
    Function GetParam(pidform:integer; pParName : string) : string; virtual;
    Function ExecSQL(pSQL : string; pParamList: array of Variant) : string; virtual;
    procedure ExecProc(pProcname : string; pParamList : array of Variant); virtual;
    function ExecFunc(pFunctName : string; pParamList : array of Variant): variant; virtual;
    procedure ChangeParam(pIDForm : integer; pParamName, value : string); virtual;
  end;

  TAppHeader = record SplashFile, DBMName, DBMVersion : string; end;

var
  DM: TDMRoot;
  cfg : IXMLDocument;
  AppHeader : TAppHeader;

function cfgFile : string;
function LoadHeader : TAppHeader;
function DBMFilename(pFBMName : string) : string;

implementation

{ TDMRoot }

function cfgFile : string;
begin
  Result := extractfilepath(application.ExeName) + '\DATA\config.xml'
end;

function LoadHeader : TAppHeader;
var
  e : IXMLNode;
  arch : string;
begin
  if not FileExists(cfgFile) then Exit;

  cfg := LoadXMLDocument(cfgFile);
  with result do
  begin
    e := cfg.DocumentElement;
    if trim(e.ChildNodes['SPLASH'].Text) <> '' then
    begin
      SplashFile :=extractfilepath(application.ExeName) + 'MEDIA\' + trim(e.ChildNodes['SPLASH'].Text);
      if not fileexists(SplashFile) then
        SplashFile := '';
    end;
    DBMName := e.ChildNodes['DBManager'].ChildNodes['DBMNAME'].Text;
    DBMVersion := e.ChildNodes['DBManager'].ChildNodes['DBMNAME'].Text;
  end;
end;

function DBMFilename(pFBMName : string) : string;
var
  d : IXMLDocument;
  e,n : IXMLNode;
  i,x : integer;
begin
  Result := '';
  if not FileExists(extractfilepath(application.ExeName) + '\DATA\DBMList.xml') then exit;

  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\DBMList.xml');
  e := d.DocumentElement;

  x := -1;
  for i := 0 to e.ChildNodes.Count - 1 do
    if e.ChildNodes[i].NodeName = pFBMName then
    begin
      x := i;
      Break;
    end;
  if (X >= 0) and(e.ChildNodes[i].NodeName = pFBMName) then
    result := e.ChildNodes[i].Attributes['LIBFILE'];
end;

{ TDMRoot }

procedure TDMRoot.ChangeParam(pIDForm : integer; pParamName, value: string);
begin

end;

function TDMRoot.Connect(pUsuario, pPassword: string): string;
begin

end;

function TDMRoot.Connected: boolean;
begin

end;


function TDMRoot.dset(pSQL: string; pParams: array of variant;
  pSource: tdatasource; pKeyFields: string; pReadonly: boolean): TDataSet;
begin

end;

function TDMRoot.dset(pSQL: string; pParams: array of variant;
  pReadonly: boolean): TDataSet;
begin

end;

function TDMRoot.ExecFunc(pFunctName: string;
  pParamList: array of Variant): variant;
begin

end;

procedure TDMRoot.ExecProc(pProcname: string; pParamList: array of Variant);
begin

end;

function TDMRoot.ExecSQL(pSQL: string; pParamList: array of Variant): string;
begin

end;

function TDMRoot.GetDate(pSQL: string; pParamList: array of Variant): tdatetime;
begin
  result := TDateTime(GetVariant(pSQL,pParamList));
end;



function TDMRoot.getDSCount: Integer;
begin
  Result := High(DSList) + 1;
end;

function TDMRoot.GetFloat(pSQL: string; pParamList: array of Variant): single;
var v : Variant;
begin
  v := GetVariant(pSQL,pParamList);

  if v = null
  then result := 0
  else result := v;


end;

function TDMRoot.GetInt(pSQL: string; pParamList: array of Variant): integer;
var v : Variant;
begin
  v := GetVariant(pSQL,pParamList);

  if v = null
  then result := 0
  else result := v;

end;

function TDMRoot.GetString(pSQL: string; pParamList: array of Variant): string;
var v : Variant;
begin
  v := GetVariant(pSQL,pParamList);

  if v = null
  then result := ''
  else result := v;

end;

function TDMRoot.GetVariant(pSQL: string;
  pParamList: array of Variant): variant;
begin
  with dset(pSQL,pParamList,true) do
  begin
    Result := fields[0].Value;
    Close;
  end;
end;

function TDMRoot.token(var cad: string; sep: string): string;
var p,n:integer;
begin
   p:=pos(sep,cad);
   if p>0 then
      n:=p-1
   else
      n:=length(cad);
   result:=Trim(copy(cad,1,n));
   delete(cad,1,n+length(sep));
end;

function TDMRoot.GetParam(pidform : integer; pParName: string): string;
begin

end;

end.
