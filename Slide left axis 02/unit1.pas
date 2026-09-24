unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TATransformations, TASeries, TAChartAxis, typinfo, TAChartAxisUtils,
  TASources, TATypes, TAIntervalSources, TATools, TAChartLiveView,
  TAChartUtils, Types, TATextElements, TANavigation;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
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
    ChartLiveView1: TChartLiveView;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Data2: TLabel;
    Data3: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListChartSource1: TListChartSource;
    ListChartSource2: TListChartSource;
    ListChartSource3: TListChartSource;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
      AMark: Double);
    procedure Chart1Click(Sender: TObject);
    procedure Chart1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseLeave(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
  Data1_range:TChartRange;
  Data2_range:TChartRange;
  Data3_range:TChartRange;
  NewExtent: TDoubleRect;
  Bottom_range:TChartRange;
  DefaultExtent: TDoubleRect;
  LeftIndex_:integer;
  BottomIndex_:integer;
  MouseDown_:boolean;
  MouseDownLeftIndex:integer;
  MouseDownBottomIndex:integer;
  MouseDownY_Start:integer;
  MouseDownY_Current:integer;
  MouseDownX_Start:integer;
  MouseDownX_Current:integer;
  MouseDownRangeMin:Double;
  MouseDownRangeMax:Double;
  MouseDownSeries:integer;
  MouseDownSeriesStep:Double;

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
  //Chart1.ZoomFull(false);
  //Chart1.EnableAutoSizing:=false;
  //Chart1.ScalingValid:=false;
  //Chart1.AutoFocus:=false;
  //Chart1.AutoAdjustLayout(TLayoutAdjustmentPolicy.lapAutoAdjustWithoutHorizontalScrolling,0,0,200,200);

  MouseDown_:=false;
  MouseDownLeftIndex:=-1;
  MouseDownBottomIndex:=-1;
  MouseDownX_Start:=0;
  MouseDownX_Current:=0;
  MouseDownY_Start:=0;
  MouseDownY_Current:=0;
  MouseDownRangeMin:=0;
  MouseDownRangeMax:=0;
  MouseDownSeries:=-1;
  MouseDownSeriesStep:=0;
  LeftIndex_:=-1;

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
  Bottom_range:=TChartRange.Create(Chart1);

  Data1_range:=TChartRange.Create(Chart1);
  Data2_range:=TChartRange.Create(Chart1);
  Data3_range:=TChartRange.Create(Chart1);
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
var
  t:Double;
  RanNumber: Integer;
begin
  Label1.Caption:= 'a.X : '+Chart1.LogicalExtent.a.X.ToString;
  Label2.Caption:= 'b.X : '+Chart1.LogicalExtent.b.X.ToString;
  Label3.Caption:= 'a.Y : '+Chart1.LogicalExtent.a.Y.ToString;
  Label4.Caption:= 'b.Y : '+Chart1.LogicalExtent.b.Y.ToString;

  t:=Now();
  Label9.Caption:=t.ToString;
  Label11.Caption:= DateTimeToStr(t);

  ListChartSource1.Add(t,0,'');

  Randomize; // Initializes the random number generator (call once per program)
  RanNumber := Random(50 - 10 + 1) + 10; // Generates a number from 10 to 50

  Randomize;
  RanNumber := Random(10001); // Generates an integer from 0 to 10000
  ListChartSource2.Add(t,RanNumber,'');
  Data2.Caption:='Drag drop Data2 to chart : ' +RanNumber.ToString;
  if Data2_range.Max<RanNumber then Data2_range.Max:=RanNumber;
  if Data2_range.Min>RanNumber then Data2_range.Min:=RanNumber;

  Randomize;
  RanNumber := Random(100 - 0 + 1) -50; // Generates a number from -50 to 50
  ListChartSource3.Add(t,RanNumber,'');
  Data3.Caption:='Drag drop Data3 to chart : ' +RanNumber.ToString;
  if Data3_range.Max<RanNumber then Data3_range.Max:=RanNumber;
  if Data3_range.Min>RanNumber then Data3_range.Min:=RanNumber;

  Data2_range.UseMax:=true;
  Data2_range.UseMin:=true;
  Data3_range.UseMax:=true;
  Data3_range.UseMin:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ClearChart();
  Bottom_range.Free;
  Data1_range.Free;
  Data2_range.Free;
  Data3_range.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  ChartSeries_:TBasicChartSeries;
  axis:TChartAxis;
  Again:boolean;
  AxisTransform_:TAxisTransform;
  //ChartHavecalLeft:boolean;
  //ChartHavecalBottom:boolean;
  //NewLefttAxis: TChartAxis;
  //NewBottomAxis: TChartAxis;
begin

  //ChartHavecalLeft:=false;
  //ChartHavecalBottom:=false;
  //for axis in Chart1.AxisList do
  //begin
  //  if axis.Alignment = TChartAxisAlignment.calBottom  then
  //  begin
  //    ChartHavecalBottom:=true;
  //  end;
  //  if axis.Alignment = TChartAxisAlignment.calLeft  then
  //  begin
  //    ChartHavecalLeft:=true;
  //  end;
  //end;
  //
  //if not ChartHavecalBottom then
  //begin
  //  NewBottomAxis := Chart1.AxisList.Add as TChartAxis;
  //  NewBottomAxis.Alignment:=TChartAxisAlignment.calBottom;
  //  NewBottomAxis.Grid.Visible:=false;
  //  NewBottomAxis.Marks.LabelBrush.Style:=bsClear;
  //  NewBottomAxis.Marks.LabelFont.Orientation:=900;
  //  NewBottomAxis.OnGetMarkText:=@Chart1AxisList1GetMarkText;
  //  NewBottomAxis.Title.Caption:='Default Bottom Axis';
  //  NewBottomAxis.Title.Visible:=false;
  //  Chart1.BottomAxis.Assign(NewBottomAxis);
  //  //Chart1.BottomAxis:=NewBottomAxis;
  //  ChartHavecalBottom:=true;
  //end;
  //
  //if not ChartHavecalLeft then
  //begin
  //  NewLefttAxis:=Chart1.AxisList.Add as TChartAxis;
  //  NewLefttAxis.Alignment:=TChartAxisAlignment.calLeft;
  //  NewLefttAxis.Grid.Visible:=false;
  //  NewLefttAxis.Marks.LabelBrush.Style:=bsClear;
  //  NewLefttAxis.Title.Caption:='Default Left Axis';
  //  NewLefttAxis.Title.Visible:=false;
  //  Chart1.LeftAxis.Assign(NewLefttAxis);
  //  //Chart1.LeftAxis:=NewLefttAxis;
  //  ChartHavecalLeft:=true;
  //end;

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

  //showmessage(Chart1.LeftAxis.Title.Caption);
  Chart1.LeftAxis.Title.Caption:='Data1';
  Chart1.LeftAxis.Range.Max:=1;
  Chart1.LeftAxis.Range.Min:=0;
  Chart1.LeftAxis.Range.UseMax:=true;
  Chart1.LeftAxis.Range.UseMin:=true;

  Chart1.BottomAxis.Marks.LabelFont.Orientation:=900;
  Chart1.BottomAxis.Marks.OverlapPolicy:=TChartMarksOverlapPolicy.opHideNeighbour;
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
  Hour, Minute, Second, MilliSecond: Word;
  HexHour, HexMinute, HexSecond: string;

begin
  DecodeTime(Now(), Hour, Minute, Second, MilliSecond);
  HexHour   := IntToHex(Hour, 2);
  HexMinute := IntToHex(Minute, 2);
  HexSecond := IntToHex(Second, 2);

  for axis in Chart1.AxisList do
  begin
    axis.Grid.Visible:=false;
    axis.Title.Visible:=false;
  end;
  Chart1.LeftAxis.Title.Caption:='Data1';
  Chart1.LeftAxis.Range.Max:=1;
  Chart1.LeftAxis.Range.Min:=0;
  Chart1.LeftAxis.Range.UseMax:=true;
  Chart1.LeftAxis.Range.UseMin:=true;

  if Chart1.Series.Count <= 0 then
  begin
    LineSeries:= TLineSeries.Create(Chart1);
    Chart1.AddSeries(LineSeries);
    LineSeries.Name:='LineSeriesData1';
    //showmessage(LineSeries.Name);
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
  axis.Title.Caption:='Data2';
  axis.Title.Visible:=false;
  axis.Range.Min:=100;
  axis.Range.Max:=10000;
  axis.Range.UseMin:=true;
  axis.Range.UseMax:=true;

  LineSeries:= TLineSeries.Create(Chart1);
  Chart1.AddSeries(LineSeries);
  LineSeries.Name:='H'+HexHour+HexMinute+HexSecond+'Data2';
  //showmessage(LineSeries.Name);
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
  axis.Title.Caption:='Data3';
  axis.Title.Visible:=false;
  axis.Range.Min:=-50;
  axis.Range.Max:=50;
  axis.Range.UseMin:=true;
  axis.Range.UseMax:=true;

  LineSeries:= TLineSeries.Create(Chart1);
  Chart1.AddSeries(LineSeries);
  LineSeries.Name:='H'+HexHour+HexMinute+HexSecond+'Data3';
  //showmessage(LineSeries.Name);
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

procedure TForm1.Button5Click(Sender: TObject);
var
  i:integer;
  ChartSeries_:TBasicChartSeries;
begin
  if Chart1.Series.Count > 0 then
  for ChartSeries_ in Chart1.Series do
  begin
    if Pos(UpCase('Data2'), UpCase(ChartSeries_.Name)) > 0 then
    begin
      TLineSeries(ChartSeries_).Source:=ListChartSource2;
      TLineSeries(ChartSeries_).SeriesColor:=clRed;
    end;
    if Pos(UpCase('Data3'), UpCase(ChartSeries_.Name)) > 0 then
    begin
      TLineSeries(ChartSeries_).Source:=ListChartSource3;
      TLineSeries(ChartSeries_).SeriesColor:=clBlue;
    end;

  end;
end;

procedure TForm1.Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
  AMark: Double);
