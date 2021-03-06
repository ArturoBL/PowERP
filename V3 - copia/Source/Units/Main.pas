unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  cxClasses, dxBar, dxRibbonForm, uDMRoot, Vcl.Menus, db;

type
  TfrmMain = class(TdxRibbonForm)
    bMan: TdxBarManager;
    ribMain: TdxRibbon;
    sbMain: TdxRibbonStatusBar;
    pmMain: TPopupMenu;
    MostrarOcultarpestaas1: TMenuItem;
    MostrarOcultarbarradebotones1: TMenuItem;
    MostrarOcultarbarradeestado1: TMenuItem;
    pmRib: TPopupMenu;
    AgregarPestaa1: TMenuItem;
    Eliminarpestaaactiva1: TMenuItem;
    Moverpestaaalaizquierda1: TMenuItem;
    Moverpestaaaladerecha1: TMenuItem;
    Cambiarttulodelaventana1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MostrarOcultarpestaas1Click(Sender: TObject);
    procedure MostrarOcultarbarradebotones1Click(Sender: TObject);
    procedure MostrarOcultarbarradeestado1Click(Sender: TObject);
    procedure ribMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AgregarPestaa1Click(Sender: TObject);
    procedure Eliminarpestaaactiva1Click(Sender: TObject);
    procedure Moverpestaaalaizquierda1Click(Sender: TObject);
    procedure Moverpestaaaladerecha1Click(Sender: TObject);
    procedure Cambiarttulodelaventana1Click(Sender: TObject);
  private
    { Private declarations }
    idf : Integer;
    dlgNewTab, dlgNewTabpr : string;
    procedure LoadConfig;
    procedure SaveConfig;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.AgregarPestaa1Click(Sender: TObject);
var
  c : string;
  t : TdxRibbonTab;
begin
  c := InputBox(dlgNewTab,dlgNewTabpr,'');

  t := ribMain.Tabs.Add;
  with t do
  begin
    DM.ExecProc('POW_ADDTABS',[idf, c]);
    Caption := c;
  end;
  ribMain.ActiveTab := t;
end;

procedure TfrmMain.Cambiarttulodelaventana1Click(Sender: TObject);
var
  c : string;
begin
  c := InputBox('T?tulo ventana','Escriba el t?tulo de la ventana:',frmMain.Caption);
  frmMain.Caption := c;
end;

procedure TfrmMain.Eliminarpestaaactiva1Click(Sender: TObject);
begin
  if not (MessageDlg('?Est? seguro que desea eliminar la pesta?a actual y todo su contenido?', mtConfirmation, [mbYes, mbNo], 0) in [mrYes, mrNone]) then Exit;
  DM.ExecProc('POW_DELTAB',[idf, ribMain.ActiveTab.Index]);
  ribMain.Tabs.Delete(ribMain.ActiveTab.Index);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveConfig;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LoadConfig;
end;

procedure TfrmMain.LoadConfig;


  procedure LoadTabs;
  var
    d: tdataset;
    ai,i : Integer;
    t : TdxRibbonTab;
  begin
    ai := Strtoint(DM.GetParam(idf,'ACTIVE_TAB'));
    d := DM.DSeT('select * from pow_tabs where id_form = ?id_form order by indice',[1], true);
    if d.Active then
    with d do
    begin
      i := 0;
      while not eof do
      begin
        t := ribMain.Tabs.Add;
        t.Caption := FieldByName('caption').AsString;
        if ai = i then
          ribMain.ActiveTab := t;
        Next;
        Inc(i);
      end;
      close;
    end;


  end;

begin
  with DM do
  begin
    idf := DM.GetInt('select * from pow_forms where form_name = ?id_form',['frmMain']);

    dlgNewTab     := 'Nueva pesta?a';
    dlgNewTabpr   := 'Escriba la etiqueta de la pesta?a:';

    frmMain.Caption := GetParam(idf,'FORM_CAPTION');
    ribMain.ShowTabHeaders := GetParam(idf,'TABS_VISIBLE') = 'S';
    ribMain.ShowTabGroups := GetParam(idf,'BAR_VISIBLE') = 'S';
    sbMain.Visible := GetParam(idf,'SB_VISIBLE') = 'S';

    if GetParam(idf,'FORM_MAXIMIZED') = 'S' then
      frmMain.WindowState := wsMaximized;
    LoadTabs;
  end;
end;

procedure TfrmMain.MostrarOcultarbarradebotones1Click(Sender: TObject);
begin
  ribMain.ShowTabGroups := not ribMain.ShowTabGroups;
end;

procedure TfrmMain.MostrarOcultarbarradeestado1Click(Sender: TObject);
begin
  sbMain.Visible := not sbMain.Visible;
end;

procedure TfrmMain.MostrarOcultarpestaas1Click(Sender: TObject);
begin
  ribMain.ShowTabHeaders := not ribMain.ShowTabHeaders;
end;

procedure TfrmMain.Moverpestaaaladerecha1Click(Sender: TObject);
begin
  DM.ExecProc('POW_MOVETAB',[idf, ribMain.ActiveTab.Index,ribMain.ActiveTab.Index + 1]);
  ribMain.ActiveTab.Index := ribMain.ActiveTab.Index + 1;
end;

procedure TfrmMain.Moverpestaaalaizquierda1Click(Sender: TObject);
begin
  DM.ExecProc('POW_MOVETAB',[idf, ribMain.ActiveTab.Index,ribMain.ActiveTab.Index-1]);
  ribMain.ActiveTab.Index := ribMain.ActiveTab.Index - 1;
end;

procedure TfrmMain.ribMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    with Self.ClientToScreen(Point(x,y)) do
      pmRib.Popup(x,y);
end;

procedure TfrmMain.SaveConfig;
const cbool : array[0..1] of string = ('N','S');
begin
  with dm do
  begin
    ChangeParam(idf,'TABS_VISIBLE',cbool[ord(ribMain.ShowTabHeaders)]);
    ChangeParam(idf,'BAR_VISIBLE',cbool[ord(ribMain.ShowTabGroups)]);
    ChangeParam(idf,'SB_VISIBLE',cbool[ord(sbMain.Visible)]);
    if ribMain.ActiveTab <> nil then
      ChangeParam(idf,'ACTIVE_TAB',ribMain.ActiveTab.Index.ToString);
    ChangeParam(idf,'FORM_MAXIMIZED',cbool[Ord(frmMain.WindowState = wsMaximized)]);
    ChangeParam(idf,'FORM_CAPTION',frmmain.Caption);
  end;
end;

end.
