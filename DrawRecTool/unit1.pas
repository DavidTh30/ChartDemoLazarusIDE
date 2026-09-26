unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  TAGraph, TASeries, TATools, TAChartUtils, TAChartListbox, Types, TALegend,
  TACustomSeries, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries2: TLineSeries;
    ChartListbox1: TChartListbox;
    ChartToolset1: TChartToolset;
    BarDragTool: TDataPointDragTool;
    DrawRectTool: TUserDefinedTool;
    CheckBox1: TCheckBox;
    LeftLine: TConstantLine;
    RightLine: TConstantLine;
    TopLine: TConstantLine;
    BottomLine: TConstantLine;
    Chart1LineSeries1: TLineSeries;
    ValueListEditor1: TValueListEditor;
    procedure BarDragToolDrag(ASender: TDataPointDragTool;
      var AGraphPoint: TDoublePoint);
    procedure BarDragToolDragStart(ASender: TDataPointDragTool;
      var AGraphPoint: TDoublePoint);
    procedure Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
    procedure ChartListbox1AddSeries(ASender: TChartListbox;
      ASeries: TCustomChartSeries; AItems: TChartLegendItems; var ASkip: Boolean);
    procedure ChartListbox1ItemClick(ASender: TObject; AIndex: Integer);
    procedure CheckBox1Change(Sender: TObject);
    procedure DrawRectToolAfterMouseDown(ATool: TChartTool; APoint: TPoint);
    procedure DrawRectToolAfterMouseMove(ATool: TChartTool; APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure ValueListEditor1PrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
  private
    procedure CalcStats;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  Math, TAGeometry;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
const
  N1 = 500;
  N2 = 400;
var
  i: Integer;
  x, y: Double;
begin
  ValueListEditor1.Clear;

  for i := 0 to N1-1 do begin
    x := RandG(56.1, 9.5);
    y := RandG(102.32, 15.3);
    Chart1LineSeries1.AddXY(x, y);
  end;

  for i := 0 to N2-1 do begin
    x := RandG(96.3, 12.56);
    y := RandG(68.43, 8.12);
    Chart1LineSeries2.AddXY(x, y);
  end;

  TopLine.Position := Infinity;
  BottomLine.Position := -Infinity;
  LeftLine.Position := -Infinity;
  RightLine.Position := Infinity;
  // Make the bars' DatapointDragtool react only on the bars, not the data points
  BarDragTool.AffectedSeries := Format('%d;%d;%d;%d', [TopLine.Index, BottomLine.Index, LeftLine.Index, RightLine.Index]);
end;

procedure TForm1.ValueListEditor1PrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  ts:TTextStyle;
begin
  if aCol=1 then
  begin
    ts := ValuelistEditor1.Canvas.TextStyle;
    ts.Alignment := taRightJustify;
    ValuelistEditor1.Canvas.TextStyle := ts;
  end;
end;

procedure TForm1.CalcStats;
const
  FMT = '0.000';
var
  ser: TChartSeries;
  i, j: Integer;
  n: Integer;
  x, y, xS, xSS, yS, ySS, xMean, yMean, xStdDev, yStdDev: Double;
  x1, x2, y1, y2: Double;
begin
  ValueListEditor1.Clear;

  x1 := Min(LeftLine.Position, RightLine.Position);
  x2 := Max(LeftLine.Position, RightLine.Position);
  y1 := Min(TopLine.Position, BottomLine.Position);
  y2 := Max(TopLine.Position, BottomLine.Position);

  for j := 0 to ChartListbox1.SeriesCount-1 do
  begin
    if not ChartListbox1.Selected[j] then
      continue;

    ser := ChartListbox1.Series[j] as TChartSeries;
    ValueListEditor1.InsertRow(ser.Title, '', true);

    xS := 0.0;
    yS := 0.0;
    xSS := 0.0;
    ySS := 0.0;
    n := 0;

    for i := 0 to ser.Count-1 do
    begin
      x := ser.XValue[i];
      y := ser.YValue[i];
      if x < x1 then Continue;
      if x > x2 then Continue;
      if y < y1 then Continue;
      if y > y2 then Continue;
      xS := xS + x;
      xSS := xSS + x*x;
      yS := yS + y;
      ySS := ySS + y*y;
      inc(n);
    end;
    if n = 0 then
    begin
      ValueListEditor1.InsertRow('    Count', IntToStr(n), true);
      ValueListEditor1.InsertRow('    Mean x', '(no data)', true);
      valueListEditor1.InsertRow('    Mean y', '(no data)', true);
      Continue;
    end;
    xMean := xS / n;
    yMean := yS / n;
    if n = 1 then
    begin
      valueListEditor1.InsertRow('    Count', IntToStr(n), true);
      ValueListEditor1.InsertRow('    Mean x', FormatFloat(FMT, xMean), true);
      valueListEditor1.InsertRow('    Mean y', FormatFloat(FMT, yMean), true);
    end else
    begin
      xStdDev := sqrt((xSS - xMean*xMean*n) / (n-1));
      yStdDev := sqrt((ySS - yMean*yMean*n) / (n-1));
      ValueListEditor1.InsertRow('    Count', IntToStr(n), true);
      ValueListEditor1.InsertRow('    Mean x', FormatFloat(FMT, xMean), true);
      ValueListEditor1.InsertRow('    StdDev x', Formatfloat(FMT, xStdDev), true);
      ValueListEditor1.InsertRow('    Mean y', FormatFloat(FMT, yMean), true);
      ValueListEditor1.InsertRow('    StdDev y', FormatFloat(FMT, yStdDev), true);
    end;
  end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
var
  ex: TDoubleRect;
  w, h: Double;
  c: TDoublePoint;
begin
  ex := Chart1.LogicalExtent;
  w := ex.b.x - ex.a.x;  // horizontal range of data
  h := ex.b.y - ex.a.y;  // vertical range of data
  c := DoublePoint((ex.a.x + ex.b.x)/2, (ex.a.y + ex.b.y)/2);  // center of data
  if TopLine.Position = Infinity then
    TopLine.Position := c.y + h/4;
  if bottomLine.Position = -Infinity then
    BottomLine.Position := c.y - h/4;
  if LeftLine.Position = -Infinity then
    LeftLine.Position := c.x - w/4;
  if RightLine.Position = Infinity then
    RightLine.Position := c.x + w/4;

  TopLine.Active := Checkbox1.Checked;
  BottomLine.Active := Checkbox1.Checked;
  LeftLine.Active := Checkbox1.Checked;
  RightLine.Active := Checkbox1.Checked;
  DrawRectTool.Enabled := Checkbox1.Checked;

  CalcStats;
end;

procedure TForm1.DrawRectToolAfterMouseDown(ATool: TChartTool; APoint: TPoint);
var
  P: TDoublePoint;
begin
  P := Chart1.ImageToGraph(APoint);
  LeftLine.Position := P.X;
  TopLine.Position := P.Y;
  RightLine.Position := P.X;
  BottomLine.Position := P.Y;
  CalcStats;
end;

procedure TForm1.DrawRectToolAfterMouseMove(ATool: TChartTool; APoint: TPoint);
var
  P: TDoublePoint;
begin
  P := Chart1.ImageToGraph(APoint);
  RightLine.Position := P.X;
  BottomLine.Position := P.Y;
  CalcStats;
end;

procedure TForm1.BarDragToolDrag(ASender: TDataPointDragTool;
  var AGraphPoint: TDoublePoint);
const
  MIN_SEPARATION_X = 1.0;
  MIN_SEPARATION_Y = 1.0;
begin
  if ASender.Series = TopLine then
  begin
    if AGraphPoint.Y > Bottomline.Position + MIN_SEPARATION_Y then
      TopLine.Position := AGraphPoint.Y
    else
      TopLine.Position := BottomLine.Position + MIN_SEPARATION_Y;
  end else
  if ASender.Series = BottomLine then
  begin
    if AGraphPoint.Y < Topline.Position - MIN_SEPARATION_Y then
      BottomLine.Position := AGraphPoint.Y
    else
      BottomLine.Position := TopLine.Position - MIN_SEPARATION_Y;
  end else
  if ASender.Series = LeftLine then
  begin
    if AGraphPoint.X < Rightline.Position - MIN_SEPARATION_X then
      LeftLine.Position := AGraphPoint.X
    else
      LeftLine.Position := RightLine.Position - MIN_SEPARATION_X;
  end else
  if ASender.Series = RightLine then
  begin
    if AGraphPoint.X > RightLine.Position + MIN_SEPARATION_X then
      RightLine.Position := AGraphPoint.X
    else
      RightLine.Position := LeftLine.Position + MIN_SEPARATION_X;
  end else
    exit;
  CalcStats;
end;

procedure TForm1.BarDragToolDragStart(ASender: TDataPointDragTool;
  var AGraphPoint: TDoublePoint);
begin
  if ASender.Series = TopLine then
    ASender.ActiveCursor := crSizeNS
  else
  if ASender.Series = BottomLine then
    ASender.ActiveCursor := crSizeNS
  else
  if ASender.Series = LeftLine then
    ASender.ActiveCursor := crSizeWE
  else
  if ASender.Series = RightLine then
    ASender.ActiveCursor := crSizeWE;
end;

procedure TForm1.Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect);
begin
  if LeftLine.Active then
  begin
    ACanvas.Brush.Color := RgbToColor(255, 240, 240);;
    ACanvas.FillRect(
      Chart1.XGraphToImage(LeftLine.Position),
      Chart1.YGraphToImage(TopLine.Position),
      Chart1.XGraphToImage(RightLine.Position),
      Chart1.YGraphToImage(BottomLine.Position)
    );
  end;
end;

procedure TForm1.ChartListbox1AddSeries(ASender: TChartListbox;
  ASeries: TCustomChartSeries; AItems: TChartLegendItems; var ASkip: Boolean);
begin
  ASkip := (ASeries = LeftLine) or (ASeries = RightLine) or
           (ASeries = TopLine) or (ASeries = BottomLine);
end;

procedure TForm1.ChartListbox1ItemClick(ASender: TObject; AIndex: Integer);
begin
  CalcStats;
end;

end.

