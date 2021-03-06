{
  @abstract(Unit get information from Firebird database)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(March 16, 2021)
  @lastmod(March 16, 2021)

  The uFBMetaData unit contains the definition and implementation of the classes needed to get information about a Firebird database.@br
  This unit contains TFBMetaData class that have some abstract methods that you need to implements in descendants classes with a specified connection components

  @bold(Change List) @br
  @unorderedList(
    @item(03/16/2021 : first version)
  )
}
unit uFBMetaData;

interface

uses
  Data.DB,
  System.Classes, System.Generics.Collections;

type
  {
    @abstract(Type of trigger.)
  }
  TTriggerType = (ttAll, ttBeforeInsert, ttAfterInsert, ttBeforeUpdate,
      ttAfterUpdate, ttBeforeDelete, ttAfterDelete);

  {
    @abstract(Class with info about an individual key/value.)
  }
  TDualValue = class
  private
    // The value of the Key (or an extended information)
    FValue: string;
    // The Key
    FKey: string;
  public
    // Returns the formatted Key + Value
    function FormattedData: string;

    // The key or principal value
    property Key: string read FKey write FKey;
    // The value of the key or extended info
    property Value: string read FValue write FValue;
  end;

  {
    @abstract(Class with a list of @link(TDualValue) (key/value).)
  }
  TDualList = class
  private
    // List of all @link(TDualValue) objects
    FValues: TObjectList<TDualValue>;

    // Returns the FValues object list. It is created if it is not created
    function GetValues: TObjectList<TDualValue>;
  public
    // Destructor of the class. Destroy all created objects
    destructor Destroy; override;

    // Adds a @link(TDualValue).
    function Add(Key, Value: string): Integer;

    // List of all values.
    property Values: TObjectList<TDualValue> read GetValues;
  end;

  {
    @abstract(Base class to get information from a Firebird DataBase.)
    You must inherit from this class to create a new class with a database connection component (like as FireDAC, ADO, ...) and implements his abstract (or virtual) methods.
  }
  TFBMetaData = class
  private
    // Database connection component
    FDataBase: TCustomConnection;
    // Query component
    FQuery: TDataSet;
  protected
    // Sets a Query component. The component must be a query component. You must override to set the correct properties of this component
    procedure SetQuery(const Value: TDataSet); virtual;

    // Executes a statement that returns one single field and returns his values into a TStringList
    function SimpleIterator(SQL: string): TStrings;
    // Executes a statement that returns two fields and returns his values into a @link(TDualList)
    function DualIterator(SQL: string): TDualList;
    // Starts a new transaction.@br You must override this method.
    procedure StartTransaction; virtual; abstract;
    // Ends the current transaction.@br You must override this method.
    procedure EndTransaction; virtual; abstract;
    // Assigns a sentence SQL to the Query component.@br You must overrides this method.
    function AssignSQL(SQL: string): Boolean; virtual; abstract;
    // Executes a SQL sentence.@br You must override this method.
    function ExecSQL(SQL: string): Boolean; virtual;

    // Query component
    property Query: TDataSet read FQuery write SetQuery;
    // Databse component
    property DataBase: TCustomConnection read FDataBase write FDataBase;
  public
    // Constructor of the class.@br You can reintroduce them if you want to specify a DataBase connection component.
    constructor Create(DataBase: TCustomConnection); virtual;
    // Destructor of the class. Destroy all created objects
    destructor Destroy; override;

    // Returns all table names
    function GetTables: TStrings;
    // Returns all fields name from a specific TableName
    function GetTableFields(TableName: string): TStrings;
    // Returns all fields name and fields type from a specific TableName
    function GetTableFieldsAndTypes(TableName: string): TDualList;
    // Returns all fields name from the primary key
    function GetPrimaryKeyFields(TableName: string): TStrings;
    // Returns all fields name and fields types from the primary key
    function GetPrimaryKeyFieldsAndTypes(TableName: string): TDualList;
    // Returns all views names
    function GetViews: TStrings;
    // Returns the source code of a specific ViewName
    function GetViewSource(ViewName: string): TStrings;
    // Returns all dependents objects and his type
    function GetDependOnObject(ObjectName: string): TDualList;
    // Returns all the objects it depends on and his type
    function GetObjectDependsOn(ObjectName: string): TDualList;
    // Returns all exceptions and its message
    function GetExceptions: TDualList;
    // Returns dimension from a field array from the specified TableName and FieldName
    function GetFieldArrayDimension(TableName, FieldName: string): TDualList;
    // Returns the UDF name installed
    function GetUDF: TStrings;
    // Returns generators name
    function GetGenerators: TStrings;
    // Returns index name from a specific TableName
    function GetIndex(TableName: string; OnlyActive: Boolean = False; Unique: Boolean = False): TStrings;
    // Returns the fields names from the specified IndexName
    function GetIndexFields(IndexName: string): TStrings;
    // Returns all procedure names
    function GetProcedures: TStrings;
    // Returns the source code of the specified ProcName
    function GetProcedureSource(ProcName: string): TStrings;
    // Returns all input parameters from the specified ProcName
    function GetProcedureInParam(ProcName: string): TStrings;
    // Returns all output parameters from the specified ProcName
    function GetProcedureOutParam(ProcName: string): TStrings;
    // Returns all triggers name
    function GetTriggers(TableName: string; TriggerType: TTriggerType): TStrings;
    // Returns the cource code from the specified TriggerName
    function GetTriggerSource(TriggerName: string): TStrings;
    // Returns all defined roles
    function GetRoles(NoSystemRoles: Boolean = True): TStrings;
  end;

