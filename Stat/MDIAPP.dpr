program Mdiapp;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  CHILDWIN in 'CHILDWIN.PAS' {MDIChild},
  about in 'about.pas' {AboutBox},
  CHILDWIN1 in 'CHILDWIN1.pas' {MDIChild1},
  StFormUnit in 'StFormUnit.pas' {StForm},
  SetUnit in 'SetUnit.pas' {MySetForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Статистика сборки';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TMySetForm, MySetForm);
  Application.Run;
end.
