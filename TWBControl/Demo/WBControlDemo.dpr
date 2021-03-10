program WBControlDemo;

uses
  Vcl.Forms,
  UMainFrm in 'UMainFrm.pas' {MainFrm},
  uWBControl in 'uWBControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
