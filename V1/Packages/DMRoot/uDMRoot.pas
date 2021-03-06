unit uDMRoot;

interface

uses classes, db;

type
  TDMRoot = class(TComponent)
  protected
    fMainParTable: string;
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
    Function DSET(pSQL : string) : tDataset; virtual;
    function GetVariant(pSQL : string) : variant; virtual;
    function GetInt(pSQL : string) : integer; virtual;
    function GetString(pSQL : string) : string; virtual;
    Function Parametro(pParName : string) : string; virtual;
    Function ExecSQL(pSQL : string) : string; virtual;
    property MainParTable : string read fMainParTable;
  end;

var DM: TDMRoot;

implementation

{ TDMRoot }

function TDMRoot.Conectar(pUsuario, pPassword: string): string;
begin

end;

function TDMRoot.Connected: boolean;
begin

end;

function TDMRoot.DSET(pSQL: string): tDataset;
begin

end;

Function TDMRoot.ExecSQL(pSQL : string):string;
begin

end;

function TDMRoot.GetInt(pSQL: string): integer;
begin

end;

function TDMRoot.GetString(pSQL: string): string;
begin

end;

function TDMRoot.GetVariant(pSQL: string): variant;
begin

end;

function TDMRoot.Parametro(pParName: string): string;
begin

end;

end.
