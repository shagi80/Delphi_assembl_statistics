unit CHILDWIN;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  LogDateClass, Dialogs, ExtCtrls, StdCtrls, DateUtils, TableClass, ComCtrls,
  Grids, Menus, ClipBrd, frxClass, Buttons;


type
  TMDIChild = class(TForm)
    CapLb: TLabel;
    InfoLB: TLabel;
    PC: TPageControl;
    TabSheet1: TTabSheet;
    ScrollBox1: TScrollBox;
    ServPB: TPaintBox;
    FltRezPB: TPaintBox;
    FaultPB: TPaintBox;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GrapPB: TPaintBox;
    TabSheet4: TTabSheet;
    AGrapPB: TPaintBox;
    TMCP: TPanel;
    Label4: TLabel;
    CodeCB: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    StHourCB: TComboBox;
    FnHourCB: TComboBox;
    Label7: TLabel;
    ModelCB: TComboBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    PM: TPopupMenu;
    CopyMI: TMenuItem;
    N1: TMenuItem;
    EKLB: TLabel;
    Splitter3: TSplitter;
    CntLB: TLabel;
    PrintBtn: TButton;
    Report: TfrxReport;
    UDS: TfrxUserDataSet;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    LogSG: TStringGrid;
    DelBtn: TSpeedButton;
    procedure ServPBMouseLeave(Sender: TObject);
    procedure ServPBMouseEnter(Sender: TObject);
    procedure ServPBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure CopyMIClick(Sender: TObject);
    procedure PMPopup(Sender: TObject);
    procedure StHourCBChange(Sender: TObject);
    procedure AGrapPBPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GrapPBPaint(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure FltRezPBPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ServPBPaint(Sender: TObject);
    procedure FaultPBPaint(Sender: TObject);
    procedure DrawServTable(var PB : TPaintBox);
    procedure DrawFaultTable(var PB : TPaintBox);
    procedure DrawFltRezTable(var PB : TPaintBox);
    procedure DrawTableHeader(var PB : TPaintBox; var Table : TMyTable);
    procedure DrawGrap(w,h : integer; cnv : TCanvas);
    procedure DrawAGrap(w,h : integer; cnv : TCanvas);
    procedure SetTextModeControl;
    procedure Init(fn:string);
    procedure WriteLogs(var SG : TStringGrid);
    procedure CopyTableToClipboard( pic : boolean);
    procedure PrintBtnClick(Sender: TObject);
    procedure ReportGetValue(const VarName: string; var Value: Variant);
    procedure DelBtnClick(Sender: TObject);
    procedure WriteTopLabel;
  private
    { Private declarations }
    ServTable   : TMyTable;
    FaultTable  : TMyTable;
    FltRezTable : TMyTable;
    Log         : TLogDate;
    StTm,FnTm   : TTime;
    FName       : string;
  public
    { Public declarations }
  end;

  TRepLogItm = record
    time : TTime;
    text : string;
  end;

                           
implementation

{$R *.dfm}

var
  CopyControl : TObject;
  ReportLog   : array of TRepLogItm;

procedure TMDIChild.CopyTableToClipboard( pic : boolean);
var
  c,r   : integer;
  str   : string;
  img   : TImage;
begin
  //
  if pic then
    begin
      img:=TImage.Create(self);
      if (CopyControl is TMyTable) then
        with(CopyControl as TMyTable)do
          begin
            img.Height:=Height;
            img.Width:=Width+Left*2;
            Draw(Img.Canvas);
          end;
      if (CopyControl is TPaintBox) then
        with(CopyControl as TPaintBox)do
          begin
            img.Height:=Height;
            img.Width:=Width;
            if name='GrapPB' then self.DrawGrap(Width,height,img.Canvas);
            if name='AGrapPB' then self.DrawAGrap(Width,height,img.Canvas);
          end;
      Clipboard.Assign(img.Picture);
    end else
    if(CopyControl is TMyTable)then
    with (CopyControl as TMyTable) do
    begin
      str:='';
      for r := 0 to RowCount - 1 do
        begin
          for c := 0 to ColCount - 1 do
            if c<(ColCount-1) then str:=str+Cells[c,r]+chr(9);
          if r<(RowCount-1) then str:=str+chr(13);
        end;
      Clipboard.AsText:=str;
    end;
end;

procedure TMDIChild.FormCreate(Sender: TObject);
begin
  Log:=TlogDate.Create;
  ServTable:=TMyTable.Create;
  FaultTable:=TMyTable.Create;
  FltRezTable:=TMyTable.Create;
end;

procedure TMDIChild.Init(fn:string);
var
  str  : string;
begin
  FName:=fn;
  StTm:=StrToTime('08:00:00');
  FnTm:=StrToTime('20:00:00');
  Log.LoadFaultTxt(ExtractFilePath(application.ExeName)+FLtTxtFile);
  Log.LoadFromTxt(Fname);
  str:=ExtractFileName(fname);
  self.Caption:=copy(str,1,pos('.',str)-1);
  self.WriteTopLabel;
  self.SetTextModeControl;
  self.WriteLogs(LogSg);
  PC.ActivePageIndex:=0;
  self.PCChange(self);
end;

procedure TMDIChild.WriteTopLabel;
var
  str  : string;
  ek   : real;
  i    : integer;
begin
  str:='Дата производства: '+datetostr(log.Date)+chr(13);
  str:=str+'Первое изделие выпущенно в '+timetostr(log.FirstTime)+chr(13);
  str:=str+'Последние изделие выпущено в '+timetostr(log.LastTime)+chr(13);
  str:=str+'Всего произведно '+
    inttostr(log.CountBetween(log.FirstTime,log.LastTime,100,''))+' ед';
  if (log.Count>0)and(log.Logs[0].empcnt>0) then begin
      str:=str+chr(13)+'Количество персонала (без учета нач смены): '
        +IntToStr(log.Logs[0].empcnt)+chr(13)+
        'Дополнительная премия на человека: '
          +chr(13)+'всего '+FormatFloat('##0.00',log.Logs[0].totalbonus)+' руб';
      if log.Logs[0].hourbonus>0 then
        str:=str+chr(13)+'по часам '+FormatFloat('##0.00',log.Logs[0].hourbonus)+' руб';
      if log.Logs[0].daybonus>0 then
        str:=str+chr(13)+'за день'+FormatFloat('##0.00',log.Logs[0].daybonus)+' руб';
      if log.Logs[0].faultbonus>0 then
        str:=str+chr(13)+'за качество '+FormatFloat('##0.00',log.Logs[0].faultbonus)+' руб';
    end;
  //Премия начальникам смен 1000 руб/смена - (% брака - NSpremBase) Х NSpremQ
  if FaultProcMax>0 then begin
    ek:=0;
    for i := 0 to Log.FaultList.Count - 1 do
      ek:=ek+log.CountBetween(log.FirstTime,log.LastTime,strtoint(Log.FaultList[i]),'');
    //фактический процент брака
    ek:=100*ek/(Log.CountBetween(log.FirstTime,log.LastTime,100,'')+ek);
    ek:=NSPremBase/(FaultProcMax-FaultProcMin)*(FaultProcMax-ek);
    if ek<0 then ek:=0;
    str:=str+chr(13)+'Премия начальника смены: '+FormatFloat('##0.00',ek)+' руб';
  end else str:=str+chr(13)+'Премия начальника смены на задана.';
  InfoLB.Caption:=str;
  //расчет эффективности на человека
  ek:=0;
  for I := 0 to Log.ModelList.Count - 1 do
    ek:=ek+Log.CountBetween(Log.FirstTime,Log.LastTime,100,Log.ModelList[i])/
      GetKENorm(Log.ModelList[i]);
  str:='Эфф-ть произв-ва: '+FormatFloat('0.00',EK);
  ek:=log.GetEP;
  if ek>0 then str:=str+chr(13)+'Эфф-ть на человека: '+FormatFloat('0.00',Ek);
  EKLB.Caption:=str;
  EKLB.Top:=InfoLB.Top;
end;

procedure TMDIChild.N1Click(Sender: TObject);
begin
  self.CopyTableToClipboard(true);
end;

procedure TMDIChild.FormResize(Sender: TObject);
begin
  EKLB.Left:=self.ClientWidth-EKLB.Width-InfoLB.Margins.Left;
  LogSG.Margins.Left:=round(((LogSG.Owner as TControl).Width-LogSG.ColWidths[0]-LogSG.ColWidths[1]-LogSG.ColWidths[2]-LogSG.ColWidths[3])/2);
  LogSG.Margins.Right:=LogSG.Margins.Left;
  case PC.ActivePageIndex of
    0 : begin
          self.DrawServTable(ServPB);
          self.DrawFaultTable(FaultPB);
          self.DrawFltRezTable(FltRezPB);
        end;
    1 : self.DrawGrap(GrapPB.Width,GrapPB.Height,GrapPb.Canvas);
    2 : self.DrawAGrap(AGrapPB.Width,AGrapPB.Height,AGrapPb.Canvas);
  end;
  PrintBtn.Top:=PC.Top;
  PrintBtn.Left:=PC.Left+PC.Width-PrintBtn.Width;
end;

procedure TMDIChild.PCChange(Sender: TObject);
begin
  self.FormResize(sender);
end;

procedure TMDIChild.PMPopup(Sender: TObject);
begin
  if CopyControl is TPaintBox then CopyMI.Enabled:=false else CopyMI.Enabled:=true;
end;

procedure TMDIChild.PrintBtnClick(Sender: TObject);
var
  i : integer;
begin
  SetLength(ReportLog,0);
  for i := 0 to Log.Count - 1 do
    if log.Logs[i].code<>100 then begin
      SetLength(ReportLog,high(ReportLog)+2);
      ReportLog[high(ReportLog)].time:=log.logs[i].time;
      ReportLog[high(ReportLog)].text:=log.logs[i].text;
    end;
  UDS.RangeEnd:=reCount;
  UDS.RangeEndCount:=high(ReportLog)+1;
  uds.First;
  Report.ShowReport(true);
end;

procedure TMDIChild.ReportGetValue(const VarName: string; var Value: Variant);
begin
  if comparetext(varname,'REPDATE')=0 then value:=FormatDateTime('dd mmmm yyyy',log.Date);
  if comparetext(varname,'DEFTIME')=0 then value:=FormatDateTime('hh:mm:ss',ReportLog[UDS.RecNo].time);
  if comparetext(varname,'DEFNAME')=0 then value:=ReportLog[UDS.RecNo].text;
  if comparetext(varname,'TOTCOUNT')=0 then value:=inttostr(log.CountBetween(log.FirstTime,log.LastTime,100,''))+' ед';
end;

procedure TMDIChild.SetTextModeControl;
var
  i : integer;
begin
  if Log.CountBetween(Log.FirstTime,Log.LastTime,-1,'')>0 then
    begin
      TMCP.Enabled:=true;
      ModelCB.Clear;
      ModelCB.Items.Add('Все модели');
      for I := 0 to Log.ModelList.Count - 1 do ModelCB.Items.Add(Log.ModelList[i]);
      ModelCB.ItemIndex:=0;
      CodeCB.Clear;
      CodeCB.Items.Add('Вся продукция');
      CodeCB.Items.Add('Готовая продукция');
      if Log.FaultTxt.Count>0 then
        for I := 0 to Log.FaultList.Count - 1 do CodeCB.Items.Add
          (FormatFloat('00',strtoint(Log.FaultList[i]))+' '+Log.FaultTxt[strtoint(Log.FaultList[i])]);
      CodeCB.ItemIndex:=0;
      StHourCB.ItemIndex:=hourof(log.FirstTime);
      FnHourCB.ItemIndex:=hourof(log.LastTime)+1;
    end else TMCP.Enabled:=false;
end;

procedure TMDIChild.StHourCBChange(Sender: TObject);
begin
  self.WriteLogs(LogSG);
end;

procedure TMDIChild.WriteLogs(var SG : TStringGrid);
var
  i   : integer;
  str : string;
begin
  SG.Margins.Left:=round(((SG.Owner as TControl).Width-SG.ColWidths[0]-SG.ColWidths[1]-SG.ColWidths[2]-
    SG.ColWidths[3])/2);
  SG.Margins.Right:=SG.Margins.Left;
  SG.RowCount:=2;
  SG.FixedRows:=1;
  SG.Rows[1].Clear;
  SG.Enabled:=false;
  SG.Cells[0,0]:='  Время';
  SG.Cells[1,0]:='  Модель';
  SG.Cells[2,0]:='  Персонал';
  SG.Cells[3,0]:='  Состояние';
  str:=copy(CodeCB.Text,1,2);
  for I := 0 to Log.Count - 1 do
    if (HourOf(Log.Logs[i].time)>=StHourCB.ItemIndex)and
       (HourOf(Log.Logs[i].time)<FnHourCB.ItemIndex)and
       ((Log.Logs[i].model=ModelCB.Text)or(ModelCB.ItemIndex=0))and
       ((CodeCB.ItemIndex=0)or(Log.Logs[i].code=StrToIntDef(str,-1))) then
      begin
        if not SG.Enabled then SG.Enabled:=true;        
        SG.Cells[0,SG.RowCount-1]:=FormatDateTime('hh:mm:ss',Log.Logs[i].time);
        SG.Cells[1,SG.RowCount-1]:=Log.Logs[i].model;
        if Log.Logs[i].empcnt>0 then SG.Cells[2,SG.RowCount-1]:=IntToStr(Log.Logs[i].empcnt)
          else SG.Cells[2,SG.RowCount-1]:='';
        SG.Cells[3,SG.RowCount-1]:=Log.Logs[i].text;
        SG.RowCount:=SG.RowCount+1;
      end;
  if SG.RowCount>2 then SG.RowCount:=SG.RowCount-1;
  if ModelCb.ItemIndex=0 then str:='' else str:=ModelCB.Text;
  CntLB.Caption:='Кол-во: '+IntToStr(Log.CountBetween(EncodeTime(StHourCB.ItemIndex,0,0,0),
    EncodeTime(FnHourCB.ItemIndex,0,0,0),LOg.GetFltInd(CodeCB.Text),str))+' ед';
  DelBtn.Enabled:=SG.Enabled;
end;

procedure TMDIChild.CopyMIClick(Sender: TObject);
begin
  self.CopyTableToClipboard(false);
end;

procedure TMDIChild.DelBtnClick(Sender: TObject);
var
  tmstr : string;
  ind,i : integer;
  ek,newek,buf: real;
begin
  if LogSG.Selection.top>0 then begin
    tmstr:=LogSG.Cells[0,LogSG.Selection.top];
    ind:=Log.IndForDate(tmstr);
    if ind=-1 then begin
      MessageDLG('Ошибка!'+chr(13)+'Элемент не найден',mtError,[mbOk],0);
      Abort;
    end;
    if Log.Logs[ind].code=100 then begin
      MessageDLG('Вы не можете удалять готовую продукцию !',mtError,[mbOk],0);
      Abort;
    end;
    tmstr:='Вы собираетесь удалить запись о дефекте'+chr(13)+'"код '+IntToStr(Log.Logs[ind].code)+
      ' '+Log.FaultTxt[Log.Logs[ind].code]+' ('+Log.Logs[ind].model+')"'+chr(13)+
      'Вы уверены ?';
    if MessageDLG(tmstr,mtWarning,[mbYes,mbCancel],0)=mrYes then begin
      if FaultProcMax>0 then begin
        //пересчет премии за брак для сборщиков
        //текущий размер премии за брак
        ek:=Log.GetFaultPorc;
        ek:=EmpPremBase/(FaultProcMax-FaultProcMin)*(FaultProcMax-ek);
        if ek<0 then ek:=0;
        //текущий размер премии за качество
        buf:=log.Logs[0].faultbonus-ek;
        if buf<0 then buf:=0;
        //удаление записи о дефекте
        Log.DeleteRec(ind);
        //новый размер премии за брак
        newek:=Log.GetFaultPorc;
        newek:=EmpPremBase/(FaultProcMax-FaultProcMin)*(FaultProcMax-newek);
        if newek<0 then newek:=0;
        {tmstr:='Внимание !'+chr(13)+'Размер премии сборщика был '+FormatFloat('###0.00',buf+ek)+' руб/чел'+
          chr(13)+'Размер премии сборщикка стал '+FormatFloat('###0.00',buf+newek)+' руб/чел';
        MessageDLG(tmstr,mtWarning,[mbOk],0); }
        if newek>0 then for I := 0 to Log.Count - 1 do begin
          Log.Logs[i].faultbonus:=buf+newek;
          Log.Logs[i].totalbonus:=Log.Logs[i].daybonus+Log.Logs[i].hourbonus
            +Log.Logs[i].faultbonus;
        end;
      end else Log.DeleteRec(ind);
      Log.SaveToTxt(Fname);
      self.WriteLogs(LogSg);
      self.WriteTopLabel;
    end;
  end;
end;

procedure TMDIChild.DrawAGrap(w,h : integer; cnv : TCanvas);
var
  max,i,cnt  : integer;
  str        : string;
  t1,t2      : TTime;
  ZPnt,BPnt  : TPoint;
  sctY, sctX : real;
  Int        : integer;
begin
  with cnv do
  begin
  SctX:=w/14;
  ZPnt.X:=round(SctX/2);
  ZPnt.Y:=h-ABS(Font.Height)*2;
  Pen.Color:=clBlack;
  Pen.Width:=2;
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X+round(SctX*13),ZPnt.Y);
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X,0);

  Pen.Color:=clGray;
  Pen.Width:=1;
  t1:=StTm;
  for I := 0 to 11 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh:mm',t2);
      MoveTo(ZPnt.X+round((i+1)*SctX),ZPnt.Y-2);
      LineTo(ZPnt.X+round((i+1)*SctX),0);
      TextOut((ZPnt.X+round((i+1)*SctX))-round(TextWidth(str)/2),ZPnt.Y+5,str);
      t1:=t2;
    end;
  max:=log.CountBetween(log.FirstTime,log.LastTime,-1,'');
  max:=((max div 10)+1)*10;
  SctY:=(Zpnt.Y*2-h)/Max;
  for I := 0 to (max div 25) do
    begin
      str:=inttostr(i*25);
      TextOut(ZPnt.X-TextWidth(str)-5,ZPnt.Y-round(i*sctY*25)-
        round(TextHeight(str)/2),str);
      MoveTo(ZPnt.X,ZPnt.Y-round(i*sctY*25));
      LineTo(ZPnt.X+round(SctX*13),ZPnt.Y-round(i*sctY*25));
    end;
  SctX:=SctX/12;
  //Вывод готовой продукции
  Pen.Width:=3;
  Pen.Color:=clBlack;
  MoveTo(ZPnt.X,ZPnt.Y);
  t1:=StTm;
  t2:=t1;
  i:=0;
  Int:=0;
  while CompareTime(Log.LastTime,t2)=1 do
    begin
      t2:=IncMinute(t2,5);
      cnt:=Log.CountBetween(t1,t2,-1,'');
      cnt:=round(cnt);
      if PenPos.Y=(ZPnt.Y-round(SctY*Cnt)) then
        begin
          Pen.Color:=clRed;
          inc(Int);
        end
        else
        begin
          Pen.Color:=clBlack;
          if int>0 then
            begin
              str:=inttostr(int*5);
              BPnt:=PenPos;
              TextOut(round(BPnt.X-SctX*int/2-TextWidth(str)/2),
                round(BPnt.Y-TextHeight(str)*1.5),str);
              MoveTo(Bpnt.X,BPnt.Y);
            end;

          int:=0;
        end;

      LineTo(ZPnt.X+round((i+1)*SctX),ZPnt.Y-round(SctY*Cnt));
      inc(i);
    end;
  end;
