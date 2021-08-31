program ServicesDemo;

uses
  Vcl.Forms,
  UMainFrm in 'UMainFrm.pas' {MainFrm},
  uServices in '..\uServices.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
