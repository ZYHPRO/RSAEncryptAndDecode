object Form1: TForm1
  Left = 674
  Top = 252
  Caption = 'SHAwithRSA/SHA Sample'
  ClientHeight = 544
  ClientWidth = 635
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 635
    Height = 544
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'SHAwithRSA'
      object Panel5: TPanel
        Left = 0
        Top = 391
        Width = 627
        Height = 125
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object Button28: TButton
          Left = 32
          Top = 16
          Width = 145
          Height = 25
          Caption = 'SHA1withRSA'
          TabOrder = 0
          OnClick = Button8Click
        end
        object Button29: TButton
          Left = 200
          Top = 16
          Width = 146
          Height = 25
          Caption = 'SHA256withRSA'
          TabOrder = 1
          OnClick = Button9Click
        end
        object Button30: TButton
          Left = 376
          Top = 16
          Width = 137
          Height = 25
          Caption = 'SHA512withRSA'
          TabOrder = 2
          OnClick = Button10Click
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 627
        Height = 391
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox9: TGroupBox
          Left = 0
          Top = 0
          Width = 627
          Height = 177
          Align = alTop
          Caption = #24453#21152#23494#25968#25454
          TabOrder = 0
          object mmo_sharsa: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 160
            Align = alClient
            Lines.Strings = (
              
                'GET\n /v3/certificates\n 1554208460\n 593BEC0C930BF1AFEB40B4A08C' +
                '8FB242\n \n')
            TabOrder = 0
          end
        end
        object GroupBox12: TGroupBox
          Left = 0
          Top = 177
          Width = 627
          Height = 214
          Align = alClient
          Caption = #21152#23494#23494#25991
          TabOrder = 1
          object mmo_sharsa_crypted: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 197
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'SHA1/SHA256/SHA512'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 428
        Width = 627
        Height = 88
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object Button15: TButton
          Left = 14
          Top = 34
          Width = 121
          Height = 25
          Caption = 'SHA1'
          TabOrder = 0
          OnClick = Button5Click
        end
        object Button16: TButton
          Left = 174
          Top = 34
          Width = 121
          Height = 25
          Caption = 'SHA256'
          TabOrder = 1
          OnClick = Button6Click
        end
        object Button17: TButton
          Left = 344
          Top = 34
          Width = 121
          Height = 25
          Caption = 'SHA512'
          TabOrder = 2
          OnClick = Button7Click
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 627
        Height = 428
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox5: TGroupBox
          Left = 0
          Top = 0
          Width = 627
          Height = 185
          Align = alTop
          Caption = #24453#21152#23494#25968#25454
          TabOrder = 0
          object mmo_sha: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 168
            Align = alClient
            Lines.Strings = (
              
                'GET\n /v3/certificates\n 1554208460\n 593BEC0C930BF1AFEB40B4A08C' +
                '8FB242\n \n')
            TabOrder = 0
          end
        end
        object GroupBox7: TGroupBox
          Left = 0
          Top = 185
          Width = 627
          Height = 243
          Align = alClient
          Caption = #21152#23494#23494#25991
          TabOrder = 1
          object mmo_sha_crypted: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 226
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Public/PrivateCrypting'
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 627
        Height = 454
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 627
          Height = 81
          Align = alTop
          Caption = #24453#21152#23494#25968#25454
          TabOrder = 0
          object mmo_pp: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 64
            Align = alClient
            Lines.Strings = (
              
                'GET\n /v3/certificates\n 1554208460\n 593BEC0C930BF1AFEB40B4A08C' +
                '8FB242\n \n')
            TabOrder = 0
          end
        end
        object GroupBox2: TGroupBox
          Left = 0
          Top = 81
          Width = 627
          Height = 105
          Align = alTop
          Caption = #21152#23494#21518#23494#25991
          TabOrder = 1
          object mmo_pp_crypted: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 88
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 186
          Width = 627
          Height = 105
          Align = alTop
          Caption = #35299#23494#21518#23494#25991
          TabOrder = 2
          object mmo_pp_decrypted: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 88
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 291
          Width = 627
          Height = 163
          Align = alClient
          Caption = #21152#35299#23494#26085#24535
          TabOrder = 3
          object mmo_pp_log: TMemo
            Left = 2
            Top = 15
            Width = 623
            Height = 146
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 454
        Width = 627
        Height = 62
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        object Button1: TButton
          Left = 3
          Top = 14
          Width = 121
          Height = 25
          Caption = #20844#38053#21152#23494
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 130
          Top = 14
          Width = 121
          Height = 25
          Caption = #31169#38053#35299#23494
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 369
          Top = 14
          Width = 121
          Height = 25
          Caption = #31169#38053#21152#23494
          TabOrder = 2
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 496
          Top = 14
          Width = 121
          Height = 25
          Caption = #20844#38053#35299#23494
          TabOrder = 3
          OnClick = Button4Click
        end
      end
    end
  end
end
