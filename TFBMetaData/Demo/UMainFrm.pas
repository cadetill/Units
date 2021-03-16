unit UMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Vcl.StdCtrls, Data.DB, FireDAC.Comp.Client, Vcl.Buttons, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, Vcl.ComCtrls;

type
  TMainFrm = class(TForm)
    lDataBase: TLabel;
    eDataBase: TEdit;
    bDataBase: TSpeedButton;
    FDConnection1: TFDConnection;
    OpenDialog1: TOpenDialog;
    bConnect: TButton;
    pcPages: TPageControl;
    TabSheet1: TTabSheet;
    bTables: TButton;
    lbTables: TListBox;
    TabSheet2: TTabSheet;
    bViews: TButton;
    lbViews: TListBox;
    mViewSource: TMemo;
    TabSheet3: TTabSheet;
    mProcedureSource: TMemo;
    lbProcedures: TListBox;
    bProcedures: TButton;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    lbFields: TListBox;
    lbPrimary: TListBox;
    lbFieldsIndex: TListBox;
    lbIndex: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    TabSheet7: TTabSheet;
    Label2: TLabel;
    lbTriggers: TListBox;
    mTriggerSource: TMemo;
    procedure bDataBaseClick(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bTablesClick(Sender: TObject);
    procedure lbTablesClick(Sender: TObject);
    procedure bViewsClick(Sender: TObject);
    procedure lbViewsClick(Sender: TObject);
    procedure lbIndexClick(Sender: TObject);
    procedure bProceduresClick(Sender: TObject);
    procedure lbProceduresClick(Sender: TObject);
    procedure lbTriggersClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainFrm: TMainFrm;

implementation

uses
  System.IOUtils, FireDAC.DApt,
  uFBMDFireDac, uFBMetaData;

{$R *.dfm}

procedure TMainFrm.bConnectClick(Sender: TObject);
begin
  if FDConnection1.Connected then
    FDConnection1.Connected := False;

  if not TFile.Exists(eDataBase.Text) then
  begin
    ShowMessage('File not found');
    Exit;
  end;

  with FDConnection1.Params as TFDPhysFBConnectionDefParams do
    Database := eDataBase.Text;

  try
    FDConnection1.Connected := True;
    ShowMessage('Database connected');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TMainFrm.bDataBaseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    eDataBase.Text := OpenDialog1.FileName;
end;

procedure TMainFrm.bProceduresClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if not FDConnection1.Connected then
  begin
    ShowMessage('Database not connected');
    Exit;
  end;

  FB := TFBMDFireDAC.Create(FDConnection1);
  try
    lbProcedures.Items.Assign(FB.GetProcedures);
  finally
    FB.Free;
  end;
end;

procedure TMainFrm.bTablesClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if not FDConnection1.Connected then
  begin
    ShowMessage('Database not connected');
    Exit;
  end;

  FB := TFBMDFireDAC.Create(FDConnection1);
  try
    lbTables.Items.Assign(FB.GetTables);
  finally
    FB.Free;
  end;
end;

procedure TMainFrm.bViewsClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if not FDConnection1.Connected then
  begin
    ShowMessage('Database not connected');
    Exit;
  end;

  FB := TFBMDFireDAC.Create(FDConnection1);
  try
    lbViews.Items.Assign(FB.GetViews);
  finally
    FB.Free;
  end;
end;

constructor TMainFrm.Create(AOwner: TComponent);
begin
  inherited;
  pcPages.ActivePageIndex := 0;
end;

procedure TMainFrm.lbIndexClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if lbIndex.ItemIndex = -1 then
    Exit;

  FB := nil;
  try
    FB := TFBMDFireDAC.Create(FDConnection1);

    lbFieldsIndex.Items.Assign(FB.GetIndexFields(lbIndex.Items[lbIndex.ItemIndex]));
  finally
    FB.Free;
  end;
end;

procedure TMainFrm.lbProceduresClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if lbProcedures.ItemIndex = -1 then
    Exit;

  FB := nil;
  try
    FB := TFBMDFireDAC.Create(FDConnection1);
    mProcedureSource.Lines.Assign(FB.GetProcedureSource(lbProcedures.Items[lbProcedures.ItemIndex]));
  finally
    FB.Free;
  end;
end;

procedure TMainFrm.lbTablesClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
  DL: TDualList;
  i: Integer;
begin
  mTriggerSource.Lines.Text := '';

  if lbTables.ItemIndex = -1 then
    Exit;

  FB := nil;
  DL := nil;
  try
    FB := TFBMDFireDAC.Create(FDConnection1);

    lbFields.Clear;
    DL := FB.GetTableFieldsAndTypes(lbTables.Items[lbTables.ItemIndex]);
    for i := 0 to DL.Values.Count - 1 do
      lbFields.Items.Add(DL.Values[i].FormattedData);

    lbPrimary.Items.Assign(FB.GetPrimaryKeyFields(lbTables.Items[lbTables.ItemIndex]));
    lbIndex.Items.Assign(FB.GetIndex(lbTables.Items[lbTables.ItemIndex]));
    lbTriggers.Items.Assign(FB.GetTriggers(lbTables.Items[lbTables.ItemIndex], ttAll));
  finally
    DL.Free;
    FB.Free;
  end;
end;

procedure TMainFrm.lbTriggersClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if lbTriggers.ItemIndex = -1 then
    Exit;

  FB := nil;
  try
    FB := TFBMDFireDAC.Create(FDConnection1);
    mTriggerSource.Lines.Assign(FB.GetTriggerSource(lbTriggers.Items[lbTriggers.ItemIndex]));
  finally
    FB.Free;
  end;
end;

procedure TMainFrm.lbViewsClick(Sender: TObject);
var
  FB: TFBMDFireDAC;
begin
  if lbViews.ItemIndex = -1 then
    Exit;

  FB := nil;
  try
    FB := TFBMDFireDAC.Create(FDConnection1);
    mViewSource.Lines.Assign(FB.GetViewSource(lbViews.Items[lbViews.ItemIndex]));
  finally
    FB.Free;
  end;
end;

end.
