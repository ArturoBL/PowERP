unit BarEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.ExtCtrls, cxInplaceContainer, dxribbon, dxBar,
  cxTextEdit, Vcl.StdCtrls,uDMRoot, Vcl.ImgList, Vcl.Menus, cxButtons,
  cxDataControllerConditionalFormattingRulesManagerDialog,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinTheBezier,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, System.ImageList, cxImageList;

type
  TfrmBarEditor = class(TForm)
    ctl: TcxTreeList;
    pnl: TPanel;
    ctlColumn1: TcxTreeListColumn;
    cil: TcxImageList;
    cbtAgregar: TcxButton;
    cbtEliminar: TcxButton;
    cbtIndexDown: TcxButton;
    cbtIndexUp: TcxButton;
    cbtEtiqueta: TcxButton;
    lbl1: TLabel;
    cbtVisible: TcxButton;
    procedure ctlClick(Sender: TObject);
    procedure cbtAgregarClick(Sender: TObject);
    procedure cbtEliminarClick(Sender: TObject);
    procedure cbtIndexDownClick(Sender: TObject);
    procedure cbtIndexUpClick(Sender: TObject);
    procedure cbtEtiquetaClick(Sender: TObject);
  private
    { Private declarations }
    rib : tdxribbon;
    fidf : Integer;
    rnode : TcxTreeListNode;
    fForm : TForm;
    bm : TdxBarManager;
    procedure checkbuttons;
    procedure tladdgoup(pindext : Integer; pCaption : string);
    function tabnode(pFN : TcxTreeListNode) : TcxTreeListNode;
  public
    { Public declarations }
    procedure updateFocused;
    procedure BuildEditorList(pForm : TForm; pidf : integer);
  end;

var
  frmBarEditor: TfrmBarEditor;

implementation

uses
  Main;

{$R *.dfm}

procedure TfrmBarEditor.tladdgoup(pindext: Integer; pCaption: string);
var
  n : TcxTreeListNode;
begin
  n := rnode.Items[pindext].AddChild;
  n.Texts[0] := pCaption;
  n.StateIndex := 2;
end;



procedure TfrmBarEditor.BuildEditorList(pForm : TForm; pidf : integer);
var
  i,j,idt : integer;
  n : TcxTreeListNode;
begin
  fidf := pidf;
  fForm := pForm;
  rnode := ctl.Items[0];
  rnode.DeleteChildren;
  bm := TdxBarManager(fForm.FindComponent('bMan'));
  rib := TdxRibbon(fForm.FindComponent('ribMain'));
  if (bm <> nil) and (rib <> nil) then
  begin


    for i := 0 to rib.TabCount -1 do
    if ctl <> nil then
    begin
      n := ctl.items[0].AddChild;
      n.Texts[0] := rib.Tabs[i].Caption;
      n.StateIndex :=1;
      for j := 0 to rib.Tabs[i].Groups.Count - 1 do
        tladdgoup(i,rib.Tabs[i].Groups[j].Caption);
    end;
  end;
  if rib.TabCount > 0 then
  begin
    ctl.FocusedNode := rnode.Items[rib.ActiveTab.Index];
    rnode.Expand(true);
  end
  else
  begin
    ctl.FocusedNode := ctl.Items[0];
  end;
  checkbuttons;
end;

procedure TfrmBarEditor.checkbuttons;
begin
  cbtEliminar.Enabled := (ctl.FocusedNode <> nil)and(ctl.FocusedNode <> rnode);
  cbtIndexDown.Enabled := (ctl.FocusedNode <> nil)and(ctl.FocusedNode <> rnode) and (ctl.FocusedNode.Index > 0);
  cbtIndexUp.Enabled := (ctl.FocusedNode <> nil) and(ctl.FocusedNode <> rnode) and (ctl.FocusedNode.Index < ctl.FocusedNode.Parent.Count - 1);
  cbtEtiqueta.Enabled := (ctl.FocusedNode <> nil)and(ctl.FocusedNode <> rnode);
  cbtVisible.Enabled := (ctl.FocusedNode <> nil)and(ctl.FocusedNode <> rnode);
end;

procedure TfrmBarEditor.ctlClick(Sender: TObject);
var
  n, fn : TcxTreeListNode;
begin
  n := ctl.FocusedNode;
  fn := n;
  if n.StateIndex <> 0 then
  begin
    n := tabnode(fn);
    rib.ActiveTab := rib.Tabs[n.Index];
    ctl.FocusedNode := fn;
  end;
  checkbuttons;
end;

function TfrmBarEditor.tabnode(pFN: TcxTreeListNode): TcxTreeListNode;
begin
  result := pFN;
  while result.StateIndex <> 1 do
    result := Result.Parent;

end;

procedure TfrmBarEditor.cbtIndexUpClick(Sender: TObject);
var
  i,it : Integer;
  fn : TcxTreeListNode;
