unit LogDateClass;

interface

uses Classes, Dialogs,sysutils,Controls, DateUtils;

const
  FltTxtFile ='faulttxtmsg.txt';
  DinStTime  ='12:00:00'; //начало обеда

type
  TLogRec = record
    time  : TTime;
    code  : integer;
    model : string[16];
    text  : string[255];
    empcnt: integer;
    totalbonus, hourbonus,
    daybonus, faultbonus : real;
  end;

  TlogRecLst = array of TlogRec;

  TLogDate = class
  private
    Fcnt  : integer;
    Fdate : TDate;
    FRec  : TlogRecLst;
    FFltLst : TstringList;
    FFltTxt : TstringList;
    function FstTime : TTime;
    function LstTime : TTime;
    function ModLst  : TStringList;
    procedure CreateFltLst;
  public
    constructor Create;
    function LoadFromTxt(fname : string): boolean;
    function LoadFaultTxt(fname : string): boolean;
    function CountBetween(tm1,tm2 : ttime; code : integer; mdl : string):integer;
    property FirstTime : TTime read FstTime;
    property LastTime  : TTime read LstTime;
    property ModelList : TStringList read ModLst;
    property FaultList : TStringList read FFltLst;
    property FaultTxt : TStringList read FFltTxt;
    property Count : integer read FCnt;
    property Logs : TlogRecLst read FRec;
    property Date : TDate read FDate;
    function GetFltInd(txt : string) : integer;
    function GetEP:real;
    function IndForDate(tm:string):integer;
    procedure DeleteRec(ind:integer);
    function GetFaultPorc:real;
    procedure SaveToTxt(fname:string);
  end;

  TLogDatearray = array of TlogDate;

  TLogDateLst = class
  private
    FCnt  : integer;
    FLogs : TLogDatearray;
    FMod  : TStringList;
    FFlts : TStringList;
    FFltTxt : TStringList;
  public
    constructor Create;
    property Items : TLogDateArray read FLogs write FLogs;
    property Count : integer read FCnt;
    property FaultList : TStringList read FFlts;
    property FaultTxt : TStringList read FFltTxt;
    procedure Add(fname : string);
    function CountBetween(tm1,tm2 : ttime; code : integer; mdl : string):integer;
    function TotalCount(code : integer; mdl : string):integer;
    function LoadFaultTxt(fname: string):boolean;
    procedure Sort;
    property Models : TStringList read Fmod;
    function GetEP:real;
  end;

function GetKENorm(model : string):integer;
var
  FaultProcMax,FaultProcMin  : real;      //диапзон процента брака
  NSpremBase                 : integer;   //базовая знач премии нач смены
  EmpPremBase                : integer;   //базовая сборщиков

implementation


function GetKENorm(model : string):integer;
begin
  result:=550;
  if (model='Ренова-30')or(model='Славда-30') then result:=1100;
  if (model='Ренова-35')or(model='Славда-35') then result:=1100;
  if (model='Ренова-40')or(model='Славда-40') then result:=550;
  if (model='Ренова-50')or(model='Славда-50') then result:=550;
  if (model='Ренова-60')or(model='Славда-60') then result:=550;
  if (model='Ренова-70')or(model='Славда-70') then result:=495;
  if (model='Ренова-80')or(model='Славда-80') then result:=418;
end;

constructor TLogDateLst.Create;
begin
  self.FCnt:=0;
  SetLength(self.FLogs,self.FCnt);
  self.FMod:=TStringList.Create;
  self.FFlts:=TStringList.Create;
  self.FFltTxt:=TStringList.Create;
end;

function TLogDateLst.GetEP:real;
var
  i,cnt : integer;
  res,oneres : real;
begin
  res:=0;
  cnt:=0;
  for I := 0 to self.FCnt - 1 do
    begin
      oneres:=self.Items[i].GetEP;
      res:=res+oneres;
      if oneres>0 then inc(cnt);
    end;
  if cnt>0 then res:=res/cnt;
  result:=res;
end;

procedure TLogDateLst.Sort;
var
  i,j : integer;
  buf : TLogDate;
  str : string;
