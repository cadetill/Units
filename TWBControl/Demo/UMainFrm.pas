unit UMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.OleCtrls, SHDocVw;

type
  TMainFrm = class(TForm)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    mData: TMemo;
    Splitter1: TSplitter;
    Label1: TLabel;
    eUrl: TEdit;
    bNavigate: TButton;
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure bNavigateClick(Sender: TObject);
  private
    FDocLoaded: Boolean;

    procedure Navigate(Url: string);
    procedure GetData;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainFrm: TMainFrm;

implementation

uses
  System.DateUtils, System.Win.Registry,
  uWBControl;

{$R *.dfm}

function GetIEVersion: Integer;
var
  Reg: TRegistry;
  Tmp: string;
  L: TStringList;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('Software\Microsoft\Internet Explorer') then
    try
      Tmp := Reg.ReadString('svcVersion');
      if Tmp = '' then
        Tmp := Reg.ReadString('Version');
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  if Tmp = '' then
    Tmp := '0';

  L := TStringList.Create;
  try
    L.Delimiter := '.';
    L.DelimitedText := Tmp;
    Result := StrToInt(L[0]);
  finally
    FreeAndNil(L);
  end;

  if Result < 7 then
    Result := 7;
  if Result > 10 then
    Result := 10;
end;

procedure TMainFrm.bNavigateClick(Sender: TObject);
begin
  Navigate(eUrl.Text);
end;

constructor TMainFrm.Create(AOwner: TComponent);
var
  Ver: Integer;
  Reg: TRegistry;
begin
  inherited;

  Ver := GetIEVersion * 1000;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION', False) then
    try
      Reg.WriteInteger(ExtractFileName(ParamStr(0)), Ver);
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TMainFrm.GetData;
var
  WBC: TWBControl;
  i: Integer;
  j: Integer;
  k: Integer;
begin
  WBC := TWBControl.Create(WebBrowser1);

  mData.Lines.Clear;
  for i := 0 to WBC.Frameset.Count - 1 do
  begin
    mData.Lines.Add(WBC.Frameset[i].Name);

    mData.Lines.Add('');
    mData.Lines.Add('******* FORMS *********');
    for j := 0 to WBC.Frameset[i].Forms.Count - 1 do
    begin
      mData.Lines.Add('   - ' + WBC.Frameset[i].Forms[j].Name);
      for k := 0 to WBC.Frameset[i].Forms[j].Fields.Count - 1 do
        mData.Lines.Add('       + ' + WBC.Frameset[i].Forms[j].Fields[k].Name);
    end;

    mData.Lines.Add('');
    mData.Lines.Add('******* LINKS *********');
    for j := 0 to WBC.Frameset[i].Links.Count - 1 do
      mData.Lines.Add('   - ' + WBC.Frameset[i].Links[j].Url);

    mData.Lines.Add('');
    mData.Lines.Add('******* IMAGES **********');
    for j := 0 to WBC.Frameset[i].Images.Count - 1 do
      mData.Lines.Add('   - ' + WBC.Frameset[i].Images[j].Img);
  end;
end;

procedure TMainFrm.Navigate(Url: string);
begin
  WebBrowser1.Navigate(Url);
end;

procedure TMainFrm.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  FDocLoaded := False;
end;

procedure TMainFrm.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  CurWebrowser : IWebBrowser;
  TopWebBrowser: IWebBrowser;
begin
  CurWebrowser := pDisp as IWebBrowser;
  TopWebBrowser := (ASender as TWebBrowser).DefaultInterface;
  if CurWebrowser = TopWebBrowser then
  begin
    FDocLoaded := True;
    GetData;
  end;
end;

end.
