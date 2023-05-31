unit CHILDWIN1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  LogDateClass, Dialogs, ExtCtrls, StdCtrls, DateUtils, TableClass, ComCtrls,
  Grids, Menus;


type
  TMDIChild1 = class(TForm)
    CapLb: TLabel;
    InfoLB: TLabel;
    PC: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    SB1: TScrollBox;
    KEPB: TPaintBox;
    GrapPB: TPaintBox;
    SB0: TScrollBox;
    Label3: TLabel;
    ServPB: TPaintBox;
    Label1: TLabel;
    FltRezPB: TPaintBox;
    SB2: TScrollBox;
    HTblPB: TPaintBox;
    HGrPB: TPaintBox;
    PM: TPopupMenu;
    CopyMI: TMenuItem;
    N1: TMenuItem;
    procedure ServPBMouseLeave(Sender: TObject);
    procedure ServPBMouseEnter(Sender: TObject);
    procedure PMPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ServPBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CopyMIClick(Sender: TObject);
    procedure HGrPBPaint(Sender: TObject);
    procedure HTblPBPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GrapPBPaint(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure FltRezPBPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ServPBPaint(Sender: TObject);
    procedure KEPBPaint(Sender: TObject);
    procedure DrawServTable(var PB : TPaintBox);
    procedure DrawKETable(var PB : TPaintBox);
    procedure DrawFltRezTable(var PB : TPaintBox);
    procedure DrawGrap  (w,h : integer; cnv : TCanvas);
    procedure DrawHrGrap(w,h : integer; cnv : TCanvas);
    procedure Init(ind : integer; var FlLst: TStringList);
    procedure DrawHourTable(var PB : TPaintBox);
    procedure CopyTableToClipboard(pic : boolean);
  private
    { Private declarations }
    ServTable   : TMyTable;
    KETable     : TMyTable;
    HourTable   : TMyTable;
    FltRezTable : TMyTable;
    Logs        : TLogDateLst;
    StTm,FnTm   : TTime;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses ClipBrd;

var
  CopyControl : TObject;

procedure TMDIChild1.CopyTableToClipboard( pic : boolean);
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
            if name='HGrPB' then self.DrawHrGrap(Width,height,img.Canvas);
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

procedure TMDIChild1.FormCreate(Sender: TObject);
begin
  Logs:=TlogDateLst.Create;
  ServTable:=TMyTable.Create;
  KETable:=TMyTable.Create;
  HourTable:=TMyTable.Create;
  FltRezTable:=TMyTable.Create;
end;

procedure TMDIChild1.Init(ind : integer; var FlLst: TStringList);
var
  str : string;
  i : integer;
  ep  : real;
begin
  StTm:=StrToTime('08:00:00');
  FnTm:=StrToTime('20:00:00');
  Logs.LoadFaultTxt(ExtractFilePath(application.ExeName)+FLtTxtFile);
  for i := 0 to FlLst.Count - 1 do
      Logs.Add(FlLst[i]);
  Logs.Sort;
  self.Caption:='Выборка '+IntToStr(ind);
  str:='';
  for I := 0 to Logs.Count - 1 do
    str:=str+DateToStr(logs.Items[i].Date)+', ';
  str[Length(str)-1]:='.';
  if Length(str)>500 then str:=copy(str,1,500)+' ...';
  str:='Выборка за даты: '+chr(13)+str+chr(13);
  str:=str+'Всего произведно '+
    inttostr(logs.TotalCount(100,''))+' ед';
  ep:=Logs.GetEP;
  if ep>0 then str:=str+chr(13)+'Средняя эфф-ть на чел: '+FormatFloat('###0.00',ep);
  InfoLB.Caption:=str;

  self.DrawServTable(ServPB);
  self.DrawFltRezTable(FltRezPB);
  self.DrawKETable(KEPB);
  self.DrawHourTable(HTblPB);
  GrapPB.Height:=round(screen.Height*0.5);
  HGrPB.Height:=round(screen.Height*0.5);

  PC.ActivePageIndex:=0;
  self.PCChange(self);
end;

procedure TMDIChild1.FormResize(Sender: TObject);
begin
  case PC.ActivePageIndex of
    0 : begin
          //ServTable.Left:=round((SB0.ClientWidth-ServTable.Width)/2);
          //FltRezTable.Left:=round((SB0.ClientWidth-FltRezTable.Width)/2);
        end;
    1 : begin
          KETable.Left:=round((SB1.ClientWidth-KETable.Width)/2);
        end;
    2 : begin
          HourTable.Left:=round((SB2.ClientWidth-HourTable.Width)/2);
        end;
  end;
end;

procedure TMDIChild1.PCChange(Sender: TObject);
begin
  self.FormResize(sender);
end;

procedure TMDIChild1.PMPopup(Sender: TObject);
begin
  if CopyControl is TPaintBox then CopyMI.Enabled:=false else CopyMI.Enabled:=true;  
end;

procedure TMDIChild1.DrawGrap(w,h : integer; cnv : TCanvas);
var
  i,j       : integer;
  str       : string;
  ZPnt      : TPoint;
  SctX,SctY : real;
  rct       : TRect;
begin
  with cnv do
  begin
  SctX:=round(w/(Logs.Count+2));
  ZPnt.X:=round(SctX/2);
  ZPnt.Y:=h-ABS(Font.Height)*2;
  SctY:=round((Zpnt.Y*2-h)/100);
  Pen.Color:=clBlack;
  Pen.Width:=2;
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X+round(SctX*(Logs.Count+1)),ZPnt.Y);
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(ZPnt.X,0);
  //
  Pen.Color:=clGray;
  Pen.Width:=1;
  for I := 0 to 9 do
    begin
      str:='0,'+inttostr(i);
      TextOut(ZPnt.X-TextWidth(str)-5,ZPnt.Y-round(i*sctY*10)-
        round(TextHeight(str)/2),str);
      MoveTo(ZPnt.X,ZPnt.Y-round(i*sctY*10));
      LineTo(ZPnt.X+round(SctX*Logs.Count+SctX/2),ZPnt.Y-round(i*sctY*10));
    end;
  //Вывод готовой продукции
  Pen.Color:=clBlack;
  Pen.Width:=1;
  for j := 0 to Logs.Count - 1 do
    begin
      rct.Bottom:=Zpnt.Y;
      rct.Left:=round(ZPnt.X+SctX*(j+1)-SctX/4);
      rct.Right:=rct.Left+round(SctX/2);
      str:=KETable.Cells[1,j+KETable.HeadRow];
      i:=strtoint(copy(str,pos(',',str)+1,maxInt));
      rct.Top:=round(ZPnt.Y-i*sctY);
      Brush.Color:=clMoneyGreen;
      Rectangle(rct);
      Brush.Color:=clWhite;
      TextOut(round(Zpnt.X+SctX*(j+1)-TextWidth(str)/2),round(ZPnt.Y-i*sctY-
        TextHeight(str)-2),str);
      str:=FormatDateTime('dd.mm',Logs.Items[j].Date);
      TextOut(round(Zpnt.X+SctX*(j+1)-TextWidth(str)/2),(Zpnt.Y+2),str);
    end;
  end;
