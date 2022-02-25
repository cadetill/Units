{
  @abstract(Unit to manage a dual list with Key-Value)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(July 31, 2021)
  @lastmod(Febrary 31, 2021)

  The uDualList unit contains the definition and implementation of the classes needed to manage a dual list with Key-Value.

  @bold(Change List) @br
  @unorderedList(
    @item(31/07/2021 : first version)
    @item(04/02/2022 : use generics for TDualList)
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
  TDualList = class(TList<TDualListItem>);

implementation


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