end;

procedure TMDIChild.DrawGrap(w,h : integer; cnv : TCanvas);
var
  max,k,i,j,cnt     : integer;
  str     : string;
  t1,t2           : TTime;
  ZPnt,Sct    : TPoint;
begin
  with cnv do
  begin
  Sct.X:=round(w/14);
  ZPnt.X:=round(Sct.X/2);
  ZPnt.Y:=h-ABS(Font.Height)*2;
  Pen.Color:=clBlack;
  Pen.Width:=2;
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X+Sct.X*13,ZPnt.Y);
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X,0);

  Pen.Color:=clGray;
  Pen.Width:=1;
  t1:=StTm;
  Max:=0;
  for I := 0 to 11 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh',t1)+'-'+FormatDateTime('hh',t2);
      MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-2);
      LineTo(ZPnt.X+(i+1)*Sct.X,0);
      TextOut((ZPnt.X+(i+1)*Sct.X)-round(TextWidth(str)/2),ZPnt.Y+5,str);
      if (i=0)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
      if (i=11)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
      cnt:=Log.CountBetween(t1,t2,100,'');
      if cnt>Max then Max:=cnt;
      t1:=t2;
    end;
  if Max=0 then Abort;
  max:=((max div 10)+1)*10;
  Sct.Y:=round((Zpnt.Y*2-h)/Max);
  for I := 0 to (max div 10) do
    begin
      str:=inttostr(i*10);
      TextOut(ZPnt.X-TextWidth(str)-5,ZPnt.Y-(i*sct.Y*10)-
        round(TextHeight(str)/2),str);
      MoveTo(ZPnt.X,ZPnt.Y-i*sct.Y*10);
      LineTo(ZPnt.X+Sct.X*13,ZPnt.Y-i*sct.Y*10);
    end;
  //Вывод готовой продукции
  Pen.Width:=2;
  for j := 0 to Log.ModelList.Count - 1 do
    begin
      case j of
        0 : Pen.Color:=clGreen;
        1 : Pen.Color:=clNavy;
        2 : Pen.Color:=clTeal;
        3 : Pen.Color:=clMaroon;
        else Pen.Color:=clBlack;
      end;
      MoveTo(ZPnt.X,ZPnt.Y);
      t1:=StTm;
      for I := 0 to 11 do
        begin
          t2:=IncHour(t1);
          if (i=0)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=12)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=Log.CountBetween(t1,t2,100,Log.ModelList[j]);
          if (cnt>0) then
            begin
            if (PenPos.Y=ZPnt.Y) then
              MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt)
              else
              LineTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
            Ellipse(ZPnt.X+(i+1)*Sct.X-3,ZPnt.Y-Sct.Y*Cnt-3,
                ZPnt.X+(i+1)*Sct.X+3,ZPnt.Y-Sct.Y*Cnt+3);
            str:=inttostr(cnt);
            TextOut(ZPnt.X+(i+1)*Sct.X-round(TextWidth(str)/2),
                ZPnt.Y-Sct.Y*Cnt-round(TextHeight(str)*1.5),str);
            str:=log.ModelList[j];
            TextOut(ZPnt.X+(i+1)*Sct.X-round(TextWidth(str)/2),
                ZPnt.Y-Sct.Y*Cnt+round(TextHeight(str)/2),str);
            MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
            end else
              MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
          t1:=t2;
        end;
    end;
  //Вывод брака
  for j := 0 to Log.ModelList.Count - 1 do
    begin
      Pen.Color:=clRed;
      MoveTo(ZPnt.X,ZPnt.Y);
      t1:=StTm;
      for I := 0 to 11 do
        begin
          t2:=IncHour(t1);
          if (i=0)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=12)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=0;
          for k := 0 to Log.FaultList.Count - 1 do
            cnt:=cnt+Log.CountBetween(t1,t2,strtoint(Log.FaultList[k]),Log.ModelList[j]);
          if (cnt>0) then
            begin
            if (PenPos.Y=ZPnt.Y) then
              MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt)
              else
              LineTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
            Ellipse(ZPnt.X+(i+1)*Sct.X-3,ZPnt.Y-Sct.Y*Cnt-3,
                ZPnt.X+(i+1)*Sct.X+3,ZPnt.Y-Sct.Y*Cnt+3);
            str:=inttostr(cnt);
            TextOut(ZPnt.X+(i+1)*Sct.X-round(TextWidth(str)/2),
                ZPnt.Y-Sct.Y*Cnt-round(TextHeight(str)*1.5),str);
            MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
            end else
              MoveTo(ZPnt.X+(i+1)*Sct.X,ZPnt.Y-Sct.Y*Cnt);
          t1:=t2;
        end;
    end;
  end;