end;

procedure TMDIChild1.DrawServTable(var PB : TPaintBox);
var
  i,j,cnt,sum         : integer;
  NSprem,NSPremToDay  : real;
  EmpPrem, hoursum, daysum, faultsum : real;

procedure DrawTableHeader(var Table : TMyTable);
var
  i,j     : integer;
  str     : string;

begin
  //Настройка ширины столбцов
  Table.LineWidth:=1;
  Table.ColCount:=Logs.Models.Count+8;
  for I := 0 to Table.ColCount-1 do
    Table.ColWidths[i]:=round(PB.Canvas.TextWidth('Ренова-30')*1.3);
  //Количество и высота строк
  Table.RowCount:=2;
  for I := 0 to Table.RowCount-1 do Table.RowHeights[i]:=20;
  //Формирование заголовка
  Table.HeadRow:=2;
  Table.AddRng(0,0,0,1);
  Table.AddRng(1,0,2,0);
  Table.AddRng(3,0,3,1);
  Table.AddRng(4,0,7,0);
  Table.AddRng(8,0,Table.ColCount-1,0);
  Table.Cells[0,0]:='Дата';
  Table.Cells[1,0]:='Всего';
  Table.Cells[1,1]:='ГП';
  Table.Cells[2,1]:='Брак';
  Table.Cells[4,0]:='Пермия сбрщик';
  Table.Cells[3,0]:='Премия НС';
  Table.Cells[4,1]:='Всего';
  Table.Cells[5,1]:='часы';
  Table.Cells[6,1]:='день';
  Table.Cells[7,1]:='кач-во';
  Table.Cells[8,0]:='По модельно';
  for I := 0 to Logs.Models.Count-1 do
    begin
      str:=Logs.Models[i];
      Table.Cells[8+i,1]:=str;
    end;
  //Установка выравнивания в ячейках
  for I := 0 to Table.ColCount - 1 do
    for j := 0 to Table.RowCount - 1 do
      Table.Flags[i,j]:=DT_CENTER or DT_SINGLELINE or DT_VCENTER;
