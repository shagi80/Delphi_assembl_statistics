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
    OpenDlg: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    StOnTopCB: TCheckBox;
    Label3: TLabel;
    FrReadED: TEdit;
    UpDown1: TUpDown;
    ViewAppNameED: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    LocalRB: TRadioButton;
    LocalGB: TGroupBox;
    LocalFolderED: TEdit;
    Button1: TButton;
    FTPRB: TRadioButton;
    FTPGB: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    FTPNameED: TEdit;
    UserNameED: TEdit;
    PswrdED: TEdit;
    procedure LocalRBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure SetMode(md : byte);
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

procedure TMySetForm.SetMode(md : byte);
var
  i : integer;
begin
  LocalRB.Checked:=(md=0);
  FTPRB.Checked:=(md=1);
  for I := 0 to LocalGb.ControlCount - 1 do LocalGB.Controls[i].Enabled:=LocalRB.Checked;
  for I := 0 to FTPGb.ControlCount - 1 do FTPGB.Controls[i].Enabled:=FTPRB.Checked;
end;

procedure TMySetForm.Button1Click(Sender: TObject);
var
  str: string;
begin
  str:='”кажите путь к дирректории с LOG-файлами: ';
  SelectDirectory(str,'',str);
  if str<>'' then LocalFolderED.Text:=str;
end;

procedure TMySetForm.Button2Click(Sender: TObject);
begin
  OpenDlg.InitialDir:=ExtractFilePath(application.ExeName);
  if OpenDlg.Execute then ViewAppNameED.Text:=OpenDlg.FileName;
end;

procedure TMySetForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MyIni : TIniFile;
begin
  if not(DirectoryExists(ExtractFilePath(getwin('%AppData%')+MyIniFile))) then
    CreateDir(ExtractFilePath(getwin('%AppData%')+MyIniFile));
  MyIni:=TIniFile.Create(getwin('%AppData%')+MyIniFile);
  MyIni.WriteString('MAINSET','VIEWERFNAME',ViewAppNameED.Text);
  MyIni.WriteInteger('MAINSET','REREADTIME',UpDown1.Position);
  MyIni.WriteBool('POSITION','STONTOP',StOnTopCB.Checked);
  if LocalRB.Checked then MyIni.WriteInteger('BASESET','MODE',0);
  if FTPRB.Checked then MyIni.WriteInteger('BASESET','MODE',1);
  MyIni.WriteString('BASESET','LOCALFOLDER',LocalFolderED.Text);
  MyIni.WriteString('BASESET','FTPNAME',FTPNameED.Text);
  MyIni.WriteString('BASESET','USERNAME',UserNameED.Text);
  MyIni.WriteString('BASESET','PSWRD',PswrdED.Text);
  MyIni.Free;
end;

procedure TMySetForm.FormShow(Sender: TObject);
var
  MyIni : TIniFile;
begin
  MyIni:=TIniFile.Create(getwin('%AppData%')+MyIniFile);
  MySetForm.ViewAppNameED.Text:=MyIni.ReadString('MAINSET','VIEWERFNAME','');
  MySetForm.UpDown1.Position:=MyIni.ReadInteger('MAINSET','REREADTIME',5);
  StOnTopCB.Checked:=(MyIni.ReadInteger('MAINSET','STONTOP',1)=1);
  LocalFolderED.Text:=MyIni.ReadString('BASESET','LOCALFOLDER','');
  FTPNameED.Text:=MyIni.ReadString('BASESET','FTPNAME','');
  UserNameED.Text:=MyIni.ReadString('BASESET','USERNAME','');
  PswrdED.Text:=MyIni.ReadString('BASESET','PSWRD','');
  SetMode(MyIni.ReadInteger('BASESET','MODE',0));
  MyIni.Free;
end;

procedure TMySetForm.LocalRBClick(Sender: TObject);
begin
  if localRB.Checked then SetMode(0);
  if FTPRB.Checked then SetMode(1);
end;

end.