end;

procedure TMDIChild.DrawTableHeader(var PB : TPaintBox; var Table : TMyTable);
var
  i,j     : integer;
  str     : string;
  t1,t2   : TTime;
begin
  //Настройка ширины столбцов
  Table.LineWidth:=1;
  Table.ColCount:=14;
  Table.ColWidths[0]:=round(PB.ClientWidth/20*5);
  for I := 1 to 13 do Table.ColWidths[i]:=round(PB.ClientWidth/20);
  //Количество и высота строк
  Table.RowCount:=2;
  for I := 0 to Table.RowCount-1 do Table.RowHeights[i]:=20;
  //Формирование заголовка
  Table.HeadRow:=2;
  Table.AddRng(0,0,0,1);
  Table.AddRng(1,0,1,1);
  Table.AddRng(2,0,13,0);
  Table.Cells[0,0]:='Модель';
  Table.Cells[1,0]:='Всего';
  Table.Cells[2,0]:='По часам';
  t1:=StTm;
  for I := 2 to 13 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh',t1)+'-'+FormatDateTime('hh',t2);
      Table.Cells[i,1]:=str;
      t1:=t2;
    end;
  //Установка выравнивания в ячейках
  for I := 0 to Table.ColCount - 1 do
    for j := 0 to Table.RowCount - 1 do
      Table.Flags[i,j]:=DT_CENTER or DT_SINGLELINE or DT_VCENTER;
