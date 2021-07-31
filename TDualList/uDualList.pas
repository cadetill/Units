{
  @abstract(Unit to manage a dual list with Key-Value)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(March 10, 2021)
  @lastmod(March 11, 2021)

  The uWBControl unit contains the definition and implementation of the classes needed to manage a HTML loaded into a TWebBrowser.@br
  You can get information about forms, images and links. You can read and set values of different elements from a Form. You can submit a form
  That unit work with HTML pages with or without Framesets. In case no exists frameset, this unit create one without name

  @bold(Change List) @br
  @unorderedList(
    @item(03/10/2021 : first version)
    @item(03/11/2021 : Added the public functions SetFieldValue, GetFieldValue and SubmitForm into TWBControl class)
  )
}
unit uDualList;

interface

uses
  System.Classes, System.Generics.Collections;

type
  TDualListItem = class
  private
    FKey: string;
    FValue: string;
  public
    constructor Create;

    procedure Assign(Source: TObject); virtual;

    property Key: string read FKey write FKey;
    property Value: string read FValue write FValue;
  end;

  TDualList = class
  private
    FItems: TList<TDualListItem>;
    function GetItem(Index: Integer): TDualListItem;
    procedure SetItem(Index: Integer; const Value: TDualListItem);
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Add: TDualListItem; overload;
    function Add(Key, Value: string): TDualListItem; overload;
    function Insert(Index: Integer): TDualListItem;
    function Find(Key: string): string;
    function KeyExists(Key: string): Integer;
    procedure Delete(Index: Integer);
    procedure Clear;
    procedure Assign(Source: TObject); virtual;

    property Items[Index: Integer]: TDualListItem read GetItem write SetItem;
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
begin
  inherited;
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
begin

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
