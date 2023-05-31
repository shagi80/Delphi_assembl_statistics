unit SetUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, ShellApi, Buttons, ComCtrls, StdCtrls, ExtCtrls, FileCtrl;

const
  MyIniFile='\AsmblViewer\barini.ini';

type
  TMySetForm = class(TForm)
    DwnPn: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    LocalGB: TGroupBox;
    LocalFolderED: TEdit;
    Button1: TButton;
    LocalFolder2ED: TEdit;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MySetForm: TMySetForm;
  ExePath : string;

function GetWin(Comand: string): string;


implementation

{$R *.dfm}

function GetWin(Comand: string): string;
var
  buff: array [0 .. $FF] of char;
begin
  ExpandEnvironmentStrings(PChar(Comand), buff, SizeOf(buff));
  Result := buff;
end;


procedure TMySetForm.Button1Click(Sender: TObject);
var
  str: string;
begin
  str:='”кажите путь к дирректории с LOG-файлами: ';
  SelectDirectory(str,'',str);
  if str<>'' then begin
    if (sender as TButton).Name='Button1' then LocalFolderED.Text:=str;
    if (sender as TButton).Name='Button2' then LocalFolder2ED.Text:=str;
  end;
end;

procedure TMySetForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MyIni : TIniFile;
begin
  if not(DirectoryExists(ExtractFilePath(getwin('%AppData%')+MyIniFile))) then
    CreateDir(ExtractFilePath(getwin('%AppData%')+MyIniFile));
  MyIni:=TIniFile.Create(getwin('%AppData%')+MyIniFile);
  MyIni.WriteString('BASESET','LOCALFOLDER1',LocalFolderED.Text);
  MyIni.WriteString('BASESET','LOCALFOLDER2',LocalFolder2ED.Text);
  MyIni.Free;
end;

procedure TMySetForm.FormShow(Sender: TObject);
var
  MyIni : TIniFile;
begin
  MyIni:=TIniFile.Create(getwin('%AppData%')+MyIniFile);
  LocalFolderED.Text:=MyIni.ReadString('BASESET','LOCALFOLDER1','');
  LocalFolder2ED.Text:=MyIni.ReadString('BASESET','LOCALFOLDER2','');
  MyIni.Free;
end;

end.