end;

procedure TMDIChild.DrawServTable(var PB : TPaintBox);
var
  i,j,cnt : integer;
  t1,t2   : TTime;
begin
  self.DrawTableHeader(pb,servtable);
  //Количество и высота строк
  ServTable.RowCount:=ServTable.RowCount+Log.ModelList.Count;
  for I := 0 to ServTable.RowCount-1 do ServTable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to ServTable.ColCount - 1 do
    for j := ServTable.HeadRow to ServTable.RowCount - 1 do
      ServTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  for j := 0 to Log.ModelList.Count - 1 do
    begin
      ServTable.Cells[0,j+ServTable.HeadRow]:=Log.ModelList[j];
      ServTable.Cells[1,j+ServTable.HeadRow]:=IntToStr(log.CountBetween(log.FirstTime,log.LastTime,100,Log.ModelList[j]));
      t1:=StTm;
      for I := 2 to 13 do
        begin
          t2:=IncHour(t1);
          if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=Log.CountBetween(t1,t2,100,Log.ModelList[j]);
          if cnt>0 then ServTable.Cells[i,j+ServTable.HeadRow]:=inttostr(cnt) else ServTable.Cells[i,j+ServTable.HeadRow]:='';
          t1:=t2;
        end;
    end;
  //Отрисовка таблицы
  if pb.Height<>ServTable.Height then pb.Height:=ServTable.Height;
  ServTable.Left:=round((PB.ClientWidth-ServTable.Width)/2);
