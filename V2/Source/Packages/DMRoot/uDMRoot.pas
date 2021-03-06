unit uDMRoot;

interface

uses classes, db;

type
  TDMRoot = class(TComponent)
  protected
    fDBMAN: string;
    fVersion: string;
    fLoginPrompt: boolean;
    fLoginAttempts: integer;
    fAdminUser: boolean;
  public
    { Public declarations }
    Property DBMAN : string read fDBMAN;
    Property VERSION : string read fVersion;
    Property LoginPrompt : boolean read fLoginPrompt;
    Property LoginAttempts : integer read fLoginAttempts;
    Property AdminUser : boolean read fAdminUser;
    Function Conectar(pUsuario, pPassword : string) : string; virtual;
    Function Connected : boolean; virtual;
    Function DSET(pSQL : string; pParamList : array of Variant) : tDataset; virtual;
    function GetVariant(pSQL : string; pParamList : array of Variant) : variant; virtual;
    function GetInt(pSQL : string; pParamList : array of Variant) : integer; virtual;
    function GetString(pSQL : string; pParamList : array of Variant) : string; virtual;
    function GetDate(pSQL : string; pParamList : array of Variant) : tdatetime; virtual;
    function GetFloat(pSQL : string; pParamList : array of Variant) : single; virtual;
    Function Parametro(sender: TObject; pParName : string) : string; virtual;
    Function ExecSQL(pSQL : string; pParamList: array of Variant) : string; virtual;
    procedure ExecProc(pProcname : string; pParamList : array of Variant); virtual;
    procedure ChangeParam(sender: TObject; pParamName, value : string); virtual;
  end;

var DM: TDMRoot;

implementation

{ TDMRoot }



{ TDMRoot }

procedure TDMRoot.ChangeParam(sender: TObject; pParamName, value: string);
begin

end;

function TDMRoot.Conectar(pUsuario, pPassword: string): string;
begin

end;

function TDMRoot.Connected: boolean;
begin

end;

function TDMRoot.DSET(pSQL: string; pParamList: array of Variant): tDataset;
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

end;

function TDMRoot.GetFloat(pSQL: string; pParamList: array of Variant): single;
begin

end;

function TDMRoot.GetInt(pSQL: string; pParamList: array of Variant): integer;
begin

end;

function TDMRoot.GetString(pSQL: string; pParamList: array of Variant): string;
begin

end;

function TDMRoot.GetVariant(pSQL: string;
  pParamList: array of Variant): variant;
begin

end;

function TDMRoot.Parametro(sender: TObject; pParName: string): string;
begin

end;

end.
