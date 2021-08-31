unit UMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMainFrm = class(TForm)
    bGet: TButton;
    lbServices: TListBox;
    procedure bGetClick(Sender: TObject);
  private
  public
  end;

var
  MainFrm: TMainFrm;

implementation

uses
  Winapi.WinSvc,
  uServices;

{$R *.dfm}

procedure TMainFrm.bGetClick(Sender: TObject);
begin
  TServices.ServiceGetList('', SERVICE_WIN32, SERVICE_STATE_ALL, lbServices.Items);
end;

end.
