{
  @abstract(Unit to manage content of a TWebBrowser)
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
unit uWBControl;

interface

uses
  SHDocVw, MSHTML,
  System.Generics.Collections ;

type
  {
    @abstract(Class with info about an individual image.)
  }
  TImage = class
  private
    // The Image
    FImage: IHTMLElement;

    // Returns the url to the image
    function GetImg: string;
  public
    // Constructor of the class.
    constructor Create(Img: IHTMLElement);

    // Url to the image
    property Img: string read GetImg;
  end;

  {
    @abstract(Class with info about an individual link.)
  }
  TLink = class
  private
    // The Link
    FLink: IHTMLElement;

    // Returns the url of the link
    function GetUrl: string;
  public
    // Constructor of the class.
    constructor Create(Link: IHTMLElement);

    // Url of the link.
    property Url: string read GetUrl;
  end;

  {
    @abstract(Class with info about an individual field.)
  }
  TField = class
  private
    // The Field
    FField: IHTMLElement;

    // Returns the name of the field
    function GetName: string;
    // Returns the value of the field
    function GetValue: string;
    // Sets a new value into the field
    procedure SetValue(const Value: string);
  public
    // Constructor of the class.
    constructor Create(Fld: IHTMLElement);

    // Name of the field.
    property Name: string read GetName;
    // Value of the field.
    property Value: string read GetValue write SetValue;
  end;

  {
    @abstract(Class with info about an individual form.)
    Contains information about all @link(TField) into the form.
  }
  TForms = class
  private
    // The Form
    FForm: IHTMLFormElement;
    // List of all @link(TField)
    FFields: TObjectList<TField>;

    // Returns the FFields object list. It is created if it is not created
    function GetField: TObjectList<TField>;
    // Returns the name of form
    function GetName: string;
  public
    // Constructor of the class.
    constructor Create(Form: IHTMLFormElement); virtual;
    // Destructor of the class. Destroy all created objects
    destructor Destroy; override;

    // Returns the position of a field in the list. If not exists returns -1
    function IndexOf(FieldName: string): Integer;
    // Gets info of all fields into the form
    procedure GetFields;
    // Submit the form
    procedure Submit;

    // Name of the form.
    property Name: string read GetName;
    // List of all fields.
    property Fields: TObjectList<TField> read GetField;
  end;

  {
    @abstract(Class with info about an individual frameset.)
    Contains information about @link(TForms), @link(TLink) and @link(TImage) into this frameset.
  }
  TFrameset = class
  private
    // The Frameset
    FFrameset: IHTMLWindow2;
    // TWebBrowser with page loaded. Used only if the page loaded don't have framesets
    FWebBrowser: TWebBrowser;
    // List of all @link(TForms)
    FForms: TObjectList<TForms>;
    // List of all @link(TLink)
    FLinks: TObjectList<TLink>;
    // List of all @link(TImage)
    FImages: TObjectList<TImage>;
    // Name of frameset. Used only if the page loaded don't have framesets
    FName: string;

    // Returns the FForms object list. It is created if it is not created
    function GetForm: TObjectList<TForms>;
    // Returns the FLinks object list. It is created if it is not created
    function GetLink: TObjectList<TLink>;
    // Returns the FImages object list. It is created if it is not created
    function GetImage: TObjectList<TImage>;
    // Returns the name of frameset
    function GetName: string;
  public
    // Constructor of the class. Called if loaded HTML page have framesets
    constructor Create(FS: IHTMLWindow2); overload; virtual;
    // Constructor of the class. Called if no frameset into the loaded HTML page
    constructor Create(WB: TWebBrowser); overload; virtual;
    // Destructor of the class. Destroy all created objects
    destructor Destroy; override;

    // Gets info of all forms, links and images into the frameset
    procedure GetAll;
    // Gets info of all forms into the frameset
    procedure GetForms;
    // Gets info of all links into the frameset
    procedure GetLinks;
    // Gets info of all images into the frameset
    procedure GetImages;
    // Returns the position of a form in the list. If not exists returns -1
    function IndexOf(FormName: string): Integer;

    // Name of the frameset.
    property Name: string read GetName;
    // List of all forms.
    property Forms: TObjectList<TForms> read GetForm;
    // List of all links.
    property Links: TObjectList<TLink> read GetLink;
    // List of all images.
    property Images: TObjectList<TImage> read GetImage;
  end;

  {
    @abstract(Class for manage the HTML of a TWebBrowser.)
    When you create an instance of this class or you call @link(SetWebBrowser) procedure, all content of the HTML loaded into the TWebBroser is processed
  }
  TWBControl = class
  private
    // The TWebBrowser with page loaded
    FWebBrowser: TWebBrowser;
    // List of all @link(TFrameset)
    FFrameset: TObjectList<TFrameset>;

    // Returns the FFrameset object list. It is created if it is not created
    function GetFrameset: TObjectList<TFrameset>;
  protected
    // Adds a @link(TFrameset). Method called by @link(GetFramesets) if the HTML loaded page have framesets
    function AddFrameset(FS: IHTMLWindow2): Integer; overload;
    // Adds a empty @link(TFrameset) with name FSName. Method called by @link(GetFramesets) if the HTML loaded page dont have framesets
    function AddFrameset(FSName: string): Integer; overload;
    // method called by the public PrintXXXX methods
    procedure Print(cmdID: OLECMDID; cmdexecopt: OLECMDEXECOPT);
  public
    // Constructor of the class
    constructor Create(WB: TWebBrowser); virtual;
    // Destructor of the class. Destroy all created objects
    destructor Destroy; override;

    // Sets a new TWebBrowser object, clears old content and gets the new info
    procedure SetWebBrowser(WB: TWebBrowser);
    // Clears information about HTML page loaded
    procedure Clear;
    // Returns the position of a frameset in the list. If not exists returns -1
    function IndexOf(FrmName: string): Integer;
    // Returns True if Field is found into the specified Form and Frameset. Otherwise returns False
    function SetFieldValue(Frameset, Form, Field, Value: string): Boolean;
    // Returns Field value if Field is found into the specified Form and Frameset. Otherwise returns an empty string
    function GetFieldValue(Frameset, Form, Field: string): string;
    // Returns True (and submit it) if Form is found into the specified Frameset. Otherwise returns False
    function SubmitForm(Frameset, Form: string): Boolean;

    // Gets info about all framesets of the loaded page. If no framesets, creates one empty @link(TFrameset) object an get info about page
    procedure GetFramesets;

    // Returns the HTML code of HTML page loaded into the TWebBrowser
    function HTMLCode: string;
    // Returns the content of HTML page loaded into the TWebBrowser
    function Content: string;

    // Prints HTML page without dialog box
    procedure PrintWithoutDialog;
    // Prints HTML page calling Print dialog box
    procedure PrintWithDialog;
    // Prints HTML page calling Preview dialog box
    procedure PrintPreview;
    // Prints HTML page calling Page Setup dialog box
    procedure PrintPageSetup;

    // List of all framesets. If the HTML don't have any, one empty frameset object is created
    property Frameset: TObjectList<TFrameset> read GetFrameset;
  end;

implementation

uses
  System.SysUtils;

{ TWBControl }

function TWBControl.AddFrameset(FS: IHTMLWindow2): Integer;
begin
  Result := Frameset.Add(TFrameset.Create(FS));
end;

function TWBControl.AddFrameset(FSName: string): Integer;
begin
  Result := Frameset.Add(TFrameset.Create(FWebBrowser));
end;

procedure TWBControl.Clear;
begin
  GetFrameset.Clear;
end;

function TWBControl.Content: string;
begin
  Result := (FWebBrowser.Document as IHTMLDocument2).body.innerText;
end;

constructor TWBControl.Create(WB: TWebBrowser);
begin
  FWebBrowser := WB;

  GetFramesets;
end;

destructor TWBControl.Destroy;
begin
  GetFrameset.Free;

  inherited;
end;

function TWBControl.GetFieldValue(Frameset, Form, Field: string): string;
var
  i: Integer;
  j: Integer;
  k: Integer;
begin
  Result := '';
  for i := 0 to FFrameset.Count - 1 do
  begin
    if SameText(Frameset, FFrameset[i].Name) then
    begin
      for j := 0 to FFrameset[i].FForms.Count - 1 do
      begin
        if SameText(Form, FFrameset[i].FForms[j].Name) then
        begin
          for k := 0 to FFrameset[i].FForms[j].FFields.Count - 1 do
          begin
            if SameText(Field, FFrameset[i].FForms[j].FFields[k].Name) then
            begin
              Result := FFrameset[i].FForms[j].FFields[k].Value;
              Break;
            end;
          end;
          Break;
        end;
      end;
      Break;
    end;
  end;
end;

function TWBControl.GetFrameset: TObjectList<TFrameset>;
begin
  if not Assigned(FFrameset) then
    FFrameset := TObjectList<TFrameset>.Create;
  Result := FFrameset;
end;

procedure TWBControl.GetFramesets;
var
  Frames: IHTMLFramesCollection2;
  Win: IHTMLWindow2;
  i: Integer;
begin
  GetFrameset.Clear;

  if not Assigned(FWebBrowser) then
    Exit;

  if not Supports((FWebBrowser.Document as IHTMLDocument2).frames, IHTMLFramesCollection2, Frames) then
    Exit;

  if Frames.Length = 0 then
    AddFrameset('')
  else
    for i := 0 to Frames.Length - 1 do
    begin
      if Supports(IDispatch(Frames.item(i)), IHTMLWindow2, Win) then
        AddFrameset(Win);
    end;
end;

function TWBControl.HTMLCode: string;
begin
  Result := (FWebBrowser.Document as IHTMLDocument2).body.innerHTML;
end;

function TWBControl.IndexOf(FrmName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FFrameset.Count - 1 do
    if SameText(FrmName, FFrameset[i].Name) then
    begin
      Result := i;
      Break;
    end;
end;

procedure TWBControl.Print(cmdID: OLECMDID; cmdexecopt: OLECMDEXECOPT);
var
  vIn: OleVariant;
  vOut: OleVariant;
begin
  FWebBrowser.ControlInterface.ExecWB(cmdID, cmdexecopt, vIn, vOut);
end;

procedure TWBControl.PrintPageSetup;
begin
  Print(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TWBControl.PrintPreview;
begin
  Print(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER);
end;

procedure TWBControl.PrintWithDialog;
begin
  Print(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TWBControl.PrintWithoutDialog;
begin
  Print(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER);
end;

function TWBControl.SetFieldValue(Frameset, Form, Field,
  Value: string): Boolean;
var
  i: Integer;
  j: Integer;
  k: Integer;
begin
  Result := False;
  for i := 0 to FFrameset.Count - 1 do
  begin
    if SameText(Frameset, FFrameset[i].Name) then
    begin
      for j := 0 to FFrameset[i].FForms.Count - 1 do
      begin
        if SameText(Form, FFrameset[i].FForms[j].Name) then
        begin
          for k := 0 to FFrameset[i].FForms[j].FFields.Count - 1 do
          begin
            if SameText(Field, FFrameset[i].FForms[j].FFields[k].Name) then
            begin
              FFrameset[i].FForms[j].FFields[k].Value := Value;
              Result := True;
              Break;
            end;
          end;
          Break;
        end;
      end;
      Break;
    end;
  end;
end;

procedure TWBControl.SetWebBrowser(WB: TWebBrowser);
begin
  Clear;
  FWebBrowser := WB;
  GetFramesets;
end;

function TWBControl.SubmitForm(Frameset, Form: string): Boolean;
var
  i: Integer;
  j: Integer;
begin
  Result := False;
  for i := 0 to FFrameset.Count - 1 do
  begin
    if SameText(Frameset, FFrameset[i].Name) then
    begin
      for j := 0 to FFrameset[i].FForms.Count - 1 do
      begin
        if SameText(Form, FFrameset[i].FForms[j].Name) then
        begin
          FFrameset[i].FForms[j].Submit;
          Result := True;
          Break;
        end;
      end;
      Break;
    end;
  end;
end;

{ TFrameset }

constructor TFrameset.Create(FS: IHTMLWindow2);
begin
  FFrameset := FS;
  FWebBrowser := nil;

  GetAll;
end;

constructor TFrameset.Create(WB: TWebBrowser);
begin
  FFrameset := nil;
  FName := '';
  FWebBrowser := WB;

  GetAll;
end;

destructor TFrameset.Destroy;
begin
  GetForm.Free;
  GetLink.Free;
  GetImage.Free;

  inherited;
end;

procedure TFrameset.GetForms;
var
  Frms: IHTMLElementCollection;
  Frm: IHTMLFormElement;
  i: Integer;
begin
  GetForm.Clear;

  if Assigned(FFrameset) then
  begin
    if not Supports((FFrameset.document as IHTMLDocument2).forms, IHTMLElementCollection, Frms) then
      Exit;

    for i := 0 to Frms.Length - 1 do
    begin
      if Supports(Frms.Item(i,0), IHTMLFormElement, Frm) then
        FForms.Add(TForms.Create(Frm));
    end;
  end
  else
    if Assigned(FWebBrowser) then
    begin
      if not Supports((FWebBrowser.Document as IHTMLDocument2).forms, IHTMLElementCollection, Frms) then
        Exit;

      for i := 0 to Frms.Length - 1 do
      begin
        if Supports(Frms.Item(i,0), IHTMLFormElement, Frm) then
          FForms.Add(TForms.Create(Frm));
      end;
    end;
end;

function TFrameset.GetImage: TObjectList<TImage>;
begin
  if not Assigned(FImages) then
    FImages := TObjectList<Timage>.Create;
  Result := FImages;
end;

procedure TFrameset.GetImages;
var
  Imgs: IHTMLElementCollection;
  Img: IHTMLElement;
  i: Integer;
begin
  GetImage.Clear;

  if Assigned(FFrameset) then
  begin
    if not Supports((FFrameset.document as IHTMLDocument2).images, IHTMLElementCollection, Imgs) then
      Exit;

    for i := 0 to Imgs.Length - 1 do
    begin
      if Supports(Imgs.Item(i,0), IHTMLElement, Img) then
        FImages.Add(TImage.Create(Img));
    end;
  end
  else
    if Assigned(FWebBrowser) then
    begin
      if not Supports((FWebBrowser.Document as IHTMLDocument2).images, IHTMLElementCollection, Imgs) then
        Exit;

      for i := 0 to Imgs.Length - 1 do
      begin
        if Supports(Imgs.Item(i,0), IHTMLElement, Img) then
          FImages.Add(TImage.Create(Img));
      end;
    end;
end;

function TFrameset.GetLink: TObjectList<TLink>;
begin
  if not Assigned(FLinks) then
    FLinks := TObjectList<TLink>.Create;
  Result := FLinks;
end;

procedure TFrameset.GetLinks;
var
  Lnks: IHTMLElementCollection;
  Lnk: IHTMLElement;
  i: Integer;
begin
  GetLink.Clear;

  if Assigned(FFrameset) then
  begin
    if not Supports((FFrameset.document as IHTMLDocument2).links, IHTMLElementCollection, Lnks) then
      Exit;

    for i := 0 to Lnks.Length - 1 do
    begin
      if Supports(Lnks.Item(i,0), IHTMLElement, Lnk) then
        FLinks.Add(TLink.Create(Lnk));
    end;
  end
  else
    if Assigned(FWebBrowser) then
    begin
      if not Supports((FWebBrowser.Document as IHTMLDocument2).links, IHTMLElementCollection, Lnks) then
        Exit;

      for i := 0 to Lnks.Length - 1 do
      begin
        if Supports(Lnks.Item(i,0), IHTMLElement, Lnk) then
          FLinks.Add(TLink.Create(Lnk));
      end;
    end;
end;

function TFrameset.GetName: string;
begin
  if Assigned(FFrameset) then
    Result := FFrameset.name
  else
    Result := FName;
end;

function TFrameset.IndexOf(FormName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FForms.Count - 1 do
    if SameText(FormName, FForms[i].Name) then
    begin
      Result := i;
      Break;
    end;
end;

procedure TFrameset.GetAll;
begin
  GetForms;
  GetLinks;
  GetImages;
end;

function TFrameset.GetForm: TObjectList<TForms>;
begin
  if not Assigned(FForms) then
    FForms := TObjectList<TForms>.Create;
  Result := FForms;
end;

{ TForms }

constructor TForms.Create(Form: IHTMLFormElement);
begin
  FForm := Form;

  GetFields;
end;

destructor TForms.Destroy;
begin
  GetField.Free;

  inherited;
end;

function TForms.GetField: TObjectList<TField>;
begin
  if not Assigned(FFields) then
    FFields := TObjectList<TField>.Create;
  Result := FFields;
end;

procedure TForms.GetFields;
var
  i: Integer;
  Fld: IHTMLElement;
begin
  GetField.Clear;

  for i := 0 to FForm.length - 1 do
  begin
    if Supports(FForm.Item(i, ''), IHTMLElement, Fld) then
      FFields.Add(TField.Create(Fld));
  end;
end;

function TForms.GetName: string;
begin
  Result := FForm.name;
end;

function TForms.IndexOf(FieldName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FFields.Count - 1 do
    if SameText(FieldName, FFields[i].Name) then
    begin
      Result := i;
      Break
    end;
end;

procedure TForms.Submit;
begin
  if Assigned(FForm) then
    FForm.submit;
end;

{ TField }

constructor TField.Create(Fld: IHTMLElement);
begin
  FField := Fld;
end;

function TField.GetName: string;
var
  Input: IHTMLInputElement;
  Select: IHTMLSelectElement;
  Text: IHTMLTextAreaElement;
begin
  Result := '';
  if not Assigned(FField) then
    Exit;

  Result := FField.id;

  if Supports(FField, IHTMLInputElement, Input) then Result := Input.name;
  if Supports(FField, IHTMLSelectElement, Select) then Result := Select.name;
  if Supports(FField, IHTMLTextAreaElement, Text) then Result := Text.name;
end;

function TField.GetValue: string;
var
  Input: IHTMLInputElement;
  Select: IHTMLSelectElement;
  Text: IHTMLTextAreaElement;
begin
  Result := '';
  if not Assigned(FField) then
    Exit;

  if Supports(FField, IHTMLInputElement, Input) then Result := Input.value;
  if Supports(FField, IHTMLSelectElement, Select) then Result := Select.value;
  if Supports(FField, IHTMLTextAreaElement, Text) then Result := Text.value;
end;

procedure TField.SetValue(const Value: string);
var
  Input: IHTMLInputElement;
  Select: IHTMLSelectElement;
  Text: IHTMLTextAreaElement;
begin
  if not Assigned(FField) then
    Exit;

  if Supports(FField, IHTMLInputElement, Input) then Input.value := Value;
  if Supports(FField, IHTMLSelectElement, Select) then Select.value := Value;
  if Supports(FField, IHTMLTextAreaElement, Text) then Text.value := Value;
end;

{ TLink }

constructor TLink.Create(Link: IHTMLElement);
begin
  FLink := Link;
end;

function TLink.GetUrl: string;
var
  Anchor: IHTMLAnchorElement;
begin
  Result := '';

  if not Assigned(FLink) then
    Exit;

  if Supports(FLink, IHTMLAnchorElement, Anchor) then
    Result := Anchor.href;
end;

{ TImage }

constructor TImage.Create(Img: IHTMLElement);
begin
  FImage := Img;
end;

function TImage.GetImg: string;
var
  Img: IHTMLImgElement;
begin
  Result := '';

  if not Assigned(FImage) then
    Exit;

  if Supports(FImage, IHTMLImgElement, Img) then
    Result := Img.src;
end;

end.
