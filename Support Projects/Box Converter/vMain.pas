unit vMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, DBCtrls, Grids, DBGrids, ActnList, DISQLite3Database,
  Ribbon, RibbonLunaStyleActnCtrls,
  ToolWin, ActnMan, ActnCtrls, ComCtrls, ShellAPI, ExtCtrls;

type
  TfMain = class(TForm)
    adoCon: TADOConnection;
    adoQuery: TADOQuery;
    adoSource: TDataSource;
    listFiles: TListBox;
    btnBrowse: TButton;
    edtDest: TEdit;
    Label1: TLabel;
    prgFile: TProgressBar;
    btnConvert: TButton;
    Label2: TLabel;
    Label3: TLabel;
    dlgOpen: TOpenDialog;
    Updater: TTimer;
    lblStatus: TLabel;
    lblTable: TLabel;
    ddb: TDISQLite3Database;
    procedure FormCreate(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure UpdaterTimer(Sender: TObject);
  private
    { Private declarations }
    BookId:   string;
    MaxRows:  integer;
    Counter:  integer;
    GlobalDone: boolean;
    Start, Stop:  Cardinal;
    ETA:      Real;
  public
    { Public declarations }
    procedure CreateDB(adofile: string; filename: string);
    procedure UpdateMain;
    procedure UpdateBook;
    procedure UpdateTOC;

    procedure DropFiles(var msg: TMessage); message WM_DROPFILES;
    function  ReplaceMarks(what: string): string;
  end;

var
  fMain: TfMain;

implementation

uses cMain;

{$R *.dfm}

function TfMain.ReplaceMarks(what: string): string;
var outstr: string;
  I: Integer;
begin
  outstr := '';
  for I := 1 to Length(what) do
  begin
      if (what[I] <> '"') then
          outstr := outstr+what[I]
      else
      outstr := outstr+'""';
  end;

  Result := outstr;

end;

procedure TfMain.UpdateMain;
var insert: UnicodeString;
    bkIdStr,
    BkStr,
    BetakaStr,
    InfStr,
    AuthStr,
    AuthInfoStr,
    TafseerNamStr,
    IslamShortStr:  UnicodeString;
begin
    adoQuery.Active := false;
    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM Main');
    adoQuery.Open;
    adoQuery.Active := true;
    lblTable.Caption := 'Converting Cover Title...';

    adoQuery.First;
    while (adoQuery.Eof = false) and (not GlobalDone) do
    begin
         BkIdStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['BkId']));
         BkStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['Bk']));
         BetakaStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['Betaka']));
         InfStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['Inf']));
         AuthStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['Auth']));
         AuthInfoStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['AuthInf']));
         TafseerNamStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['TafseerNam']));
         IslamShortStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['IslamShort']));

        insert := Format('"%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s" ',
        [BkIdStr, BkStr, BetakaStr, InfStr, AuthStr, AuthInfoStr, TafseerNamStr, IslamShortStr]);

        ddb.Execute('INSERT INTO Main VALUES ('+insert+')');

        //Stop := Now - Start;
        ETA := (GetTickCount - Start) / 1000;

        Counter := Counter + 1;

        Application.ProcessMessages;

        adoQuery.Next;
    end;
end;

procedure TfMain.UpdaterTimer(Sender: TObject);
var percent: integer;
begin
    prgFile.Position := Counter;

    if MaxRows = 0 then percent := 0
    else percent := Counter * 100 div  MaxRows;

    if MaxRows > 0 then
    begin
      lblStatus.Caption := IntToStr(percent)+'% at record '+
        IntToStr(Counter)+' of '+IntToStr(MaxRows)+', ETA '+Format('%.2f mins', [(
          ETA / Counter) * (MaxRows - Counter) / 60]);
    end;
end;

procedure TfMain.UpdateBook;
var insert: UnicodeString;
    recno: integer;
    idStr,
    nassStr,
    partStr,
    pageStr,
    hnoStr: UnicodeString;
begin
    adoQuery.Active := false;
    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM b'+BookId);
    adoQuery.Open;
    adoQuery.Active := true;

    lblTable.Caption := 'Converting Book Content...';

    adoQuery.First;
    recno := 1;
    while (adoQuery.Eof = false) and (not GlobalDone) do
    begin
         idStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['id']));
         nassStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['nass']));
         partStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['part']));
         pageStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['page']));
         if adoQuery.FieldCount < 5 then
            hnoStr := '0'
         else
            hnoStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['hno']));

        insert := Format('"%s", "%s", "%s", "%s", "%s"',
        [idStr, nassStr, partStr, pageStr, hnoStr]);

         try
            ddb.Execute('INSERT INTO "b'+BookId+'" VALUES ('+insert+')');
         except
            MessageBox(self.Handle, PChar('At Rec '+IntToStr(recno)+', SQL: INSERT INTO "b'+BookId+'" VALUES ('+insert+
              ')'), 'ERROR', MB_OK or MB_ICONERROR);
         end;

        ETA := (GetTickCount - Start) / 1000;

        Counter := Counter + 1;
        Inc(recno);

        Application.ProcessMessages;

        adoQuery.Next;
    end;

