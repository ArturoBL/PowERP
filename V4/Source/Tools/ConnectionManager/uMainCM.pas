unit uMainCM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,XMLDoc,XMLIntf, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.StdCtrls, cxStyles,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxInplaceContainer,
  cxVGrid, cxCheckbox, cxSpinEdit, cxClasses, Vcl.ExtCtrls, GR32_Image, graphicex,
  Vcl.Menus, Vcl.ExtDlgs, cxButtons;

type

  TSettingsInfo = record
    SettingName : string;
    DefaultValue : string;
    SettingType : string;
    ronly : Boolean;
    options: array of string;
  end;

  TDBMVersionInfo = record
    VersionName : string;
    SettingList : array of TSettingsInfo;
  end;

  TDBMInfo = record
    DBMName : string;
    LibFile : string;
    versions : array of TDBMVersionInfo;
  end;

  TDBMList = array of TDBMInfo;


  TfrmMainCM = class(TForm)
    vg: TcxVerticalGrid;
    Panel1: TPanel;
    cxLabel1: TcxLabel;
    cbxMan: TcxComboBox;
    cxLabel2: TcxLabel;
    cbxVer: TcxComboBox;
    Panel2: TPanel;
    Panel3: TPanel;
    imgSplash: TImage32;
    pumSplash: TPopupMenu;
    Ninguna1: TMenuItem;
    Cargar1: TMenuItem;
    opd: TOpenPictureDialog;
    Panel4: TPanel;
    btnGuardar: TcxButton;
    csr: TcxStyleRepository;
    cxStyle1: TcxStyle;
    vgEditorRow1: TcxEditorRow;
    procedure FormCreate(Sender: TObject);
    procedure cbxManPropertiesChange(Sender: TObject);
    procedure cbxVerPropertiesChange(Sender: TObject);
    procedure Cargar1Click(Sender: TObject);
    procedure Ninguna1Click(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DBML : TDBMLIst;
    fcambios : Boolean;
    Procedure LoadConfig;
    procedure SaveConfig;
    Procedure LoadManagers;
    function getIm: integer;
    function getIv: integer;
    property im : integer read getIm;
    property iv : integer read getIv;
    procedure setRow(pRowName : string; val : variant);
    procedure ValueChanged(Sender: TObject);
  public
    { Public declarations }
    fSplash : string;
    Procedure LoadSplash;
  end;

var
  frmMainCM: TfrmMainCM;

implementation

{$R *.dfm}

{ TfrmMainCM }

procedure TfrmMainCM.btnGuardarClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmMainCM.Cargar1Click(Sender: TObject);
var
  arch1, arch2 : string;
begin
  if opd.Execute then
  begin
    arch1 := opd.FileName;
    fsplash := extractfilename(arch1);
    arch2 := extractfilepath(application.ExeName) + '\media\' + fsplash;
    CopyFile(pWidechar(arch1), pWidechar(arch2), false);

    LoadSplash;
    fcambios := True;
  end;
end;

procedure TfrmMainCM.cbxManPropertiesChange(Sender: TObject);
var i : integer;
begin
  cbxver.Properties.Items.Clear;

  if im < 0 then exit;

  for I := 0 to high(dbml[im].versions) do
    cbxver.Properties.Items.Add(dbml[im].versions[i].VersionName);
  cbxver.ItemIndex := 0;

  fcambios := True;
end;

procedure TfrmMainCM.cbxVerPropertiesChange(Sender: TObject);
var
  l : tcxlabel;
  i, y, j : integer;
  c : string;
  t : tcxtextedit;
begin
  vg.ClearRows;

  if (im >= 0) and (iv >= 0) then
  with dbml[im].versions[iv] do
  for i := 0 to High(SettingList) do
  with SettingList[i] do
  begin
    c := SettingName;
    with vg.add(TcxEditorRow) as TcxEditorRow do
    begin
      Properties.caption := c;
      if (high(SettingList[i].options) >= 0) and ((SettingList[i].options[0] = 'S') or (SettingList[i].options[0] = 'N')) then
      begin
        Properties.EditPropertiesClass := TcxCheckboxProperties;
        TcxCheckboxProperties(properties.EditProperties).ValueChecked := 'S' ;
        TcxCheckboxProperties(properties.EditProperties).ValueUnchecked := 'N' ;
      end
      else
      if (high(SettingList[i].options) >= 0) then
      BEGIN
        Properties.EditPropertiesClass := TcxComboboxProperties;
        for j := 0 to high(SettingList[i].options) do
          TcxComboboxProperties(properties.EditProperties).Items.Add(SettingList[i].options[j]);
      END
      ELSE
      begin
        if (defaultValue = 'S') or (defaultValue = 'N') then
        begin
          Properties.EditPropertiesClass := TcxCheckboxProperties;
          TcxCheckboxProperties(properties.EditProperties).ValueChecked := 'S' ;
          TcxCheckboxProperties(properties.EditProperties).ValueUnchecked := 'N' ;
        end
        else
        if settingtype = 'INT' then
        begin
          Properties.EditPropertiesClass := TcxSpinEditProperties;
        end
        else
        begin
          Properties.EditPropertiesClass := TcxTextEditProperties;
        end;

      end;
      properties.Value := defaultValue;
      properties.EditProperties.OnEditValueChanged := ValueChanged;
      Properties.EditProperties.ReadOnly := SettingList[i].ronly;
    end;
    inc(y,30);
  end;
  fcambios := True;
end;

procedure TfrmMainCM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btnGuardar.SetFocus;
  if (fcambios) and (MessageDlg('?Quiere guardar los cambios?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    SaveConfig;

end;

procedure TfrmMainCM.FormCreate(Sender: TObject);
begin
  LoadManagers;
  LoadConfig;
  fcambios := False;
end;

function TfrmMainCM.getIm: integer;
begin
  with cbxMan do
  if Text <> '' then
    ItemIndex := Properties.Items.IndexOf(text);
  result := cbxman.ItemIndex;
end;

function TfrmMainCM.getIv: integer;
begin
  with cbxVer do
  if Text <> '' then
    ItemIndex := Properties.Items.IndexOf(Text);
  result := cbxver.ItemIndex;
end;

procedure TfrmMainCM.LoadConfig;
var
  d : IXMLDocument;
  e : IXMLNode;
  i : integer;
  arch : string;
begin
  //Leemos los par{ametros de archivo
  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\config.xml');
  e := d.DocumentElement;

  fsplash := e.ChildNodes['SPLASH'].Text;
  if fsplash = '' then
    arch := 'none.png'
  else
    arch := fsplash;
  imgsplash.Bitmap.LoadFromFile(extractfilepath(application.ExeName) + '\media\' + arch);

  with e.ChildNodes['DBManager'] do
  begin
    cbxMan.Text := ChildNodes['DBMNAME'].Text;
    cbxVer.Text := ChildNodes['DBMVERSION'].Text;

    with ChildNodes['DBSETTINGS'] do
    for i  := 0 to AttributeNodes.Count - 1 do
      setRow(AttributeNodes[i].NodeName, AttributeNodes[i].Text);
  end;
end;

procedure TfrmMainCM.LoadManagers;
var
  d : IXMLDocument;
  e : IXMLNode;
  im, iv, ia, io : integer;
  c, r : string;
begin
  cbxman.Clear;
  cbxVer.Clear;
  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\DBMList.xml');
  e := d.DocumentElement;
  setlength(dbml,e.ChildNodes.Count);
  for im := 0 to e.ChildNodes.Count - 1 do
  with dbml[im],e.ChildNodes[im] do
  begin
    DBMName := NodeName;
    cbxman.Properties.Items.Add(DBMName);
    LibFile := Attributes['libfile'];
    setlength(versions,childnodes.Count);
    for iv := 0 to childnodes.Count - 1 do
    with versions[iv], childnodes[iv] do
    begin
      VersionName := NodeName;
      setlength(SettingList,childnodes.Count);
      for ia := 0 to childnodes.Count - 1 do
      with SettingList[ia], childnodes[ia] do
      begin
        SettingName := nodename;
        if attributes['default'] <> null then
          defaultvalue := attributes['default'];
        if attributes['type'] <> null then
          Settingtype := attributes['type'];

        ronly := (attributes['readonly'] <> null) and (attributes['readonly'] = 'S');

        setlength(options,childnodes.Count);
        for io := 0 to childnodes.Count - 1 do
        begin
          c:= childnodes[io].Text;
          options[io] := c;
        end;
      end;
    end;
  end;

end;

procedure TfrmMainCM.LoadSplash;
var
  arch : string;
begin
  if fsplash = ''
  then arch := 'none.png'
  else arch := fsplash;
  imgSplash.Bitmap.LoadFromFile(extractfilepath(application.ExeName) + '\media\' + arch);
end;

procedure TfrmMainCM.Ninguna1Click(Sender: TObject);
begin
  fsplash := '';
  loadsplash;
  fcambios := True;
end;

procedure TfrmMainCM.SaveConfig;
var
  d : IXMLDocument;
  e,n : IXMLNode;
  i : integer;
begin
  Screen.Cursor := crHourGlass;
  D := LoadXMLDocument(extractfilepath(application.ExeName) + '\DATA\config.xml');
  e := d.DocumentElement;
  e.ChildNodes['SPLASH'].Text := fsplash;

  with e.ChildNodes['DBManager'] do
  begin
    ChildNodes['DBMNAME'].Text := cbxMan.Text;
    ChildNodes['DBMVERSION'].Text := cbxVer.Text;
    with ChildNodes['DBSETTINGS'] do
    begin
      AttributeNodes.Clear;

      for i := 0 to vg.Rows.Count - 1 do
      with TcxEditorRow(vg.rows[i]).Properties do
      //if not EditProperties.ReadOnly then
        SetAttributeNS(Caption,'',Value);
    end;
  end;
  d.SaveToFile(extractfilepath(application.ExeName) + '\DATA\config.xml');
  fcambios := False;
  Screen.Cursor := crDefault;
end;

procedure TfrmMainCM.setRow(pRowName: string; val: variant);
begin
  TcxEditorRow(vg.RowByCaption(pRowName)).Properties.Value := val;
end;

procedure TfrmMainCM.ValueChanged(Sender: TObject);
begin
  fcambios := True;
end;

end.