begin
  if AMark>20000 then
  AText := TimeToStr(AMark); //DateToStr(AMark);
end;

procedure TForm1.Chart1Click(Sender: TObject);
begin
  exit;
  NewExtent := Chart1.LogicalExtent;

  if ChartLiveView1.Active then
  begin
    Chart1.Extent.XMax:=NewExtent.b.X;
    Chart1.Extent.Xmin:=NewExtent.a.X;
    Chart1.Extent.UseXMax:=true;
    Chart1.Extent.UseXMin:=true;
    //Memo1.Append('copy');
  end
  else
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;

  ChartLiveView1.Active:=false;
  //Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;

  if not ChartLiveView1.Active then
  begin
    Chart1.Extent.XMax:=NewExtent.b.X;
    Chart1.Extent.Xmin:=NewExtent.a.X;
    Chart1.Extent.UseXMax:=true;
    Chart1.Extent.UseXMin:=true;
    //NewExtent.a.X := NewExtent.b.X - 0.0005;
    Chart1.LogicalExtent := NewExtent;
    //Memo1.Append('Fource')
  end;
  if ChartLiveView1.Active then
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;
end;

procedure TForm1.Chart1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  //Memo1.Append('Chart1ContextPopup');
  ChartLiveView1.Active:=false;
  //Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;