implementation

uses
  System.SysUtils;

{ TFBMetaData }

constructor TFBMetaData.Create(DataBase: TCustomConnection);
begin
  FDataBase := DataBase;
end;

destructor TFBMetaData.Destroy;
begin
  if Assigned(FQuery) then FreeAndNil(FQuery);

  inherited;
end;

function TFBMetaData.ExecSQL(SQL: string): Boolean;
begin
  Result := False;
  if not Assigned(FQuery) then Exit;

  if FQuery.Active then FQuery.Close;
  if not AssignSQL(SQL) then Exit;
  try
    FQuery.Open;
    Result := True;
  except
    on E: Exception do raise; // you can do your control of this exception
  end;
end;

function TFBMetaData.GetTableFields(TableName: string): TStrings;
const
  SQL =
    'select rdb$field_name ' +
    'from rdb$relation_fields ' +
    'where upper(rdb$relation_name) = upper(''%s'') and rdb$system_flag = 0 ' +
    'order by rdb$field_position';
begin
  Result := SimpleIterator(Format(SQL, [TableName]));
end;

function TFBMetaData.GetPrimaryKeyFields(TableName: string): TStrings;
const
  SQL =
    'select s.rdb$field_name ' +
    'from rdb$relation_constraints c ' +
    '  inner join rdb$index_segments s on s.rdb$index_name = c.rdb$index_name ' +
    'where ' +
    '  upper(c.rdb$relation_name) = upper(''%s'') and ' +
    '  c.rdb$constraint_type = ''PRIMARY KEY'' ' +
    'order by s.rdb$field_position';
begin
  Result := SimpleIterator(Format(SQL, [TableName]));
end;

function TFBMetaData.GetDependOnObject(ObjectName: string): TDualList;
const
  SQL =
    'select ' +
    '  distinct d.rdb$dependent_name, ' +
    '  case d.rdb$dependent_type ' +
    '    when 0 then ''TABLE'' ' +
    '    when 1 then ''VIEW'' ' +
    '    when 2 then ''TRIGGER'' ' +
    '    when 3 then ''COMPUTED_FIELD'' ' +
    '    when 4 then ''VALIDATION'' ' +
    '    when 5 then ''PROCEDURE'' ' +
    '    when 6 then ''EXPRESSION_INDEX'' ' +
    '    when 7 then ''EXCEPTION'' ' +
    '    when 8 then ''USER'' ' +
    '    when 9 then ''FIELD'' ' +
    '    when 10 then ''INDEX'' ' +
    '    else ''UNDEFINED'' ' +
    '  end rdb$dependent_type ' +
    'from rdb$dependencies d ' +
    'where upper(d.rdb$depended_on_name) = upper(''%s'') ';
begin
  Result := DualIterator(Format(SQL, [ObjectName]));
end;

function TFBMetaData.GetExceptions: TDualList;
const
  SQL =
    'select e.rdb$exception_name, e.rdb$message from rdb$exceptions e ' +
    'where e.rdb$system_flag = 0 order by e.rdb$exception_number';
begin
  Result := DualIterator(SQL);
end;

