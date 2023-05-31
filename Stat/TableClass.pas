unit TableClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShelLAPI;

type

  TmyTable = class
  private
    FRCnt   : integer;
    FCCnt   : integer;
    FLWdth  : integer;
    FRngCnt : integer;
    FHRCnt  : integer;
    FLeft   : integer;
    FResRow : integer;
    FRngLst : array [0..255] of TRect;
    function TotWidth  : integer;
    function TotHeight : integer;
    function GetCRct(c: Integer; r: Integer;var rct: TRect):boolean;
  public
    Cells   : array [0..255,0..255] of string[255];
    ColWidths  : array [0..255] of integer;
    RowHeights : array [0..255] of integer;
    Flags : array [0..255,0..255] of Cardinal;
    constructor Create;
    property ColCount: integer read FCCnt write FCCnt;
    property RowCount: integer read FRCnt write FRCnt;
    property LineWidth  : integer read FLWdth write FLWdth;
    property Width  : integer read TotWidth;
    property Height : integer read TotHeight;
    property Left   : integer read FLeft write FLeft;
    property HeadRow: integer read FHRCnt write FHRCnt;
    procedure  AddRng(Left,Top,Right,Btm : integer);
    procedure Draw(Cnv : TCanvas);
  end;

implementation

constructor TMyTable.Create;
var
  i,j : integer;
begin
  self.FRCnt:=3;
  self.FCCnt:=5;
  self.FRngCnt:=0;
  self.FLWdth:=1;
  self.FHRCnt:=2;
  self.FLeft:=0;
  self.FResRow:=-1;
  for I := 0 to self.FRCnt - 1 do self.RowHeights[i]:=20;
  for I := 0 to self.FCCnt - 1 do self.ColWidths[i]:=60;
  for I := 0 to self.FCCnt - 1 do
    for j := 0 to self.FRCnt - 1 do
      self.Flags[i,j]:=DT_LEFT;
end;

procedure  TMyTable.AddRng(Left,Top,Right,Btm : integer);
begin
  inc(self.FRngCnt);
  self.FRngLst[self.FRngCnt-1].Left:=Left;
  self.FRngLst[self.FRngCnt-1].Top:=Top;
  self.FRngLst[self.FRngCnt-1].Right:=Right;
  self.FRngLst[self.FRngCnt-1].Bottom:=Btm;
end;

procedure TMyTable.Draw(Cnv: TCanvas);
var
  c,r : integer;
  rct : TRect;
  Fl  : cardinal;
  str : string;
begin
  //
  Cnv.Pen.Color:=clBlack;
  Cnv.Pen.Width:=self.FLWdth;
  for r := 0 to self.FRCnt - 1 do
    for c := 0 to self.FCCnt - 1 do
      if self.GetCRct(c,r,rct) then
        begin
          str:=self.Cells[c,r];
          if (self.FResRow>-1)and(self.FResRow<>r) then self.FResRow:=-1;  
          if str='Итого:' then self.FResRow:=r;
          Cnv.Rectangle(rct.Left-self.FLWdth,rct.Top-self.FLWdth,
            rct.Right+self.FLWdth,rct.Bottom+self.FLWdth);
          Fl := self.Flags[c,r];
          if (r<self.FHRCnt)or(r=self.FResRow) then cnv.Brush.Color:=clBtnFace else Cnv.Brush.Color:=clWhite;
          Cnv.FillRect(rct);
          inc(rct.Left,2);
          inc(rct.Top,2);
          dec(rct.Right,2);
          dec(rct.Bottom,2);
          DrawText(Cnv.Handle,PChar(str),Length(str),rct,fl);
        end;
end;

function TMyTable.GetCRct(c: Integer; r: Integer; var rct: TRect):boolean;
var
  i   : integer;
begin
  result:=true;
  rct.Left:=self.FLeft+self.FLWdth;
  for I := 0 to c-1 do rct.Left:=rct.Left+self.ColWidths[i]+self.FLWdth;
  rct.Top:=self.FLWdth;
  for I := 0 to r-1 do rct.Top:=rct.Top+self.RowHeights[i]+self.FLWdth;
  i:=0;
  while(i<self.FRngCnt)and(not ((c<=self.FRngLst[i].Right)and(c>=self.FRngLst[i].Left)
        and(r<=self.FRngLst[i].Bottom)and(r>=self.FRngLst[i].Top))) do inc(i);
  if i<self.FRngCnt then
    if (c=self.FRngLst[i].Left)and(r=self.FRngLst[i].Top) then
      begin
        c:=self.FRngLst[i].Right;
        r:=self.FRngLst[i].Bottom;
      end else result:=false;
  if result then
    begin
      rct.Right:=self.FLeft;
      for I := 0 to c do rct.Right:=rct.Right+self.ColWidths[i]+self.FLWdth;
      rct.Bottom:=0;
      for I := 0 to r do rct.Bottom:=rct.Bottom+self.RowHeights[i]+self.FLWdth;
    end;
end;

function TMyTable.TotWidth : integer;
var
  i,j : integer;
begin
  j:=0;
  for I := 0 to self.FCCnt - 1 do j:=j+self.ColWidths[i]+self.FLWdth;
  j:=j+self.FLWdth;
  result:=j;
end;

function TMyTable.TotHeight : integer;
var
  i,j : integer;
begin
  j:=0;
  for I := 0 to self.FRCnt - 1 do j:=j+self.RowHeights[i]+self.FLWdth;
  j:=j+self.FLWdth;
  result:=j;
end;


end.