end;

procedure TForm1.Chart1DblClick(Sender: TObject);
begin
  //Memo1.Append('Chart1DblClick');
  ChartLiveView1.Active:=true;
  //Label1.Caption:='LiveView = '+ChartLiveView1.Active.ToInteger.ToString;
  if ChartLiveView1.Active then
  begin
    Chart1.Extent.UseXMax:=false;
    Chart1.Extent.UseXMin:=false;
  end;
end;

procedure TForm1.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ChartSeries_:TBasicChartSeries;
  Data_range: array of TChartRange;
  i:integer;
  axis:TChartAxis;
begin

  if Button=mbRight then exit;

  if ((LeftIndex_ < 0) and (BottomIndex_ < 0)) then
  if ChartLiveView1.Active then
  begin

    if Chart1.AxisList.Count > 0 then
    begin
      SetLength(Data_range, Chart1.AxisList.Count);
      for i:=Low(Data_range) to High(Data_range) do
      begin
        Data_range[i] := TChartRange.Create(Chart1);
      end;

      i:=Low(Data_range);
      for axis in Chart1.AxisList do
      begin
        Data_range[i].Assign(axis.Range);
        i:=i+1;
      end;
    end;

    ////Bottom_range := Chart1.BottomAxis.Range;
    //NewExtent := Chart1.LogicalExtent;
    ChartLiveView1.Active:=false;
    //Chart1.Extent.XMax:=NewExtent.b.X;
    //Chart1.Extent.Xmin:=NewExtent.a.X;
    //Chart1.Extent.UseXMax:=true;
    //Chart1.Extent.UseXMin:=true;
    //Chart1.Extent.FixTo(NewExtent);
    ////Chart1.BottomAxis.Range:=Bottom_range;

    if Chart1.AxisList.Count > 0 then
    begin

      i:=Low(Data_range);
      for axis in Chart1.AxisList do
      begin
        axis.Range.Assign(Data_range[i]);
        i:=i+1;
      end;

      for i:=Low(Data_range) to High(Data_range) do
      begin
        Data_range[i].Free;
      end;
    end;
  end;


  if (LeftIndex_ < 0) and ( not MouseDown_) then begin MouseDownLeftIndex:=-1;  end;
  if (BottomIndex_ < 0) and ( not MouseDown_) then begin MouseDownBottomIndex:=-1;  end;
  //if (LeftIndex_ < 0) and (BottomIndex_ < 0) then showmessage('sdfsdfsd');

  if (LeftIndex_ >= 0) and ( not MouseDown_) then
  begin
    MouseDown_:=true;
    MouseDownLeftIndex:= LeftIndex_;

    MouseDownY_Start:=Y;
    MouseDownY_Current:=Y;
    MouseDownRangeMin:=Chart1.AxisList[MouseDownLeftIndex].Range.Min;
    MouseDownRangeMax:=Chart1.AxisList[MouseDownLeftIndex].Range.Max;
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if TLineSeries(ChartSeries_).AxisIndexY=MouseDownLeftIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        //MouseDownSeriesStep:=0.003/ABS(Chart1.Series[MouseDownSeries].AxisToGraphY(Y)-Chart1.Series[MouseDownSeries].AxisToGraphY(Y+1));// .AxisToGraphY(Y);
        MouseDownSeriesStep:=ABS(MouseDownRangeMin-MouseDownRangeMax)/chart1.Height;
      end;
    end;
  end;

  if (BottomIndex_ >= 0) and ( not MouseDown_) then
  begin
    MouseDown_:=true;
    MouseDownBottomIndex:= BottomIndex_;
    ChartLiveView1.Active:=false;
    MouseDownX_Start:=X;
    MouseDownX_Current:=X;
    MouseDownRangeMin:=Chart1.AxisList[MouseDownBottomIndex].Range.Min;
    MouseDownRangeMax:=Chart1.AxisList[MouseDownBottomIndex].Range.Max;
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if TLineSeries(ChartSeries_).AxisIndexX=MouseDownBottomIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        MouseDownSeriesStep:=ABS(MouseDownRangeMin-MouseDownRangeMax)/chart1.ChartWidth;
      end;
    end;
  end;
  if ( not MouseDown_) then  begin MouseDownLeftIndex:=-1; MouseDownBottomIndex:=-1; exit; end;