end;

begin
  if Logs.Count=0 then abort;
  DrawTableHeader(servtable);
  //Количество и высота строк
  ServTable.RowCount:=ServTable.RowCount+Logs.Count+2;
  for I := 0 to ServTable.RowCount-1 do ServTable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to ServTable.ColCount - 1 do
    for j := ServTable.HeadRow to ServTable.RowCount - 1 do
      ServTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  NSprem:=0;
  EmpPrem:=0;
  hoursum:=0;
  daysum:=0;
  faultsum:=0;
  for j := 0 to Logs.Count - 1 do
    begin
      ServTable.Cells[0,j+ServTable.HeadRow]:=FormatDateTime('dd.mm.yy',Logs.Items[j].Date);
      cnt:=Logs.Items[j].CountBetween(Logs.items[j].FirstTime,Logs.items[j].LastTime,100,'');
      ServTable.Cells[1,j+ServTable.HeadRow]:=inttostr(cnt);
      sum:=Logs.Items[j].CountBetween(Logs.items[j].FirstTime,Logs.items[j].LastTime,-1,'');
      cnt:=sum-cnt;
      if cnt>0 then
        begin
          ServTable.Cells[2,j+ServTable.HeadRow]:=inttostr(cnt)+'/'+FormatFloat('##0.00',cnt/sum*100)+'%';
          //расчет преми нач смен 1000 - % брака х NSpremQ
          NSpremToDay:=cnt/sum*100;
          NSpremToDay:=NSPremBase/(FaultProcMax-FaultProcMin)*(FaultProcMax-NSpremToDay);
          if NSpremToDay<0 then NSpremToDay:=0;
          NsPrem:=NsPrem+NSpremToDay;
          //премия НС
          ServTable.Cells[3,j+ServTable.HeadRow]:=FormatFloat('##0.00',NSpremToDay);
          //премия сборщиков
          ServTable.Cells[4,j+ServTable.HeadRow]:=FormatFloat('##0.00',Logs.Items[j].Logs[0].totalbonus);
          ServTable.Cells[5,j+ServTable.HeadRow]:=FormatFloat('##0.00',Logs.Items[j].Logs[0].hourbonus);
          ServTable.Cells[6,j+ServTable.HeadRow]:=FormatFloat('##0.00',Logs.Items[j].Logs[0].daybonus);
          ServTable.Cells[7,j+ServTable.HeadRow]:=FormatFloat('##0.00',Logs.Items[j].Logs[0].faultbonus);
          EmpPrem:=EmpPrem+Logs.Items[j].Logs[0].totalbonus;
          hoursum:=hoursum+Logs.Items[j].Logs[0].hourbonus;
          daysum:=daysum+Logs.Items[j].Logs[0].daybonus;
          faultsum:=faultsum+Logs.Items[j].Logs[0].faultbonus;
        end  else ServTable.Cells[2,j+ServTable.HeadRow]:='';
      for I := 0 to Logs.Models.Count-1 do
        begin
          cnt:=Logs.Items[j].CountBetween(Logs.items[j].FirstTime,Logs.items[j].LastTime,100,Logs.Models[i]);
          if cnt>0 then ServTable.Cells[i+8,j+ServTable.HeadRow]:=inttostr(cnt) else ServTable.Cells[i+8,j+ServTable.HeadRow]:='';
        end;
    end;
  //вывод премии нач смен
  InfoLb.Caption:=InfoLB.Caption+chr(13)+'Премия нач смены: '+FormatFloat('##0.00',NSPrem);
  //Строка "Итого"
  ServTable.Cells[0,Logs.Count+ServTable.HeadRow]:='Итого:';
  //премия НС
  ServTable.Cells[3,Logs.Count+ServTable.HeadRow]:=FormatFloat('##0.00',NSPrem);
  //премия сборщиков
  ServTable.Cells[4,Logs.Count+ServTable.HeadRow]:=FormatFloat('##0.00',EmpPrem);
  ServTable.Cells[5,Logs.Count+ServTable.HeadRow]:=FormatFloat('##0.00',hoursum);
  ServTable.Cells[6,Logs.Count+ServTable.HeadRow]:=FormatFloat('##0.00',daysum);
  ServTable.Cells[7,Logs.Count+ServTable.HeadRow]:=FormatFloat('##0.00',faultsum);
  //кол-во
  cnt:=Logs.TotalCount(100,'');
  ServTable.Cells[1,Logs.Count+ServTable.HeadRow]:=inttostr(cnt);
  sum:=Logs.TotalCount(-1,'');
  cnt:=sum-cnt;
  if cnt>0 then
    ServTable.Cells[2,Logs.Count+ServTable.HeadRow]:=inttostr(cnt)+'/'+FormatFloat('##0.00',cnt/sum*100)+'%'
    else ServTable.Cells[2,Logs.Count+ServTable.HeadRow]:='';
  for I := 0 to Logs.Models.Count-1 do
    begin
      cnt:=Logs.TotalCount(100,Logs.Models[i]);
      if cnt>0 then ServTable.Cells[i+8,Logs.Count+ServTable.HeadRow]:=inttostr(cnt)
      else ServTable.Cells[i+8,Logs.Count+ServTable.HeadRow]:='';
    end;
  ServTable.AddRng(0,ServTable.RowCount-1,7,ServTable.RowCount-1);
  Servtable.Cells[0,ServTable.RowCount-1]:='% модели от общ кол-ва:';
  for I := 0 to Logs.Models.Count - 1 do
    begin
      cnt:=Logs.TotalCount(100,Logs.Models[i]);
      if cnt>0 then ServTable.Cells[i+8,ServTable.RowCount-1]:=FormatFloat('##0.00',
        cnt/Logs.TotalCount(100,'')*100)+'%'
      else ServTable.Cells[i+8,ServTable.RowCount-1]:='';
    end;
  //Установка размеров }
  if pb.Height<>ServTable.Height then pb.Height:=ServTable.Height;
  if pb.Width<ServTable.Width then pb.Width:=ServTable.Width;
  pb.Top:=Label3.Top+label3.Height+3;
  self.FormResize(self);