begin
  //Date
  for j := 0 to self.FCnt - 2 do
    for i := 0 to self.FCnt-j-2 do
      if CompareDate(self.FLogs[i].Date,self.FLogs[i+1].Date)=1 then
        begin
          buf:=self.Flogs[i];
          self.FLogs[i]:=self.FLogs[i+1];
          self.FLogs[i+1]:=buf;
        end;
  //Flts
  for j := 0 to self.FFlts.Count - 2 do
    for i := 0 to self.FFlts.Count-j-2 do
      if (self.TotalCount(StrToInt(self.FFlts[i]),''))<(self.TotalCount(StrToInt(self.FFlts[i+1]),'')) then
        begin
          str:=self.FFlts[i];
          self.FFlts[i]:=self.FFlts[i+1];
          self.FFlts[i+1]:=str;
        end;
end;

procedure TLogDateLst.Add(fname : string);
var
  i,j  : integer;
  strs : TStringList;
  str  : string;
begin
  inc(self.FCnt);
  SetLength(self.FLogs,self.FCnt);
  self.FLogs[self.FCnt-1]:=TLogDate.Create;
  self.FLogs[self.FCnt-1].LoadFromTxt(fname);
  Strs:=TStringList.Create;
  strs:=self.FLogs[self.FCnt-1].ModLst;
  for I := 0 to strs.Count - 1 do
    begin
      j:=0;
      while (j<self.FMod.Count)and(strs[i]<>self.FMod[j]) do inc(j);
      if(j=self.FMod.Count)then self.FMod.Add(strs[i]);
    end;
  strs.Clear;
  strs:=self.FLogs[self.FCnt-1].FFltLst;
  for I := 0 to strs.Count - 1 do
    begin
      j:=0;
      while (j<self.FFlts.Count)and(strs[i]<>self.FFlts[j]) do inc(j);
      if(j=self.FFlts.Count)then
        begin
          self.FFlts.Add(strs[i]);
          for j:=self.FFltTxt.Count to StrToInt(strs[i]) do self.FFltTxt.Add('Неисправность №'+strs[i]);
        end;
    end;
end;

function TLogDateLst.LoadFaultTxt(fname: string):boolean;
var
  fstr : TFileStream;
begin
  result:=false;
  if fileexists(fname) then
    begin
      fstr:=TFileStream.Create(fname,fmOpenRead,fmShareDenyNone);
      self.FFltTxt.LoadFromStream(fstr);
      fstr.free;
      result:=true;
    end;
end;

function TLogDateLst.CountBetween(tm1,tm2 : ttime; code : integer; mdl : string):integer;
var
  i, sum : integer;
begin
  sum:=0;
  for I := 0 to self.FCnt - 1 do
    sum:=sum+self.FLogs[i].CountBetween(tm1,tm2,code,mdl);
  result:=sum;
end;

function TLogDateLst.TotalCount(code : integer; mdl : string):integer;
var
  i, sum : integer;
begin
  sum:=0;
  for I := 0 to self.FCnt - 1 do
    sum:=sum+self.FLogs[i].CountBetween(self.FLogs[i].FirstTime,self.FLogs[i].LastTime,code,mdl);
  result:=sum;
end;

//------------------------------------------------------------------------------

constructor TLogDate.Create;
begin
  self.Fcnt:=0;
  SetLength(self.FRec,self.Fcnt);
  self.FFltLst:=TstringList.Create;
  self.FFltTxt:=TstringList.Create;
end;

function TLogDate.GetEP:real;
var
  ep : real;
  i,timenorm  : integer;
begin
  //расчет эффективности на человека
  ep:=0;
  for I := 0 to self.Fcnt - 1 do
    begin
      //норма времени с учетом обеденного перерыва
      if TimeOf(self.Logs[i].time)<StrToTime(DinStTime) then timenorm:=SecondsBetween(self.LastTime,self.FirstTime)
        else timenorm:=SecondsBetween(self.LastTime,self.FirstTime)-3600;
      if (self.Logs[i].empcnt)>0 then ep:=ep+((self.CountBetween(self.FirstTime,self.LastTime,100,'')/
        timenorm)/(self.Logs[i].empcnt))*(3600*11);
    end;
  if self.CountBetween(self.FirstTime,self.LastTime,-1,'')>0 then ep:=ep/self.CountBetween(self.FirstTime,self.LastTime,-1,'');
  result:=ep;
