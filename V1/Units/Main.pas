unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxRibbonForm, dxSkinsCore, dxSkinBlack,
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
  dxRibbonCustomizationForm, dxStatusBar, dxRibbonStatusBar, cxClasses,
  dxRibbon, dxBar, uDMRoot, dxRibbonRadialMenu, Vcl.Menus;

type
  TfrmMain = class(TdxRibbonForm)
    BMan: TdxBarManager;
    ribMainTab1: TdxRibbonTab;
    ribMain: TdxRibbon;
    rsbMain: TdxRibbonStatusBar;
    rrmMain: TdxRibbonRadialMenu;
    blbTabsConfig: TdxBarLargeButton;
    blbBarraConfig: TdxBarButton;
    blbStatusBar: TdxBarLargeButton;
    pumStatus: TPopupMenu;
    Agregar1: TMenuItem;
    pumRibbon: TPopupMenu;
    AgregarPestaa1: TMenuItem;
    Eliminarpestaa1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure blbTabsConfigClick(Sender: TObject);
    procedure blbBarraConfigClick(Sender: TObject);
    procedure blbStatusBarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ribMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AgregarPestaa1Click(Sender: TObject);
    procedure Eliminarpestaa1Click(Sender: TObject);
  private
    { Private declarations }
    Procedure LoadSettings;
    Procedure SaveSettings;
    function ChangePar(parval : boolean; dbpar : string): boolean;
    Procedure SavePar(pParval : boolean; pParName : string);
    procedure UpdatePumRibbon;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.blbStatusBarClick(Sender: TObject);
begin
  rsbMain.Visible := not rsbMain.Visible;
end;

procedure TfrmMain.blbTabsConfigClick(Sender: TObject);
begin
  ribmain.ShowTabHeaders := not ribmain.ShowTabHeaders;
end;

function TfrmMain.ChangePar(parval: boolean; dbpar: string) : boolean;
var
  s, csql, r : string;
begin
  result := not parval;
  if result
  then s := 'S'
  else s := 'N';
  csql := 'update ' + dm.MainParTable + ' set valor = ''' + s + ''' where parametro = ''' + dbpar + '''';
  r := dm.ExecSQL(csql);
end;

procedure TfrmMain.Eliminarpestaa1Click(Sender: TObject);
begin
  if not (MessageDlg('?Est? seguro que quiere eliminar la pesta?a "' + ribMain.ActiveTab.Caption + '" y todo su contenido?', mtConfirmation, [mbYes, mbNo], 0) = mrYES) then Exit;
  dm.ExecSQL('delete from pow_tabs where orden = ' + IntToStr(ribMain.ActiveTab.Index) );
  ribMain.Tabs.Delete(ribMain.ActiveTab.Index);
  UpdatePumRibbon;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //SaveSettings;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //Se leen caracter?sticas generales desde la Base de datos
  //LoadSettings;

end;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    with ribMain.ClientToScreen(Point(x,y)) do
      rrmMain.Popup(x,y);
end;

procedure TfrmMain.LoadSettings;
var
  i : integer;

  procedure LoadTabs;
  var
    s : string;
  begin
    with dm.DSET('select caption, id_tab from pow_tabs order by orden') do
    begin
      i := 0;
      while not eof do
      begin
        if ribmain.TabCount < i + 1 then
        begin
          ribmain.Tabs.Add;
        end;
        with ribmain.Tabs[i] do
        begin
          Caption := fieldbyname('caption').AsString;
          Tag := fieldbyname('id_tab').AsInteger;
        end;
        inc(i);
        next;
      end;
      close;free;
    end;
    s := dm.Parametro('ACTIVE_TAB');
    if s <> '' then
      ribmain.ActiveTab :=ribmain.Tabs[strtoint(s)-1];
  end;
begin
  with dm do
  begin
    ribmain.ShowTabHeaders := Parametro('TABS_VISIBLE') = 'S';
    ribmain.ShowTabGroups := Parametro('BAR_VISIBLE') = 'S';
    rsbMain.Visible := Parametro('MAINSB_VISIBLE') = 'S';
    if Parametro('MAIN_MAXIMIZED') = 'S'
    then frmmain.WindowState := wsMaximized
    else frmmain.WindowState := wsNormal;

    LoadTabs;

  end;
end;

procedure TfrmMain.ribMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbRight then
    with ribmain.ClientToScreen(point(x,y)) do
      pumRibbon.Popup(x,y);
end;

procedure TfrmMain.SavePar(pParval: boolean; pParName: string);
var s, csql : string;
begin
  if pParVal
  then s := 'S'
  else s := 'N';
  csql := 'update ' + dm.MainParTable + ' set valor = ''' + s + ''' where parametro = ''' + pParName + '''';
  dm.ExecSQL(csql);
end;

procedure TfrmMain.SaveSettings;
var
  n : integer;
  csql, r : string;
begin
  SavePar(ribmain.ShowTabHeaders,'TABS_VISIBLE');
  SavePar(ribmain.ShowTabGroups,'BAR_VISIBLE');
  SavePar(rsbMain.Visible,'MAINSB_VISIBLE');
  SavePar(frmmain.WindowState = wsMaximized,'MAIN_MAXIMIZED');

  n := dm.GetInt('select count(*) from pow_mainpar where parametro = ''ACTIVE_TAB'' ');
  if n > 0 then
    if ribMain.TabCount > 0
    then csql := 'update POW_MAINPAR set valor = ''' + inttostr(ribmain.ActiveTab.Index+1) + ''' where parametro = ''ACTIVE_TAB'''
    else csql := 'update POW_MAINPAR set valor = ''-1'' where parametro = ''ACTIVE_TAB'''
  else
    if ribMain.TabCount > 0
    then csql := 'insert into pow_mainpar(PARAMETRO,VALOR) values(''ACTIVE_TAB'',''' + inttostr(ribmain.ActiveTab.Index + 1) + ''')'
    else csql := 'insert into pow_mainpar(PARAMETRO,VALOR) values(''ACTIVE_TAB'',''-1'')';

  r := dm.ExecSQL(csql);
end;

procedure TfrmMain.UpdatePumRibbon;
begin
  Eliminarpestaa1.Visible := ribMain.TabCount > 0;
end;

procedure TfrmMain.AgregarPestaa1Click(Sender: TObject);
var
  s : string;
begin
  s := inputbox('Nueva pesta?a','Etiqueta:','');
  with ribMain.Tabs.Add do
  begin
    caption := s;
    tag := ribmain.TabCount;
    dm.ExecSQL('insert into pow_tabs(caption, orden) values(''' + s + ''',' + inttostr(tag) + ')');
  end;
  with ribmain do
    ActiveTab := Tabs[TabCount - 1];
end;

procedure TfrmMain.blbBarraConfigClick(Sender: TObject);
begin
  ribmain.ShowTabGroups := not ribmain.ShowTabGroups;
end;

end.