end;

procedure TMDIChild1.DrawKETable(var PB : TPaintBox);
var
  i,j,cnt: integer;
  ke,sum : real;
  colsum : array of real;
  colcnt : array of integer;

procedure DrawTableHeader(var Table : TMyTable);
var
  i,j     : integer;
  str     : string;
begin
  //Настройка ширины столбцов
  Table.LineWidth:=1;
  Table.ColCount:=Logs.Models.Count+2;
  for I := 0 to Table.ColCount-1 do Table.ColWidths[i]:=round(PB.Canvas.TextWidth('Ренова-30')*1.3);
  //Количество и высота строк
  Table.RowCount:=3;
  for I := 0 to Table.RowCount-1 do Table.RowHeights[i]:=20;
  //Формирование заголовка
  Table.HeadRow:=3;
  Table.AddRng(0,0,0,1);
  Table.AddRng(1,0,1,1);
  Table.AddRng(2,0,Table.ColCount-1,0);
  Table.AddRng(0,2,1,2);
  Table.Cells[0,0]:='Дата';
  Table.Cells[1,0]:='Всего';
  Table.Cells[2,0]:='По модельно';
  Table.Cells[0,2]:='Норма эффективности:';
  for I := 0 to Logs.Models.Count-1 do
    begin
      str:=inttostr(GetKeNorm(Logs.Models[i]));
      Table.Cells[2+i,2]:=str;
    end;
  for I := 0 to Logs.Models.Count-1 do
    begin
      str:=Logs.Models[i];
      Table.Cells[2+i,1]:=str;
    end;
  //Установка выравнивания в ячейках
  for I := 0 to Table.ColCount - 1 do
    for j := 0 to Table.RowCount - 1 do
      Table.Flags[i,j]:=DT_CENTER or DT_SINGLELINE or DT_VCENTER;
  Table.Flags[0,2]:=DT_LEFT or DT_SINGLELINE or DT_VCENTER;
end;

