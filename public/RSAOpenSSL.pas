{****************************************************
Copyright (C) 2015, Ivan Lodyanoy
ddlencemc@gmail.com

uses libeay32 - Copyright (C) 2002-2010, Marco Ferrante.
}

unit RSAOpenSSL;

interface

uses SysUtils, Dialogs, Classes, Controls, StdCtrls, libeay32,EncdDecd_suman;

type
  TRSAData = packed record
    DecryptedData: AnsiString;
    CryptedData: AnsiString;
    ErrorResult: integer;
    ErrorMessage: AnsiString;
  end;

type
  TRSAOpenSSL = class
  private
    { Private declarations }
    FPublicKey: pEVP_PKEY;
    FPrivateKey: pEVP_PKEY;
    FCryptedBuffer: pointer;
    fPublicKeyPath : AnsiString;
    fPrivateKeyPath : AnsiString;
    function LoadPrivateKey(KeyFile: AnsiString): pEVP_PKEY;
    function LoadPublicKey(KeyFile: AnsiString): pEVP_PKEY;
    procedure FreeSSL;
    procedure LoadSSL;
    function LoadPrivateKeyFromString(KeyFile: AnsiString): pEVP_PKEY;

  public
    { Public declarations }
    constructor Create(aPathToPublickKey, aPathToPrivateKey: string); overload;
    destructor Destroy; override;
    procedure PublickEncrypt(var aRSAData: TRSAData);
    procedure PrivateDecrypt(var aRSAData: TRSAData);
    procedure PrivateEncrypt11(var aRSAData: TRSAData);
    procedure PublicDecrypt(var aRSAData: TRSAData);
    function SHA1_base64(AData: AnsiString): string;
    function SHA1_Sign_PK(msg : AnsiString):string;
    function SHA256_Sign_PK(msg : AnsiString):string;
    function SHA512_Sign_PK(msg : AnsiString):string;
    function SHA1(AData: AnsiString): string;
    function SHA256(AData: AnsiString): string;
    function SHA512(AData: AnsiString): string;



  protected

  end;

implementation

{ TRSAOpenSSL }

constructor TRSAOpenSSL.Create(aPathToPublickKey, aPathToPrivateKey: string);
var
  err: Cardinal;
begin
  //inherited;
  OpenSSL_add_all_algorithms;
  OpenSSL_add_all_ciphers;
  OpenSSL_add_all_digests;
  ERR_load_crypto_strings;
  ERR_load_RSA_strings;
  fPublicKeyPath := aPathToPublickKey;
  fPrivateKeyPath := aPathToPrivateKey
  {
  with aRSAKeys do
  begin
    ErrorResult := 0;
    ErrorMessage:= '';

    if PathToPublickKey <> '' then
    begin
      FPublicKey := LoadPublicKey(PathToPublickKey);
      if FPublicKey = nil then
      begin
        ErrorResult := -1;
        err := ERR_get_error;
        repeat
          ErrorMessage:= ErrorMessage + string(ERR_error_string(err, nil)) + #10;
          err := ERR_get_error;
        until err = 0;
      end
      else
        ErrorMessage:= ErrorMessage + 'Publick Key Stored' + #10;
    end;

    if PathToPrivateKey <> '' then
    begin
      FPrivateKey := LoadPrivateKey(PathToPrivateKey);
      if FPrivateKey = nil then
      begin
        ErrorResult := -1;
        err := ERR_get_error;
        repeat
          ErrorMessage:= ErrorMessage + string(ERR_error_string(err, nil)) + #10;
          err := ERR_get_error;
        until err = 0;
      end
      else
        ErrorMessage:= ErrorMessage + 'Private Key Stored' + #10;
    end;
  end;
  }


end;

destructor TRSAOpenSSL.Destroy;
begin
  EVP_cleanup;
  ERR_free_strings;

  if FPublicKey <> nil then
    EVP_PKEY_free(FPublicKey);
  if FPrivateKey <> nil then
    EVP_PKEY_free(FPrivateKey);

  
  inherited;
end;



