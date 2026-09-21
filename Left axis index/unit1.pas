unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TATransformations, TASeries, TAChartAxis, typinfo,
  TAChartAxisUtils, TASources;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartAxisTransformations1AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartAxisTransformations2: TChartAxisTransformations;
    ChartAxisTransformations2AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartAxisTransformations3: TChartAxisTransformations;
    ChartAxisTransformations3AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Data1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListChartSource1: TListChartSource;
    ListChartSource2: TListChartSource;
    ListChartSource3: TListChartSource;
    Timer1: TTimer;
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ComputedSize:integer;
  axis:TChartAxis;
  t:Double;
begin
  t:=Now();
  Label9.Caption:=t.ToString;
  Label11.Caption:= DateTimeToStr(t);
  ComputedSize := Chart1.LeftAxis.MeasureLabelSize(Chart1.Drawer);
  Label1.Caption:='Label Size LeftAxis : '+ ComputedSize.ToString;
  ComputedSize := Chart1.AxisList[2].LabelSize;
  Label2.Caption:='Label Size AxisList[2] : '+ ComputedSize.ToString;
  ComputedSize := Chart1.ClipRect.Left;
  Label3.Caption:='Chart ClipRect Left : '+ ComputedSize.ToString;
  //ComputedSize := Chart1.LeftAxis.MeasureLabels(Chart1.Canvas).X
  //showmessage(IntToStr(ComputedSize));

  for axis in Chart1.AxisList do
  begin
    if axis.Index = 0 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label4.Caption:='Chart Axis['+axis.Index.ToString+'] '+GetEnumName(typeInfo(TChartAxisAlignment), Ord(axis.Alignment))+ ' LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 1 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label5.Caption:='Chart Axis['+axis.Index.ToString+'] '+GetEnumName(typeInfo(TChartAxisAlignment), Ord(axis.Alignment))+ ' LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 2 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label6.Caption:='Chart Axis['+axis.Index.ToString+'] '+GetEnumName(typeInfo(TChartAxisAlignment), Ord(axis.Alignment))+ ' LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 3 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label7.Caption:='Chart Axis['+axis.Index.ToString+'] '+GetEnumName(typeInfo(TChartAxisAlignment), Ord(axis.Alignment))+ ' LabelSize : '+ ComputedSize.ToString;
    end;
  end;
  Label10.Caption:='MarginsExternal Left: ' + Chart1.MarginsExternal.Left.ToString;
end;

procedure TForm1.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Source is  Tlabel then
  showmessage(Tlabel(Source).Name);
end;

procedure TForm1.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=true;
end;

procedure TForm1.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i:integer;
  axis:TChartAxis;
  Axis_Width:integer;
  Index_:integer;
begin
  Index_:=-1;
  i:=Chart1.MarginsExternal.Left;
  for axis in Chart1.AxisList do
  begin
    if axis.Alignment =TChartAxisAlignment.calLeft then
    begin
      Axis_Width:=axis.MeasureLabelSize(Chart1.Drawer);
      if (X>i) and (X<=i+Axis_Width) then
      begin
        Index_:=axis.Index;
      end;
      i:=i+Axis_Width;
    end;
  end;
  Label8.Caption:='Left axis index: ' +Index_.ToString;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  t:Double;
begin
  t:=Now()-(0.000005*240);
  for i:=0 to 240 do
  begin
    t:=t+0.000005;
    ListChartSource1.Add(t,0,'');
    ListChartSource2.Add(t,0,'');
    ListChartSource3.Add(t,-50,'');
  end;
end;

end.

