unit cMain;

interface

uses SysUtils;

type
    MainController = class(TObject)
    public
        class function Instance: MainController;
        class function GetBodyTableSQL(tableName: string): string;
        class function GetTOCTableSQL(tableName: string): string;
        class function GetMainTableSQL: string;
    end;


implementation

var mInstance: MainController = nil;


class function MainController.GetBodyTableSQL(tableName: string): string;
begin
  Result := 'CREATE TABLE IF NOT EXISTS '+QuotedStr(tableName)+
            '('+
            '"id" NUMBER,'+
            '"nass" VARCHAR(65535),'+
            '"part" NUMBER,'+
            '"page" NUMBER,'+
            '"hno" NUMBER'+
            ')';
end;

class function MainController.GetTOCTableSQL(tableName: string): string;
begin
  Result := 'CREATE TABLE IF NOT EXISTS '+QuotedStr(tableName)+
            '('+
            '"id" NUMBER,'+
            '"tit" VARCHAR(1000),'+
            '"lvl" NUMBER,'+
            '"sub" NUMBER'+
            ')';
end;

class function MainController.GetMainTableSQL: string;
begin
  Result := 'CREATE TABLE IF NOT EXISTS "Main"'+
'('+
'"BkId" LARGEINT,'+
'"Bk" VARCHAR(1000),'+
'"Betaka" VARCHAR(1000),'+
'"Inf" VARCHAR(1000),'+
'"Auth" VARCHAR(1000),'+
'"AuthInfo" VARCHAR(1000),'+
'"TafseerNam" VARCHAR(1000),'+
'"IslamShort" NUMBER'+
')';
end;

{ ------------ Singleton -----------------------}


class function MainController.Instance: MainController;
begin
    if (mInstance = nil) then
      mInstance := MainController.Create;

    Result := mInstance;
end;

initialization

finalization
begin
    if (mInstance <> nil) then
    begin
      mInstance.Free;
      mInstance := nil;
    end;

end;

end.