end;

procedure TMDIChild.DrawFaultTable(var PB : TPaintBox);
var
  i,j,cnt : integer;
  t1,t2   : TTime;
begin
  self.DrawTableHeader(PB,FaultTable);
  //Количество и высота строк
  FaultTable.RowCount:=Log.FaultList.Count+FaultTable.RowCount;
  for I := 0 to FaultTable.RowCount do FaultTable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to FaultTable.ColCount - 1 do
    for j := FaultTable.HeadRow to FaultTable.RowCount - 1 do
        FaultTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  for j := 0 to Log.FaultList.Count - 1 do
    begin
      FaultTable.Cells[0,j+FaultTable.HeadRow]:=Log.FaultTxt[strtoint(Log.FaultList[j])];
      FaultTable.Cells[1,j+FaultTable.HeadRow]:=IntToStr(log.CountBetween(log.FirstTime,log.LastTime,strtoint(Log.FaultList[j]),''));
      t1:=StTm;
      for I := 2 to 13 do
        begin
          t2:=IncHour(t1);
          if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=Log.CountBetween(t1,t2,strtoint(Log.FaultList[j]),'');
          if cnt>0 then FaultTable.Cells[i,j+2]:=inttostr(cnt) else FaultTable.Cells[i,j+2]:='';
          t1:=t2;
        end;
    end;
  //Отрисовка таблицы
  if pb.Height<>FaultTable.Height then pb.Height:=FaultTable.Height;
  FaultTable.Left:=round((PB.ClientWidth-FaultTable.Width)/2);