function TRSAOpenSSL.LoadPublicKey(KeyFile: AnsiString) :pEVP_PKEY ;
var
  mem: pBIO;
//  err: Cardinal;
  k: pEVP_PKEY;
begin
  k:=nil;
  mem := BIO_new(BIO_s_file());
  BIO_read_filename(mem, PAnsiChar(KeyFile));
  try
    result := PEM_read_bio_PUBKEY(mem, k, nil, nil);
  finally
    BIO_free_all(mem);
  end;
end;

function TRSAOpenSSL.LoadPrivateKey(KeyFile: AnsiString) :pEVP_PKEY;
var
  mem: pBIO;
//  err: Cardinal;
  k: pEVP_PKEY;
begin
  k := nil;
  mem := BIO_new(BIO_s_file());
  BIO_read_filename(mem, PAnsiChar(KeyFile));
  try
    result := PEM_read_bio_PrivateKey(mem, k, nil, nil);
  finally
    BIO_free_all(mem);
  end;
end;


function TRSAOpenSSL.LoadPrivateKeyFromString(KeyFile: AnsiString) :pEVP_PKEY;
var
  mem, keybio: pBIO;
//  err: Cardinal;
  k: pEVP_PKEY;
  keystring: AnsiString;
begin
  keystring :=
 { '-----BEGIN RSA PRIVATE KEY-----' + #10 +
  'MIICXgIBAAKBgQCfydli2u2kJfb2WetkOekjzQIg7bIuU7AzAlBUPuA72UYXWnQ/' + #10 +
  'XcdSzEEMWSBLP7FO1vyVXR4Eb0/WqthF0ZViOK5bCN9CnR/1GMMiSqmIdByv/gUe' + #10 +
  'Z/UjGrKmxeQOoa2Yt0MJC64cNXgnKmYC7ui3A12LlvNdBBEF3WpcDbv+PQIDAQAB' + #10 +
  'AoGBAJnxukKHchSHjxthHmv9byRSyw42c0g20LcUL5g6y4Zdmi29s+moy/R1XOYs' + #10 +
  'p/RXdNfkQI0WnWjgZScIij0Z4rSs39uh7eQ5qxK+NH3QIWeR2ZNIno9jAXPn2bkQ' + #10 +
  'odS8FPzbZM9wHhpRvKW4FNPXqTc3ZkTcxi4zOwOdlECf9G+BAkEAzsJHgW1Isyac' + #10 +
  'I61MDu2qjMUwOdOBYS8GwEBfi/vbn/duwZIBXG/BZ7Pn+cBwImfksEXwx0MTkgF3' + #10 +
  'gyaChUSu+QJBAMXX3d94TwcF7lG9zkzc+AR/Onl4Z5UAb1GmUV57oYIFVgW1RIOk' + #10 +
  'vqynXWrTjTOg9C9j+VEpBG67LcnkwU16JmUCQH7pukKz9kAhnw43PcycDmhCUgvs' + #10 +
  'zCn/V8GCwiOHAZT7qLyhBrzazHj/cZFYknxMEZAyHk3x2n1w8Q9MACoVsuECQQDF' + #10 +
  'U7cyara31IyM7vlS5JpjMdrKyPLXRKXDFFXYHQtLubLA4rlBbBHZ9txP7kzJj+G9' + #10 +
  'WsOS1YxcPUlAM28xrYGZAkEArVKJHX4dF8UUtfvyv78muXJZNXTwmaaFy02xjtR5' + #10 +
  'uXWT1QjVN2a6jv6AW7ukXiSoE/spgfvdoriMk2JSs88nUw==' + #10 +
  '-----END RSA PRIVATE KEY-----' ;    }

  '-----BEGIN PRIVATE KEY-----' + #10 +
  'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2nsMAxGl7HC8o' + #10 +
  'TxMCDOYcuAP3FO8EUnl8afgHsJMjVWxBySkpTQN35QBonrGGBMru2w4dHG2fsxFC' + #10 +
  'Koiy3UMPEAW7MTrT5hho11GzLxLEhX5YsY8Od+tGv3ay0klxznNAqzxdgo7xr6Dk' + #10 +
  '7Agyi5XHDiO+EZRTtRbLqlo8ry8oJpKekXm/kaJdT8ahvhCFEoHz12TrFjuxDwsF' + #10 +
  'GL+RDy1Ut5F4TbzV/R1aWobSPy/B4jQbnXmttiOzi5SNs0NDJ+vZxFRi6OP7O+xE' + #10 +
  'nPzLicCEoRDHCyaYwysHwx+pEZ34KPWqNfT65vT7Kw+0JiSxImznUxBL/M3Ks51+' + #10 +
  'PRsAsJVvAgMBAAECggEBAJLkMwBr/FhtPDVVHXn5vCJ/lZjp+rPkTxnW9w3gZwn1' + #10 +
  'zSVBVF2HN/H5fpGojCy7sCvegYTC+B6L36b0JY6R0T3Nan6+w43sN9gk0e+qPpNa' + #10 +
  'uV1IPUSrCtGWcji2UyM6p5Pt6Jliye33khhxDsrxYiGB6xgYddG7CMH7nafQVcMZ' + #10 +
  'n6KdGJzvELBNlq0mpR8HmN1bxkuwNKiTU/5OrnyCk0iDHrCFgJix8vVHIvRJJk5K' + #10 +
  'Vt27TwIkD8MQNVliRASVIt6uDbApNYv76QtYLzWdGlljZbIN4nr6oK3Syzr4t11u' + #10 +
  'FFfKhmfaZ0zkJm+U2IDri4gpJDfvaMrgjYP8gshPCIECgYEA4HjTIJm8bYkP/35q' + #10 +
  '9IS8w1F9FVNukWFT0Drw9D+UtZ9Nwi+jjfZLFu0pQLCl7sd44jGZrNwA/myjYFdy' + #10 +
  '+UXYIKIM5fY8Kww0nyyx+empmPdwFC7W9/UfYexq6AcydTdekx9I9pA4xfcN7eO7' + #10 +
  'zFukzAgwFnejL3qePeV0cRR3qq8CgYEA0EUaHKDea6ylBuwDwE+gCrBf6rDVGqEL' + #10 +
  'nP7fR+kgOBX24SRoHM6yGYF/CC1mIi1ngMH2zQ9PONUsLjOo5E8Yj5aGyLKBBGAc' + #10 +
  'M9lgn5TllsDtQWQ/kBEomi2cmUE9w2CG2rKs3EtkZXBw74sAvozwlGqo5/F/2Tpk' + #10 +
  'wK0x23U5cUECgYEA0epLzhXWrzxY2J35GVc0SxdeeN3/7TZuMbGc+VyoDby+89Sn' + #10 +
  'B7AGgpcgV92aHxUtB6JIyu0mhMdFdWfyHghh2AqTM0408DDG2P/sJACOWH00s7sl' + #10 +
  'ztXNFj8HrppkZld0OvMrwWAXp5Gk1g185tvg3ejeR3R0B4eMieeVH9Z7HgMCgYAz' + #10 +
  'vUb8X7aBt1UUACP6bY2Luj9J1X5LbECvUt3zRmX7qPE5A0teBLdYAMSnKmgaC3+Q' + #10 +
  'DB+c17XNn5+nJqxJc6DdYv6+8yF8DchT1Sfc3SegKPOH8DieOLUGgFhL9lo6pEs8' + #10 +
  'H3E0FQKu9J0J1VVtASRvKoQlguhI9em7uAsPwvJvQQKBgFXDFX3peroqyQwsMjoK' + #10 +
  'MeQylvZzeENDf1htpyWVfTNq6lC4wFSbJEzoexrnHiHVDdDWVHtup+8cr3dcGmBl' + #10 +
  '+8uCvvo/i8L/gi+2AqKQSz7AsFxqiknf5qjAP1LkH2gb9bPneyzKy13FIbB7Nb3O' + #10 +
  'ea8DZa9JV1UcnFkoKlGUT1+z' + #10 +
  '-----END PRIVATE KEY-----';


  k := nil;


  keybio := BIO_new_mem_buf(Pchar(keystring), -1);
  mem := BIO_new(BIO_s_mem());
  BIO_read(mem, PAnsiChar(keystring), length(PAnsiChar(keystring)));

  try
    result := PEM_read_bio_PrivateKey(keybio, k, nil, nil);
  finally
    BIO_free_all(mem);
  end;
