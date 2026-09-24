unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls,
  TAGraph, TAChartAxis, TASeries, TAChartUtils, TATransformations;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart2: TChart;
    Chart2LineSeries1: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartAxisTransformations1LogarithmAxisTransform1: TLogarithmAxisTransform;
    ChartAxisTransformations2: TChartAxisTransformations;
    ChartAxisTransformations2LogarithmAxisTransform1: TLogarithmAxisTransform;
    Label1: TLabel;
    mnuLogarithmic: TMenuItem;
    mnuLinear: TMenuItem;
    mnuSeparator2: TMenuItem;
    mnuAutoScale: TMenuItem;
    mnuSetMax: TMenuItem;
    mnuSetMin: TMenuItem;
    mnuSeparator1: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure mnuAutoScaleClick(Sender: TObject);
    procedure mnuLinLogClick(Sender: TObject);
    procedure mnuSetMaxMinClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    function FindLogTransform(Axis: TChartAxis): TLogarithmAxisTransform;
    procedure LogAxis(Axis: TChartAxis; Enable: Boolean);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Math, TACustomSource;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
const
  N1 = 100;
  N2 = 150;
  MIN1 = -10;
  MAX1 = +10;
  MIN2 = 0;
  MAX2 = 100;
var
  i: Integer;
  x, y, y0: Double;
begin
  for i := 0 to N1-1 do
  begin
    x := MIN1 + (MAX1 - MIN1) * i / (N1-1);
    y0 := exp(-sqr(x/2))*150;
    repeat
      y := y0 + RandG(0.0, 0.2);
    until y > 0;
    Chart1LineSeries1.AddXY(x, y);
  end;

  for i := 0 to N2-1 do
  begin
    x := MIN2 + (MAX2 - MIN2) * i / (N2-1);
    y0 := exp(-x * 0.1) * 79.5;
    repeat
      y := y0 + RandG(0.0, 0.12);
    until y > 0;
    Chart2LineSeries1.AddXY(x, y);
  end;

  // VERY IMPORTANT FOR LOG AXIS:
  Chart1LineSeries1.AxisIndexY := 0;
  Chart2LineSeries1.AxisIndexY := 0;
end;

function TForm1.FindLogTransform(Axis: TChartAxis): TLogarithmAxisTransform;
var
  t: TAxisTransform;
begin
  for t in Axis.Transformations.List do
    if t is TLogarithmAxisTransform then
    begin
      Result := TLogarithmAxisTransform(t);
      exit;
    end;
  Result := nil;
end;

procedure TForm1.LogAxis(Axis: TChartAxis; Enable: Boolean);
var
  chart: TChart;
  wasLog: Boolean;
  t: TLogarithmAxisTransform;
  ymin, ymax: Double;
  ext: TDoubleRect;
  fullExt: TDoubleRect;
begin
  t := FindLogTransform(Axis);
  if t = nil then begin
    MessageDlg('No log transformation found.', mtError, [mbOK], 0);
    exit;
  end;

  wasLog := t.Enabled;
  if wasLog = Enable then  // No change --> nothing to do
    exit;

  chart := TChart(Axis.GetChart);
  ext := chart.LogicalExtent;
  if Enable and ((ext.a.y <= 0) or (ext.b.y <= 0)) then
  begin
    fullExt := chart.GetFullExtent;
    if ext.a.y <= 0 then ext.a.y := fullExt.a.y;
    if ext.b.y <= 0 then ext.b.y := fullExt.b.y;
  end;
  ymin := ext.a.y;
  ymax := ext.b.y;

  // Switch axis transformation to log or lin, depending in value of Enable.
  with Axis do
    if Enable then
    begin
      t.Enabled := true;
      Intervals.MaxLength := 80;
      Intervals.MinLength := 30;
      Intervals.Options := Intervals.Options + [aipGraphCoords];
      Intervals.Tolerance := 100;
    end else
    begin
      t.Enabled := false;
      Intervals.MaxLength := 50;
      Intervals.MinLength := 10;
      Intervals.Options := Intervals.Options - [aipGraphCoords];
      Intervals.Tolerance := 0;
    end;

  if Enable then begin
    // new axis is logarithmic --> we must convert current axis limit to log
    ext.a.y := Axis.GetTransform.AxisToGraph(ymin);
    ext.b.y := Axis.GetTransform.AxisToGraph(ymax);
  end else
  begin
    // new axis is linear --> convert axis limits from log to linear
    ext.a.y := Axis.GetTransform.GraphToAxis(ymin);
    ext.b.y := Axis.GetTransform.GraphToAxis(ymax);
  end;
  chart.LogicalExtent := ext;