function TFBMetaData.GetFieldArrayDimension(TableName, FieldName: string): TDualList;
const
  SQL =
    'select d.rdb$lower_bound, d.rdb$upper_bound ' +
    'from rdb$relation_fields f ' +
    '  inner join rdb$field_dimensions d on d.rdb$field_name = f.rdb$field_source ' +
    'where upper(f.rdb$relation_name) = upper(''%s'') and upper(f.rdb$field_name) = upper(''%s'') ' +
    'order by d.rdb$dimension';
begin
  Result := DualIterator(Format(SQL, [TableName, FieldName]));
end;

function TFBMetaData.GetGenerators: TStrings;
const
  SQL = 'select g.rdb$generator_name from rdb$generators g where g.rdb$system_flag = 0';
begin
  Result := SimpleIterator(SQL);
end;

function TFBMetaData.GetIndex(TableName: string; OnlyActive, Unique: Boolean): TStrings;
const
  SQL =
    'select i.rdb$index_name ' +
    'from rdb$indices i ' +
    'where (i.rdb$system_flag is null or i.rdb$system_flag = 0) and i.rdb$relation_name = ''%s'' %s ' +
    'order by i.rdb$index_name';
  OnlyAc = ' and (i.rdb$index_inactive is null or i.rdb$index_inactive <> 0) ';
  OnlyUni = ' and i.rdb$unique_flag = 1 ';
var
  Tmp: string;
begin
  Tmp := '';
  if OnlyActive then Tmp := OnlyAc;
  if Unique then Tmp := Tmp + OnlyUni;

  Result := SimpleIterator(Format(SQL, [TableName, Tmp]));
end;

function TFBMetaData.GetIndexFields(IndexName: string): TStrings;
const
  SQL =
    'select s.rdb$field_name ' +
    'from rdb$index_segments s ' +
    'where s.rdb$index_name = ''%s'' ' +
    'order by s.rdb$field_position';
begin
  Result := SimpleIterator(Format(SQL, [IndexName]));
end;

function TFBMetaData.GetPrimaryKeyFieldsAndTypes(TableName: string): TDualList;
const
  SQL =
    'select s.rdb$field_name, ' +
    '  case f.rdb$field_type ' +
    '    when 7 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''SMALLINT'' ' +
    '        when 1 then ''NUMERIC('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 8 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''INTEGER'' ' +
    '        when 1 then ''NUMERIC(''  || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 9 then ''QUAD'' ' +
    '    when 10 then ''FLOAT'' ' +
    '    when 12 then ''DATE'' ' +
    '    when 13 then ''TIME'' ' +
    '    when 14 then ''CHAR('' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 16 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''BIGINT'' ' +
    '        when 1 then ''NUMERIC('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 27 then ''DOUBLE'' ' +
    '    when 35 then ''TIMESTAMP'' ' +
    '    when 37 then ''VARCHAR('' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 40 then ''CSTRING'' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 45 then ''BLOB_ID'' ' +
    '    when 261 then ''BLOB SUB_TYPE '' || f.rdb$field_sub_type ' +
    '    else ''RDB$FIELD_TYPE: '' || f.rdb$field_type || ''?'' ' +
    '  end field_type ' +
    'from rdb$index_segments s ' +
    '  join rdb$relation_fields r on r.rdb$field_name = s.rdb$field_name ' +
    '  join rdb$fields f on f.rdb$field_name = r.rdb$field_source ' +
    '  left outer join rdb$character_sets ch on (ch.rdb$character_set_id = f.rdb$character_set_id) ' +
    'where s.rdb$index_name = ( ' +
    '                          select rdb$index_name ' +
    '                          from rdb$relation_constraints ' +
    '                          where upper(rdb$relation_name) = upper(''%s'') and ' +
    '                                rdb$constraint_type = ''PRIMARY KEY'' ' +
    '                         ) and ' +
    '  upper(r.rdb$relation_name) = upper(''%s'') ' +
    'order by s.rdb$field_position';
begin
  Result := DualIterator(Format(SQL, [TableName, TableName]));
end;

function TFBMetaData.GetProcedureInParam(ProcName: string): TStrings;
const
  SQL =
    'select p.rdb$parameter_name ' +
    'from rdb$procedure_parameters p ' +
    'where p.rdb$procedure_name = ''%s'' and p.rdb$system_flag = 0 and p.rdb$parameter_type = 0 ' +
    'order by p.rdb$parameter_number';
begin
  Result := SimpleIterator(Format(SQL, [ProcName]));
end;