end;  

procedure TRSAOpenSSL.PublickEncrypt(var aRSAData: TRSAData);
var
  rsa: pRSA;
  str, data: AnsiString;
  len, b64len: Integer;
  penc64: PAnsiChar;
  b64, mem: pBIO;
  size: Integer;
  err: Cardinal;
begin
  LoadSSL;
  FPublicKey := LoadPublicKey(fPublicKeyPath);

  if FPublicKey = nil then
  begin
    err := ERR_get_error;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
    exit;
  end;


  rsa := EVP_PKEY_get1_RSA(FPublicKey);
  //EVP_PKEY_free(FPublicKey);

  size := RSA_size(rsa);

  GetMem(FCryptedBuffer, size);
  str := AnsiString(aRSAData.DecryptedData);

  len := RSA_public_encrypt(Length(str), PAnsiChar(str), FCryptedBuffer, rsa, RSA_PKCS1_PADDING);

  if len > 0 then
  begin
    aRSAData.ErrorResult:= 0;
    //create a base64 BIO
    b64 := BIO_new(BIO_f_base64);
    mem := BIO_push(b64, BIO_new(BIO_s_mem));
    try
      //encode data to base64
      BIO_write(mem, FCryptedBuffer, len);
      BIO_flush(mem);
      b64len := BIO_get_mem_data(mem, penc64);

      //copy data to string
      SetLength(data, b64len);
      Move(penc64^, PAnsiChar(data)^, b64len);
      aRSAData.ErrorMessage := 'String has been crypted, then base64 encoded.' + #10;
      aRSAData.CryptedData:= string(data);
    finally
      BIO_free_all(mem);

    end;
  end
  else
  begin
    err := ERR_get_error;
    aRSAData.ErrorResult := -1;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
  end;
  RSA_free(rsa);
  FreeSSL;
  FreeMem(FCryptedBuffer);
