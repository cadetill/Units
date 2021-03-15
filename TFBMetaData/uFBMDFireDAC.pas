unit uFBMDFireDAC;

interface

uses
  FireDAC.Comp.Client, Data.DB,
  uFBMetaData;

type
  TFBMDFireDAC = class(TFBMetaData)
  protected
    procedure SetQuery(const Value: TDataSet); override;
    procedure StartTransaction; override;
    procedure EndTransaction; override;
    function AssignSQL(SQL: string): Boolean; override;
  public
    constructor Create(DataBase: TFDConnection); reintroduce; virtual;
  end;

implementation

{ TFBMDFireDAC }

function TFBMDFireDAC.AssignSQL(SQL: string): Boolean;
begin
  Result := False;
  if not Assigned(Query) then Exit; // check assigned
  if not (Query is TFDQuery) then Exit; // check class

  TFDQuery(Query).SQL.Text := SQL;
  Result := True;
end;

constructor TFBMDFireDAC.Create(DataBase: TFDConnection);
begin
  inherited Create(DataBase);

  SetQuery(TFDQuery.Create(nil));
end;

procedure TFBMDFireDAC.EndTransaction;
begin
  if TFDQuery(Query).Connection.InTransaction then
    TFDQuery(Query).Connection.CommitRetaining;
end;

procedure TFBMDFireDAC.SetQuery(const Value: TDataSet);
begin
  inherited;

  TFDQuery(Query).Connection := TFDConnection(DataBase);
end;

procedure TFBMDFireDAC.StartTransaction;
begin
  if not TFDQuery(Query).Connection.InTransaction then
    TFDQuery(Query).Connection.StartTransaction;
end;

end.