end;

procedure TForm1.mnuAutoScaleClick(Sender: TObject);
var
  chart: TChart;
begin
  if not (Sender is TMenuItem) or not (PopupMenu1.PopupComponent is TChart) then
    exit;
  chart := TChart(PopupMenu1.PopupComponent);

  chart.ZoomFull;
end;

procedure TForm1.mnuLinLogClick(Sender: TObject);
var
  chart: TChart;
  transf: TChartAxisTransformations;
begin
  if not (Sender is TMenuItem) or not (PopupMenu1.PopupComponent is TChart) then
    exit;
  chart := TChart(PopupMenu1.PopupComponent);

  if chart = Chart1 then
    transf := ChartAxisTransformations1
  else
    transf := ChartAxisTransformations2;

  LogAxis(chart.LeftAxis, not FindLogTransform(chart.LeftAxis).Enabled);
end;

procedure TForm1.mnuSetMaxMinClick(Sender: TObject);
var
  chart: TChart;
  ext: TDoubleRect;
  fullExt: TDoubleRect;
  ymin, ymax: Double;
  s: String;
  isLog: boolean;
begin
  if not (Sender is TMenuItem) or not (PopupMenu1.PopupComponent is TChart) then
    exit;
  chart := TChart(PopupMenu1.PopupComponent);

  isLog := FindLogTransform(chart.LeftAxis).Enabled;

  ext := chart.LogicalExtent;
  if isLog and ((ext.a.y <= 0) or (ext.b.y <= 0)) then
  begin
    fullExt := chart.GetFullExtent;
    ext.a.y := fullExt.a.y;
    ext.b.y := fullExt.b.Y;
  end;

  if (Sender = mnuSetMax) then
  begin
    ymax := chart.LeftAxis.GetTransform.GraphToAxis(ext.b.y);  // in "axis" units
    s := FormatFloat('0.###', ymax);
    if InputQuery('Enter new y maximum', 'Maximum value:', s) then
      if TryStrToFloat(s, ymax) then
      begin
        ext.b.y := chart.LeftAxis.GetTransform.AxisToGraph(ymax);
        Chart.LogicalExtent := ext;
      end;
  end else
  if (Sender =mnuSetMin) then
  begin
    ymin := chart.LeftAxis.GetTransform.GraphToAxis(ext.a.y);  // in "axis" units
    s := FormatFloat('0.###', ymin);
    if InputQuery('Enter new y minimum', 'Minimum value:', s) then
      if TryStrToFloat(s, ymin) then
      begin
        ext.a.y := chart.LeftAxis.GetTransform.AxisToGraph(ymin);
        Chart.LogicalExtent := ext;
      end;
  end;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
var
  chart: TChart;
  fullext: TDoubleRect;
  currExt: TDoubleRect;
begin
  if not (Sender is TPopupMenu) or not (PopupMenu1.PopupComponent is TChart) then
    exit;
  chart := TChart(PopupMenu1.PopupComponent);
  Caption := 'PopupMenu of ' + chart.Name;
  fullExt := chart.GetFullExtent();
  currExt := chart.LogicalExtent;
  mnuAutoScale.Enabled := not (SameValue(fullExt.a.y, currExt.a.y, 1e-6) and SameValue(fullExt.b.y, currExt.b.y, 1e-6));
  mnuLogarithmic.Checked := FindLogTransForm(chart.LeftAxis).Enabled;
  mnuLinear.Checked := not mnuLogarithmic.Checked;
end;


end.