end;


procedure TRSAOpenSSL.PrivateDecrypt(var aRSAData: TRSAData);
var
  rsa: pRSA;
  key: pEVP_PKEY;

  rsa_derypted: pointer;
  out_: AnsiString;
  str, data: PAnsiChar;
  len, b64len: Integer;
  penc64: PAnsiChar;
  b64, mem, bio_out, bio: pBIO;
  size: Integer;
  err: Cardinal;
begin
  LoadSSL;
  FPrivateKey := LoadPrivateKey(fPrivateKeyPath);
  //FPrivateKey := LoadPrivateKeyFromString(''); // Load PrivateKey from including ansistring;
  if FPrivateKey = nil then
  begin
    err := ERR_get_error;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
    exit;
  end;
  rsa := EVP_PKEY_get1_RSA(FPrivateKey);
  size := RSA_size(rsa);


  GetMem(data, size);
  GetMem(str, size);

  b64 := BIO_new(BIO_f_base64);
  mem := BIO_new_mem_buf(PAnsiChar(aRSAData.CryptedData), Length(aRSAData.CryptedData));
  BIO_flush(mem);
  mem := BIO_push(b64, mem);
  BIO_read(mem, str , Length(aRSAData.CryptedData));
  BIO_free_all(mem);

  len := RSA_private_decrypt(size, PAnsiChar(str), data, rsa, RSA_PKCS1_PADDING);

  if len > 0 then
  begin
    SetLength(out_, len);
    Move(data^, PAnsiChar(out_ )^, len);
    aRSAData.ErrorResult := 0;
    aRSAData.ErrorMessage := 'Base64 has been decoded and decrypted' + #10;
    aRSAData.DecryptedData := out_;
  end
  else
  begin
    err := ERR_get_error;
    aRSAData.ErrorResult := -1;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
  end;
  RSA_free(rsa);
  FreeSSL;
  FreeMem(data);
  FreeMem(str);