begin
  fn := ctl.FocusedNode;
  i := fn.Index;
  case ctl.FocusedNode.StateIndex of
    1 :   //TAB
      begin
        DM.ExecProc('POW_MOVETAB',[fidf, i, i + 1]);
        rib.ActiveTab.Index := i + 1;
        BuildEditorList(fForm,fidf);

        ctl.FocusedNode := ctl.Items[0].Items[i+1];
      end;
    2 :
      begin
        it := tabnode(fn).Index;

        DM.ExecProc('POW_MOVEGROUP',[fidf,tabnode(fn).Index, i, i + 1]);
        rib.ActiveTab.Groups[i].Index := i + 1;
        BuildEditorList(fForm,fidf);
        ctl.FocusedNode := rnode.Items[it].Items[i+1];
      end;
  end;
  checkbuttons;
end;

procedure TfrmBarEditor.cbtAgregarClick(Sender: TObject);
var
  c : string;
  t : TdxRibbonTab;
  n, fn : TcxTreeListNode;
  tb : TdxBar;
begin
  if ctl.FocusedNode = nil then Exit;
  case ctl.FocusedNode.StateIndex of
    0 :   //TAB
      begin
        if not InputQuery('Nueva pesta?a','Escriba la etiqueta de la pesta?a:',c) then Exit;

        n := ctl.FocusedNode.AddChild;
        n.StateIndex := 1;
        n.Texts[0] := c;
        rnode.Expanded := True;
        ctl.FocusedNode := n;

        t := rib.Tabs.Add;
        t.Caption := c;
        rib.ActiveTab := t;
        DM.ExecProc('POW_ADDTAB',[fidf, c]);
      end;
    1 :   //GROUP
      begin
        if not InputQuery('Nuevo grupo','Escriba la etiqueta del grupo',c) then Exit;

        tb := bm.AddToolBar;
        tb.Caption := c;
        rib.ActiveTab.AddToolBar(tb);
        n := tabnode(ctl.FocusedNode);
        fn := n.AddChild;
        fn.Texts[0] := c;
        fn.StateIndex := 2;
        n.Expanded := True;
        DM.ExecProc('POW_ADDGROUP',[fidf,n.Index,c]);
        ctl.FocusedNode := fn;
      end;
  end;

  checkbuttons;
end;

procedure TfrmBarEditor.cbtEliminarClick(Sender: TObject);
var
  i : integer;
  tb : TdxBar;
begin
  if ctl.FocusedNode = nil then Exit;
  case ctl.FocusedNode.StateIndex of
    1 :   //TAB
      begin
        if not (MessageDlg('?Est? seguro que desea eliminar la pesta?a "' + rib.Tabs[ctl.FocusedNode.Index].Caption + '" y todo su contenido?', mtConfirmation, [mbYes, mbNo], 0) in [mrYes, mrNone]) then Exit;
        i := ctl.FocusedNode.Index;

        rib.Tabs.Delete(i);
        DM.ExecProc('POW_DELTAB',[fidf, i]);

        ctl.FocusedNode.Delete;

      end;
    2 :   //Group
      begin
        tb := rib.ActiveTab.Groups[ctl.FocusedNode.Index].ToolBar;
        if not (MessageDlg('?Est? seguro que desea eliminar el grupo "' + rib.ActiveTab.Groups[ctl.FocusedNode.Index].Caption + '" y todo su contenido?', mtConfirmation, [mbYes, mbNo], 0) in [mrYes, mrNone]) then Exit;
        dm.ExecProc('POW_DELGROUP',[fidf, tabnode(ctl.FocusedNode).Index,ctl.FocusedNode.Index]);

        rib.ActiveTab.Groups.Delete(ctl.FocusedNode.Index);
        ctl.FocusedNode.Delete;
        bm.DeleteToolBar(tb, false);
      end;
  end;
  checkbuttons;
end;

procedure TfrmBarEditor.cbtEtiquetaClick(Sender: TObject);
var s : string;
begin
  case ctl.FocusedNode.StateIndex of
    0 : s := ctl.FocusedNode.Texts[0];
  end;

  if not InputQuery('Etiqueta','Nueva etiqueta:',s) then Exit;

  case ctl.FocusedNode.StateIndex of
    0 :
      begin
        rib.ActiveTab.Caption := s;
        ctl.FocusedNode.Texts[0] := s;
        dm.ExecProc('POW_RENAMETAB',[fidf,rib.ActiveTab.Index,s]);
      end;
  end;

end;

procedure TfrmBarEditor.cbtIndexDownClick(Sender: TObject);
var
  i, it : Integer;
  fn : TcxTreeListNode;
begin
  fn := ctl.FocusedNode;
  i := fn.Index;
  case ctl.FocusedNode.StateIndex of
    1 :   //TAB
      begin
        DM.ExecProc('POW_MOVETAB',[fidf, i, i - 1]);
        rib.ActiveTab.Index := i - 1;
        BuildEditorList(fForm,fidf);
        ctl.FocusedNode := ctl.Items[0].Items[i-1];
      end;
    2 :  //GROUP
      begin
        it := tabnode(fn).Index;
        DM.ExecProc('POW_MOVEGROUP',[fidf,tabnode(fn).Index, i, i - 1]);
        rib.ActiveTab.Groups[i].Index := i - 1;
        BuildEditorList(fForm,fidf);
        ctl.FocusedNode := rnode.Items[it].Items[i-1];
      end;
  end;
  checkbuttons;
end;

procedure TfrmBarEditor.updateFocused;
begin
  ctl.FocusedNode := ctl.Items[0].Items[rib.ActiveTab.Index];
end;

end.


