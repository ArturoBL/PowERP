unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,dxRibbonForm, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxSkinsdxBarPainter, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxRibbonSkins, dxSkinsdxRibbonPainter,
  dxRibbonCustomizationForm, dxStatusBar, dxRibbonStatusBar, dxRibbon,
  cxClasses, dxBar, Vcl.Menus, uDMRoot, Vcl.StdCtrls;


type
  TfrmMain = class(TdxRibbonForm)
    bman: TdxBarManager;
    ribMain: TdxRibbon;
    rsbMain: TdxRibbonStatusBar;
    pumMain: TPopupMenu;
    MostrarOcultarbarraprincipal1: TMenuItem;
    MostrarOcultarpestaas1: TMenuItem;
    MostrarOcultarbarradeestado1: TMenuItem;
    procedure MostrarOcultarbarraprincipal1Click(Sender: TObject);
    procedure MostrarOcultarpestaas1Click(Sender: TObject);
    procedure MostrarOcultarbarradeestado1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function cbool(pVal : Boolean) : string;
    function ChangeBoolParam(pParam : Boolean; pParamName : string): Boolean;
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function TfrmMain.cbool(pVal: Boolean): string;
begin
  if pVal 
  then result := 'S'
  else result := 'N';
end;

function TfrmMain.ChangeBoolParam(pParam: Boolean; pParamName: string): Boolean;
begin
  pParam := not pParam;
  DM.ExecProc('POW_CHANGEPARAM',[Self.Name,pParamName,cbool(pParam)]);
  result := pParam;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TfrmMain.MostrarOcultarbarradeestado1Click(Sender: TObject);
begin
  rsbMain.Visible := ChangeBoolParam(rsbMain.Visible,'SB_VISIBLE');
end;

procedure TfrmMain.MostrarOcultarbarraprincipal1Click(Sender: TObject);
begin
  ribMain.ShowTabGroups := ChangeBoolParam(ribMain.ShowTabGroups,'BAR_VISIBLE');
end;

procedure TfrmMain.MostrarOcultarpestaas1Click(Sender: TObject);
var b :Boolean;
begin
  b := ribMain.ShowTabHeaders;
  ribMain.ShowTabHeaders := ChangeBoolParam(b,'TABS_VISIBLE');
end;

procedure TfrmMain.SaveSettings;
begin
  DM.ExecProc('POW_CHANGEPARAM',[Self.Name,'TABS_VISIBLE','S']);
//  DM.ExecProc('POW_CHANGEPARAM',[Self.Name,'BAR_VISIBLE',cbool(ribMain.ShowTabGroups)]);
//  DM.ExecProc('POW_CHANGEPARAM',[Self.Name,'SB_VISIBLE',cbool(rsbMain.Visible)]);
end;

end.
