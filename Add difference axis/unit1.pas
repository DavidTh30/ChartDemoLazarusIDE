unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TATransformations, TASeries, TAChartAxis, typinfo, TAChartAxisUtils,
  TASources, TATypes, TAIntervalSources, TATools, TAChartLiveView, TAChartUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListChartSource1: TListChartSource;
    ListChartSource2: TListChartSource;
    ListChartSource3: TListChartSource;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    procedure InitChart();
    procedure ClearChart();
  end;

var
  Form1: TForm1;
  Data2_range:TChartRange;
  Data3_range:TChartRange;
  NewExtent: TDoubleRect;
  DefaultExtent: TDoubleRect;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.InitChart();
var
  i:integer;
  ChartSeries_:TBasicChartSeries;
  axis:TChartAxis;
  Again:boolean;
  AxisTransform_:TAxisTransform;
  SkipFreeObject:boolean;
begin

  SkipFreeObject:=false;
  for axis in Chart1.AxisList do
  begin
    if Pos(UpCase('Data'),UpCase(axis.Title.Caption))>0 then
    begin
      SkipFreeObject:=true;
      break;
    end;
  end;

  if SkipFreeObject then exit;

  while Chart1.Series.Count > 0 do
  for ChartSeries_ in Chart1.Series do
  begin
    //showmessage(ChartSeries_.Name);
    ChartSeries_.Free;
  end;
  //freeandnil(Chart1LineSeries1);
  //freeandnil(Chart1LineSeries2);
  //freeandnil(Chart1LineSeries3);

  while Chart1.AxisList.Count > 0 do
  for axis in Chart1.AxisList do
  begin
    axis.Free;
  end;

  Again:=true;
  while Again do
  begin
    Again:=false;
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TChartAxisTransformations then
      begin
        Again:=true;
        for AxisTransform_ in TChartAxisTransformations(Components[i]).List do
        begin
          AxisTransform_.Free;
        end;
        Components[i].Free;
        break;
      end;
    end;

  end;

end;

procedure TForm1.ClearChart();
var
  i:integer;
  ChartSeries_:TBasicChartSeries;
  axis:TChartAxis;
  Again:boolean;
  AxisTransform_:TAxisTransform;
begin

  while Chart1.Series.Count > 0 do
  for ChartSeries_ in Chart1.Series do
  begin
    //showmessage(ChartSeries_.Name);
    ChartSeries_.Free;
  end;
  //freeandnil(Chart1LineSeries1);
  //freeandnil(Chart1LineSeries2);
  //freeandnil(Chart1LineSeries3);

  while Chart1.AxisList.Count > 0 do
  for axis in Chart1.AxisList do
  begin
    axis.Free;
  end;

  Again:=true;
  while Again do
  begin
    Again:=false;
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TChartAxisTransformations then
      begin
        Again:=true;
        for AxisTransform_ in TChartAxisTransformations(Components[i]).List do
        begin
          AxisTransform_.Free;
        end;
        Components[i].Free;
        break;
      end;
    end;

  end;

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

  DefaultExtent.a.X:=-1;
  DefaultExtent.b.X:=1;
  DefaultExtent.a.Y:=-1;
  DefaultExtent.b.Y:=1;

  NewExtent := Chart1.LogicalExtent;
end;

procedure TForm1.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin

end;

procedure TForm1.FormDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Label1.Caption:= 'a.X : '+Chart1.LogicalExtent.a.X.ToString;
  Label2.Caption:= 'b.X : '+Chart1.LogicalExtent.b.X.ToString;
  Label3.Caption:= 'a.Y : '+Chart1.LogicalExtent.a.Y.ToString;
  Label4.Caption:= 'b.Y : '+Chart1.LogicalExtent.b.Y.ToString;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ClearChart();
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  ChartSeries_:TBasicChartSeries;
  axis:TChartAxis;
  Again:boolean;
  AxisTransform_:TAxisTransform;