end;

procedure TRSAOpenSSL.PrivateEncrypt11(var aRSAData: TRSAData);
var
  rsa: pRSA;
  str, data: AnsiString;
  len, b64len: Integer;
  penc64: PAnsiChar;
  b64, mem: pBIO;
  size: Integer;
  err: Cardinal;
begin
  LoadSSL;
  FPrivateKey := LoadPrivateKey(fPrivateKeyPath);

  if FPrivateKey = nil then
  begin
    err := ERR_get_error;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
    exit;
  end;


  rsa := EVP_PKEY_get1_RSA(FPrivateKey);
  //EVP_PKEY_free(FPrivateKey);

  size := RSA_size(rsa);

  GetMem(FCryptedBuffer, size);
  str := AnsiString(aRSAData.DecryptedData);

  len := RSA_private_encrypt(Length(str), PAnsiChar(str), FCryptedBuffer, rsa, RSA_PKCS1_PADDING);

  if len > 0 then
  begin
    aRSAData.ErrorResult:= 0;
    //create a base64 BIO
    b64 := BIO_new(BIO_f_base64);
    mem := BIO_push(b64, BIO_new(BIO_s_mem));
    try
      //encode data to base64
      BIO_write(mem, FCryptedBuffer, len);
      BIO_flush(mem);
      b64len := BIO_get_mem_data(mem, penc64);

      //copy data to string
      SetLength(data, b64len);
      Move(penc64^, PAnsiChar(data)^, b64len);
      aRSAData.ErrorMessage := 'String has been crypted, then base64 encoded.' + #10;
      aRSAData.CryptedData:= string(data);
    finally
      BIO_free_all(mem);

    end;
  end
  else
  begin
    err := ERR_get_error;
    aRSAData.ErrorResult := -1;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
  end;
  RSA_free(rsa);
  FreeMem(FCryptedBuffer);
end;


procedure TRSAOpenSSL.PublicDecrypt(var aRSAData: TRSAData);
var
  rsa: pRSA;
  out_: AnsiString;
  str, data: PAnsiChar;
  len, b64len: Integer;
  penc64: PAnsiChar;
  b64, mem, bio_out, bio: pBIO;
  size: Integer;
  err: Cardinal;
begin
  LoadSSL;
  FPublicKey := LoadPublicKey(fPublicKeyPath);

  if FPublicKey = nil then
  begin
    err := ERR_get_error;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
    exit;
  end;

  rsa := EVP_PKEY_get1_RSA(FPublicKey);
  size := RSA_size(rsa);


  GetMem(data, size);
  GetMem(str, size);

  b64 := BIO_new(BIO_f_base64);
  mem := BIO_new_mem_buf(PAnsiChar(aRSAData.CryptedData), Length(aRSAData.CryptedData));
  BIO_flush(mem);
  mem := BIO_push(b64, mem);
  BIO_read(mem, str , Length(aRSAData.CryptedData));
  BIO_free_all(mem);

  len := RSA_public_decrypt(size, PAnsiChar(str), data, rsa, RSA_PKCS1_PADDING);

  if len > 0 then
  begin
    SetLength(out_, len);
    Move(data^, PAnsiChar(out_ )^, len);
    aRSAData.ErrorResult := 0;
    aRSAData.ErrorMessage := 'Base64 has been decoded and decrypted' + #10;
    aRSAData.DecryptedData := out_;
  end
  else
  begin
    err := ERR_get_error;
    aRSAData.ErrorResult := -1;
    repeat
      aRSAData.ErrorMessage:= aRSAData.ErrorMessage + string(ERR_error_string(err, nil)) + #10;
      err := ERR_get_error;
    until err = 0;
  end;
  RSA_free(rsa);
  FreeMem(data);
  FreeMem(str);
end;