begin
  if Logs.Count=0 then abort;
  DrawTableHeader(KEtable);
  //Количество и высота строк
  KETable.RowCount:=KETable.RowCount+Logs.Count+1;
  for I := 0 to KETable.RowCount-1 do KETable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to KETable.ColCount - 1 do
    for j := KETable.HeadRow to KETable.RowCount - 1 do
      KETable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  SetLength(colsum,self.Logs.Models.Count+1);
  SetLength(colcnt,self.Logs.Models.Count+1);
  for j := 0 to Logs.Count - 1 do
    begin
      KETable.Cells[0,j+KETable.HeadRow]:=FormatDateTime('dd.mm.yy',Logs.Items[j].Date);
      sum:=0;
      for I := 0 to Logs.Models.Count-1 do
        begin
          cnt:=Logs.Items[j].CountBetween(Logs.items[j].FirstTime,Logs.items[j].LastTime,100,Logs.Models[i]);
          ke:=cnt/GetKENorm(Logs.Models[i]);
          sum:=sum+ke;
          colsum[i+1]:=colsum[i+1]+ke;
          if ke>0 then KETable.Cells[i+2,j+KETable.HeadRow]:=FormatFloat('0.00',ke) else KETable.Cells[i+2,j+KETable.HeadRow]:='';
          if Ke>0 then inc(colcnt[i+1]);
        end;
      colsum[0]:=colsum[0]+sum;
      KETable.Cells[1,j+KETable.HeadRow]:=FormatFloat('0.00',sum);
    end;
  //
  KETable.Cells[0,KETable.RowCount-1]:='Итого:';
  KETable.Cells[1,KETable.RowCount-1]:=FormatFloat('0.00',colsum[0]/Logs.Count);
  if (high(colsum)>=0)and(high(colcnt)>=0) then

  for I := 0 to Logs.Models.Count-1 do
    if (colcnt[i+1]>0) then KETable.Cells[i+2,KETable.RowCount-1]:=FormatFloat('0.00',colsum[i+1]/colcnt[i+1]);
  //Установка размеров }
  if pb.Height<>KETable.Height then pb.Height:=KETable.Height;
  self.FormResize(self);
end;

procedure TMDIChild1.DrawFltRezTable(var PB : TPaintBox);
var
  i,j,cnt : integer;

procedure DrawTableHeader(var Table : TMyTable);
var
  i,j     : integer;
  str     : string;
begin
  //Настройка ширины столбцов
  Table.LineWidth:=1;
  Table.ColCount:=Logs.Models.Count+2;
  for I := 1 to Table.ColCount-1 do Table.ColWidths[i]:=round(PB.Canvas.TextWidth('Ренова-30')*1.3);
  Table.ColWidths[0]:=Table.ColWidths[1]*2;
  //Количество и высота строк
  Table.RowCount:=2;
  for I := 0 to Table.RowCount-1 do Table.RowHeights[i]:=20;
  //Формирование заголовка
  Table.HeadRow:=2;
  Table.AddRng(0,0,0,1);
  Table.AddRng(1,0,1,1);
  Table.AddRng(2,0,Table.ColCount-1,0);
  Table.Cells[0,0]:='Вид брака';
  Table.Cells[1,0]:='Всего';
  Table.Cells[2,0]:='По модельно';
  for I := 0 to Logs.Models.Count-1 do
    begin
      str:=Logs.Models[i];
      Table.Cells[2+i,1]:=str;
    end;
  //Установка выравнивания в ячейках
  for I := 0 to Table.ColCount - 1 do
    for j := 0 to Table.RowCount - 1 do
      Table.Flags[i,j]:=DT_CENTER or DT_SINGLELINE or DT_VCENTER;
end;

