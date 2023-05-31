program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  SetUnit in 'SetUnit.pas' {MySetForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMySetForm, MySetForm);
  Application.Run;
end.
