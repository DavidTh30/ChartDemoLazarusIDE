unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TATransformations, TASeries, TAChartAxis;

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
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Timer1: TTimer;
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
begin
  ComputedSize := Chart1.LeftAxis.MeasureLabelSize(Chart1.Drawer);
  Label1.Caption:='Label Size LeftAxis : '+ ComputedSize.ToString;
  ComputedSize := Chart1.AxisList[2].LabelSize;
  Label2.Caption:='Label Size AxisList[2] : '+ ComputedSize.ToString;
  ComputedSize := Chart1.ClipRect.Left;
  Label3.Caption:='Chart ClipRect : '+ ComputedSize.ToString;
  //ComputedSize := Chart1.LeftAxis.MeasureLabels(Chart1.Canvas).X
  //showmessage(IntToStr(ComputedSize));

  for axis in Chart1.AxisList do
  begin
    if axis.Index = 0 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label4.Caption:='Chart Axis['+axis.Index.ToString+'] LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 1 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label5.Caption:='Chart Axis['+axis.Index.ToString+'] LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 2 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label6.Caption:='Chart Axis['+axis.Index.ToString+'] LabelSize : '+ ComputedSize.ToString;
    end;
    if axis.Index = 3 then
    begin
      ComputedSize := axis.MeasureLabelSize(Chart1.Drawer);
      Label7.Caption:='Chart Axis['+axis.Index.ToString+'] LabelSize : '+ ComputedSize.ToString;
    end;
  end;
end;

end.

