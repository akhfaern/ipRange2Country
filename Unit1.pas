unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TIpLocation = record
    rangeStart: Int64;
    rangeEnd: Int64;
    country: string;
end;

type
  TIpLocationList = array of TIpLocation;

type
  TStringArray = array of string;

type
  TIP2Location = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtIPStart: TEdit;
    edtIPEnd: TEdit;
    btnStart: TButton;
    Label3: TLabel;
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    SaveDialog1: TSaveDialog;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    function explode(Delimitter, Haystack: string): TStringArray;
    function cleanString(FStr: string): string;
    function getLongIp(FIp1, FIp2, FIp3, FIp4: Integer): Int64;
    function searchIp(FLongIpAddress: Int64): Integer;
    procedure setStatus(FStatusMessage: string);
  end;

var
  IP2Location: TIP2Location;
  FIpLocationList: TIpLocationList;

implementation

{$R *.dfm}

procedure TIP2Location.FormCreate(Sender: TObject);
begin
  SetLength(FIpLocationList, 0);
end;

procedure TIP2Location.btnStartClick(Sender: TObject);
var
  FList: TStringList;
  I: Integer;
  FStrArray,
  FIpStart,
  FIpEnd: TStringArray;
  FIpS1, FIpS2,
  FIpS3, FIpS4,
  FIpE1, FIpE2,
  FIpE3, FIpE4,
  FIpResult: Integer;
  FLongIp: Int64;
begin
  if Length(FIpLocationList) = 0 then
  begin
    setStatus('Loading database...');
    Application.ProcessMessages;
    FList := TStringList.Create;
    FList.LoadFromFile('database.csv');
    SetLength(FIpLocationList, FList.Count);
    for I := 0 to FList.Count - 1 do
    begin
      if Trim(FList[I]) <> '' then
      begin
        FStrArray := explode(',', FList[I]);
        with FIpLocationList[I] do
        begin
          rangeStart := StrToInt64(cleanString(FStrArray[0]));
          rangeEnd := StrToInt64(cleanString(FStrArray[1]));
          country := cleanString(FStrArray[3]);
        end;
      end;
    end;
    FList.Clear;
    FList.Free;
    setStatus('Database loaded.');
  end;
  FIpStart := explode('.', edtIPStart.Text);
  FIpEnd := explode('.', edtIPEnd.Text);
  if (Length(FIpStart) = 4) and (Length(FIpEnd) = 4) then
  begin
    try
      FIpS1 := StrToInt(FIpStart[0]);
      FIpS2 := StrToInt(FIpStart[1]);
      FIpS3 := StrToInt(FIpStart[2]);
      FIpS4 := StrToInt(FIpStart[3]);
      FIpE1 := StrToInt(FIpEnd[0]);
      FIpE2 := StrToInt(FIpEnd[1]);
      FIpE3 := StrToInt(FIpEnd[2]);
      FIpE4 := StrToInt(FIpEnd[3]);
    except
      Application.MessageBox('Please enter valid IP addresses.', 'Error',
        MB_OK + MB_ICONERROR);
      Exit;
    end;
    for FIpS1 := StrToInt(FIpStart[0]) to FIpE1 do
      for FIpS2 := StrToInt(FIpStart[1]) to FIpE2 do
        for FIpS3 := StrToInt(FIpStart[2]) to FIpE3 do
          for FIpS4 := StrToInt(FIpStart[3]) to FIpE4 do
          begin
            Application.ProcessMessages;
            setStatus('Querying Ip: ' + IntToStr(FIpS1) + '.' + IntToStr(FIpS2)
              + '.' + IntToStr(FIpS3) + '.' + IntToStr(FIpS4));
            FLongIp := getLongIp(FIpS1, FIpS2, FIpS3, FIpS4);
            FIpResult := searchIp(FLongIp);
            if (FIpResult > -1) and (ListBox1.Items.IndexOf(FIpLocationList[FIpResult].country) < 0) then
            begin
              ListBox1.Items.Add(FIpLocationList[FIpResult].country);
            end;
          end;
    setStatus('process completed.');
  end else
    Application.MessageBox('Please enter valid IP addresses.', 'Hata',
      MB_OK + MB_ICONERROR);
end;

function TIP2Location.explode(Delimitter, Haystack: string): TStringArray;
begin
  SetLength(Result, 0);
  if Pos(Delimitter, Haystack) < 1 then
  begin
    SetLength(Result, 1);
    Result[0] := Haystack;
  end else
  begin
    while Pos(Delimitter, Haystack) > 0 do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Copy(Haystack, 1, Pos(Delimitter, Haystack) - 1);
      Delete(Haystack, 1, Pos(Delimitter, Haystack));
    end;
    if Length(Haystack) > 0 then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Haystack;
    end;
  end;
end;

function TIP2Location.cleanString(FStr: string): string;
begin
  Result := StringReplace(FStr, '"', '', [rfReplaceAll]);
end;

procedure TIP2Location.setStatus(FStatusMessage: string);
begin
  StatusBar1.Panels[0].Text := FStatusMessage;
end;

function TIP2Location.getLongIp(FIp1, FIp2, FIp3, FIp4: Integer): Int64;
begin
  Result := FIp4 + FIp3 * 256 + FIp2 * 256 * 256 + FIp1 * 256 * 256 * 256;
end;

function TIP2Location.searchIp(FLongIpAddress: Int64): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(FIpLocationList) - 1 do
  begin
    if (FLongIpAddress >= FIpLocationList[I].rangeStart) and (FLongIpAddress <= FIpLocationList[I].rangeEnd) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TIP2Location.ListBox1DblClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    ListBox1.Items.SaveToFile(SaveDialog1.FileName);
end;

end.
