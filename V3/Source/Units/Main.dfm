object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'PowERP'
  ClientHeight = 387
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ribMain: TdxRibbon
    Left = 0
    Top = 0
    Width = 684
    Height = 27
    ApplicationButton.Visible = False
    BarManager = bMan
    ColorSchemeAccent = rcsaGreen
    ColorSchemeName = 'Office2013White'
    PopupMenuItems = []
    QuickAccessToolbar.Visible = False
    SupportNonClientDrawing = True
    Contexts = <>
    TabOrder = 0
    TabStop = False
    OnTabChanged = ribMainTabChanged
    OnMouseDown = ribMainMouseDown
  end
  object sbMain: TdxRibbonStatusBar
    Left = 0
    Top = 364
    Width = 684
    Height = 23
    Panels = <>
    Ribbon = ribMain
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object Button1: TButton
    Left = 112
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object bMan: TdxBarManager
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
    Left = 256
    Top = 176
    PixelsPerInch = 96
  end
  object pmMain: TPopupMenu
    Left = 328
    Top = 176
    object MostrarOcultarpestaas1: TMenuItem
      Caption = 'Mostrar/Ocultar pesta'#241'as'
      OnClick = MostrarOcultarpestaas1Click
    end
    object MostrarOcultarbarradebotones1: TMenuItem
      Caption = 'Mostrar/Ocultar barra de botones'
      OnClick = MostrarOcultarbarradebotones1Click
    end
    object MostrarOcultarbarradeestado1: TMenuItem
      Caption = 'Mostrar/Ocultar barra de estado'
      OnClick = MostrarOcultarbarradeestado1Click
    end
    object Cambiarttulodelaventana1: TMenuItem
      Caption = 'Cambiar t'#237'tulo de la ventana'
      OnClick = Cambiarttulodelaventana1Click
    end
    object Editarbarra1: TMenuItem
      Caption = 'Editar barra'
      OnClick = Editarbarra1Click
    end
  end
  object pmRib: TPopupMenu
    Left = 328
    Top = 96
    object EditarBarra2: TMenuItem
      Caption = 'Editar Barra'
      OnClick = Editarbarra1Click
    end
  end
end
