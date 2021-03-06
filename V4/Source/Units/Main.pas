unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxRibbonSkins, dxRibbonCustomizationForm, dxStatusBar,
  dxRibbonStatusBar, cxClasses, dxRibbon, dxBar,
  dxRibbonForm, Vcl.Menus, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, db, uDMRoot, BarEditor;

type
  TfrmMain = class(TdxRibbonForm)
    bMan: TdxBarManager;
    ribMain: TdxRibbon;
    rsbMain: TdxRibbonStatusBar;
    pmMain: TPopupMenu;
    MostrarOcultarpestaas1: TMenuItem;
    MostrarOcultarbarradebotones1: TMenuItem;
    MostrarOcultarbarradeestado1: TMenuItem;
    Cambiarttulodelaventana1: TMenuItem;
    Editarbarra1: TMenuItem;
    pmRib: TPopupMenu;
    EditarBarra2: TMenuItem;
    procedure MostrarOcultarpestaas1Click(Sender: TObject);
    procedure MostrarOcultarbarradebotones1Click(Sender: TObject);
    procedure MostrarOcultarbarradeestado1Click(Sender: TObject);
    procedure Cambiarttulodelaventana1Click(Sender: TObject);
    procedure Editarbarra1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ribMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    xi,yi : Integer;

    procedure SaveConfig;
    procedure WMEnterSizeMove(var Message: TMessage) ; message WM_ENTERSIZEMOVE;
    procedure WMMove(var Message: TMessage) ; message WM_MOVE;
    procedure WMExitSizeMove(var Message: TMessage) ; message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    idf : Integer;
    procedure LoadConfig;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.Cambiarttulodelaventana1Click(Sender: TObject);
var
  c : string;
begin
  c := InputBox('T?tulo ventana','Escriba el t?tulo de la ventana:',frmMain.Caption);
  frmMain.Caption := c;
end;

procedure TfrmMain.Editarbarra1Click(Sender: TObject);
begin
  if (not Assigned(frmBarEditor))or(frmBarEditor.Owner = nil) then
    Application.CreateForm(TfrmBarEditor, frmBarEditor);
  frmBarEditor.BuildEditorList(self, idf);
  frmBarEditor.Show;
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
    tb : tdxbar;
  begin
//    ai := Strtoint(DM.GetParam(idf,'ACTIVE_TAB'));
    ai := -1;
    ribMain.Tabs.Clear;
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
        with DM.dset('select * from pow_groups where id_form = ?id_form and id_tab = ?id_tab order by indice',[idf,FieldByName('id_tab').AsInteger], true) do
        begin
          while not eof do
          begin
            tb := bman.AddToolBar;
            tb.Caption := FieldByName('caption').AsString;
            t.AddToolBar(tb);
            Next;
          end;
          close;
        end;
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


    frmMain.Caption := GetParam(idf,'FORM_CAPTION');
    ribMain.ShowTabHeaders := GetParam(idf,'TABS_VISIBLE') = 'S';
    ribMain.ShowTabGroups := GetParam(idf,'BAR_VISIBLE') = 'S';
    rsbMain.Visible := GetParam(idf,'SB_VISIBLE') = 'S';

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
  rsbMain.Visible := not rsbMain.Visible;
end;

procedure TfrmMain.MostrarOcultarpestaas1Click(Sender: TObject);
begin
  ribMain.ShowTabHeaders := not ribMain.ShowTabHeaders;
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
    ChangeParam(idf,'SB_VISIBLE',cbool[ord(rsbMain.Visible)]);
    if ribMain.ActiveTab <> nil then
      ChangeParam(idf,'ACTIVE_TAB',ribMain.ActiveTab.Index.ToString);
    ChangeParam(idf,'FORM_MAXIMIZED',cbool[Ord(frmMain.WindowState = wsMaximized)]);
    ChangeParam(idf,'FORM_CAPTION',frmmain.Caption);
  end;
end;

procedure TfrmMain.WMEnterSizeMove(var Message: TMessage);
begin
  if (frmBarEditor <> nil)and (frmBarEditor.Owner <> nil) then
  begin
    xi := frmBarEditor.Left - Self.Left;
    yi := frmBarEditor.Top - Self.Top;
  end;
end;

procedure TfrmMain.WMExitSizeMove(var Message: TMessage);
begin

end;

procedure TfrmMain.WMMove(var Message: TMessage);
begin
  if (frmBarEditor <> nil)and (frmBarEditor.Owner <> nil) then
  begin
    frmBarEditor.Left := Self.Left + xi;
    frmBarEditor.Top := Self.Top + yi;
  end;
end;

end.