function TRSAOpenSSL.SHA1_base64(AData: AnsiString): string;
var
  b64Length: integer;
  mdLength: cardinal;
  mdValue: array [0..EVP_MAX_MD_SIZE] of byte;
  mdctx: EVP_MD_CTX;
  memout, b64: pBIO;
  inbuf, outbuf: array [0..1023] of AnsiChar;
begin
  StrPCopy(inbuf, AData);
  EVP_DigestInit(@mdctx, EVP_sha1());
  EVP_DigestUpdate(@mdctx, @inbuf, StrLen(inbuf));
  EVP_DigestFinal(@mdctx, @mdValue, mdLength);

  b64 := BIO_new(BIO_f_base64);
  memout := BIO_new(BIO_s_mem);
  b64 := BIO_push(b64, memout);
  BIO_write(b64, @mdValue, mdLength);
  BIO_flush(b64);
  b64Length := BIO_read(memout, @outbuf, 1024);
  outbuf[b64Length-1] := #0;
  result := StrPas(outbuf);
end;

function TRSAOpenSSL.SHA1(AData: AnsiString): string;
  var
  Len: cardinal;
  mdctx: EVP_MD_CTX;
  inbuf, outbuf: array [0..1023] of AnsiChar;
  key: pEVP_PKEY;
begin
  StrPCopy(inbuf, AData);
  LoadSSL;

  EVP_DigestInit(@mdctx, EVP_sha1());

  EVP_DigestUpdate(@mdctx, @inbuf, StrLen(inbuf));
  EVP_DigestFinal(@mdctx, @outbuf, Len);

  FreeSSL;
  BinToHex(outbuf, inbuf,Len);
  inbuf[2*Len]:=#0;
  result := StrPas(inbuf);
end;

function TRSAOpenSSL.SHA256(AData: AnsiString): string;
  var
  Len: cardinal;
  mdctx: EVP_MD_CTX;
  inbuf, outbuf: array [0..1023] of AnsiChar;
  key: pEVP_PKEY;
begin
  StrPCopy(inbuf, AData);
  LoadSSL;

  EVP_DigestInit(@mdctx, EVP_sha256());
  EVP_DigestUpdate(@mdctx, @inbuf, StrLen(inbuf));
  EVP_DigestFinal(@mdctx, @outbuf, Len);

  FreeSSL;
  BinToHex(outbuf, inbuf,Len);
  inbuf[2*Len]:=#0;
  result := StrPas(inbuf);
end;

function TRSAOpenSSL.SHA512(AData: AnsiString): string;
  var
  Len: cardinal;
  mdctx: EVP_MD_CTX;
  inbuf, outbuf: array [0..1023] of AnsiChar;
  key: pEVP_PKEY;
begin
  StrPCopy(inbuf, AData);
  LoadSSL;

  EVP_DigestInit(@mdctx, EVP_sha512());
  EVP_DigestUpdate(@mdctx, @inbuf, StrLen(inbuf));
  EVP_DigestFinal(@mdctx, @outbuf, Len);

  FreeSSL;
  BinToHex(outbuf, inbuf,Len);
  inbuf[2*Len]:=#0;
  result := StrPas(inbuf);
end;




function LoadPrivateKey(filename:string ): PEVP_PKEY;
var  
  bp : PBIO  ;  
 A,pkey :PEVP_PKEY ;  
begin  
  a:=nil;  
  bp := BIO_new(BIO_s_file()) ;  
  BIO_read_filename(bp, PAnsiChar(filename));
  pkey := PEM_read_bio_PrivateKey(bp, a, nil,NIL);  
  BIO_free(bp);  
  Result:= pkey;
end;