begin
  DrawTableHeader(FltRezTable);
  //Количество и высота строк
  FltRezTable.RowCount:=FltRezTable.RowCount+Logs.FaultList.Count+2;
  for I := FltRezTable.HeadRow to FltRezTable.RowCount-3 do FltRezTable.RowHeights[i]:=
    round(PB.Canvas.TextHeight('Неисправность')*2.3);
  FltRezTable.RowHeights[FltRezTable.RowCount-2]:=round(PB.Canvas.TextHeight('Неисправность')*1.5);
  FltRezTable.RowHeights[FltRezTable.RowCount-1]:=round(PB.Canvas.TextHeight('Неисправность')*1.5);
  //Установка выравнивания в ячейках
  for j := FltRezTable.HeadRow to FltRezTable.RowCount - 1 do
        FltRezTable.Flags[0,j]:=DT_WORDBREAK;
  for I := 1 to FltRezTable.ColCount - 1 do
    for j := FltRezTable.HeadRow to FltRezTable.RowCount - 1 do
        FltRezTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  for j := 0 to Logs.FaultList.Count - 1 do
    begin
      FltRezTable.Cells[0,j+FltRezTable.HeadRow]:=Logs.FaultTxt[strtoint(Logs.FaultList[j])];
      cnt:=Logs.TotalCount(strtoint(Logs.FaultList[j]),'');
      FltRezTable.Cells[1,j+FltRezTable.HeadRow]:=IntToStr(cnt)+'/'+FormatFloat('##0.00',
        cnt/(Logs.TotalCount(-1,'')-Logs.TotalCount(100,''))*100)+'%';
      for I := 0 to Logs.Models.Count-1 do
        begin
          cnt:=Logs.TotalCount(strtoint(Logs.FaultList[j]),logs.Models[i]);
          if cnt>0 then FltRezTable.Cells[i+2,j+FltRezTable.HeadRow]:=inttostr(cnt) else FltRezTable.Cells[i+2,j+FltRezTable.HeadRow]:='';
        end;
    end;
  //
  FltRezTable.Cells[0,FltRezTable.RowCount-2]:='Итого:';
  FltRezTable.Cells[1,FltRezTable.RowCount-2]:=IntToStr(Logs.TotalCount(-1,'')-
    Logs.TotalCount(100,''));
  for I := 0 to Logs.Models.Count - 1 do
    begin
      cnt:=Logs.TotalCount(-1,logs.Models[i])-Logs.TotalCount(100,logs.Models[i]);
      if cnt>0 then FltRezTable.Cells[i+2,FltRezTable.RowCount-2]:=inttostr(cnt) else FltRezTable.Cells[i+2,FltRezTable.RowCount-2]:='';
    end;
  //
  FltRezTable.Cells[0,FltRezTable.RowCount-1]:='% от ГП:';
  if Logs.TotalCount(100,'')>0 then
    FltRezTable.Cells[1,FltRezTable.RowCount-1]:=FormatFloat('##0.00',(Logs.TotalCount(-1,'')-
      Logs.TotalCount(100,''))/Logs.TotalCount(100,'')*100)+'%'
    else FltRezTable.Cells[1,FltRezTable.RowCount-1]:='';
  for I := 0 to Logs.Models.Count - 1 do
    begin
      cnt:=Logs.TotalCount(-1,logs.Models[i])-Logs.TotalCount(100,logs.Models[i]);
      if (cnt>0)and(Logs.TotalCount(100,Logs.Models[i])>0) then FltRezTable.Cells[i+2,FltRezTable.RowCount-1]:=
        FormatFloat('##0.00',cnt/Logs.TotalCount(100,Logs.Models[i])*100)+'%'
      else FltRezTable.Cells[i+2,FltRezTable.RowCount-1]:='';
    end;
  //Установка размеров }
  if pb.Height<>FltRezTable.Height then pb.Height:=FltRezTable.Height;
  if pb.Width<FltRezTable.Width then pb.Width:=FltRezTable.Width;
  Label1.Top:=ServPB.Top+ServPb.Height+10;
  Label1.Width:=pb.Width;
  pb.Top:=Label1.Top+Label1.Height+3;
  self.FormResize(self);
end;

procedure TMDIChild1.DrawHourTable(var PB : TPaintBox);
var
  i,j,k,sum,cnt,x : integer;
  t1,t2   : TTime;
  fl      : boolean;

procedure DrawTableHeader(var Table : TMyTable);
var
  i,j     : integer;
  str     : string;
  t1,t2   : TTime;
begin
  //Настройка ширины столбцов
  Table.LineWidth:=1;
  Table.ColCount:=13;
  Table.ColWidths[0]:=round(PB.ClientWidth/20*5);
  for I := 1 to 13 do Table.ColWidths[i]:=round(PB.ClientWidth/20);
  //Количество и высота строк
  Table.RowCount:=2;
  for I := 0 to Table.RowCount-1 do Table.RowHeights[i]:=20;
  //Формирование заголовка
  Table.HeadRow:=2;
  Table.AddRng(0,0,0,1);
  Table.AddRng(1,0,12,0);
  Table.Cells[0,0]:='Модель';
  Table.Cells[1,0]:='По часам';
  t1:=StTm;
  for I := 0 to 11 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh',t1)+'-'+FormatDateTime('hh',t2);
      Table.Cells[i+1,1]:=str;
      t1:=t2;
    end;
  //Установка выравнивания в ячейках
  for I := 0 to Table.ColCount - 1 do
    for j := 0 to Table.RowCount - 1 do
      Table.Flags[i,j]:=DT_CENTER or DT_SINGLELINE or DT_VCENTER;
