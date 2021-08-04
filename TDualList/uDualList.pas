{
  @abstract(Unit to manage a dual list with Key-Value)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(July 31, 2021)
  @lastmod(July 31, 2021)

  The uDualList unit contains the definition and implementation of the classes needed to manage a dual list with Key-Value.

  @bold(Change List) @br
  @unorderedList(
    @item(31/07/2021 : first version)
  )
}
unit uDualList;

interface

uses
  System.Classes, System.Generics.Collections;

type
  {
    @abstract(Class that represents an individual item.)
    This class represents an individual Item. An Item is represented by a Key and a Value.
  }
  TDualListItem = class
  private
    FKey: string;
    FValue: string;
  public
    // constructor class
    constructor Create;

    // Copies the contents of another similar object.
    procedure Assign(Source: TObject); virtual;

    // Key from the key-value
    property Key: string read FKey write FKey;
    // Value from the key-value
    property Value: string read FValue write FValue;
  end;

  {
    @abstract(Class that maintains a list of @link(TDualListItem).)
    Use a TDualList object to store and manipulate a list of a pair key-value.
  }
  TDualList = class
  private
    FItems: TList<TDualListItem>;
    function GetItem(Index: Integer): TDualListItem;
    procedure SetItem(Index: Integer; const Value: TDualListItem);
    function GetCount: Integer;
  public
    // constructor class
    constructor Create;
    // destructor class
    destructor Destroy; override;

    // Adds a new @link(TDualListItem).
    function Add: TDualListItem; overload;
    // Adds a new @link(TDualListItem) with the Key-Value values.
    function Add(Key, Value: string): TDualListItem; overload;
    // Inserts a new @link(TDualListItem) into Index position.
    function Insert(Index: Integer): TDualListItem;
    // Finds a @link(TDualListItem) into the list by a Key value and returns his Value.
    function Find(Key: string): string;
    // Finds a @link(TDualListItem) into the list by a Key value and returns his position.
    function KeyExists(Key: string): Integer;
    // Deletes a @link(TDualListItem) from the list by a Index.
    procedure Delete(Index: Integer);
    // Deletes all @link(TDualListItem) from the list.
    procedure Clear;
    // Copies the contents of another similar object.
    procedure Assign(Source: TObject); virtual;

    // List of all @link(TDualListItem).
    property Items[Index: Integer]: TDualListItem read GetItem write SetItem;
    // Indicate the number of @link(TDualListItem) in the list.
    property Count: Integer read GetCount;
  end;

implementation

uses
  System.SysUtils;

{ TDualList }

function TDualList.Add: TDualListItem;
begin
  Result := TDualListItem.Create;
  FItems.Add(Result);
end;

function TDualList.Add(Key, Value: string): TDualListItem;
begin
  Result := TDualListItem.Create;
  Result.Key := Key;
  Result.Value := Value;
  FItems.Add(Result);
end;

procedure TDualList.Assign(Source: TObject);
var
  i: Integer;
begin
  inherited;

  if not (Source is TDualList) then
    Exit;

  Clear;
  for i := 0 to TDualList(Source).Count - 1 do
    Add(TDualList(Source).Items[i].Key, TDualList(Source).Items[i].Value);
end;

procedure TDualList.Clear;
begin
  FItems.Clear;
end;

constructor TDualList.Create;
begin
  FItems := TList<TDualListItem>.Create;
end;

procedure TDualList.Delete(Index: Integer);
begin
  FItems.Delete(Index);
end;

destructor TDualList.Destroy;
begin
  if Assigned(FItems) then
  begin
    Clear;
    FItems.DisposeOf;
  end;

  inherited;
end;

function TDualList.Find(Key: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to GetCount - 1 do
    if SameText(Key, FItems[i].Key) then
    begin
      Result := FItems[i].Value;
      Break;
    end;
end;

function TDualList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TDualList.GetItem(Index: Integer): TDualListItem;
begin
  Result := FItems[Index];
end;

function TDualList.Insert(Index: Integer): TDualListItem;
begin
  Result := TDualListItem.Create;
  FItems.Insert(Index, Result);
end;

function TDualList.KeyExists(Key: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to GetCount - 1 do
    if SameText(Key, FItems[i].Key) then
    begin
      Result := i;
      Break;
    end;
end;

procedure TDualList.SetItem(Index: Integer; const Value: TDualListItem);
begin
  TDualListItem(FItems[Index]).Assign(Value);
end;

{ TDualListItem }

procedure TDualListItem.Assign(Source: TObject);
begin
  inherited;

  if not (Source is TDualListItem) then
    Exit;

  FKey := TDualListItem(Source).Key;
  FValue := TDualListItem(Source).Value;
end;

constructor TDualListItem.Create;
begin
  FKey := '';
  FValue := '';
end;

end.