function TFBMetaData.GetProcedureOutParam(ProcName: string): TStrings;
const
  SQL =
    'select p.rdb$parameter_name ' +
    'from rdb$procedure_parameters p ' +
    'where p.rdb$procedure_name = ''%s'' and p.rdb$system_flag = 0 and p.rdb$parameter_type = 1 ' +
    'order by p.rdb$parameter_number';
begin
  Result := SimpleIterator(Format(SQL, [ProcName]));
end;

function TFBMetaData.GetProcedures;
const
  SQL = 'select p.rdb$procedure_name from rdb$procedures p where p.rdb$system_flag = 0';
begin
  Result := SimpleIterator(SQL);
end;

function TFBMetaData.GetProcedureSource(ProcName: string): TStrings;
const
  SQL = 'select p.rdb$procedure_source from rdb$procedures p where p.rdb$system_flag = 0 and upper(p.rdb$procedure_name) = upper(''%s'') ';
begin
  Result := TStringList.Create;

  StartTransaction;
  if ExecSQL(Format(SQL, [ProcName])) then
    Result.Text := FQuery.Fields[0].AsString;
  EndTransaction;
end;

function TFBMetaData.GetRoles(NoSystemRoles: Boolean): TStrings;
const
  SQL = 'select r.rdb$role_name from rdb$roles r %s';
  NoSystem = ' where r.rdb$system_flag = 0';
var
  Tmp: string;
begin
  Tmp := '';
  if NoSystemRoles then Tmp := NoSystem;
  Result := SimpleIterator(Format(SQL, [Tmp]));
end;

function TFBMetaData.GetObjectDependsOn(ObjectName: string): TDualList;
const
  SQL =
    'select ' +
    '  distinct d.rdb$depended_on_name, ' +
    '  case d.rdb$depended_on_type ' +
    '    when 0 then ''TABLE'' ' +
    '    when 1 then ''VIEW'' ' +
    '    when 2 then ''TRIGGER'' ' +
    '    when 3 then ''COMPUTED_FIELD'' ' +
    '    when 4 then ''VALIDATION'' ' +
    '    when 5 then ''PROCEDURE'' ' +
    '    when 6 then ''EXPRESSION_INDEX'' ' +
    '    when 7 then ''EXCEPTION'' ' +
    '    when 8 then ''USER'' ' +
    '    when 9 then ''FIELD'' ' +
    '    when 10 then ''INDEX'' ' +
    '    else ''UNDEFINED'' ' +
    '  end rdb$depended_on_type ' +
    'from rdb$dependencies d ' +
    'where upper(d.rdb$dependent_name) = upper(''%s'') ';
begin
  Result := DualIterator(Format(SQL, [ObjectName]));
end;

function TFBMetaData.GetTableFieldsAndTypes(TableName: string): TDualList;
const
  SQL =
    'select r.rdb$field_name, ' +
    '  case f.rdb$field_type ' +
    '    when 7 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''SMALLINT'' ' +
    '        when 1 then ''NUMERIC('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 8 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''INTEGER'' ' +
    '        when 1 then ''NUMERIC(''  || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 9 then ''QUAD'' ' +
    '    when 10 then ''FLOAT'' ' +
    '    when 12 then ''DATE'' ' +
    '    when 13 then ''TIME'' ' +
    '    when 14 then ''CHAR('' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 16 then ' +
    '      case f.rdb$field_sub_type ' +
    '        when 0 then ''BIGINT'' ' +
    '        when 1 then ''NUMERIC('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '        when 2 then ''DECIMAL('' || f.rdb$field_precision || '','' || (-f.rdb$field_scale) || '')'' ' +
    '      end ' +
    '    when 27 then ''DOUBLE'' ' +
    '    when 35 then ''TIMESTAMP'' ' +
    '    when 37 then ''VARCHAR('' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 40 then ''CSTRING'' || (trunc(f.rdb$field_length / ch.rdb$bytes_per_character)) || '')'' ' +
    '    when 45 then ''BLOB_ID'' ' +
    '    when 261 then ''BLOB SUB_TYPE '' || f.rdb$field_sub_type ' +
    '    else ''RDB$FIELD_TYPE: '' || f.rdb$field_type || ''?'' ' +
    '  end field_type ' +
    'from rdb$relation_fields r ' +
    '  join rdb$fields f on f.rdb$field_name = r.rdb$field_source ' +
    '  left outer join rdb$character_sets ch on (ch.rdb$character_set_id = f.rdb$character_set_id) ' +
    'where upper(r.rdb$relation_name) = upper(''%s'') ' +
    'order by r.rdb$field_position';