end;

procedure TMDIChild.DrawFltRezTable(var PB : TPaintBox);
var
  i,j,k,cnt : integer;
  t1,t2   : TTime;
begin
  self.DrawTableHeader(PB,FltRezTable);
  //Количество и высота строк
  FltRezTable.RowCount:=Log.ModelList.Count+FltRezTable.RowCount+1;
  for I := 0 to FltRezTable.RowCount do FltRezTable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to FltRezTable.ColCount - 1 do
    for j := FltRezTable.HeadRow to FltRezTable.RowCount - 1 do
        FltRezTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  for j := 0 to Log.ModelList.Count - 1 do
    begin
      FltRezTable.Cells[0,j+FltRezTable.HeadRow]:=Log.ModelList[j];
      cnt:=0;
      for I := 0 to Log.FaultList.Count - 1 do
        cnt:=cnt+log.CountBetween(StTm,FnTm,strtoint(log.FaultList[i]),log.ModelList[j]);
      FltRezTable.Cells[1,j+FltRezTable.HeadRow]:=IntToStr(cnt);
      t1:=StTm;
      for I := 2 to 13 do
        begin
          t2:=IncHour(t1);
          if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=0;
          for k := 0 to log.FaultList.Count - 1 do
            cnt:=cnt+Log.CountBetween(t1,t2,strtoint(log.FaultList[k]),log.ModelList[j]);
          if cnt>0 then FltRezTable.Cells[i,j+FltRezTable.HeadRow]:=inttostr(cnt) else FltRezTable.Cells[i,j+FltRezTable.HeadRow]:='';
          t1:=t2;
        end;
    end;
    FltRezTable.Cells[0,FltRezTable.RowCount-1]:='По всем моделям';
    cnt:=0;
    for I := 0 to Log.FaultList.Count - 1 do
      cnt:=cnt+log.CountBetween(StTm,FnTm,strtoint(log.FaultList[i]),'');
    FltRezTable.Cells[1,FltRezTable.RowCount-1]:=IntToStr(cnt);
    t1:=StTm;
    for I := 2 to 13 do
      begin
        t2:=IncHour(t1);
        if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
        if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
        cnt:=0;
        for k := 0 to log.FaultList.Count - 1 do
            cnt:=cnt+Log.CountBetween(t1,t2,strtoint(log.FaultList[k]),'');
        if cnt>0 then FltRezTable.Cells[i,FltRezTable.RowCount-1]:=inttostr(cnt)
          else FltRezTable.Cells[i,FltRezTable.RowCount-1]:='';
        t1:=t2;
      end;
  //Отрисовка таблицы
  if pb.Height<>FltRezTable.Height then pb.Height:=FltRezTable.Height;
  FltRezTable.Left:=round((PB.ClientWidth-FltRezTable.Width)/2);
