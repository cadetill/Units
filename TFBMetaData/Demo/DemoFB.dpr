program DemoFB;

uses
  Vcl.Forms,
  UMainFrm in 'UMainFrm.pas' {MainFrm},
  uFBMetaData in '..\uFBMetaData.pas',
  uFBMDFireDAC in '..\uFBMDFireDAC.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
