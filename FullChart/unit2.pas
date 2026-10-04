unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, StdCtrls, TAGraph, TATools, TAChartAxis, TAChartAxisUtils, TASeries,
  TATransformations, TATypes, TASources, TACustomSource, Unit3, Types;

type

  { TForm2 }

  TForm2 = class(TForm)
    AutoHorizental: TMenuItem;
    AutoRangeControl: TMenuItem;
    AutoVartical: TMenuItem;
    BottomAxisMenu: TPopupMenu;
    Chart1: TChart;
    DefaultLeftAxisTransform: TChartAxisTransformations;
    DefaultLeftAxisTransformAutoScaleAxis: TAutoScaleAxisTransform;
    DefaultBottomAxisTransform: TChartAxisTransformations;
    DefaultBottomAxisTransformAutoScaleAxis: TAutoScaleAxisTransform;
    DefaultConstantLine: TConstantLine;
    DefaultSeries: TLineSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1AxisClickTool1: TAxisClickTool;
    ChartToolset1UserDefinedTool1: TUserDefinedTool;
    LeftAxisMenu: TPopupMenu;
    MainMenu1: TMainMenu;
    ManualVartical: TMenuItem;
    DeleteAxis: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    SettingMenu: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    UseCurrentHorizental: TMenuItem;
    procedure AutoHorizentalClick(Sender: TObject);
    procedure AutoRangeControlClick(Sender: TObject);
    procedure AutoVarticalClick(Sender: TObject);
    procedure Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
    procedure Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
      AMark: Double);
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseLeave(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChartToolset1AxisClickTool1BeforeMouseWheelDown(
      ATool: TChartTool; APoint: TPoint);
    procedure ChartToolset1AxisClickTool1BeforeMouseWheelUp(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure DeleteAxisClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ManualVarticalClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UseCurrentHorizentalClick(Sender: TObject);
  private
    procedure FindSourceYRangeManually(Source: TListChartSource; MinX, MaxX: Double; var MinY, MaxY: Double);

    var
      Mouse_:MouseRec;
      MouseDownY_Start:integer;
      MouseDownY_Current:integer;
      MouseDownX_Start:integer;
      MouseDownX_Current:integer;
      MouseDownRangeMin:Double;
      MouseDownRangeMax:Double;
      MouseDownSeries:integer;
      XY:XY_;
      ChartRec : ChartRec_;
      V_Control: array of VerticalControl;
  public

  end;

var
  Form2: TForm2;
  ObjName:string;
  ObjIndex:integer;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FindSourceYRangeManually(Source: TListChartSource; MinX, MaxX: Double; var MinY, MaxY: Double);
var
  i: Integer;
  Item: PChartDataItem;
  FoundAny: Boolean;
begin
  FoundAny := False;
  MinY := MaxInt;  // Seed with temporary high/low values
  MaxY := -MaxInt;

  for i := 0 to Source.Count - 1 do
  begin
    Item := Source.Item[i]; // Accessing the data point pointer

    // Check if the point's X coordinate falls within your specified window
    if (Item^.X >= MinX) and (Item^.X <= MaxX) then
    begin
      if not FoundAny then
      begin
        MinY := Item^.Y;
        MaxY := Item^.Y;
        FoundAny := True;
      end
      else
      begin
        if Item^.Y < MinY then MinY := Item^.Y;
        if Item^.Y > MaxY then MaxY := Item^.Y;
      end;
    end;
  end;

  if not FoundAny then
  begin
    MinY := 0;
    MaxY := 0;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  i:integer;
  index_:integer;
  axis:TChartAxis;
  LineS:TLineSeries;
  AxisTransform:TChartAxisTransformations;
  AutoScaleAxisTrans:TAutoScaleAxisTransform;

  RandomColor: TColor;
begin
  Timer1.Enabled:=false;

  Randomize;
  RandomColor := Standard16Colors[Random(16)];  //RGBToColor(Random(256), Random(256), Random(256));

  Chart1.LeftAxis.Grid.Visible:=false;
  Chart1.LeftAxis.Range.Max:=1;
  Chart1.LeftAxis.Range.Min:=0;
  Chart1.LeftAxis.Range.UseMax:=true;
  Chart1.LeftAxis.Range.UseMin:=true;

  Chart1.BottomAxis.Grid.Visible:=false;
  Chart1.BottomAxis.Range.Max:=1;
  Chart1.BottomAxis.Range.Min:=1;
  Chart1.BottomAxis.Range.UseMax:=true;
  Chart1.BottomAxis.Range.UseMin:=true;
  Chart1.BottomAxis.Intervals.Count:=5;
  Chart1.BottomAxis.Intervals.MaxLength:=50;
  Chart1.BottomAxis.Intervals.MinLength:=10;
  Chart1.BottomAxis.Intervals.NiceSteps:='0.2|0.5|1.0';
  Chart1.BottomAxis.Intervals.Options:=[aipGraphCoords,aipUseMaxLength,aipUseMinLength,aipUseNiceSteps];

  Chart1.Extent.UseXMax:=false;
  Chart1.Extent.UseXMin:=false;
  Chart1.Extent.UseYMax:=false;
  Chart1.Extent.UseYMin:=false;
  Chart1.Extent.XMax:=0;
  Chart1.Extent.XMin:=0;
  Chart1.Extent.YMax:=0;
  Chart1.Extent.YMin:=0;

  Chart1.AllowZoom:=false;
  Chart1.AllowPanning:=true;

  DefaultSeries.Source:=DefaultData;
  //showmessage(DefaultData.Name);
  //showmessage(TLineSeries(Chart1.Series[0]).Source.Name);
  ChartRec.X1:=Chart1.ClipRect.Left+1;
  ChartRec.X2:=Chart1.ClipRect.Right-1;
  ChartRec.Y1:=Chart1.ClipRect.Top+1;
  ChartRec.Y2:=Chart1.ClipRect.Bottom-1;

  ChartRec.ChartForwardCmd:=true;
  //0.000005 = 500ms
  ChartRec.HorizontalSpace:=0.000005*((120*5/100)*20); //20% of (60Sec x 5)
  ChartRec.HorizontalDistance:=0.000005*((120*5/100)*80);  //100%-HorizontalSpace  //80% of (60Sec x 5)

  Mouse_.IsDrag:=false;
  Mouse_.X1:=0;
  Mouse_.X2:=0;
  Mouse_.Y1:=0;
  Mouse_.Y2:=0;
  DefaultConstantLine.Position:=0;
  DefaultConstantLine.SeriesColor:=clNone;
  DefaultConstantLine.Pen.Color:=clNone;
  DefaultConstantLine.Pen.Style:=psClear;

  SetLength(V_Control, Chart1.AxisList.Count);
  for i:=0 to Chart1.AxisList.Count-1 do
  begin
    V_Control[i].ManualVartical:=false;
    V_Control[i].AutoRangeControl:=false;
    V_Control[i].AutoVartical:=true;
  end;

  if ObjIndex >= Low(Heater) then
  if ObjIndex <= High(Heater) then
  begin
  index_:=ObjIndex;

  axis:=Chart1.AxisList.Add;
  axis.Alignment:=calLeft;

  axis.Title.Visible:=false;
  axis.Grid.Visible:=false;
  axis.Marks.LabelFont.Color:=RandomColor;
  axis.Range.Max:=1;
  axis.Range.Min:=0;
  axis.Range.UseMax:=true;
  axis.Range.UseMin:=true;
  LineS:= TLineSeries.Create(Chart1);
  Chart1.AddSeries(LineS);
  LineS.AxisIndexX:=Chart1.BottomAxis.Index;
  LineS.AxisIndexY:=axis.Index;
  LineS.SeriesColor:=RandomColor;
  AxisTransform:=TChartAxisTransformations.Create(Chart1);
  AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
  AutoScaleAxisTrans.Transformations:=AxisTransform;

  axis.Transformations:=AxisTransform;
  SetLength(V_Control, Chart1.AxisList.Count);
  V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
  V_Control[axis.Index].ManualVartical:=false;
  V_Control[axis.Index].AutoRangeControl:=false;
  V_Control[axis.Index].AutoVartical:=true;

  if Pos(UpperCase('Enable'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Enable';
    LineS.Source:=Heater[index_].Enable_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Enable_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Enable_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Enable_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Enable_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Enable_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
  end;

  if Pos(UpperCase('Auto'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' AutoMode';
    LineS.Source:=Heater[index_].Auto_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Auto_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Auto_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Auto_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Auto_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Auto_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
  end;

  if Pos(UpperCase('Name'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Start';
    LineS.Source:=Heater[index_].Start_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Start_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Start_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Start_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Start_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Start_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
  end;

  if Pos(UpperCase('Fault'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Fault';
    LineS.Source:=Heater[index_].Fault_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Fault_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Fault_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Fault_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Fault_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Fault_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
  end;

  if Pos(UpperCase('Set'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Setpoint';
    LineS.Source:=Heater[index_].Setpoint_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Setpoint_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Setpoint_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Setpoint_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Setpoint_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Setpoint_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=axis.Index;
  end;

  if Pos(UpperCase('Gain'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Gain';
    LineS.Source:=Heater[index_].Gain_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Gain_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Gain_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Gain_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Gain_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Gain_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=axis.Index;
  end;

  if Pos(UpperCase('Actual'), UpperCase(ObjName))>0 then
  begin
    axis.Title.Caption:=Heater[index_].DeviceName+' Actual';
    LineS.Source:=Heater[index_].Actual_.Source;

    V_Control[axis.Index].VerDevProName:=Heater[index_].Actual_.PropertyName;
    V_Control[axis.Index].PropertyIndex:=Heater[index_].Setpoint_.PropertyIndex;
    V_Control[axis.Index].IsDigital:=Heater[index_].Actual_.IsDigital;
    V_Control[axis.Index].GuideMin:= Heater[index_].Actual_.GuideMin;
    V_Control[axis.Index].GuideMax:= Heater[index_].Actual_.GuideMax;
    V_Control[axis.Index].OffsetMin:=0;
    V_Control[axis.Index].OffsetMax:=axis.Index;
  end;

  LineS.Title:=axis.Title.Caption;

  end;

  Timer1.Enabled:=true;
end;

procedure TForm2.ManualVarticalClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].ManualVartical:=true;
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
    V_Control[Mouse_.LeftIndex].AutoVartical:=false;
  end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
  t:double;
  YMin:double;
  YMax:double;
  i:integer;
  ChartSeries_:TBasicChartSeries;
  aY:double;
  bY:double;
  i2:integer;
begin
  t:=Now();

  DefaultData.FindBounds(Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,ChartRec.ALB,ChartRec.AUB);

  //ListChartSource1.FindYRange(Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,true,YMin,YMax);
  FindSourceYRangeManually(DefaultData,Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,YMin,YMax);
  if (YMin=0) and (YMax=0) then
  begin
    YMin:=YMin-1;
    YMax:=YMax+1;
  end;
  if ChartRec.ChartForwardCmd then
  begin
    chart1.BottomAxis.Range.Min:=t-ChartRec.HorizontalDistance;
    chart1.BottomAxis.Range.Max:=t+ChartRec.HorizontalSpace;
  end;

  for ChartSeries_ in Chart1.Series do
  begin
    if ChartSeries_ is TLineSeries then
    if ChartSeries_.Index>0 then
    if TLineSeries(ChartSeries_).AxisIndexY>=2 then
    begin
      i:=TLineSeries(ChartSeries_).AxisIndexY;
      i2:=High(V_Control);

    if V_Control[i].AutoVartical then
      begin
        aY:=TLineSeries(ChartSeries_).Source.Extent.a.Y;
        bY:=TLineSeries(ChartSeries_).Source.Extent.b.Y;
        if (aY=0) and (bY=0) then
        begin
          aY:=aY-1;
          bY:=bY+1;
        end;
        YMin:=aY;

        if (V_Control[i].GuideMin<>0) or (V_Control[i].GuideMax<>0) then
        begin
          YMin:=V_Control[i].GuideMin+V_Control[i].OffsetMin;
          YMax:=V_Control[i].GuideMax+V_Control[i].OffsetMax;
          aY:=V_Control[i].GuideMin+V_Control[i].OffsetMin;
          bY:=V_Control[i].GuideMax+V_Control[i].OffsetMax;
        end;

        if (YMin+bY)<(YMin-bY) then
          YMin:=YMin+(bY/2)
        else
          YMin:=YMin-(bY/2);
        chart1.AxisList[i].Range.Min:=YMin;
        chart1.AxisList[i].Range.Max:=bY*1.5;
      end;

      if V_Control[i].AutoRangeControl then
      begin
        FindSourceYRangeManually(TListChartSource(TLineSeries(ChartSeries_).Source),Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,YMin,YMax);
        if (YMin=0) and (YMax=0) then
        begin
          YMin:=YMin-1;
          YMax:=YMax+1;
        end;
        if YMin>0 then YMin:=0;
        if YMin<0 then YMin:=YMin*1.5;
        chart1.AxisList[i].Range.Min:=YMin;
        chart1.AxisList[i].Range.Max:=YMax*1.5;
      end;

    end;
  end;
end;

procedure TForm2.UseCurrentHorizentalClick(Sender: TObject);
begin
  timer1.Enabled:=false;
  ChartRec.HorizontalDistance:= DefaultData.Extent.b.X - Chart1.BottomAxis.Range.Min;
  ChartRec.HorizontalSpace:=Chart1.BottomAxis.Range.Max-DefaultData.Extent.b.X;
  ChartRec.ChartForwardCmd:=true;
  timer1.Enabled:=true;
end;

procedure TForm2.Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect);
begin
  if Mouse_.IsDrag then
  begin
    ACanvas.Brush.Color := RgbToColor(255, 240, 240);
    ACanvas.FillRect(
      Mouse_.X1,   //LeftLine
      Mouse_.Y1,  //TopLine
      Mouse_.X2, //RightLine
      Mouse_.Y2 //BottomLine
    );
  end;
end;

procedure TForm2.AutoHorizentalClick(Sender: TObject);
begin
  //0.000005 = 500ms
  ChartRec.HorizontalSpace:=0.000005*((120/100)*20); //20% of 60Sec
  ChartRec.HorizontalDistance:=0.000005*((120/100)*80);  //100%-HorizontalSpace  //80% of 60Sec
  ChartRec.ChartForwardCmd:=true;
end;

procedure TForm2.AutoRangeControlClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=true;
    V_Control[Mouse_.LeftIndex].ManualVartical:=false;
    V_Control[Mouse_.LeftIndex].AutoVartical:=false;
  end;
end;

procedure TForm2.AutoVarticalClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].AutoVartical:=true;
    V_Control[Mouse_.LeftIndex].ManualVartical:=false;
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
  end;
end;

procedure TForm2.Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
  AMark: Double);
begin
  if AMark>40000 then
  AText := FormatDateTime('hh:nn:ss.zzz', AMark)+chr(13)+chr(10)+DateToStr(AMark); //DateToStr(AMark);
end;

procedure TForm2.Chart1DblClick(Sender: TObject);
begin
  ChartRec.ChartForwardCmd:=true;
end;

procedure TForm2.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  index_:integer;
  axis:TChartAxis;
  LineS:TLineSeries;
  AxisTransform:TChartAxisTransformations;
  AutoScaleAxisTrans:TAutoScaleAxisTransform;
  RandomColor: TColor;
begin
  Randomize;
  RandomColor := Standard16Colors[Random(16)];  //RGBToColor(Random(256), Random(256), Random(256));

  if Source is TLabel then
  begin
    index_:=strToInt('0'+RightStr(Tlabel(Source).Name,2))-1;
    if index_ < Low(Heater) then  exit;
    if index_ > High(Heater) then exit;

    if Pos(UpperCase('Auto'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' AutoMode';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Marks.LabelFont.Color:=RandomColor;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Auto_.Source;
      LineS.SeriesColor:=RandomColor;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Auto_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Auto_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Auto_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Auto_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Auto_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
    end;

    if Pos(UpperCase('Name'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Start';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Marks.LabelFont.Color:=RandomColor;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Start_.Source;
      LineS.SeriesColor:=RandomColor;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Start_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Start_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Start_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Start_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Start_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
    end;

    if Pos(UpperCase('Fault'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Fault';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Fault_.Source;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Fault_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Fault_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Fault_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Fault_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Fault_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
    end;

    if Pos(UpperCase('Set'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Setpoint';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Setpoint_.Source;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Setpoint_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Setpoint_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Setpoint_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Setpoint_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Setpoint_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=axis.Index;
    end;

    if Pos(UpperCase('Gain'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Gain';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Gain_.Source;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Gain_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Gain_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Gain_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Gain_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Gain_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=axis.Index;
    end;

    if Pos(UpperCase('Actual'), UpperCase(Tlabel(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Actual';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Actual_.Source;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Actual_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Actual_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Actual_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Actual_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Actual_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=axis.Index;
    end;
  end;

  if Source is TShape then
  begin
    index_:=strToInt('0'+RightStr(TShape(Source).Name,2))-1;
    if index_ < Low(Heater) then  exit;
    if index_ > High(Heater) then exit;

    if Pos(UpperCase('EnableDisable'), UpperCase(TShape(Source).Name))>0 then
    begin
      axis:=Chart1.AxisList.Add;
      axis.Alignment:=calLeft;
      axis.Title.Caption:=Heater[index_].DeviceName+' Enable';
      axis.Title.Visible:=false;
      axis.Grid.Visible:=false;
      axis.Range.Max:=1;
      axis.Range.Min:=0;
      axis.Range.UseMax:=true;
      axis.Range.UseMin:=true;
      LineS:= TLineSeries.Create(Chart1);
      Chart1.AddSeries(LineS);
      LineS.Title:=axis.Title.Caption;
      LineS.AxisIndexX:=Chart1.BottomAxis.Index;
      LineS.AxisIndexY:=axis.Index;
      LineS.Source:=Heater[index_].Enable_.Source;
      AxisTransform:=TChartAxisTransformations.Create(Chart1);
      AutoScaleAxisTrans:=TAutoScaleAxisTransform.Create(AxisTransform);
      AutoScaleAxisTrans.Transformations:=AxisTransform;
      axis.Transformations:=AxisTransform;
      SetLength(V_Control, Chart1.AxisList.Count);
      V_Control[axis.Index].DeviceIndex:=Heater[index_].DeviceIndex;
      V_Control[axis.Index].ManualVartical:=false;
      V_Control[axis.Index].AutoRangeControl:=false;
      V_Control[axis.Index].AutoVartical:=true;

      V_Control[axis.Index].VerDevProName:=Heater[index_].Enable_.PropertyName;
      V_Control[axis.Index].PropertyIndex:=Heater[index_].Enable_.PropertyIndex;
      V_Control[axis.Index].IsDigital:=Heater[index_].Enable_.IsDigital;
      V_Control[axis.Index].GuideMin:= Heater[index_].Enable_.GuideMin;
      V_Control[axis.Index].GuideMax:= Heater[index_].Enable_.GuideMax;
      V_Control[axis.Index].OffsetMin:=0;
      V_Control[axis.Index].OffsetMax:=0.1*axis.Index;
    end;
  end;

end;

procedure TForm2.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=true;
end;

procedure TForm2.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ChartSeries_:TBasicChartSeries;
  Data_range: array of TChartRange;
  i:integer;
  axis:TChartAxis;
begin

  if ChartRec.IsInside then
  if Button=mbRight then
  begin
    ChartRec.ChartForwardCmd:=false;
    Chart1.Cursor:=crSizeAll;
    Mouse_.RightDown:=true;
    MouseDownX_Start:=X;
    MouseDownX_Current:=X;
    MouseDownRangeMin:=Chart1.BottomAxis.Range.Min;
    MouseDownRangeMax:=Chart1.BottomAxis.Range.Max;
    MouseDownSeries:=-1;
    Mouse_.DownSeriesStep:=1*(ABS(MouseDownRangeMin-MouseDownRangeMax)/ABS(ChartRec.X2-ChartRec.X1));
    exit;
  end;

  if Button=mbRight then exit;

  if ((Mouse_.LeftIndex < 0) and (Mouse_.BottomIndex < 0)) then

  if (Mouse_.LeftIndex < 0) and ( not Mouse_.LeftDown) then begin Mouse_.DownLeftIndex:=-1;  end;
  if (Mouse_.BottomIndex < 0) and ( not Mouse_.LeftDown) then begin Mouse_.DownBottomIndex:=-1;  end;

  if (Mouse_.LeftIndex >= 0) and ( not Mouse_.LeftDown) then
  begin
    Mouse_.LeftDown:=true;
    Mouse_.DownLeftIndex:= Mouse_.LeftIndex;

    MouseDownY_Start:=Y;
    MouseDownY_Current:=Y;
    MouseDownRangeMin:=Chart1.AxisList[Mouse_.DownLeftIndex].Range.Min;
    MouseDownRangeMax:=Chart1.AxisList[Mouse_.DownLeftIndex].Range.Max;
    //if MouseDownRangeMin= MouseDownRangeMax then
    //begin
    //  MouseDownRangeMin:=MouseDownRangeMin-1;
    //  MouseDownRangeMax:=MouseDownRangeMax+1;
    //end;
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if ChartSeries_ is TLineSeries then
      if TLineSeries(ChartSeries_).AxisIndexY=Mouse_.DownLeftIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        Mouse_.DownSeriesStep:=ABS(MouseDownRangeMin-MouseDownRangeMax)/ABS(ChartRec.Y2-ChartRec.Y1);
      end;
    end;
  end;

  if (Mouse_.BottomIndex >= 0) and ( not Mouse_.LeftDown) then
  begin
    ChartRec.ChartForwardCmd:=false;
    Mouse_.LeftDown:=true;
    Mouse_.DownBottomIndex:= Mouse_.BottomIndex;
    MouseDownX_Start:=X;
    MouseDownX_Current:=X;
    MouseDownRangeMin:=Chart1.AxisList[Mouse_.DownBottomIndex].Range.Min;
    MouseDownRangeMax:=Chart1.AxisList[Mouse_.DownBottomIndex].Range.Max;
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if ChartSeries_ is TLineSeries then
      if TLineSeries(ChartSeries_).AxisIndexX=Mouse_.DownBottomIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        Mouse_.DownSeriesStep:=1*(ABS(MouseDownRangeMin-MouseDownRangeMax)/ABS(ChartRec.X2-ChartRec.X1));
      end;
    end;
  end;

  if Mouse_.DownBottomIndex > 0 then
  begin

  end
  else
  begin

  end;

  if ( not Mouse_.LeftDown) then  begin Mouse_.DownLeftIndex:=-1; Mouse_.DownBottomIndex:=-1; exit; end;

end;

procedure TForm2.Chart1MouseLeave(Sender: TObject);
begin
  Chart1.Cursor:=crDefault;
  Mouse_.RightDown:=false;
  Mouse_.LeftDown:=false;
  Mouse_.DownLeftIndex:=-1;
  Mouse_.DownBottomIndex:=-1;
  Mouse_.DownSeriesStep:=0;
end;

procedure TForm2.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i:integer;
  axis:TChartAxis;
  Axis_Width:integer;
  Axis_Height:integer;
begin

  //Chart Frame
  ChartRec.X1:=Chart1.ClipRect.Left+1;
  ChartRec.X2:=Chart1.ClipRect.Right-1;
  ChartRec.Y1:=Chart1.ClipRect.Top+1;
  ChartRec.Y2:=Chart1.ClipRect.Bottom-1;

  //Mouse inside/Outside Chart Frame
  if (X >= ChartRec.X1) and (X <= ChartRec.X2) and (Y >= ChartRec.Y1) and (Y <= ChartRec.Y2) then
  begin ChartRec.IsInside:=true; ChartRec.IsOutside:=false; end
  else begin ChartRec.IsInside:=false; ChartRec.IsOutside:=true; end;

  if Mouse_.RightDown then
  begin
    MouseDownY_Current:=Y;
    MouseDownX_Current:=X;
    Chart1.BottomAxis.Range.Max:=MouseDownRangeMax-((MouseDownX_Current-MouseDownX_Start)*Mouse_.DownSeriesStep);
    Chart1.BottomAxis.Range.Min:=MouseDownRangeMin-((MouseDownX_Current-MouseDownX_Start)*Mouse_.DownSeriesStep);
    exit;
  end;

  //Find Left index
  Mouse_.LeftIndex:=-1;
  i:=Chart1.MarginsExternal.Left;
  for axis in Chart1.AxisList do
  begin
    if axis.Alignment =TChartAxisAlignment.calLeft then
    begin
      Axis_Width:=axis.MeasureLabelSize(Chart1.Drawer);
      if (X>i) and (X<=i+Axis_Width) then
      begin
        Mouse_.LeftIndex:=axis.Index;
      end;
      i:=i+Axis_Width;
    end;
  end;

  //Find Bottom index
  Mouse_.BottomIndex:=-1;
  i:=Chart1.MarginsExternal.Bottom;
  for axis in Chart1.AxisList do
  begin
    if axis.Alignment =TChartAxisAlignment.calBottom then
    begin
      Axis_Height:=axis.MeasureLabelSize(Chart1.Drawer);
      if ((Chart1.Height-Y)>i) and ((Chart1.Height-Y)<=i+Axis_Height) then
      begin
        Mouse_.BottomIndex:=axis.Index;
      end;
      i:=i+Axis_Height;
    end;
  end;

  if ChartRec.IsOutside and (Mouse_.BottomIndex>=0) then Chart1.PopupMenu:=BottomAxisMenu;
  if ChartRec.IsOutside and (Mouse_.LeftIndex>=0) then Chart1.PopupMenu:=LeftAxisMenu;
  if ChartRec.IsInside then Chart1.PopupMenu:=nil;

  if ( not Mouse_.LeftDown) then  begin Mouse_.DownLeftIndex:=-1; Mouse_.DownBottomIndex:=-1; end;

  MouseDownY_Current:=Y;
  MouseDownX_Current:=X;

  if Mouse_.DownLeftIndex >=0 then
  begin
    if V_Control[Mouse_.DownLeftIndex].AutoVartical or V_Control[Mouse_.DownLeftIndex].AutoRangeControl then
    begin
      V_Control[Mouse_.DownLeftIndex].AutoVartical:=false;
      V_Control[Mouse_.DownLeftIndex].AutoRangeControl:=false;
      V_Control[Mouse_.DownLeftIndex].ManualVartical:=true;
    end;
    Chart1.AxisList[Mouse_.DownLeftIndex].Range.Max:=MouseDownRangeMax+((MouseDownY_Current-MouseDownY_Start)*Mouse_.DownSeriesStep);
    Chart1.AxisList[Mouse_.DownLeftIndex].Range.Min:=MouseDownRangeMin+((MouseDownY_Current-MouseDownY_Start)*Mouse_.DownSeriesStep);
  end;

  if Mouse_.DownBottomIndex >=0 then
  begin
    Chart1.AxisList[Mouse_.DownBottomIndex].Range.Max:=MouseDownRangeMax-((MouseDownX_Current-MouseDownX_Start)*Mouse_.DownSeriesStep);
    Chart1.AxisList[Mouse_.DownBottomIndex].Range.Min:=MouseDownRangeMin-((MouseDownX_Current-MouseDownX_Start)*Mouse_.DownSeriesStep);
  end;
end;

procedure TForm2.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Chart1.Cursor:=crDefault;
  Mouse_.RightDown:=false;
  Mouse_.LeftDown:=false;
  Mouse_.DownLeftIndex:=-1;
  Mouse_.DownBottomIndex:=-1;
  Mouse_.DownSeriesStep:=0;
end;

procedure TForm2.ChartToolset1AxisClickTool1BeforeMouseWheelDown(
  ATool: TChartTool; APoint: TPoint);
var
  step:double;
  FullDistance:double;
  FreePercent:double;
begin
  if Mouse_.LeftIndex >=0 then
  begin
    if V_Control[Mouse_.LeftIndex].AutoVartical or V_Control[Mouse_.LeftIndex].AutoRangeControl then
    begin
      V_Control[Mouse_.LeftIndex].AutoVartical:=false;
      V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
      V_Control[Mouse_.LeftIndex].ManualVartical:=true;
    end;
    step:=ABS(Chart1.AxisList[Mouse_.LeftIndex].Range.Min-Chart1.AxisList[Mouse_.LeftIndex].Range.Max)/ABS(ChartRec.Y2-ChartRec.Y1);
    step:=step*3;
    Chart1.AxisList[Mouse_.LeftIndex].Range.Max:=Chart1.AxisList[Mouse_.LeftIndex].Range.Max+step;
    Chart1.AxisList[Mouse_.LeftIndex].Range.Min:=Chart1.AxisList[Mouse_.LeftIndex].Range.Min-step;
  end;

  if Mouse_.BottomIndex >=0 then
  begin
    timer1.Enabled:=false;

    FullDistance:=ChartRec.HorizontalSpace+ChartRec.HorizontalDistance;
    FreePercent:=(ChartRec.HorizontalSpace/FullDistance)*100;
    //Label14.Caption:=FullDistance.ToString;//+'%';

    step:=ABS(Chart1.AxisList[Mouse_.BottomIndex].Range.Min-Chart1.AxisList[Mouse_.BottomIndex].Range.Max)/ABS(ChartRec.X2-ChartRec.X1);
    step:=step*5;
    Chart1.AxisList[Mouse_.BottomIndex].Range.Max:=Chart1.AxisList[Mouse_.BottomIndex].Range.Max+step;
    Chart1.AxisList[Mouse_.BottomIndex].Range.Min:=Chart1.AxisList[Mouse_.BottomIndex].Range.Min-step;

    FullDistance:=(Chart1.AxisList[Mouse_.BottomIndex].Range.Max-Chart1.AxisList[Mouse_.BottomIndex].Range.Min);
    ChartRec.HorizontalSpace:=(FullDistance/100)*FreePercent;
    ChartRec.HorizontalDistance:=abs(FullDistance-ChartRec.HorizontalSpace);

    timer1.Enabled:=true;
  end;
end;

procedure TForm2.ChartToolset1AxisClickTool1BeforeMouseWheelUp(
  ATool: TChartTool; APoint: TPoint);
var
  step:double;
  FullDistance:double;
  FreePercent:double;
begin
  if Mouse_.LeftIndex >=0 then
  begin
    if V_Control[Mouse_.LeftIndex].AutoVartical or V_Control[Mouse_.LeftIndex].AutoRangeControl then
    begin
      V_Control[Mouse_.LeftIndex].AutoVartical:=false;
      V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
      V_Control[Mouse_.LeftIndex].ManualVartical:=true;
    end;
    step:=ABS(Chart1.AxisList[Mouse_.LeftIndex].Range.Min-Chart1.AxisList[Mouse_.LeftIndex].Range.Max)/ABS(ChartRec.Y2-ChartRec.Y1);
    step:=step*3;
    Chart1.AxisList[Mouse_.LeftIndex].Range.Max:=Chart1.AxisList[Mouse_.LeftIndex].Range.Max-step;
    Chart1.AxisList[Mouse_.LeftIndex].Range.Min:=Chart1.AxisList[Mouse_.LeftIndex].Range.Min+step;
  end;

  if Mouse_.BottomIndex >=0 then
  begin
    timer1.Enabled:=false;

    FullDistance:=ChartRec.HorizontalSpace+ChartRec.HorizontalDistance;
    FreePercent:=(ChartRec.HorizontalSpace/FullDistance)*100;
    //Label14.Caption:=FreePercent.ToString+'%';

    step:=ABS(Chart1.AxisList[Mouse_.BottomIndex].Range.Min-Chart1.AxisList[Mouse_.BottomIndex].Range.Max)/ABS(ChartRec.X2-ChartRec.X1);
    step:=step*5;
    Chart1.AxisList[Mouse_.BottomIndex].Range.Max:=Chart1.AxisList[Mouse_.BottomIndex].Range.Max-step;
    Chart1.AxisList[Mouse_.BottomIndex].Range.Min:=Chart1.AxisList[Mouse_.BottomIndex].Range.Min+step;

    FullDistance:=(Chart1.AxisList[Mouse_.BottomIndex].Range.Max-Chart1.AxisList[Mouse_.BottomIndex].Range.Min);
    ChartRec.HorizontalSpace:=(FullDistance/100)*FreePercent;
    ChartRec.HorizontalDistance:=abs(FullDistance-ChartRec.HorizontalSpace);

    timer1.Enabled:=true;
  end;
end;

procedure TForm2.ChartToolset1UserDefinedTool1AfterMouseMove(ATool: TChartTool;
  APoint: TPoint);
var
  i:integer;
  axis:TChartAxis;
  Axis_Width:integer;
  Axis_Height:integer;
  X_:integer;
  Y_:integer;
  a_:double;
  b_:double;
  d_:double;
  o_:double;
  r_:double;
begin
  if Mouse_.RightDown then exit;
  if (Mouse_.DownBottomIndex >=0) or (Mouse_.DownLeftIndex >=0) then exit;

  ChartRec.ChartForwardCmd:=false;
  DefaultConstantLine.Position:=0;
  DefaultConstantLine.Active:=not DefaultConstantLine.Active;

  X_:=APoint.X;
  Y_:=APoint.Y;

  if X_<=ChartRec.X1 then X_:=ChartRec.X1;
  if X_>=ChartRec.X2 then X_:=ChartRec.X2;
  if Y_<=ChartRec.Y1 then Y_:=ChartRec.Y1;
  if Y_>=ChartRec.Y2 then Y_:=ChartRec.Y2;

  if Mouse_.IsDrag then
  begin
    Mouse_.X2:=X_;
    Mouse_.Y2:=Y_;
  end;
  if not Mouse_.IsDrag then
  begin
    Mouse_.IsDrag:=true;
    Mouse_.X1:=X_;
    Mouse_.X2:=X_;
    Mouse_.Y1:=Y_;
    Mouse_.Y2:=Y_;
  end;

end;

procedure TForm2.ChartToolset1UserDefinedTool1AfterMouseUp(ATool: TChartTool;
  APoint: TPoint);
var
  axis:TChartAxis;
begin

  //memo1.Append('AfterMouseUp');
  if Mouse_.IsDrag then
  begin
    for axis in Chart1.AxisList do
    begin
      if axis.Index<> 0 then
      if axis.Alignment =TChartAxisAlignment.calLeft then
      begin
        XY.Y.Min:= axis.Range.Min;
        XY.Y.Max:= axis.Range.Max;
        XY.Y.d:= XY.Y.Max-XY.Y.Min;
        XY.Y.offsetMin:= XY.Y.d*Chart1.YImageToGraph(Mouse_.Y2);
        XY.Y.offsetMax:= XY.Y.d*Chart1.YImageToGraph(Mouse_.Y1);
        XY.Y.NewMin:= axis.Range.Min+XY.Y.offsetMin;
        XY.Y.NewMax:= axis.Range.Min+XY.Y.offsetMax;
        axis.Range.Min:=XY.Y.NewMin;
        axis.Range.Max:=XY.Y.NewMax;
      end;
      if axis.Index<> 0 then
      if axis.Alignment =TChartAxisAlignment.calBottom then
      begin
        XY.X.Min:= axis.Range.Min;
        XY.X.Max:= axis.Range.Max;
        XY.X.d:= XY.X.Max-XY.X.Min;
        XY.X.offsetMin:= XY.X.d*Chart1.XImageToGraph(Mouse_.X1);
        XY.X.offsetMax:= XY.X.d*Chart1.XImageToGraph(Mouse_.X2);
        XY.X.NewMin:= axis.Range.Min+XY.X.offsetMin;
        XY.X.NewMax:= axis.Range.Min+XY.X.offsetMax;
        axis.Range.Min:=XY.X.NewMin;
        axis.Range.Max:=XY.X.NewMax;
      end;
    end;
  end;

  Mouse_.IsDrag:=false;
  Mouse_.X1:=0;
  Mouse_.X2:=0;
  Mouse_.Y1:=0;
  Mouse_.Y2:=0;

  DefaultConstantLine.Active:=not DefaultConstantLine.Active;
end;

procedure TForm2.DeleteAxisClick(Sender: TObject);
var
  ChartSeries_:TBasicChartSeries;
  i:integer;
begin
  if Mouse_.LeftIndex >= 2 then
  begin
    Timer1.Enabled:=false;

    //for ChartSeries_ in Chart1.Series do
    //begin
    //  if ChartSeries_ is TLineSeries then
    //  begin
    //    i:=TLineSeries(ChartSeries_).AxisIndexY;
    //    showmessage(ChartSeries_.Index.ToString + ' '+ i.ToString);
    //  end;
    //end;

    Chart1.Series[Mouse_.LeftIndex].Destroy;
    Chart1.AxisList[Mouse_.LeftIndex].Transformations.Destroy;
    Chart1.AxisList[Mouse_.LeftIndex].Destroy;

    Delete(V_Control, Mouse_.LeftIndex, 1);

    for ChartSeries_ in Chart1.Series do
    begin
      if ChartSeries_ is TLineSeries then
      TLineSeries(ChartSeries_).AxisIndexY:= ChartSeries_.Index;
    end;

    Timer1.Enabled:=true;
  end;
end;

end.