end;

procedure TMDIChild.ServPBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  nm : string;
begin
  if button=mbRight then
    begin
      nm:=(sender as TControl).Name;
      if nm='ServPB' then CopyControl:=ServTable;
      if nm='FaultPB' then CopyControl:=FaultTable;
      if nm='FltRezPB' then CopyControl:=FltRezTable;
      if nm='GrapPB' then CopyControl:=GrapPB;
      if nm='AGrapPB' then CopyControl:=AGrapPB;
    end;
end;

procedure TMDIChild.ServPBMouseEnter(Sender: TObject);
begin
  screen.Cursor:=crHandPoint;
end;

procedure TMDIChild.ServPBMouseLeave(Sender: TObject);
begin
  screen.Cursor:=crDefault;
end;

procedure TMDIChild.ServPBPaint(Sender: TObject);
begin
  ServTable.Draw(ServPB.Canvas);
end;

procedure TMDIChild.FaultPBPaint(Sender: TObject);
begin
  FaultTable.Draw(FaultPB.Canvas);
end;

procedure TMDIChild.FltRezPBPaint(Sender: TObject);
begin
  FltRezTable.Draw(FltRezPB.Canvas);
end;

procedure TMDIChild.GrapPBPaint(Sender: TObject);
begin
  self.DrawGrap(GrapPB.Width,GrapPB.Height,GrapPB.Canvas);
end;

procedure TMDIChild.AGrapPBPaint(Sender: TObject);
begin
  self.DrawAGrap(AGrapPB.Width,AGrapPB.Height,AGrapPB.Canvas);
end;


end.