end;

procedure TForm1.Chart1MouseLeave(Sender: TObject);
begin
  MouseDownLeftIndex:=-1;
  MouseDown_:=false;
  MouseDownSeriesStep:=0
end;

procedure TForm1.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i:integer;
  axis:TChartAxis;
  Axis_Width:integer;
  Axis_Height:integer;
begin
  LeftIndex_:=-1;
  i:=Chart1.MarginsExternal.Left;
  for axis in Chart1.AxisList do
  begin
    if axis.Alignment =TChartAxisAlignment.calLeft then
    begin
      Axis_Width:=axis.MeasureLabelSize(Chart1.Drawer);
      if (X>i) and (X<=i+Axis_Width) then
      begin
        LeftIndex_:=axis.Index;
      end;
      i:=i+Axis_Width;
    end;
  end;
  Label8.Caption:='Left axis index: ' +LeftIndex_.ToString;

  BottomIndex_:=-1;
  i:=Chart1.MarginsExternal.Bottom;
  for axis in Chart1.AxisList do
  begin
    if axis.Alignment =TChartAxisAlignment.calBottom then
    begin
      Axis_Height:=axis.MeasureLabelSize(Chart1.Drawer);
      if ((Chart1.Height-Y)>i) and ((Chart1.Height-Y)<=i+Axis_Height) then
      begin
        BottomIndex_:=axis.Index;
      end;
      i:=i+Axis_Height;
    end;
  end;
  if BottomIndex_ >=0 then
  Label8.Caption:='Bottom axis index: ' +BottomIndex_.ToString;

  if (LeftIndex_ < 0) and (BottomIndex_<0) then Chart1.AllowZoom:=true else Chart1.AllowZoom:=false;

  Label5.Caption:='Index Step : ';

  if MouseDownSeries >=0 then
  Label5.Caption:=Label5.Caption + FloatToStr(MouseDownSeriesStep);

  if ( not MouseDown_) then  begin MouseDownLeftIndex:=-1; MouseDownSeriesStep:=0; exit; end;

  MouseDownY_Current:=Y;
  MouseDownX_Current:=X;

  if MouseDownLeftIndex >=0 then
  begin
    Chart1.AxisList[MouseDownLeftIndex].Range.Max:=MouseDownRangeMax+((MouseDownY_Current-MouseDownY_Start)*MouseDownSeriesStep);
    Chart1.AxisList[MouseDownLeftIndex].Range.Min:=MouseDownRangeMin+((MouseDownY_Current-MouseDownY_Start)*MouseDownSeriesStep);
  end;
  if MouseDownBottomIndex >=0 then
  begin
    Chart1.AxisList[MouseDownBottomIndex].Range.Max:=MouseDownRangeMax+((MouseDownX_Current-MouseDownX_Start)*MouseDownSeriesStep);
    Chart1.AxisList[MouseDownBottomIndex].Range.Min:=MouseDownRangeMin+((MouseDownX_Current-MouseDownX_Start)*MouseDownSeriesStep);
  end;
end;

procedure TForm1.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDownLeftIndex:=-1;
  MouseDown_:=false;
  MouseDownSeriesStep:=0;
end;

end.