end;

begin
  DrawTableHeader(HourTable);
  //Количество и высота строк
  HourTable.RowCount:=HourTable.RowCount+Logs.Models.Count+1;
  for I := 0 to HourTable.RowCount-1 do HourTable.RowHeights[i]:=20;
  //Установка выравнивания в ячейках
  for I := 1 to HourTable.ColCount - 1 do
    for j := HourTable.HeadRow to HourTable.RowCount - 1 do
      HourTable.Flags[i,j]:=DT_CENTER;
  //Вывод информационной части
  for j := 0 to Logs.Models.Count - 1 do
    begin
      HourTable.Cells[0,j+HourTable.HeadRow]:=Logs.Models[j];
      t1:=StTm;
      for I := 0 to 11 do
        begin
          t2:=IncHour(t1);
          cnt:=0;
          sum:=0;
          for k := 0 to Logs.Count - 1 do
            begin
              if (i=0)and(CompareTime(t1,Logs.Items[k].FirstTime)=1) then t1:=Logs.Items[k].FirstTime;
              if (i=11)and(CompareTime(t2,Logs.Items[k].FirstTime)=-1) then t2:=Logs.Items[k].LastTime;
              x:=Logs.Items[k].CountBetween(t1,t2,100,Logs.Models[j]);
              sum:=sum+X;
              if X>0 then inc(cnt);
            end;
          if cnt>0 then cnt:=round(sum/cnt);
          if cnt>0 then HourTable.Cells[i+1,j+HourTable.HeadRow]:=inttostr(cnt) else HourTable.Cells[i+1,j+HourTable.HeadRow]:='';
          t1:=t2;
        end;
    end;
  HourTable.Cells[0,HourTable.RowCount-1]:='Итого:';
  for I := 0 to 11 do
    begin
    repeat
      sum:=0;
      cnt:=0;
      fl:=true;
      for j := 0 to Logs.Models.Count - 1 do
      if Length(HourTable.Cells[i+1,j+HourTable.HeadRow])>0 then
        begin
          x:=strtoint(HourTable.Cells[i+1,j+HourTable.HeadRow]);
          sum:=sum+x;
          inc(cnt);
        end;
      if cnt>0 then cnt:=round(sum/cnt);
      if cnt>0 then HourTable.Cells[i+1,HourTable.RowCount-1]:=inttostr(cnt) else HourTable.Cells[i+1,HourTable.RowCount-1]:='';
      j:=0;
      while(j<Logs.Models.Count)and(fl=true)do
        begin
          if Length(HourTable.Cells[i+1,j+HourTable.HeadRow])>0 then
            x:=strtoint(HourTable.Cells[i+1,j+HourTable.HeadRow]) else x:=0;
          if (x>0)and(round(x/cnt*100)<25) then
            begin
              HourTable.Cells[i+1,j+HourTable.HeadRow]:='';
              fl:=false;
            end;
          inc(j);
        end;
    until (fl=true) ;
    end;
  //Установка размеров }
  if pb.Height<>HourTable.Height then pb.Height:=HourTable.Height;
  self.FormResize(self);
end;

procedure TMDIChild1.ServPBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  nm : string;
begin
  if button=mbRight then
    begin
      nm:=(sender as TControl).Name;
      if nm='ServPB' then CopyControl:=ServTable;
      if nm='FltRezPB' then CopyControl:=FltRezTable;
      if nm='HTblPB' then CopyControl:=HourTable;
      if nm='KEPB' then CopyControl:=KETable;
      if nm='HGrPB' then CopyControl:=HGrPB;
      if nm='GrapPB' then CopyControl:=GrapPB;
    end;
end;

procedure TMDIChild1.ServPBMouseEnter(Sender: TObject);
begin
  screen.Cursor:=crHandPoint;
end;

procedure TMDIChild1.ServPBMouseLeave(Sender: TObject);
begin
    screen.Cursor:=crDefault;
end;

procedure TMDIChild1.ServPBPaint(Sender: TObject);
begin
  ServTable.Draw(ServPB.Canvas);
