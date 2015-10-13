program BokConverter;

uses
  Forms,
  vMain in 'vMain.pas' {fMain},
  cMain in 'cMain.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Bok Convert';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