function TRSAOpenSSL.SHA1_Sign_PK(msg : AnsiString):string;
var
     ctx : EVP_MD_CTX   ;
     buf_in:PAnsiChar;
     m_len,outl :cardinal;
     pKey : PEVP_PKEY;
     m,buf_out:array   [0..1024]   of   AnsiChar;
     p:array   [0..255]   of   AnsiChar;
     i,count:Integer;
     s1:AnsiString;
 begin

 buf_out:='';
  pKey := LoadPrivateKey(fPrivateKeyPath);
   buf_in := PAnsiChar(msg);
   EVP_MD_CTX_init(@ctx);            //��ʼ��  
   EVP_SignInit(@ctx,EVP_sha1());    //����Ҫʹ�õ�ժҪ�㷨����ctxl��
    EVP_SignUpdate(@ctx,buf_in,Length(buf_in));//�������ֵ
   EVP_DigestFinal(@ctx,m,m_len);    //��ȡ����ĳ���Ϊm_lenժҪֵ����m��
 rSA_sign(EVP_sha1()._type,m,m_len,buf_out,@outl,pkey.pkey.rsa); //64ΪSHA1��NID
 EVP_MD_CTX_cleanup(@ctx);
  
count := outl;
for i:=0 to count-1 do
begin
    s1 := s1 + buf_out[i];
end;

Result:= EncodeString(s1) ;    //deltail(EncodeString(s1))
end;




function TRSAOpenSSL.SHA256_Sign_PK(msg : AnsiString):string;
var
    ctx : EVP_MD_CTX   ;
    pKey :    PEVP_PKEY;   //Q4A38GwtqQ
   s1:AnsiString;
  midbuf_Len,outbuf_Len: cardinal;
  mdctx: EVP_MD_CTX;
  inbuf, midbuf,outbuf: array [0..10230] of AnsiChar;
  key: pEVP_PKEY;
  i,count:Integer;
begin
  pKey := LoadPrivateKey(fPrivateKeyPath);
  StrPCopy(inbuf, msg);
  EVP_MD_CTX_init(@ctx);
  EVP_SignInit(@ctx,EVP_sha256());
  EVP_SignUpdate(@ctx,@inbuf,StrLen(inbuf));
  EVP_DigestFinal(@ctx,@midbuf, midbuf_Len);
  rSA_sign(EVP_sha256()._type,@midbuf,midbuf_Len,outbuf,@outbuf_Len,pkey.pkey.rsa);
  EVP_MD_CTX_cleanup(@ctx);

  count := outbuf_Len;
  for i:=0 to count-1 do
  begin
      s1 := s1 + outbuf[i];
  end;

  Result:= EncodeString(s1);  //deltail(EncodeString(s1)) ;
end;



function TRSAOpenSSL.SHA512_Sign_PK(msg : AnsiString):string;
var
    ctx : EVP_MD_CTX   ;
    pKey :    PEVP_PKEY;   //Q4A38GwtqQ
   s1:AnsiString;
  midbuf_Len,outbuf_Len: cardinal;
  mdctx: EVP_MD_CTX;
  inbuf, midbuf,outbuf: array [0..10240] of AnsiChar;
  key: pEVP_PKEY;
    i,count:Integer;
begin
  pKey := LoadPrivateKey(fPrivateKeyPath);
  StrPCopy(inbuf, msg);
  EVP_MD_CTX_init(@ctx);
  EVP_SignInit(@ctx,EVP_sha512());
  EVP_SignUpdate(@ctx,@inbuf,StrLen(inbuf));
  EVP_DigestFinal(@ctx,@midbuf, midbuf_Len);
  rSA_sign(EVP_sha512()._type,@midbuf,midbuf_Len,outbuf,@outbuf_Len,pkey.pkey.rsa);
  EVP_MD_CTX_cleanup(@ctx);

  count := outbuf_Len;
  for i:=0 to count-1 do
  begin
      s1 := s1 + outbuf[i];
  end;
  Result:= EncodeString(s1) ;  //deltail(EncodeString(s1))
end;

procedure TRSAOpenSSL.LoadSSL;
begin
  OpenSSL_add_all_algorithms;
  OpenSSL_add_all_ciphers;
  OpenSSL_add_all_digests;
  ERR_load_crypto_strings;
  ERR_load_RSA_strings;
end;

procedure TRSAOpenSSL.FreeSSL;
begin
  EVP_cleanup;
  ERR_free_strings;
end;


end.
