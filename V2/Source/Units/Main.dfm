object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'PowERP'
  ClientHeight = 231
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pumMain
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ribMain: TdxRibbon
    Left = 0
    Top = 0
    Width = 499
    Height = 27
    ApplicationButton.Visible = False
    BarManager = bman
    ColorSchemeName = 'Blue'
    ShowTabGroups = False
    SupportNonClientDrawing = True
    Contexts = <>
    TabOrder = 4
    TabStop = False
  end
  object rsbMain: TdxRibbonStatusBar
    Left = 0
    Top = 208
    Width = 499
    Height = 23
    Panels = <>
    Ribbon = ribMain
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Visible = False
  end
  object bman: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 152
    Top = 64
    DockControlHeights = (
      0
      0
      0
      0)
  end
  object pumMain: TPopupMenu
    Left = 232
    Top = 80
    object MostrarOcultarbarraprincipal1: TMenuItem
      Caption = 'Mostrar/Ocultar barra principal'
      OnClick = MostrarOcultarbarraprincipal1Click
    end
    object MostrarOcultarpestaas1: TMenuItem
      Caption = 'Mostrar/Ocultar pesta'#241'as'
      OnClick = MostrarOcultarpestaas1Click
    end
    object MostrarOcultarbarradeestado1: TMenuItem
      Caption = 'Mostrar/Ocultar barra de estado'
      OnClick = MostrarOcultarbarradeestado1Click
    end
  end
end
