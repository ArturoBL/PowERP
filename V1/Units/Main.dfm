object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'PowERP'
  ClientHeight = 426
  ClientWidth = 717
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object ribMain: TdxRibbon
    Left = 0
    Top = 0
    Width = 717
    Height = 126
    ApplicationButton.Visible = False
    BarManager = BMan
    ColorSchemeName = 'Blue'
    PopupMenuItems = []
    SupportNonClientDrawing = True
    Contexts = <>
    TabOrder = 4
    TabStop = False
    OnMouseDown = ribMainMouseDown
    object ribMainTab1: TdxRibbonTab
      Active = True
      Caption = 'Inicio'
      Groups = <>
      Index = 0
    end
  end
  object rsbMain: TdxRibbonStatusBar
    Left = 0
    Top = 403
    Width = 717
    Height = 23
    Panels = <>
    Ribbon = ribMain
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    PopupMenu = pumStatus
  end
  object BMan: TdxBarManager
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
    Left = 40
    Top = 160
    DockControlHeights = (
      0
      0
      0
      0)
    object blbTabsConfig: TdxBarLargeButton
      Caption = 'Mostrar/Ocultar pesta'#241'as principales'
      Category = 0
      Hint = 'Mostrar/Ocultar pesta'#241'as principales'
      Visible = ivAlways
      OnClick = blbTabsConfigClick
    end
    object blbBarraConfig: TdxBarButton
      Caption = 'Mostrar/Ocultar barra principal'
      Category = 0
      Hint = 'Mostrar/Ocultar barra principal'
      Visible = ivAlways
      OnClick = blbBarraConfigClick
    end
    object blbStatusBar: TdxBarLargeButton
      Caption = 'Mostrar/Ocultar barra de estado'
      Category = 0
      Hint = 'Mostrar/Ocultar barra de estado'
      Visible = ivAlways
      OnClick = blbStatusBarClick
    end
  end
  object rrmMain: TdxRibbonRadialMenu
    ItemLinks = <
      item
        Visible = True
        ItemName = 'blbStatusBar'
      end
      item
        Visible = True
        ItemName = 'blbTabsConfig'
      end
      item
        Visible = True
        ItemName = 'blbBarraConfig'
      end>
    Ribbon = ribMain
    UseOwnFont = False
    Left = 80
    Top = 160
  end
  object pumStatus: TPopupMenu
    Left = 328
    Top = 312
    object Agregar1: TMenuItem
      Caption = 'Agregar...'
    end
  end
  object pumRibbon: TPopupMenu
    Left = 312
    Top = 176
    object AgregarPestaa1: TMenuItem
      Caption = 'Agregar pesta'#241'a...'
      OnClick = AgregarPestaa1Click
    end
    object Eliminarpestaa1: TMenuItem
      Caption = 'Eliminar pesta'#241'a'
      OnClick = Eliminarpestaa1Click
    end
  end
end