begin
  Result := DualIterator(Format(SQL, [TableName]));
end;

function TFBMetaData.GetTables: TStrings;
const
  SQL =
    'select rdb$relation_name ' +
    'from rdb$relations ' +
    'where rdb$view_blr is null and (rdb$system_flag is null or rdb$system_flag = 0)';
begin
  Result := SimpleIterator(SQL);
end;

function TFBMetaData.GetTriggers(TableName: string; TriggerType: TTriggerType): TStrings;
const
  SQL =
    'select t.rdb$trigger_name ' +
    'from rdb$triggers t ' +
    'where t.rdb$system_flag = 0 and upper(t.rdb$relation_name) = upper(''%s'') %s';
  TType = ' and t.rdb$trigger_type = %d';
var
  Tmp: string;
begin
  case TriggerType of
    ttBeforeInsert: Tmp := Format(TType, [1]);
    ttAfterInsert: Tmp := Format(TType, [2]);
    ttBeforeUpdate: Tmp := Format(TType, [3]);
    ttAfterUpdate: Tmp := Format(TType, [4]);
    ttBeforeDelete: Tmp := Format(TType, [5]);
    ttAfterDelete: Tmp := Format(TType, [6]);
    else Tmp := '';
  end;

  Result := SimpleIterator(Format(SQL, [TableName, Tmp]));
end;

function TFBMetaData.GetTriggerSource(TriggerName: string): TStrings;
const
  SQL = 'select t.rdb$trigger_source from rdb$triggers t where t.rdb$system_flag = 0 and upper(t.rdb$trigger_name) = upper(''%s'') ';
begin
  Result := TStringList.Create;

  StartTransaction;
  if ExecSQL(Format(SQL, [TriggerName])) then
    Result.Text := FQuery.Fields[0].AsString;
  EndTransaction;
end;

function TFBMetaData.GetUDF: TStrings;
const
  SQL = 'select f.rdb$function_name from rdb$functions f where f.rdb$system_flag = 0';
begin
  Result := SimpleIterator(SQL);
end;

function TFBMetaData.GetViews: TStrings;
const
  SQL =
    'select rdb$relation_name ' +
    'from rdb$relations ' +
    'where rdb$view_blr is not null and (rdb$system_flag is null or rdb$system_flag = 0)';
begin
  Result := SimpleIterator(SQL);
end;

function TFBMetaData.GetViewSource(ViewName: string): TStrings;
const
  SQL = 'select r.rdb$view_source from rdb$relations r where r.rdb$relation_name = ''%s'' ';
begin
  Result := TStringList.Create;

  StartTransaction;
  if ExecSQL(Format(SQL, [ViewName])) then
    Result.Text := FQuery.Fields[0].AsString;
  EndTransaction;
end;

function TFBMetaData.SimpleIterator(SQL: string): TStrings;
begin
  Result := TStringList.Create;

  StartTransaction;
  if not ExecSQL(SQL) then
  begin
    EndTransaction;
    Exit;
  end;

  while not FQuery.Eof do
  begin
    Result.Add(FQuery.Fields[0].AsString);
    FQuery.Next;
  end;
  EndTransaction;
end;

function TFBMetaData.DualIterator(SQL: string): TDualList;
begin
  Result := TDualList.Create;

  StartTransaction;
  if not ExecSQL(SQL) then
  begin
    EndTransaction;
    Exit;
  end;

  while not FQuery.Eof do
  begin
    Result.Add(FQuery.Fields[0].AsString, FQuery.Fields[1].AsString);
    FQuery.Next;
  end;
  EndTransaction;
end;

procedure TFBMetaData.SetQuery(const Value: TDataSet);
begin
  FQuery := Value;
end;

{ TDualList }

function TDualList.Add(Key, Value: string): Integer;
begin
  Result := GetValues.Add(TDualValue.Create);
  FValues[Result].Key := Key;
  FValues[Result].Value := Value;
end;

destructor TDualList.Destroy;
begin
  GetValues.Free;

  inherited;
end;

function TDualList.GetValues: TObjectList<TDualValue>;
begin
  if not Assigned(FValues) then
    FValues := TObjectList<TDualValue>.Create;
  Result := FValues;
end;

{ TDualValue }

function TDualValue.FormattedData: string;
begin
  Result := Key + ' (' + Value + ')';
end;

end.
