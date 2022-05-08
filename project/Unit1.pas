unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,RSAOpenSSL, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    mmo_pp: TMemo;
    GroupBox2: TGroupBox;
    mmo_pp_crypted: TMemo;
    GroupBox3: TGroupBox;
    mmo_pp_decrypted: TMemo;
    GroupBox4: TGroupBox;
    mmo_pp_log: TMemo;
    Panel3: TPanel;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Panel4: TPanel;
    GroupBox5: TGroupBox;
    mmo_sha: TMemo;
    GroupBox7: TGroupBox;
    mmo_sha_crypted: TMemo;
    Panel5: TPanel;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Panel6: TPanel;
    GroupBox9: TGroupBox;
    mmo_sharsa: TMemo;
    GroupBox12: TGroupBox;
    mmo_sharsa_crypted: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
    fRSAOpenSSL : TRSAOpenSSL;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  aPathToPublickKey, aPathToPrivateKey: string;
begin
  aPathToPublickKey := '1public.pem';
  //aPathToPublickKey := 'public.cer';

  aPathToPrivateKey := 'pro22.pem';
  fRSAOpenSSL := TRSAOpenSSL.Create(aPathToPublickKey, aPathToPrivateKey);


end;

procedure TForm1.Button1Click(Sender: TObject);
var
  aRSAData: TRSAData;
begin
  aRSAData.DecryptedData := mmo_pp.Lines.Text;
  fRSAOpenSSL.PublickEncrypt(aRSAData);
  if aRSAData.ErrorResult = 0 then
  mmo_pp_crypted.Lines.Text := aRSAData.CryptedData;
  mmo_pp_log.Lines.Add(aRSAData.ErrorMessage);

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  aRSAData: TRSAData;
begin
  aRSAData.CryptedData := mmo_pp_crypted.Lines.Text;
  fRSAOpenSSL.PrivateDecrypt(aRSAData);
  if aRSAData.ErrorResult = 0 then
  mmo_pp_decrypted.Lines.Text := aRSAData.DecryptedData;
  mmo_pp_log.Lines.Add(aRSAData.ErrorMessage);

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  aRSAData: TRSAData;
begin
  aRSAData.DecryptedData := mmo_pp.Lines.Text;
  fRSAOpenSSL.PrivateEncrypt11(aRSAData);
  if aRSAData.ErrorResult = 0 then
  mmo_pp_crypted.Lines.Text := aRSAData.CryptedData;
  mmo_pp_log.Lines.Add(aRSAData.ErrorMessage);

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  aRSAData: TRSAData;
begin
  aRSAData.CryptedData := mmo_pp_crypted.Lines.Text;
  fRSAOpenSSL.PublicDecrypt(aRSAData);
  if aRSAData.ErrorResult = 0 then
  mmo_pp_decrypted.Lines.Text := aRSAData.DecryptedData;
  mmo_pp_log.Lines.Add(aRSAData.ErrorMessage);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  mmo_sha_crypted.Text := fRSAOpenSSL.SHA1(mmo_sha.Lines.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  mmo_sha_crypted.Text := fRSAOpenSSL.SHA256(mmo_sha.lines.Text);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  mmo_sha_crypted.Text := fRSAOpenSSL.SHA512(mmo_sha.lines.Text);
end;

procedure TForm1.Button8Click(Sender: TObject);

begin
  mmo_sharsa_crypted.Text :=  fRSAOpenSSL.SHA1_Sign_PK(mmo_sharsa.Lines.Text);
end;

procedure TForm1.Button9Click(Sender: TObject);
var
 s1:AnsiString;
begin
    s1 := mmo_sharsa.Lines.Text;
    mmo_sharsa_crypted.Text :=  fRSAOpenSSL.SHA256_Sign_PK(s1);
end;



procedure TForm1.Button10Click(Sender: TObject);
var
 s1:string;
begin
   s1 := mmo_sharsa.Lines.Text;
   mmo_sharsa_crypted.Text :=  fRSAOpenSSL.SHA512_Sign_PK(s1);
end;

end.