end;

function TLogDate.LoadFromTxt(fname: string):boolean;
var
  strs  : TStringList;
  s1,s2 : string;
  i,j   : integer;
  Rec   : TLogRec;
  fstr  : TFileStream;
begin
  //
  self.Fcnt:=0;
  result:=false;
  strs:=TStringList.Create;
  try
  fstr:=TFileStream.Create(fname,fmOpenRead,fmShareDenyNone);
  strs.LoadFromStream(fstr);
  fstr.Free;
  s2:=ExtractFileName(fname);
  self.Fdate:=EncodeDate(strtoint('20'+copy(s2,5,2)),strtoint(copy(s2,3,2)),strtoint(copy(s2,1,2)));
  for I := 0 to strs.Count - 1 do
    begin
      s1:=strs[i];
      j:=0;
      Rec.model:='';
      Rec.text:='';
      while Length(s1)>0 do
        begin
          if(pos(chr(9),s1)>0)then s2:=copy(s1,1,pos(chr(9),s1)-1)
            else s2:=copy(s1,1,maxint);
          delete(s1,1,Length(s2)+1);
          case j of
            0 : begin
                  //if i=0 then self.Fdate:=DateOf(strtodatetime(s2));
                  Rec.time:=TimeOf(strtodatetime(s2));
                end;
            1 : Rec.code:=strtoint(s2);
            2 : Rec.model:=s2;
            3 : Rec.text:=s2;
            4 : Rec.empcnt:=strtoint(s2);
            5 : Rec.totalbonus:=strtofloat(s2);
            6 : Rec.hourbonus:=strtofloat(s2);
            7 : Rec.daybonus:=strtofloat(s2);
            8 : Rec.faultbonus:=strtofloat(s2);
          end;
          inc(j);
        end;
      if (rec.text='') then
        if(rec.code=100)then Rec.text:='Готовая продукция'
          else
            if (self.FFltTxt.Count>Rec.code) then Rec.text:=self.FFltTxt[rec.code]
              else
                begin
                  for j := self.FFltTxt.Count to rec.code do self.FFltTxt.Add('Неисправность №'+inttostr(j));
                  rec.text:='Неисправность №'+inttostr(Rec.code);
                end
        else
          begin
            if (self.FFltTxt.Count<=Rec.code) then
              for j := self.FFltTxt.Count to rec.code do self.FFltTxt.Add('Неисправность №'+inttostr(j));
            self.FFltTxt[rec.code]:=Rec.text;
          end;
      inc(self.Fcnt);
      SetLength(self.FRec,self.Fcnt);
      self.FRec[self.Fcnt-1]:=Rec;
    end;
  self.CreateFltLst;
  if self.Fcnt>0 then result:=true else result:=false;
  strs.Free;
  finally
    //
  end;
end;

function TLogDate.LoadFaultTxt(fname: string):boolean;
var
  fstr : TFileStream;
begin
  result:=false;
  if fileexists(fname) then
    begin
      fstr:=TFileStream.Create(fname,fmOpenRead,fmShareDenyNone);
      self.FFltTxt.LoadFromStream(fstr);
      fstr.free;
      result:=true;
    end;
end;

function TLogDate.GetFltInd(txt : string) : integer;
var
  i : integer;
begin
  result:=-1;
  i:=0;
  while(i<self.FFltTxt.Count)and(self.FFltTxt[i]<>txt)do inc(i);
  if (i<self.FFltTxt.Count)and(self.FFltTxt[i]=txt) then result:=i;
  if txt='Готовая продукция' then  result:=100;
end;

function TLogDate.CountBetween(tm1: TTime; tm2: TTime; code: Integer; mdl : string):integer;
var
  i,cnt : integer;
  Log   : TlogRec;
begin
  cnt:=0;
  for I := 0 to self.Fcnt - 1 do
    begin
      Log:=self.frec[i];
      if (CompareTime(TTime(Log.time),tm1)=1)or(CompareTime(TTime(Log.time),tm1)=0)then
        if (CompareTime(TTime(Log.time),tm2)=-1)or(CompareTime(TTime(Log.time),tm2)=0) then
          if (code=-1)or(log.code=code) then
             if (mdl='')or(log.model=mdl) then inc(cnt);
    end;
  result:=cnt;