end;

procedure TMDIChild1.DrawHrGrap(w,h : integer; cnv : TCanvas);
var
  max,i,cnt     : integer;
  str       : string;
  t1,t2     : TTime;
  ZPnt      : TPoint;
  SctX,SctY : real;
begin
  with cnv do
  begin
  SctX:=round(w/14);
  ZPnt.X:=round(SctX/2);
  ZPnt.Y:=h-ABS(Font.Height)*2;
  Pen.Color:=clBlack;
  Pen.Width:=2;
  MoveTo(ZPnt.X,ZPnt.Y);
  LineTo(round(ZPnt.X+SctX*13),ZPnt.Y);
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
      MoveTo(round(ZPnt.X+(i+1)*SctX),ZPnt.Y-2);
      LineTo(round(ZPnt.X+(i+1)*SctX),0);
      TextOut(round(ZPnt.X+(i+1)*SctX)-round(TextWidth(str)/2),ZPnt.Y+5,str);
      if Length((HourTable.Cells[i+1,HourTable.RowCount-1]))>0 then
        cnt:=StrToInt(HourTable.Cells[i+1,HourTable.RowCount-1]) else cnt:=0;
      if cnt>Max then Max:=cnt;
      t1:=t2;
    end;
  if Max=0 then Abort;
  max:=((max div 10)+1)*10;
  SctY:=(Zpnt.Y*2-h)/Max;
  for I := 0 to (max div 10) do
    begin
      str:=inttostr(i*10);
      TextOut(ZPnt.X-TextWidth(str)-5,round(ZPnt.Y-(i*sctY*10))-
        round(TextHeight(str)/2),str);
      MoveTo(ZPnt.X,round(ZPnt.Y-i*sctY*10));
      LineTo(round(ZPnt.X+SctX*13),round(ZPnt.Y-i*sctY*10));
    end;
  //Вывод готовой продукции
  Pen.Width:=2;
  MoveTo(ZPnt.X,ZPnt.Y);
  for I := 0 to 11 do
    begin
      if Length(HourTable.Cells[i+1,HourTable.RowCount-1])>0 then
        cnt:=strtoint(HourTable.Cells[i+1,HourTable.RowCount-1]) else cnt:=0;
      if (cnt>0) then
        begin
          if (PenPos.Y=ZPnt.Y) then
            MoveTo(round(ZPnt.X+(i+1)*SctX),round(ZPnt.Y-SctY*Cnt))
          else
            LineTo(round(ZPnt.X+(i+1)*SctX),round(ZPnt.Y-SctY*Cnt));
          Ellipse(round(ZPnt.X+(i+1)*SctX-3),round(ZPnt.Y-SctY*Cnt-3),
            round(ZPnt.X+(i+1)*SctX+3),round(ZPnt.Y-SctY*Cnt+3));
          str:=inttostr(cnt);
          TextOut(round(ZPnt.X+(i+1)*SctX-TextWidth(str)/2),
            round(ZPnt.Y-SctY*Cnt-TextHeight(str)*1.5),str);
          MoveTo(round(ZPnt.X+(i+1)*SctX),round(ZPnt.Y-SctY*Cnt));
        end else
          MoveTo(round(ZPnt.X+(i+1)*SctX),round(ZPnt.Y-SctY*Cnt));
    end;
  end;
end;

procedure TMDIChild1.KEPBPaint(Sender: TObject);
begin
  KETable.Draw(KEPB.Canvas);
end;

procedure TMDIChild1.N1Click(Sender: TObject);
begin
  self.CopyTableToClipboard(true);
end;

procedure TMDIChild1.CopyMIClick(Sender: TObject);
begin
  self.CopyTableToClipboard(false);
end;

procedure TMDIChild1.FltRezPBPaint(Sender: TObject);
begin
  FltRezTable.Draw(FltRezPB.Canvas);
end;

procedure TMDIChild1.GrapPBPaint(Sender: TObject);
begin
  self.DrawGrap(GrapPB.ClientWidth,GrapPB.ClientHeight,GrapPB.Canvas);
end;

procedure TMDIChild1.HGrPBPaint(Sender: TObject);
begin
  self.DrawHrGrap(HGrPB.Width,HGrPB.Height,HGrPB.Canvas);
end;

procedure TMDIChild1.HTblPBPaint(Sender: TObject);
begin
  HourTable.Draw(HTblPB.Canvas);
end;


end.
