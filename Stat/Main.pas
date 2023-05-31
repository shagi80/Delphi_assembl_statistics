unit MAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, FileCtrl, IniFiles, DateUtils, ButtonGroup;
  //IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP;

type
  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    ImageList1: TImageList;
    FlLstPn: TPanel;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    UnselBtn: TToolButton;
    FileLW: TListView;
    FltrBtn: TToolButton;
    SelAllBtn: TToolButton;
    CngSelBtn: TToolButton;
    MnMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    MnLb: TLabel;
    N13: TMenuItem;
    N14: TMenuItem;
    PausePn: TPanel;
    Panel4: TPanel;
    ToolBar2: TToolBar;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Panel2: TPanel;
    ShowBaseBtn: TSpeedButton;
    Label1: TLabel;
    ToolButton12: TToolButton;
    ToolButton1: TToolButton;
    BG: TButtonGroup;
    MainMenu1: TMainMenu;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    ShowBase: TAction;
    ShowBaseMI: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Setting: TAction;
    N24: TMenuItem;
    MsgLB: TLabel;
    Bevel1: TBevel;
    Panel3: TPanel;
    YearBox: TComboBox;
    Label2: TLabel;
    Panel5: TPanel;
    Path1Btn: TSpeedButton;
    Path2Btn: TSpeedButton;
    procedure YearBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SettingExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ShowBaseExecute(Sender: TObject);
    procedure BGButtonClicked(Sender: TObject; Index: Integer);
    procedure UnselBtnClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FltrBtnClick(Sender: TObject);
    procedure FileLWDblClick(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure UpdateFileLW(fltr : string);
    procedure CreateChild1(fname : string);
    procedure CreateChild2(var fllst : TStringList);
    procedure CloseChild(sender: TObject;var act: TCloseAction);
    procedure DeleteDir(FolderName:string);
    procedure Path1BtnClick(Sender: TObject);
    procedure Path2BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation



{$R *.dfm}


uses ShellApi, CHILDWIN, CHILDWIN1,LogDateClass, about, StFormUnit, SetUnit;


var
  BasePath1, BasePath2, BasePath : string;

procedure TMainForm.BGButtonClicked(Sender: TObject; Index: Integer);
var
  i : integer;
begin
  for I := 0 to self.MDIChildCount - 1 do
    if self.MDIChildren[i].Caption=BG.Items[Index].Caption then
        if self.MDIChildren[i].WindowState=wsMinimized then
          self.MDIChildren[i].WindowState:=wsNormal else   self.MDIChildren[i].BringToFront;
end;

procedure TMainForm.CloseChild(sender: TObject;var act: TCloseAction);
var
  i : integer;
begin
  i:=0;
  While(i<BG.Items.Count)and((sender as TForm).Caption<>BG.Items[i].Caption) do inc(i);
  if (sender as TForm).Caption=BG.Items[i].Caption then
    BG.Items[i].Destroy;
  Act := caFree;
end;

procedure TMainForm.UpdateFileLW(fltr: string);
const
  Month   : Array [1..12] of String = ('Январь', 'Февраль', 'Март', 'Апрель',
                                'Май', 'Июнь', 'Июль', 'Август',
                                'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь');var
  fname   : string;
  sres    : TSearchRec;
  LItm    : TListItem;
  yearstr : string;
begin
  if Length(fltr)>0 then MnLb.Caption:=Month[StrToInt(fltr)]+' :' else MnLb.Caption:='Все файлы :';
  if not DirectoryExists(BasePath) then begin
      MsgLB.Caption:='Нет доступа к папке...';
      Abort;
    end;
  MsgLB.Caption:='Локальная папка';
  FileLW.Items.Clear;

  yearstr:=YearBox.Text;
  yearstr:=copy(yearstr,Length(yearstr)-1,MaxInt);
  if Length(fltr)>0 then fname:=basepath+'\??'+fltr+yearstr+'.txt'
    else fname:=basepath+'\????'+yearstr+'.txt';
  if(FindFirst(fname,faAnyFile,sres)=0)then
    repeat
      LItm:=FileLW.Items.Add;
      LItm.Caption:=sres.Name;
    until FindNext(sres)<>0 ;
end;

procedure TMainForm.YearBoxChange(Sender: TObject);
begin
  self.UpdateFileLW('');
end;

procedure TMainForm.DeleteDir(FolderName:string);
var
  sr: TSearchRec;
begin
  if FindFirst(FolderName+'\*.*',faAnyFile,sr)=0 then
    repeat
      DeleteFile(FolderName+'\'+sr.Name);
    until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure TMainForm.CreateChild2(var fllst : TStringList);
var
  Child1  : TMDIChild1;
  btn     : TGrpButtonItem;
  AppPath : string;
  i      : integer;
begin
  if fllst.Count>0 then
    begin
      Child1:=TMDIChild1.Create(application);
      LockWindowUpdate(Child1.Handle);
      PausePn.Left:=round((self.ClientWidth-PausePn.Width)/2);
      PausePn.Top:=round((self.ClientHeight-PausePn.Height)/2);
      PausePn.Visible:=true;
      PausePn.Caption:='Подключение к базе данных ..';
      PausePn.Repaint;
      if not(DirectoryExists(ExtractFilePath(getwin('%AppData%')+MyIniFile)+'\temp')) then
        CreateDir(ExtractFilePath(getwin('%AppData%')+MyIniFile)+'\temp');
      AppPath:=ExtractFilePath(getwin('%AppData%')+MyIniFile);
      for I := 0 to fllst.Count - 1 do begin
        copyfile(PChar(BasePath+'\'+fllst[i]),PChar(AppPath+'temp\'+fllst[i]),true);
        fllst[i]:=AppPath+'temp\'+fllst[i];
        PausePn.Caption:='Загрузка из папки: '+FormatFloat('00',(i+1)/fllst.Count*100)+'%';
        PausePn.Repaint;
      end;
      PausePn.Caption:='Обработка статистики ...';
      PausePn.Repaint;
      Child1.Init(self.MDIChildCount,fllst);
      self.DeleteDir(AppPath+'temp');
      PausePn.Visible:=False;
      Child1.OnClose:=self.CloseChild;
      btn:=BG.Items.Add;
      btn.ImageIndex:=1;
      btn.Caption:=Child1.Caption;
      LockWindowUpdate(0);
    end;
end;

procedure TMainForm.CreateChild1(fname : string);
var
  Child1 : TMDIChild;
  btn    : TGrpButtonItem;
  AppPAth: string;
begin
  if Length(fname)>0 then
    begin
      PausePn.Left:=round((self.ClientWidth-PausePn.Width)/2);
      PausePn.Top:=round((self.ClientHeight-PausePn.Height)/2);
      PausePn.Visible:=true;
      PausePn.Caption:='Подключение к базе ..';
      PausePn.Repaint;
      if not(DirectoryExists(ExtractFilePath(getwin('%AppData%')+MyIniFile)+'\temp')) then
        CreateDir(ExtractFilePath(getwin('%AppData%')+MyIniFile)+'\temp');
      AppPath:=ExtractFilePath(getwin('%AppData%')+MyIniFile);
      fname:=BasePath+'\'+fname;
      PausePn.Caption:='Обработка статитсики ...';
      PausePn.Repaint;
      if FileExists(fname) then
        begin
          Child1:=TMDIChild.Create(application);
          LockWindowUpdate(Child1.Handle);
          Child1.Init(fname);
          Child1.OnClose:=self.CloseChild;
          btn:=BG.Items.Add;
          btn.ImageIndex:=6;
          btn.Caption:=Child1.Caption;
          LockWindowUpdate(0);
        end;
      self.DeleteDir(AppPath+'temp');
      PausePn.Visible:=False;
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.DeleteDir(ExePath+'temp');
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  MyIni   : TIniFile;
  str     : string;
  i       : integer;
  bmp     : TBitMap;
begin
  ExePath:=ExtractFilePath(application.ExeName);
  MyIni:=TIniFile.Create(getwin('%AppData%')+MyIniFile);
  //Установка множителя для расчета премии НС
  FaultProcMax:=MyIni.ReadInteger('CALKDATA','FPROCMAX',0);
  FaultProcMin:=MyIni.ReadInteger('CALKDATA','FPROCMIN',0);
  NSPremBase:=MyIni.ReadInteger('CALKDATA','NSPREM',0);
  EmpPremBase:=MyIni.ReadInteger('CALKDATA','EMPPREM',0);
  //параметры подключения к базе
  StForm:=TStForm.Create(self);
  StForm.Label3.Caption:='ПОДКЛЮЧЕНИЕ К ЛОКАЛЬНОЙ ПАПКЕ ...';
  StForm.Show;
  StForm.Repaint;
  BasePath1:=MyIni.ReadString('BASESET','LOCALFOLDER1','');
  BasePath2:=MyIni.ReadString('BASESET','LOCALFOLDER2','');
  MyIni.Free;
  YearBox.ItemIndex:=YearBox.Items.Count-1;
  str:=inttostr(MonthOfTheYear(now));
  if Length(str)=1 then str:='0'+str;
  Path1Btn.Down:=true;
  BasePath:=BasePath1;
  self.UpdateFileLW(str);
  for I := 0 to FileLW.Items.Count - 1 do FileLW.Items[i].Checked:=true;
  BG.ButtonWidth:=round((BG.Images.Width+BG.Canvas.TextWidth('Выборка00'))*1.3);
  ShowBaseBtn.Caption:='';
  bmp:=TBitMap.Create;
  ImageList1.GetBitmap(24,bmp);
  ShowBaseBtn.Glyph:=bmp;
  StForm.Free;
  if (ParamCount>0)then self.CreateChild1(ParamStr(1));
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.N2Click(Sender: TObject);
var
  str:string;
begin
  if Sender is TMenuItem then
    begin
      str:=(sender as TMenuItem).name;
      str:=copy(str,2,MaxInt);
      if Length(str)=1 then str:='0'+str;
      if str='13' then str:='';
      self.UpdateFileLW(str);
    end;
end;

procedure TMainForm.Path1BtnClick(Sender: TObject);
var
  str:string;
begin
    BasePath:=BasePath1;
    str:=inttostr(MonthOfTheYear(now));
    if Length(str)=1 then str:='0'+str;
    self.UpdateFileLW(str);
end;

procedure TMainForm.Path2BtnClick(Sender: TObject);
var
  str:string;
begin
    BasePath:=BasePath2;
    str:=inttostr(MonthOfTheYear(now));
    if Length(str)=1 then str:='0'+str;
    self.UpdateFileLW(str);
end;

procedure TMainForm.SettingExecute(Sender: TObject);
begin
  if MySetForm.ShowModal=mrOk then
    with MySetForm do begin
      BasePath1:=LocalFolderED.Text;
      BasePath2:=LocalFolder2ED.Text;
      if Path1Btn.Down then BasePath:=BasePath1 else BasePath:=BasePath2;
      self.UpdateFileLW('');
    end;
end;

procedure TMainForm.ShowBaseExecute(Sender: TObject);
var
  bmp : TBitMap;
begin
  FlLstPn.Visible:=not FlLstPn.Visible;
  bmp:=TBitMap.Create;
  if FlLstPn.Visible then
    ImageList1.GetBitmap(24,bmp)
  else
    ImageList1.GetBitmap(23,bmp);
 ShowBaseBtn.Glyph:=bmp;
 ShowBaseMI.Checked:=FlLstPn.Visible;
end;

procedure TMainForm.ToolButton2Click(Sender: TObject);
var
  i : integer;
  FlLst : TStringList;
begin
  FlLst:=TStringList.Create;
  for I := 0 to FileLW.Items.Count-1 do
    if FileLW.Items[i].Checked=true then FlLst.Add(FileLW.Items[i].Caption);
  if FlLst.Count=1 then self.CreateChild1(FlLst[0])
    else self.CreateChild2(FlLst);
end;

procedure TMainForm.ToolButton5Click(Sender: TObject);
var
  i,j,ml : integer;
  mask : array of boolean;
begin
  if FileLW.Items.Count>4 then
    begin
      ml:=4;
      SetLength(mask,ml);
      for I := 0 to ml-1 do mask[i]:=FileLW.Items[i].Checked;
      j:=0;
      for I := ml to FileLW.Items.Count - 1 do
        begin
          if j>=ml then j:=0;
          FileLW.Items[i].Checked:=mask[j];
          inc(j);
        end;
    end;
end;

procedure TMainForm.UnselBtnClick(Sender: TObject);
var
  i : integer;
begin
  if (sender is TToolButton) then
    for I := 0 to FileLW.Items.Count - 1 do
      begin
        if (Sender as TToolButton).Name='SelAllBtn' then FileLW.Items[i].Checked:=true;
        if (Sender as TToolButton).Name='UnselBtn' then FileLW.Items[i].Checked:=false;
        if (Sender as TToolButton).Name='CngSelBtn' then FileLW.Items[i].Checked:=not(FileLW.Items[i].Checked);
      end;
end;

procedure TMainForm.FltrBtnClick(Sender: TObject);
begin
  MnMenu.Popup(mouse.CursorPos.X,mouse.CursorPos.Y)
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FileLWDblClick(Sender: TObject);
begin
  if FileLW.SelCount=1 then self.CreateChild1(FileLW.Selected.Caption);
end;

end.