end;

function TLogDate.FstTime:TTime;
begin
  if self.Fcnt>0 then result:=self.fRec[0].time
    else result:=strtotime('00:00:00');
end;

function TLogDate.LstTime:TTime;
begin
  if self.Fcnt>0 then result:=self.fRec[self.Fcnt-1].time
    else result:=strtotime('00:00:00');
end;

function TLogDate.ModLst:TStringList;
var
  strs : TStringList;
  i,j  : integer;
begin
  strs:=TStringList.Create;
  for I := 0 to self.Fcnt - 1 do
    begin
      j:=0;
      while (j<strs.Count)and(strs[j]<>self.frec[i].model) do inc(j);
      if(j=strs.Count)then strs.Add(self.frec[i].model);
    end;
  result:=strs;
end;

procedure TLogDate.CreateFltLst;
var
  strs : TStringList;
  i,j,x,y  : integer;
  str : string;
begin
  strs:=TStringList.Create;
  for I := 0 to self.Fcnt - 1 do
    if self.frec[i].code<100 then
      begin
        j:=0;
        while (j<strs.Count)and(strs[j]<>inttostr(self.frec[i].code)) do inc(j);
        if(j=strs.Count)then strs.Add(inttostr(self.frec[i].code));
      end;
  if strs.Count>0 then
    for j := 0 to strs.Count - 2 do
      begin
        x:=self.CountBetween(self.FstTime,self.LastTime,strtoint(strs[j]),'');
        for I := j+1 to strs.Count - 1 do
        begin
          y:=self.CountBetween(self.FstTime,self.LastTime,strtoint(strs[i]),'');
          if y>x then
            begin
              str:=strs[j];
              strs[j]:=strs[i];
              strs[i]:=str;
              x:=y;
            end;
        end;
      end;
  self.FFltLst:=strs;
end;

function TLogDate.IndForDate(tm:string):integer;
var
  i : integer;
begin
  I := 0;
  while(i<self.Fcnt)and(not (FormatDateTime('hh:mm:ss',self.FRec[i].time)=tm)) do inc(i);
  if(FormatDateTime('hh:mm:ss',self.FRec[i].time)=tm)then result:=i else result:=-1;
end;

procedure TLogDate.DeleteRec(ind: Integer);
var
  i  : integer;
begin
  for I := ind to self.Fcnt - 2 do
    self.FRec[i]:=self.fRec[i+1];
  SetLength(self.FRec,high(self.FRec));
  dec(self.Fcnt);
end;

function TLogDate.GetFaultPorc;
var
  ek : real;
  i  : integer;
begin
  if self.Fcnt>0 then begin
    ek:=0;
    for i := 0 to self.FFltLst.Count - 1 do ek:=ek+self.CountBetween(self.FirstTime,self.LastTime,strtoint(self.FFltLst[i]),'');
    ek:=100*ek/(self.CountBetween(self.FirstTime,self.LastTime,100,'')+ek);
    result:=ek;
  end else result:=0;
end;

procedure TlogDate.SaveToTxt(fname:string);
var
  strs  : TStringList;
  s1,s2 : string;
  i,j   : integer;
  Rec   : TLogRec;
  fstr  : TFileStream;
begin
  strs:=TStringList.Create;
  for I := 0 to self.Count - 1 do begin
    s1:=FormatDateTime('dd.mm.yyyy',self.Date)+' '+FormatDateTime('hh:mm:ss',self.FRec[i].time);
    s1:=s1+chr(9)+IntToStr(self.FRec[i].code)+chr(9)+self.FRec[i].model+chr(9)+self.FRec[i].text;
    s1:=s1+chr(9)+IntToStr(self.FRec[i].empcnt)+chr(9)+FloatToStr(self.FRec[i].totalbonus)
      +chr(9)+FloatToStr(self.FRec[i].hourbonus)+chr(9)+FloatToStr(self.FRec[i].daybonus)
      +chr(9)+FloatToStr(self.FRec[i].faultbonus);
    strs.Add(s1);
  end;
  strs.SaveToFile(fname);
  strs.Free;
end;

end.