begin

  while Chart1.Series.Count > 0 do
  for ChartSeries_ in Chart1.Series do
  begin
    //showmessage(ChartSeries_.Name);
    ChartSeries_.Free;
  end;

  Again:=true;
  while Again do
  begin
    Again:=false;
    for axis in Chart1.AxisList do
    begin
      if (axis.Index <> 0) and (axis.Alignment<>calBottom) then
      begin
        Again:=true;
        axis.Free;
      end;
    end;
  end;

  Again:=true;
  while Again do
  begin
    Again:=false;
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TChartAxisTransformations then
      begin
        Again:=true;
        for AxisTransform_ in TChartAxisTransformations(Components[i]).List do
        begin
          AxisTransform_.Free;
        end;
        Components[i].Free;
        break;
      end;
    end;
  end;

  Chart1.LogicalExtent:=DefaultExtent;

  Chart1.LeftAxis.Range.Max:=1;
  Chart1.LeftAxis.Range.Min:=0;
  Chart1.LeftAxis.Range.UseMax:=true;
  Chart1.LeftAxis.Range.UseMin:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  NewExtent := Chart1.LogicalExtent;
  //NewExtent.a.X := NewExtent.b.X - 0.0005;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Chart1.LogicalExtent:=NewExtent;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  axis:TChartAxis;
  LineSeries: TLineSeries;
  ChartAxisTransformations:TChartAxisTransformations;
  AutoScaleAxisTransForm:TAutoScaleAxisTransForm;
begin
  for axis in Chart1.AxisList do
  begin
    axis.Grid.Visible:=false;
    axis.Title.Visible:=false;
  end;

  Chart1.LeftAxis.Range.Max:=1;
  Chart1.LeftAxis.Range.Min:=0;
  Chart1.LeftAxis.Range.UseMax:=true;
  Chart1.LeftAxis.Range.UseMin:=true;

  if Chart1.Series.Count <= 0 then
  begin
    LineSeries:= TLineSeries.Create(Chart1);
    Chart1.AddSeries(LineSeries);
    //LineSeries.Source:=ListChartSource2;
    //axis.Range:=Data1_range;
    LineSeries.AxisIndexY:=Chart1.LeftAxis.Index;
    LineSeries.AxisIndexX:=Chart1.BottomAxis.Index;
    ChartAxisTransformations:=TChartAxisTransformations.Create(Form1);
    AutoScaleAxisTransForm:=TAutoScaleAxisTransForm.Create(ChartAxisTransformations);
    AutoScaleAxisTransForm.Transformations:=ChartAxisTransformations;
    AutoScaleAxisTransForm.MaxValue:=1;
    AutoScaleAxisTransForm.MinValue:=0;
    AutoScaleAxisTransForm.Enabled:=true;
    Chart1.LeftAxis.Transformations:=ChartAxisTransformations;
  end;

  axis:=Chart1.AxisList.Add;
  axis.Alignment:=TChartAxisAlignment.calLeft;
  axis.Grid.Visible:=false;
  axis.Marks.LabelBrush.Style:=bsClear;
  axis.Title.Caption:='Data1';
  axis.Title.Visible:=false;
  axis.Range.Min:=100;
  axis.Range.Max:=10000;
  axis.Range.UseMin:=true;
  axis.Range.UseMax:=true;

  LineSeries:= TLineSeries.Create(Chart1);
  Chart1.AddSeries(LineSeries);
  //LineSeries.Source:=ListChartSource2;
  //axis.Range:=Data1_range;
  LineSeries.AxisIndexY:=axis.Index;
  ChartAxisTransformations:=TChartAxisTransformations.Create(Form1);
  AutoScaleAxisTransForm:=TAutoScaleAxisTransForm.Create(ChartAxisTransformations);
  AutoScaleAxisTransForm.Transformations:=ChartAxisTransformations;
  AutoScaleAxisTransForm.MaxValue:=1;
  AutoScaleAxisTransForm.MinValue:=0;
  AutoScaleAxisTransForm.Enabled:=true;
  axis.Transformations:=ChartAxisTransformations;

  axis:=Chart1.AxisList.Add;
  axis.Alignment:=TChartAxisAlignment.calLeft;
  axis.Grid.Visible:=false;
  axis.Marks.LabelBrush.Style:=bsClear;
  axis.Title.Caption:='Data2';
  axis.Title.Visible:=false;
  axis.Range.Min:=-50;
  axis.Range.Max:=50;
  axis.Range.UseMin:=true;
  axis.Range.UseMax:=true;

  LineSeries:= TLineSeries.Create(Chart1);
  Chart1.AddSeries(LineSeries);
  //LineSeries.Source:=ListChartSource3;
  //axis.Range:=Data2_range;
  LineSeries.AxisIndexY:=axis.Index;
  ChartAxisTransformations:=TChartAxisTransformations.Create(Form1);
  AutoScaleAxisTransForm:=TAutoScaleAxisTransForm.Create(ChartAxisTransformations);
  AutoScaleAxisTransForm.Transformations:=ChartAxisTransformations;
  AutoScaleAxisTransForm.MaxValue:=1;
    AutoScaleAxisTransForm.MinValue:=0;
    AutoScaleAxisTransForm.Enabled:=true;
  axis.Transformations:=ChartAxisTransformations;

  //showmessage(Chart1.Series.Count.ToString);
end;

end.

