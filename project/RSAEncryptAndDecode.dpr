program RSAEncryptAndDecode;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  EncdDecd_suman in '..\public\EncdDecd_suman.pas',
  libeay32 in '..\public\libeay32.pas',
  RSAOpenSSL in '..\public\RSAOpenSSL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
