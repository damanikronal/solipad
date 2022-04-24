unit solipadpluginforms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppDockingForms, StdCtrls, NppPlugin, SciSupport;

type
  TSolipadPluginForm = class(TNppDockingForm)
    Button2: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormFloat(Sender: TObject);
    procedure FormDock(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const JokerA   = 53;
      JokerB   = 54;

var
  SolipadPluginForm: TSolipadPluginForm;
  deck      : array[1..54] of shortint;
  keystream : array[1..255] of shortint;
  key       : string[255];
implementation

{$R *.dfm}

// Solitaire Algorithm, concept by Bruce Schneier
// Coded in Delphi 7 by Ronal

// Inisialisasi Deck Kartu
procedure initialDeck;
var count: shortint;
begin
  for count := 1 to 54 do
    deck[count] := count;
end;

function mod26 (input : shortint) : shortint;
begin
  repeat
    if (input < 1) then input := input + 26;
    if (input > 26) then input := input - 26;
  until (input >= 1) and (input <= 26);
  mod26 := input;
end;

function chartoint(ch : char) : shortint;
begin
  if (upcase(ch) >= upcase('A')) and (upcase(ch) <= upcase('Z'))
  then chartoint := ord(upcase(ch))-ord(upcase('A'))+1
  else if (ch = ' ') then chartoint := 32;
end;

function inttochar(input : shortint) : char;
begin
  if (input < 1) or (input > 26) then input := mod26(input);
  inttochar := chr(ord('A') + input - 1);
end;

// Temukan Joker A dan B
// Jika Joker A ketemu maka tukar posisi Joker A dengan 1 kartu dibawahnya
// Jika Joker B ketemu maka tukar posisi Joker B dengan 2 kartu dibawahnya
procedure moveonedown(card : shortint);
var place : shortint;
    dumpint : shortint;
begin
  // Temukan Joker A dan B
  place := 1;
  while (deck[place] <> card) do inc(place);
  if place = 54 then
  // Jika kartu joker dipaling bawah
  begin
    for dumpint := 53 downto 2 do
      deck[dumpint+1] := deck[dumpint];
    deck[2] := card;
  end
  // Jika kartu joker tdk dipaling bawah, pindahkan kebawah satu kartu
  else begin
    deck[place] := deck[place+1];
    deck[place+1] := card;
  end;
end;

// Fungsi triplecut
procedure triplecut;
var copydeck : array[1..54] of shortint;
    placejoker1, placejoker2 : shortint;
    movecount : shortint;
    copycount : shortint;
begin
  {step 3a: find first joker (JokerA or JokerB)}
  placejoker1 := 1;
  while (deck[placejoker1] < JokerA) do inc(placejoker1);

  {step 3b: find second joker}
  placejoker2 := placejoker1 + 1;
  while (deck[placejoker2] < JokerA) do inc(placejoker2);

  {step 3c: make exact copy of deck}
  for copycount := 1 to 54 do
    copydeck[copycount] := deck[copycount];
  copycount := 1;

  {step 3d: move all cards from section3 to front of deck}
  if placejoker2 < 54 then
    for movecount := (placejoker2+1) to 54 do
    begin
      deck[copycount] := copydeck[movecount];
      inc(copycount);
    end;

  {step 3e: move all cards from section2 behind section3}
  for movecount := placejoker1 to placejoker2 do
    begin
      deck[copycount] := copydeck[movecount];
      inc(copycount);
    end;

  {step 3f: move all cards from section1 behind section2}
  if placejoker1 > 1 then
    for movecount := 1 to (placejoker1-1) do
    begin
      deck[copycount] := copydeck[movecount];
      inc(copycount);
    end;
end;

// Fungsi countcut
procedure countcut(count : shortint);
var copydeck : array[1..54] of shortint;
    movecount : shortint;
    copycount : shortint;
begin
  {step 4a: make exact copy of deck}
  for copycount := 1 to 54 do
    copydeck[copycount] := deck[copycount];
  copycount := 1;

  {step 4b: move all cards from section2 to front of deck}
  for movecount := (count+1) to 53 do
    begin
      deck[copycount] := copydeck[movecount];
      inc(copycount);
    end;

  {step 4c: move all cards from section1 behind section2}
  for movecount := 1 to count do
    begin
      deck[copycount] := copydeck[movecount];
      inc(copycount);
    end;
end;

procedure keyDeck(passphrase : string);
var passcount : shortint;
begin
  if length(passphrase) < 1 then exit;
  for passcount := 1 to length(passphrase) do
  begin
    {step 1: move Joker A one cards down}
    moveonedown(JokerA);
    {step 2: move Joker B two cards down}
    moveonedown(JokerB);
    moveonedown(JokerB);
    {step 3: swap section 1 and section 3}
    triplecut;
    {step 4: count cut deck and place before last card using last card}
    if (deck[54] < JokerA) then countcut(deck[54])
      else countcut(53); {if lastcard is a joker}
    {step 5: count cut deck and place before last card using passphrase}
    countcut(chartoint(passphrase[passcount]));
  end;
end;

procedure generateKeystream(count :integer);
var streamcount : integer;
    found : integer;
begin
  streamcount := 1;
  repeat
    {step 1: move Joker A one cards down}
    moveonedown(JokerA);
    {step 2: move Joker B two cards down}
    moveonedown(JokerB);
    moveonedown(JokerB);
    {step 3: swap section 1 and section 3}
    triplecut;
    {step 4: count cut deck and place before last card using last cards value}
    if (deck[54] < JokerA) then countcut(deck[54])
      else countcut(53); {if lastcard is a joker}
    {step 5: find next key by counting from top using value of top card}
    if (deck[1] < JokerA) then found := deck[deck[1]+1]
      else found := deck[54]; {if topcard is a joker}
    case found of
       1..52: begin keystream[streamcount] := found; inc(streamcount); end;
      53..54:
    end;
  until streamcount > count;
end;

function encrypt(originalteks, passphrase : string) : string;
var
  delspace,pesan : string[255];
  msgcount : integer;
  arrmsg : array[1..255] of shortint;
begin
  // Langkah 1 Buang Spasi Pada Plainteks
  delspace := '';
  pesan := originalteks;
  for msgcount := 1 to length(pesan) do
    case upcase(pesan[msgcount]) of
      'A'..'Z': delspace := delspace + upcase(pesan[msgcount]);
      else; // Tdk lakukan apa-apa
    end;
  pesan := delspace;
  // Langkah 2 Buat Grup 5 Karakter Dari Plainteks
  case (length(pesan) mod 5) of
    0: ; // Tdk lakukan apa-apa
    1: pesan := pesan + 'XXXX'; // Tbh 4 karakter X
    2: pesan := pesan + 'XXX'; // Tbh 3 karakter X
    3: pesan := pesan + 'XX'; // Tbh 2 karakter X
    4: pesan := pesan + 'X'; // Tbh 1 karakter X
  end;
  // Langkah 3 Konversi Plainteks Menjadi Array Angka
  for msgcount := 1 to length(pesan) do
    arrmsg[msgcount] := chartoint(pesan[msgcount]);
  // Langkah 4 Membuat Keydeck
  initialDeck;
  keyDeck(passphrase);
  generateKeystream(length(pesan));
  // Langkah 5 Enkripsi
  for msgcount := 1 to length(pesan) do
    arrmsg[msgcount] := arrmsg[msgcount]+keystream[msgcount];

  // Langkah 6 Konversi Array Angka Ke Karakter
  for msgcount := 1 to length(pesan) do
    pesan[msgcount] := inttochar(arrmsg[msgcount]);

  // Buat grup 7 karakter
  delspace := '';
  for msgcount := 1 to length(pesan) do
    if ((msgcount mod 5) = 0) then delspace := delspace + pesan[msgcount] + ' '
      else delspace := delspace + pesan[msgcount];
  encrypt := delspace;

end;

function decrypt(originalteks, passphrase : string) : string;
var
  delspace,pesan : string[255];
  msgcount : integer;
  arrmsg : array[1..255] of shortint;
begin
  // Langkah 1 Buang Spasi Pada Plainteks
  delspace := '';
  pesan := originalteks;
  for msgcount := 1 to length(pesan) do
    case upcase(pesan[msgcount]) of
      'A'..'Z': delspace := delspace + upcase(pesan[msgcount]);
      else; // Tdk lakukan apa-apa
    end;
  pesan := delspace;
  // Langkah 2 Konversi cipherteks Menjadi Array Angka
  for msgcount := 1 to length(pesan) do
    arrmsg[msgcount] := chartoint(pesan[msgcount]);
  // Langkah 3 Membuat Keydeck
  initialDeck;
  keyDeck(passphrase);
  generateKeystream(length(pesan));
  // Langkah 4 dekripsi
  for msgcount := 1 to length(pesan) do
    arrmsg[msgcount] := arrmsg[msgcount]-keystream[msgcount];

  // Langkah 5 Konversi Array Angka Ke Karakter
  for msgcount := 1 to length(pesan) do
    pesan[msgcount] := inttochar(arrmsg[msgcount]);

  // Buat grup 5 karakter
  delspace := '';
  for msgcount := 1 to length(pesan) do
    if ((msgcount mod 5) = 0) then delspace := delspace + pesan[msgcount] + ' '
      else delspace := delspace + pesan[msgcount];
  decrypt := delspace;

end;

procedure TSolipadPluginForm.FormCreate(Sender: TObject);
begin
  self.NppDefaultDockingMask := DWS_DF_FLOATING; // whats the default docking position
  self.KeyPreview := true; // special hack for input forms
  self.OnFloat := self.FormFloat;
  self.OnDock := self.FormDock;
  inherited;
end;

procedure TSolipadPluginForm.Button2Click(Sender: TObject);
begin
  inherited;
  self.Hide;
end;

// Docking code calls this when the form is hidden by either "x" or self.Hide
procedure TSolipadPluginForm.FormHide(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 0);
end;

procedure TSolipadPluginForm.FormDock(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TSolipadPluginForm.FormFloat(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TSolipadPluginForm.FormShow(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure TSolipadPluginForm.Button3Click(Sender: TObject);
var
  pSelected: PChar;
  Selected, Cipherteks: String;
  SelectStart: Integer;
  FullDocument: Boolean;
  cryptkey : string;
  iSize: DWORD; //This will be the size of the buffer pSelected.
begin
  inherited;
  cryptkey := Edit1.text;
  pSelected := nil;
  iSize:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELTEXT, 0, LPARAM(PChar($0)));
  //The above gets the buffer size needed to read in the variable.
  If iSize=1 then
  begin
    FullDocument:=True;
    iSize:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, 0, LPARAM(PChar($0)));
  end
  else
  begin
    FullDocument:=False;
  end;
  try
    pSelected:=StrAlloc(iSize); //Sets the buffer size
    If FullDocument then
    begin
      SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, iSize, LPARAM(pSelected)); //Gets the selected text
    end
    else
    begin
      SelectStart:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELECTIONSTART, 0, LPARAM(pChar(#0))); //Gets the selected text
      SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELTEXT, 0, LPARAM(pSelected)); //Gets the selected text
    end;
    Selected:=pSelected; //You now have the selected text in a string to be used however you want.
    Cipherteks := encrypt(Selected,cryptkey);
    begin
      If FullDocument then
      begin
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETTEXT, 0, LPARAM(PChar(Cipherteks)));
      end
      else
      begin
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PChar(Cipherteks)));
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETSELECTIONSTART, SelectStart, LPARAM(PChar(#0)));
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETSELECTIONEND, SelectStart+Length(Selected), LPARAM(PChar(#0)));
      end;
    end;
    finally
    StrDispose(pSelected);
  end;
end;

procedure TSolipadPluginForm.Button4Click(Sender: TObject);
var
  pSelected: PChar;
  Selected, Plainteks: String;
  SelectStart: Integer;
  FullDocument: Boolean;
  cryptkey : string;
  iSize: DWORD; //This will be the size of the buffer pSelected.
begin
  inherited;
  cryptkey := Edit1.text;
  pSelected := nil;
  iSize:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELTEXT, 0, LPARAM(PChar($0)));
  //The above gets the buffer size needed to read in the variable.
  If iSize=1 then
  begin
    FullDocument:=True;
    iSize:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, 0, LPARAM(PChar($0)));
  end
  else
  begin
    FullDocument:=False;
  end;
  try
    pSelected:=StrAlloc(iSize); //Sets the buffer size
    If FullDocument then
    begin
      SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, iSize, LPARAM(pSelected)); //Gets the selected text
    end
    else
    begin
      SelectStart:=SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELECTIONSTART, 0, LPARAM(pChar(#0))); //Gets the selected text
      SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_GETSELTEXT, 0, LPARAM(pSelected)); //Gets the selected text
    end;
    Selected:=pSelected; //You now have the selected text in a string to be used however you want.
    Plainteks := decrypt(Selected,cryptkey);
    begin
      If FullDocument then
      begin
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETTEXT, 0, LPARAM(PChar(Plainteks)));
      end
      else
      begin
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PChar(Plainteks)));
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETSELECTIONSTART, SelectStart, LPARAM(PChar(#0)));
        SendMessage(self.Npp.NppData.ScintillaMainHandle, SCI_SETSELECTIONEND, SelectStart+Length(Selected), LPARAM(PChar(#0)));
      end;
    end;
    finally
    StrDispose(pSelected);
  end;
end;

end.
