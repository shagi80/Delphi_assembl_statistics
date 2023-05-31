unit LogDateClass;

interface

uses Classes, Dialogs,sysutils,Controls, DateUtils;

const
  FltTxtFile='faulttxtmsg.txt';

type
  TLogRec = record
    time  : TTime;
    code  : integer;
    model : string[16];
    text  : string[255];
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
  end;

function GetKENorm(model : string):integer;

implementation


function GetKENorm(model : string):integer;
begin
  result:=550;
  if (model='Ренова-30')or(model='Славда-30') then result:=1100;
  if (model='Ренова-40')or(model='Славда-40') then result:=550;
  if (model='Ренова-45')or(model='Славда-45') then result:=550;
  if (model='Ренова-50')or(model='Славда-50') then result:=550;
  if (model='Ренова-60')or(model='Славда-60') then result:=495;
  if (model='Ренова-70')or(model='Славда-70') then result:=418;
end;

//------------------------------------------------------------------------------

constructor TLogDate.Create;
begin
  self.Fcnt:=0;
  SetLength(self.FRec,self.Fcnt);
  self.FFltLst:=TstringList.Create;
  self.FFltTxt:=TstringList.Create;
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
                  if i=0 then self.Fdate:=DateOf(strtodatetime(s2));
                  Rec.time:=TimeOf(strtodatetime(s2));
                end;
            1 : Rec.code:=strtoint(s2);
            2 : Rec.model:=s2;
            3 : Rec.text:=s2;
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


end.
