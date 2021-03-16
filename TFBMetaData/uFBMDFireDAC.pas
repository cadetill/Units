{
  @abstract(Unit get information from Firebird database using FireDAC)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(March 16, 2021)
  @lastmod(March 16, 2021)

  The uFBMDFireDAC unit contains the definition and implementation of the class @link(TFBMDFireDAC) that inherited from @link(TFBMetaData) and implements a FireDAC connection.

  @bold(Change List) @br
  @unorderedList(
    @item(03/16/2021 : first version)
  )
}
unit uFBMDFireDAC;

interface

uses
  FireDAC.Comp.Client, Data.DB,
  uFBMetaData;

type
  {
    @abstract(Class to get information from a Firebird DataBase with a FireDAC connection.)
    This class inherits from @link(TFBMetaData) and implements methods needed.
  }
  TFBMDFireDAC = class(TFBMetaData)
  protected
    // Sets a TFDQuery component. If the components isn't a TFDQuery, raise an exception.
    procedure SetQuery(const Value: TDataSet); override;
    // Starts a new transaction.
    procedure StartTransaction; override;
    // Ends the current transaction.
    procedure EndTransaction; override;
    // Assigns a sentence SQL to the TFDQuery component.
    function AssignSQL(SQL: string): Boolean; override;
  public
    // Constructor of the class.
    constructor Create(DataBase: TFDConnection); reintroduce; virtual;
  end;

implementation

uses
  System.SysUtils;

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
  if not (Value is TFDQuery) then
    raise Exception.Create('Bad Query component');

  inherited;

  TFDQuery(Query).Connection := TFDConnection(DataBase);
end;

procedure TFBMDFireDAC.StartTransaction;
begin
  if not TFDQuery(Query).Connection.InTransaction then
    TFDQuery(Query).Connection.StartTransaction;
end;

end.