end;

procedure TfMain.UpdateTOC;
var insert: UnicodeString;
    recno:  integer;
    idStr,
    titStr,
    lvlStr,
    subStr: UnicodeString;
begin
    adoQuery.Active := false;
    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM t'+BookId);
    adoQuery.Open;
    adoQuery.Active := true;

    lblTable.Caption := 'Converting Table Of Contents...';

    adoQuery.First;
    recno := 1;
    while (adoQuery.Eof = false) and (not GlobalDone) do
    begin
         idStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['id']));
         titStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['tit']));
         lvlStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['lvl']));
         subStr := ReplaceMarks(VarToStr(adoQuery.FieldValues['sub']));

        insert := Format('"%s", "%s", "%s", "%s"',
        [idStr, titStr, lvlStr, subStr]);

        try
          ddb.Execute('INSERT INTO "t'+BookId+'" VALUES ('+insert+')');
        except
            MessageBox(self.Handle,
            PChar('At Rec '+IntToStr(recno)+', SQL: INSERT INTO "t'+BookId+'" VALUES ('+insert+')'),
            'ERROR', MB_OK or MB_ICONERROR);
        end;

        ETA := (GetTickCount - Start) / 1000;

        Counter := Counter + 1;
        Inc(recno);

        Application.ProcessMessages;

        adoQuery.Next;
    end;
end;

procedure TfMain.btnBrowseClick(Sender: TObject);
begin
    dlgOpen.Filter := 'BOK files (*.bok)|*.box|MDB files (*.mdb)|*.mdb|Any ' +
      'files (*.*)|*.*';
    if dlgOpen.Execute(Handle) then
    begin

    end;
end;

procedure TfMain.btnConvertClick(Sender: TObject);
var
  adoName: string;
  fname: string;
  i: integer;
  path: string;
begin

    if btnConvert.Caption = 'Convert' then
    begin
      Updater.Enabled := true;
      GlobalDone := false;
      btnConvert.Caption := 'Cancel';

      Start := GetTickCount;

      MaxRows := 0;
      Counter := 0;
      for i := 0 to Pred(listFiles.Count) do
      begin
        adoName := ExtractFileName(listFiles.Items[i]);
        fname := ChangeFileExt(adoName, '.aza');

        path := edtDest.Text;
        if Trim(path)<>'' then
          if path[Length(path)] <> '\' then
              path := path+'\';

        CreateDB(listFiles.Items[i], path+fname);
        //ShowMessage(path+fname);
        UpdateMain();

        prgfile.Min := 0;
        prgFile.Max := MaxRows;

        UpdateTOC();
        UpdateBook();

      end;

    end else
    begin
      GlobalDone := true;
    end;

    btnConvert.Caption := 'Convert';
    Updater.Enabled := false;
    lblStatus.Caption := 'Ready';
    MaxRows := 0;
    lblTable.Caption := '';
    ddb.Close;

end;

procedure TfMain.CreateDB(adofile: string; filename: string);
var
  insert:   UnicodeString;
  con:      UnicodeString;
begin
    con := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+adofile+
      ';Persist ' +
      'Security Info=False';
    adoQuery.ConnectionString := con;

    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM Main');
    adoQuery.Open;
    adoQuery.Active := true;

    BookId := adoQuery.FieldValues['BkId'];

    ddb.DatabaseName := filename;
    ddb.CreateDatabase;

    ddb.Execute(MainController.GetMainTableSQL);
    ddb.Execute(MainController.GetTOCTableSQL('t'+BookId));
    ddb.Execute(MainController.GetBodyTableSQL('b'+BookId));

    MaxRows := MaxRows + adoQuery.RecordCount;

    // Load book table
    adoQuery.Active := false;
    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM b'+BookId);
    adoQuery.Open;
    adoQuery.Active := true;

    MaxRows := MaxRows + adoQuery.RecordCount;

    // Load book table of contents
    adoQuery.Active := false;
    adoQuery.SQL.Clear;
    adoQuery.SQL.Add('SELECT * FROM t'+BookId);
    adoQuery.Open;
    adoQuery.Active := true;

    MaxRows := MaxRows + adoQuery.RecordCount;

end;

procedure TfMain.DropFiles(var msg: TMessage);
var
  i, count  : integer;
  dropFileName : array [0..511] of Char;
  MAXFILENAME: integer;
begin
  MAXFILENAME := 511;
  // we check the query for amount of files received
  count := DragQueryFile(msg.WParam, $FFFFFFFF, dropFileName, MAXFILENAME);
  // we process them all
  for i := 0 to count - 1 do
  begin
    DragQueryFile(msg.WParam, i, dropFileName, MAXFILENAME);

    listFiles.Items.Add(dropFileName);
  end;
  // release memory used
  DragFinish(msg.WParam);
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
    DragAcceptFiles(listFiles.Handle, true);
    edtDest.Text := GetCurrentDir();
    Counter := 0;
end;

end.

