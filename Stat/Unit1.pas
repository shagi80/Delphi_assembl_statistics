unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    WSSB: TScrollBox;
    PagePn: TPanel;
    PageWS: TPanel;
    Label1: TLabel;
    FaultSG: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    pb: TImage;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WriteServSG;
    procedure WriteFaultSG;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses DateUtils, PageSet, LogDateClass, TableClass;

var
  Log       : TlogDate;
  StTm,FnTm : TTime;
  ServSG    : TMyTable;

procedure TForm1.WriteServSG;
var
  i,j,cnt : integer;
  str     : string;
  t1,t2   : TTime;
  modlst  : TStringList;
begin
  //
  ServSG.LineWidth:=1;
  ServSG.ColCount:=14;
  ServSG.ColWidths[0]:=round(screen.PixelsPerInch*0.7);
  j:=round((PB.ClientWidth-ServSG.ColWidths[0])/13);
  ServSG.ColWidths[0]:=pb.ClientWidth-j*13-servsg.LineWidth*2;
  j:=j-ServSG.LineWidth;
  for I := 1 to 13 do ServSG.ColWidths[i]:=j;

  modlst:=TstringList.Create;
  modlst:=log.ModelList;
  //
  ServSG.RowCount:=modlst.Count+1;
  for I := 0 to ServSG.RowCount do ServSG.RowHeights[i]:=20;
  pb.Height:=servsg.Height;
  ServSG.Cells[0,0]:='Модель';
  ServSG.Cells[1,0]:='Всего';
  t1:=StTm;
  for I := 2 to 13 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh',t1)+'-'+FormatDateTime('hh',t2);
      ServSG.Cells[i,0]:=str;
      t1:=t2;
    end;

  for j := 0 to modlst.Count - 1 do
    begin
      ServSG.Cells[0,j+1]:=modlst[j];
      ServSG.Cells[1,j+1]:=IntToStr(log.CountBetween(log.FirstTime,log.LastTime,100,modlst[j]));
      t1:=StTm;
      for I := 2 to 13 do
        begin
          t2:=IncHour(t1);
          if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=Log.CountBetween(t1,t2,100,modlst[j]);
          if cnt>0 then ServSG.Cells[i,j+1]:=inttostr(cnt) else ServSG.Cells[i,j+1]:='';
          t1:=t2;
        end;
    end;

  //
end;

procedure TForm1.FormResize(Sender: TObject);
var
  i,j : integer;
begin
  if PagePn.Width<WSSB.ClientWidth then
      PagePn.Left:=round((WSSB.ClientWidth-PagePn.Width)/2)
    else PagePn.Left:=10;
  if PagePn.Height<WSSB.ClientHeight then
      PagePn.Top:=round((WSSB.ClientHeight-PagePn.Height)/2)
    else PagePn.Top:=10;
end;

procedure TForm1.WriteFaultSG;
var
  i,j,cnt,sum : integer;
  str     : string;
  t1,t2   : TTime;
  fltlst  : TStringList;
begin
  //
  FaultSG.ColWidths[0]:=round(screen.PixelsPerInch*1.5);
  j:=round((FaultSG.ClientWidth-FaultSG.ColWidths[0])/13);
  FaultSG.ColWidths[0]:=FaultSG.ClientWidth-j*13;
  j:=j-FaultSG.GridLineWidth;
  for I := 1 to 13 do FaultSG.ColWidths[i]:=j;
  for i := 0 to FaultSG.RowCount - 1 do
    if i<2 then FaultSG.RowHeights[i]:=round(screen.PixelsPerInch*0.22)
      else FaultSG.RowHeights[i]:=round(screen.PixelsPerInch*0.4);


  fltlst:=TstringList.Create;
  fltlst:=log.FaultList;
  FaultSG.RowCount:=fltlst.Count+2;
  FaultSG.Cells[0,0]:='Вид брака';
  FaultSG.Cells[1,0]:='Всего';
  t1:=StTm;
  for I := 2 to 13 do
    begin
      t2:=IncHour(t1);
      str:=FormatDateTime('hh',t1)+'-'+FormatDateTime('hh',t2);
      FaultSG.Cells[i,0]:=str;
      t1:=t2;
    end;

  FaultSG.Cells[0,1]:='Все виды';
  sum:=0;
  for j := 0 to fltlst.Count - 1 do
     sum:=sum+log.CountBetween(log.FirstTime,log.LastTime,strtoint(fltlst[j]),'');
  FaultSG.Cells[1,1]:=inttostr(sum);

  t1:=StTm;
  for I := 2 to 13 do
    begin
      t2:=IncHour(t1);
      if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
      if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
      sum:=0;
      for j := 0 to fltlst.Count - 1 do
        sum:=sum+Log.CountBetween(t1,t2,strtoint(fltlst[j]),'');
      if sum>0 then FaultSG.Cells[i,1]:=inttostr(sum) else FaultSG.Cells[i,1]:='';
      t1:=t2;
    end;

  for j := 0 to fltlst.Count - 1 do
    begin
      FaultSG.Cells[0,j+2]:=fltlst[j];
      FaultSG.Cells[1,j+2]:=IntToStr(log.CountBetween(log.FirstTime,log.LastTime,strtoint(fltlst[j]),''));
      t1:=StTm;
      for I := 2 to 13 do
        begin
          t2:=IncHour(t1);
          if (i=2)and(CompareTime(t1,Log.FirstTime)=1) then t1:=Log.FirstTime;
          if (i=13)and(CompareTime(t2,Log.FirstTime)=-1) then t2:=Log.LastTime;
          cnt:=Log.CountBetween(t1,t2,strtoint(fltlst[j]),'');
          if cnt>0 then FaultSG.Cells[i,j+2]:=inttostr(cnt) else FaultSG.Cells[i,j+2]:='';
          t1:=t2;
        end;
    end;
  //
  j:=0;
  for I := 0 to FaultSG.RowCount - 1 do j:=j+FaultSG.RowHeights[i]+FaultSG.GridLineWidth;
  FaultSG.Height:=j+FaultSG.BevelWidth;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  StTm:=StrToTime('08:00:00');
  FnTm:=StrToTime('20:00:00');
  Log:=TlogDate.Create;
  Log.LoadFromTxt('260613.txt');
  //SetPageSize(0,true,PagePn);
  pagepn.Width:=round(screen.Width/5*4);
  SetBorder(0.5,0.5,0.5,0.5,PageWS);

  ServSG:=TMyTable.Create;
end;

end.
