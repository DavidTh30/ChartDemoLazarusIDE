unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  TAGraph, TATools, TATransformations, TASources, TASeries, TAIntervalSources,
  TAChartLiveView, DividerBevel, Types, TAChartUtils, TALegend, TADrawUtils,
  TATextElements, TAChartAxis, TAStyles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartLiveView1: TChartLiveView;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    Label1: TLabel;
    ListChartSource1: TListChartSource;
    ListChartSource2: TListChartSource;
    Memo1: TMemo;
    T1: TAutoScaleAxisTransform;
    ChartAxisTransformations2: TChartAxisTransformations;
    T2: TAutoScaleAxisTransform;
    ChartAxisTransformations3: TChartAxisTransformations;
    T3: TAutoScaleAxisTransform;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Chart1AfterDraw(ASender: TChart; ADrawer: IChartDrawer);
    procedure Chart1AfterPaint(ASender: TChart);
    procedure Chart1ChartAxisMarksGetShape(ASender: TChartTextElement;
      const ABoundingBox: TRect; var APolygon: TPointArray);
    procedure Chart1Click(Sender: TObject);
    procedure Chart1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Chart1ControlBorderSpacingChange(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart1DrawLegend(ASender: TChart; ADrawer: IChartDrawer;
      ALegendItems: TChartLegendItems; ALegendItemSize: TPoint;
      const ALegendRect: TRect; AColCount, ARowCount: Integer);
    procedure Chart1ExtentChanged(ASender: TChart);
    procedure Chart1ExtentChanging(ASender: TChart);
    procedure Chart1ExtentValidate(ASender: TChart;
      var ALogicalExtent: TDoubleRect; var AllowChange: Boolean);
    procedure Chart1FullExtentChanged(ASender: TChart);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartToolset1AxisClickTool1Click(ASender: TChartTool;
      Axis: TChartAxis; AHitInfo: TChartAxisHitTests);
    procedure ChartToolset1LegendClickTool1Click(ASender: TChartTool;
      ALegend: TChartLegend);
    procedure ChartToolset1PanClickTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1ZoomClickTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  NewExtent: TDoubleRect;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  //TAutoScaleAxisTransform(ChartAxisTransformations1.List[0]).MaxValue:=1+ScrollBar1.Position;
  //TAutoScaleAxisTransform(ChartAxisTransformations1.List[0]).MinValue:=0+ScrollBar1.Position;
  //Chart1.AxisList[0].Range.Max:=1+ScrollBar1.Position;
  //Chart1.AxisList[0].Range.Min:=0+ScrollBar1.Position;
  Chart1.AxisList[2].Range.Max:=100+ScrollBar1.Position+ScrollBar2.Position;
  Chart1.AxisList[2].Range.Min:=0-ScrollBar1.Position+ScrollBar2.Position;
  DividerBevel1.Caption:=ScrollBar1.Position.ToString + ' ' +
                         Chart1.AxisList[0].Range.Min.ToString+ ' ' +
                         Chart1.AxisList[0].Range.Max.ToString;
end;

procedure TForm1.Chart1Click(Sender: TObject);
begin
  Memo1.Append('Chart1Click');

  Chart1.AxisList[2].Range.Max:=100+ScrollBar1.Position+ScrollBar2.Position;
  Chart1.AxisList[2].Range.Min:=0-ScrollBar1.Position+ScrollBar2.Position;

  Chart1.AxisList[3].Range.Max:=200+ScrollBar3.Position;
  Chart1.AxisList[3].Range.Min:=50+ScrollBar3.Position;

  NewExtent := Chart1.LogicalExtent;

  if ChartLiveView1.Active then
  begin
    Chart1.Extent.XMax:=NewExtent.b.X;
    Chart1.Extent.Xmin:=NewExtent.a.X;
    Chart1.Extent.UseXMax:=true;
    Chart1.Extent.UseXMin:=true;
    Memo1.Append('copy');
  end
  else
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;

  ChartLiveView1.Active:=false;
  Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;

  if not ChartLiveView1.Active then
  begin
    Chart1.Extent.XMax:=NewExtent.b.X;
    Chart1.Extent.Xmin:=NewExtent.a.X;
    Chart1.Extent.UseXMax:=true;
    Chart1.Extent.UseXMin:=true;
    //NewExtent.a.X := NewExtent.b.X - 0.0005;
    Chart1.LogicalExtent := NewExtent;
    Memo1.Append('Fource')
  end;
  if ChartLiveView1.Active then
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;
end;

procedure TForm1.Chart1ChartAxisMarksGetShape(ASender: TChartTextElement;
  const ABoundingBox: TRect; var APolygon: TPointArray);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Append('a.X='+Chart1.CurrentExtent.a.X.ToString);
  Memo1.Append('b.X='+Chart1.CurrentExtent.b.X.ToString);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  NewExtent := Chart1.LogicalExtent;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  NewExtent.a.X := NewExtent.b.X - 0.0005;

  Chart1.LogicalExtent := NewExtent;
end;

procedure TForm1.Chart1AfterDraw(ASender: TChart; ADrawer: IChartDrawer);
begin
  //Memo1.Append('Chart1AfterDraw');
end;

procedure TForm1.Chart1AfterPaint(ASender: TChart);
begin
  //Memo1.Append('Chart1AfterPaint');
end;

procedure TForm1.Chart1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  Memo1.Append('Chart1ContextPopup');
  ChartLiveView1.Active:=false;
  Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;
end;

procedure TForm1.Chart1ControlBorderSpacingChange(Sender: TObject);
begin
  //Memo1.Append('Chart1ControlBorderSpacingChange');
end;

procedure TForm1.Chart1DblClick(Sender: TObject);
begin
  Memo1.Append('Chart1DblClick');
  ChartLiveView1.Active:=true;
  Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;
  if ChartLiveView1.Active then
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;
end;

procedure TForm1.Chart1DrawLegend(ASender: TChart; ADrawer: IChartDrawer;
  ALegendItems: TChartLegendItems; ALegendItemSize: TPoint;
  const ALegendRect: TRect; AColCount, ARowCount: Integer);
begin
 Memo1.Append('Chart1DrawLegend');
end;

procedure TForm1.Chart1ExtentChanged(ASender: TChart);
begin
  //Memo1.Append('Chart1ExtentChanged');
end;

procedure TForm1.Chart1ExtentChanging(ASender: TChart);
begin
  //Memo1.Append('Chart1ExtentChanging');
end;

procedure TForm1.Chart1ExtentValidate(ASender: TChart;
  var ALogicalExtent: TDoubleRect; var AllowChange: Boolean);
begin
  //Memo1.Append('Chart1ExtentValidate');
  Chart1.AxisList[2].Range.Max:=100+ScrollBar1.Position+ScrollBar2.Position;
  Chart1.AxisList[2].Range.Min:=0-ScrollBar1.Position+ScrollBar2.Position;

  Chart1.AxisList[3].Range.Max:=200+ScrollBar3.Position;
  Chart1.AxisList[3].Range.Min:=50+ScrollBar3.Position;

end;

procedure TForm1.Chart1FullExtentChanged(ASender: TChart);
begin
  //Memo1.Append('Chart1FullExtentChanged');
end;

procedure TForm1.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Memo1.Append('Chart1MouseUp');
end;

procedure TForm1.ChartToolset1AxisClickTool1Click(ASender: TChartTool;
  Axis: TChartAxis; AHitInfo: TChartAxisHitTests);
begin
   Memo1.Append('ChartToolset1AxisClickTool1Click');
end;

procedure TForm1.ChartToolset1LegendClickTool1Click(ASender: TChartTool;
  ALegend: TChartLegend);
begin
  Memo1.Append('ChartToolset1LegendClickTool1Click');
end;

procedure TForm1.ChartToolset1PanClickTool1AfterMouseUp(ATool: TChartTool;
  APoint: TPoint);
begin
  Memo1.Append('ChartToolset1PanClickTool1AfterMouseUp');
end;

procedure TForm1.ChartToolset1ZoomClickTool1AfterMouseUp(ATool: TChartTool;
  APoint: TPoint);
begin
  Memo1.Append('ChartToolset1ZoomClickTool1AfterMouseUp');
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  //TAutoScaleAxisTransform(ChartAxisTransformations2.List[0]).MaxValue:=1+ScrollBar2.Position;
  //TAutoScaleAxisTransform(ChartAxisTransformations2.List[0]).MinValue:=0+ScrollBar2.Position;
  Chart1.AxisList[2].Range.Max:=100+ScrollBar1.Position+ScrollBar2.Position;
  Chart1.AxisList[2].Range.Min:=0-ScrollBar1.Position+ScrollBar2.Position;
  DividerBevel2.Caption:=ScrollBar2.Position.ToString + ' ' +
                         Chart1.AxisList[2].Range.Min.ToString+ ' ' +
                         Chart1.AxisList[2].Range.Max.ToString;
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  //TAutoScaleAxisTransform(ChartAxisTransformations3.List[0]).MaxValue:=1+ScrollBar3.Position;
  //TAutoScaleAxisTransform(ChartAxisTransformations3.List[0]).MinValue:=0+ScrollBar3.Position;
  Chart1.AxisList[3].Range.Max:=200+ScrollBar3.Position;
  Chart1.AxisList[3].Range.Min:=50+ScrollBar3.Position;
  DividerBevel3.Caption:=ScrollBar3.Position.ToString + ' ' +
                         Chart1.AxisList[3].Range.Min.ToString+ ' ' +
                         Chart1.AxisList[3].Range.Max.ToString;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  t:double;
begin
  Randomize;
  t:=Now();
  //showmessage(t.ToString);
  ListChartSource1.Add(t,Random(21)+20,FormatDateTime('hh:nn:ss dd/mm/yyyy', Now()));
  ListChartSource2.Add(t,Random(21)+150,FormatDateTime('hh:nn:ss dd/mm/yyyy', Now()));
  //RandomChartSource1.PointsNumber:=RandomChartSource1.PointsNumber+1;
  //RandomChartSource1.XMax:=RandomChartSource1.XMax+1;
  //RandomChartSource2.PointsNumber:=RandomChartSource2.PointsNumber+1;
  //RandomChartSource2.XMax:=RandomChartSource2.XMax+1;
end;

end.

