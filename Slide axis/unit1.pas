unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, TAGraph, TASeries, TATransformations, TATools, Types, TADrawUtils,
  TAChartAxis, typinfo, TAChartAxisUtils, math, TATypes, Variants, TAChartUtils,
  TASources, TACustomSource;

type
  MouseRec = record
    IsDrag:boolean;
    LeftDown:boolean;
    RightDown:boolean;
    LeftIndex:integer;
    BottomIndex:integer;
    DownLeftIndex:integer;
    DownBottomIndex:integer;
    DownSeriesStep:Double;
    X1: integer;
    X2: integer;
    Y1: integer;
    Y2: integer;
  end;

type
  VerticalControl = record
    ManualVartical:boolean;
    AutoRangeControl:boolean;
    AutoVartical:boolean;
  end;

type
  ChartRec_ = record
    ChartForwardCmd:boolean;
    HorizontalSpace:double;
    HorizontalDistance:double;
    IsInside:boolean;
    IsOutside:boolean;
    X1: integer;
    X2: integer;
    Y1: integer;
    Y2: integer;
    ALB:integer;
    AUB:integer;
  end;

type
  abdor_ = record
    Min:double;
    Max:double;
    d: double;
    offsetMin: double;
    offsetMax: double;
    NewMin: double;
    NewMax: double;
  end;

type
  XY_ = record
    X:abdor_;
    Y:abdor_;
  end;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    DefaultSeries: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartAxisTransformations1AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartAxisTransformations2: TChartAxisTransformations;
    ChartAxisTransformations2AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartAxisTransformations3: TChartAxisTransformations;
    ChartAxisTransformations3AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartAxisTransformations4: TChartAxisTransformations;
    ChartAxisTransformations4AutoScaleAxisTransform1: TAutoScaleAxisTransform;
    ChartToolset1: TChartToolset;
    ChartToolset1AxisClickTool1: TAxisClickTool;
    ChartToolset1UserDefinedTool1: TUserDefinedTool;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DefaultSource: TListChartSource;
    ListChartSource1: TListChartSource;
    ListChartSource2: TListChartSource;
    Memo1: TMemo;
    Memo2: TMemo;
    UseCurrentHorizental: TMenuItem;
    BottomAxisMenu: TPopupMenu;
    LeftAxisMenu: TPopupMenu;
    ManualVartical: TMenuItem;
    AutoHorizental: TMenuItem;
    AutoRangeControl: TMenuItem;
    AutoVartical: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Timer1: TTimer;
    procedure AutoHorizentalClick(Sender: TObject);
    procedure AutoRangeControlClick(Sender: TObject);
    procedure AutoVarticalClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Chart1AfterCustomDrawBackWall(ASender: TChart;
      ADrawer: IChartDrawer; const ARect: TRect);
    procedure Chart1AfterDrawBackground(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
    procedure Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
    procedure Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
      AMark: Double);
    procedure Chart1DblClick(Sender: TObject);
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
    procedure ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure ManualVarticalClick(Sender: TObject);
    procedure UseCurrentHorizentalClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    procedure FindSourceYRangeManually(Source: TListChartSource; MinX, MaxX: Double; var MinY, MaxY: Double);
  end;

var
  Form1: TForm1;
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

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FindSourceYRangeManually(Source: TListChartSource; MinX, MaxX: Double; var MinY, MaxY: Double);
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

procedure PrintAllPropertyValues(Obj: TObject; OutputStrings: TStrings);
var
  PropCount: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
  I: Integer;
  ValName, ValType, ValStr: string;
begin
  OutputStrings.Clear;
  // Get the total number of properties and the property list
  PropCount := GetPropList(Obj, PropList);
  try
    for I := 0 to PropCount - 1 do
    begin
      PropInfo := PropList^[I];
      ValName := PropInfo^.Name;
      ValType := PropInfo^.PropType^.Name;

      // Get the value of the property as a variant/string
      ValStr := VarToStr(GetPropValue(Obj, ValName));

      OutputStrings.Add(Format('%s %s %s', [ValName , ValType,  ValStr]));
    end;
  finally
    // Free the allocated property list memory
    FreeMem(PropList);
  end;
end;

procedure EnumFields(RecInfo: PTypeInfo; OutputStrings: TStrings);
var
  Data: PTypeData;
  i: Integer;
  MF: PManagedField;
begin
  OutputStrings.Clear;
  if not Assigned(RecInfo) or (RecInfo^.Kind <> tkRecord) then
    Exit;
  OutputStrings.Add(Format('%s %s', ['Record type=', RecInfo^.Name]));
  Data := GetTypeData(RecInfo);
  MF := Pointer(PByte(@Data^.ManagedFldCount) + SizeOf(Data^.ManagedFldCount));
  for i := 1 to Data^.ManagedFldCount do
  begin
    OutputStrings.Add(Format('%s %s %s %s', ['Type=', MF^.TypeRef^.Name, ' offset=', MF^.FldOffset.ToString]));
    Inc(MF);
  end;
end;

procedure ListObjectProperties(AObject: TObject; OutputStrings: TStrings);
var
  PropCount, Size, I: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
  PropValue: string;
begin
  //OutputStrings.Clear;
  if AObject = nil then Exit;

  // 1. Get the total count of properties available for this class type
  PropCount := GetPropList(AObject.ClassInfo, tkAny, nil);

  if PropCount > 0 then
  begin
    // 2. Allocate memory for the property list pointer array
    Size := PropCount * SizeOf(Pointer);
    GetMem(PropList, Size);
    try
      // 3. Populate the list with actual property data
      GetPropList(AObject.ClassInfo, tkAny, PropList);

      // 4. Loop through each property
      for I := 0 to PropCount - 1 do
      begin
        PropInfo := PropList^[I];

        // Skip methods/events if you only want traditional data properties
        if PropInfo^.PropType^.Kind in tkMethods then
          Continue;

        // 5. Fetch the current value of the property safely as a string
        PropValue := GetPropValue(AObject, PropInfo^.Name);

        // Add to your list: PropertyName = CurrentValue
        OutputStrings.Add(Format('%s = %s', [PropInfo^.Name, PropValue]));
      end;
    finally
      // 6. Always clean up allocated memory
      FreeMem(PropList, Size);
    end;
  end;
end;

procedure TForm1.ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
  APoint: TPoint);
begin

end;

procedure TForm1.Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
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
  //ACanvas.Brush.Color := RgbToColor(255, 240, 240);
  //ACanvas.FillRect(
  //    Chart1.XGraphToImage(-0.8),   //LeftLine
  //    Chart1.YGraphToImage(0.8),  //TopLine
  //    Chart1.XGraphToImage(0.8), //RightLine
  //    Chart1.YGraphToImage(-0.8) //BottomLine
  //  );
  //
  //ACanvas.Pen.Color := clBlue;
  //ACanvas.Line(ARect.Left, (ARect.Top + ARect.Bottom) div 2, ARect.Right, (ARect.Top + ARect.Bottom) div 2);
end;

procedure TForm1.Chart1AxisList1GetMarkText(Sender: TObject; var AText: String;
  AMark: Double);
begin
  if AMark>40000 then
  AText := TimeToStr(AMark); //DateToStr(AMark);
end;

procedure TForm1.Chart1DblClick(Sender: TObject);
begin
  ChartRec.ChartForwardCmd:=true;
end;

procedure TForm1.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
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
  //if ChartLiveView1.Active then
  //begin
  //
  //  if Chart1.AxisList.Count > 0 then
  //  begin
  //    SetLength(Data_range, Chart1.AxisList.Count);
  //    for i:=Low(Data_range) to High(Data_range) do
  //    begin
  //      Data_range[i] := TChartRange.Create(Chart1);
  //    end;
  //
  //    i:=Low(Data_range);
  //    for axis in Chart1.AxisList do
  //    begin
  //      Data_range[i].Assign(axis.Range);
  //      i:=i+1;
  //    end;
  //  end;
  //
  //  ////Bottom_range := Chart1.BottomAxis.Range;
  //  //NewExtent := Chart1.LogicalExtent;
  //  ChartLiveView1.Active:=false;
  //  //Chart1.Extent.XMax:=NewExtent.b.X;
  //  //Chart1.Extent.Xmin:=NewExtent.a.X;
  //  //Chart1.Extent.UseXMax:=true;
  //  //Chart1.Extent.UseXMin:=true;
  //  //Chart1.Extent.FixTo(NewExtent);
  //  ////Chart1.BottomAxis.Range:=Bottom_range;
  //
  //  if Chart1.AxisList.Count > 0 then
  //  begin
  //
  //    i:=Low(Data_range);
  //    for axis in Chart1.AxisList do
  //    begin
  //      axis.Range.Assign(Data_range[i]);
  //      i:=i+1;
  //    end;
  //
  //    for i:=Low(Data_range) to High(Data_range) do
  //    begin
  //      Data_range[i].Free;
  //    end;
  //  end;
  //end;


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
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if ChartSeries_ is TLineSeries then
      if TLineSeries(ChartSeries_).AxisIndexY=Mouse_.DownLeftIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        //MouseDownSeriesStep:=0.003/ABS(Chart1.Series[MouseDownSeries].AxisToGraphY(Y)-Chart1.Series[MouseDownSeries].AxisToGraphY(Y+1));// .AxisToGraphY(Y);
        //Mouse_.DownSeriesStep:=ABS(MouseDownRangeMin-MouseDownRangeMax)/chart1.Height;
        Mouse_.DownSeriesStep:=ABS(MouseDownRangeMin-MouseDownRangeMax)/ABS(ChartRec.Y2-ChartRec.Y1);
      end;
    end;
  end;

  if (Mouse_.BottomIndex >= 0) and ( not Mouse_.LeftDown) then
  begin
    ChartRec.ChartForwardCmd:=false;
    Mouse_.LeftDown:=true;
    Mouse_.DownBottomIndex:= Mouse_.BottomIndex;
    //ChartLiveView1.Active:=false;
    MouseDownX_Start:=X;
    MouseDownX_Current:=X;
    //MouseDownRangeMin:=Chart1.LogicalExtent.a.X;
    //MouseDownRangeMax:=Chart1.LogicalExtent.b.X;
    //Chart1.AxisList[MouseDownBottomIndex].Range.Min:=Chart1.LogicalExtent.a.X;
    //Chart1.AxisList[MouseDownBottomIndex].Range.Max:=Chart1.LogicalExtent.b.X;
    //Chart1.AxisList[MouseDownBottomIndex].Range.UseMin:=true;
    //Chart1.AxisList[MouseDownBottomIndex].Range.UseMax:=true;
    MouseDownRangeMin:=Chart1.AxisList[Mouse_.DownBottomIndex].Range.Min;
    MouseDownRangeMax:=Chart1.AxisList[Mouse_.DownBottomIndex].Range.Max;
    MouseDownSeries:=-1;
    for ChartSeries_ in Chart1.Series do
    begin
      if ChartSeries_ is TLineSeries then
      if TLineSeries(ChartSeries_).AxisIndexX=Mouse_.DownBottomIndex then
      begin
        MouseDownSeries:=TLineSeries(ChartSeries_).Index;
        //Mouse_.DownSeriesStep:=1*(ABS(MouseDownRangeMin-MouseDownRangeMax)/chart1.ChartWidth);
        Mouse_.DownSeriesStep:=1*(ABS(MouseDownRangeMin-MouseDownRangeMax)/ABS(ChartRec.X2-ChartRec.X1));
      end;
    end;
  end;
  //Label6.Caption:='X : '+X.ToString;
  //Label7.Caption:='Y : '+Y.ToString;

  if Mouse_.DownBottomIndex > 0 then
  begin
    //Label10.Caption:='Bottom Min : '+Chart1.AxisList[MouseDownBottomIndex].Range.Min.ToString+' / ' +TimeToStr(Chart1.AxisList[MouseDownBottomIndex].Range.Min);
    //Label12.Caption:='Bottom Max : '+Chart1.AxisList[MouseDownBottomIndex].Range.Max.ToString+' / ' +TimeToStr(Chart1.AxisList[MouseDownBottomIndex].Range.Max);
  end
  else
  begin
    //Label10.Caption:='Bottom Min : ';
    //Label12.Caption:='Bottom Max : ';
  end;


  if ( not Mouse_.LeftDown) then  begin Mouse_.DownLeftIndex:=-1; Mouse_.DownBottomIndex:=-1; exit; end;

end;

procedure TForm1.Chart1MouseLeave(Sender: TObject);
begin
  Chart1.Cursor:=crDefault;
  Mouse_.RightDown:=false;
  Mouse_.LeftDown:=false;
  Mouse_.DownLeftIndex:=-1;
  Mouse_.DownBottomIndex:=-1;
  Mouse_.DownSeriesStep:=0;
end;

procedure TForm1.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i:integer;
  axis:TChartAxis;
  Axis_Width:integer;
  Axis_Height:integer;
begin

  //Chart Frame
  //i:=Chart1.MarginsExternal.Left;
  //for axis in Chart1.AxisList do
  //begin
  //  if axis.Alignment =TChartAxisAlignment.calLeft then
  //  begin
  //    Axis_Width:=axis.MeasureLabelSize(Chart1.Drawer);
  //    i:=i+Axis_Width;
  //  end;
  //end;
  //Axis_Width:=i;
  //
  //i:=Chart1.MarginsExternal.Bottom;
  //for axis in Chart1.AxisList do
  //begin
  //  if axis.Alignment =TChartAxisAlignment.calBottom then
  //  begin
  //    Axis_Height:=axis.MeasureLabelSize(Chart1.Drawer);
  //    i:=i+Axis_Height;
  //  end;
  //end;
  //Axis_Height:=i;
  //
  //ChartRec.X1:=Axis_Width+1;
  //ChartRec.X2:=(Chart1.Width-Chart1.MarginsExternal.Right-1);
  //ChartRec.Y1:=Chart1.MarginsExternal.Top+4;
  //ChartRec.Y2:=Chart1.Height-Axis_Height-1;
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

procedure TForm1.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Chart1.Cursor:=crDefault;
  Mouse_.RightDown:=false;
  Mouse_.LeftDown:=false;
  Mouse_.DownLeftIndex:=-1;
  Mouse_.DownBottomIndex:=-1;
  Mouse_.DownSeriesStep:=0;
end;

procedure TForm1.ChartToolset1AxisClickTool1BeforeMouseWheelDown(
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
    Label14.Caption:=FullDistance.ToString;//+'%';

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

procedure TForm1.ChartToolset1AxisClickTool1BeforeMouseWheelUp(
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
    Label14.Caption:=FreePercent.ToString+'%';

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

procedure TForm1.Chart1AfterCustomDrawBackWall(ASender: TChart;
  ADrawer: IChartDrawer; const ARect: TRect);
begin
  //ADrawer.SetBrushColor(clMoneyGreen);
  ////ADrawer.SetBrushStyle(bsSolid);
  //ADrawer.FillRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);

  //ADrawer.SetBrushColor(RgbToColor(255, 240, 240));
  //ADrawer.FillRect(
  //    Chart1.XGraphToImage(-0.8),   //LeftLine
  //    Chart1.YGraphToImage(0.8),  //TopLine
  //    Chart1.XGraphToImage(0.8), //RightLine
  //    Chart1.YGraphToImage(-0.8) //BottomLine
  //  );
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  NewExtent: TDoubleRect;
begin
  Memo1.Clear;
  //PrintAllPropertyValues(Chart1, Memo1.Lines);
  //ListObjectProperties(Chart1, Memo1.Lines);
  ListObjectProperties(Chart1.Extent, Memo1.Lines);
  ListObjectProperties(Chart1.ExtentSizeLimit, Memo1.Lines);
  //EnumFields(TypeInfo(Chart1.LogicalExtent.a), Memo2.Lines);
  //Memo2.Clear;
  //Memo2.Lines.Add('a.X : '+Chart1.LogicalExtent.a.X.ToString);
  //Memo2.Lines.Add('a.Y : '+Chart1.LogicalExtent.a.Y.ToString);
  //Memo2.Lines.Add('b.X : '+Chart1.LogicalExtent.b.X.ToString);
  //Memo2.Lines.Add('b.Y : '+Chart1.LogicalExtent.b.Y.ToString);
  //
  //Memo2.Lines.Add('BottomAxis.Range.Min : '+Chart1.BottomAxis.Range.Min.ToString);
  //Memo2.Lines.Add('BottomAxis.Range.Max : '+Chart1.BottomAxis.Range.Max.ToString);
  //
  //Memo2.Lines.Add('Prev a.X : '+Chart1.PrevLogicalExtent.a.X.ToString);
  //Memo2.Lines.Add('Prev a.Y : '+Chart1.PrevLogicalExtent.a.Y.ToString);
  //Memo2.Lines.Add('Prev b.X : '+Chart1.PrevLogicalExtent.b.X.ToString);
  //Memo2.Lines.Add('Prev b.Y : '+Chart1.PrevLogicalExtent.b.Y.ToString);
  //
  //NewExtent:= Chart1.LogicalExtent;
  //Chart1.ZoomFull;
  //
  //ListObjectProperties(Chart1.Extent, Memo1.Lines);
  //ListObjectProperties(Chart1.ExtentSizeLimit, Memo1.Lines);
  //Memo2.Lines.Add('a.X : '+Chart1.LogicalExtent.a.X.ToString);
  //Memo2.Lines.Add('a.Y : '+Chart1.LogicalExtent.a.Y.ToString);
  //Memo2.Lines.Add('b.X : '+Chart1.LogicalExtent.b.X.ToString);
  //Memo2.Lines.Add('b.Y : '+Chart1.LogicalExtent.b.Y.ToString);
  //
  //Memo2.Lines.Add('BottomAxis.Range.Min : '+Chart1.BottomAxis.Range.Min.ToString);
  //Memo2.Lines.Add('BottomAxis.Range.Max : '+Chart1.BottomAxis.Range.Max.ToString);
  //
  //Memo2.Lines.Add('Prev a.X : '+Chart1.PrevLogicalExtent.a.X.ToString);
  //Memo2.Lines.Add('Prev a.Y : '+Chart1.PrevLogicalExtent.a.Y.ToString);
  //Memo2.Lines.Add('Prev b.X : '+Chart1.PrevLogicalExtent.b.X.ToString);
  //Memo2.Lines.Add('Prev b.Y : '+Chart1.PrevLogicalExtent.b.Y.ToString);
  //
  //Chart1.LogicalExtent:=NewExtent;

  Chart1.Extent.XMin :=Now()-0.00010;
  Chart1.Extent.XMax :=Now()+0.00005;
  Chart1.Extent.UseXMin:=not Chart1.Extent.UseXMin;
  Chart1.Extent.UseXMax:=not Chart1.Extent.UseXMax;
end;

procedure TForm1.AutoHorizentalClick(Sender: TObject);
begin
  //0.000005 = 500ms
  ChartRec.HorizontalSpace:=0.000005*((120/100)*20); //20% of 60Sec
  ChartRec.HorizontalDistance:=0.000005*((120/100)*80);  //100%-HorizontalSpace  //80% of 60Sec
  ChartRec.ChartForwardCmd:=true;
end;

procedure TForm1.AutoRangeControlClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=true;
    V_Control[Mouse_.LeftIndex].ManualVartical:=false;
    V_Control[Mouse_.LeftIndex].AutoVartical:=false;
  end;
end;

procedure TForm1.AutoVarticalClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].AutoVartical:=true;
    V_Control[Mouse_.LeftIndex].ManualVartical:=false;
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
  end;
end;

procedure TForm1.Chart1AfterDrawBackground(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect);
begin
  //ACanvas.Brush.Color := RgbToColor(255, 240, 240);
  //ACanvas.FillRect(
  //    Chart1.XGraphToImage(-0.8),   //LeftLine
  //    Chart1.YGraphToImage(0.8),  //TopLine
  //    Chart1.XGraphToImage(0.8), //RightLine
  //    Chart1.YGraphToImage(-0.8) //BottomLine
  //  );
end;

procedure TForm1.ChartToolset1UserDefinedTool1AfterMouseMove(ATool: TChartTool;
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
  Chart1ConstantLine1.Position:=0;
  Chart1ConstantLine1.Active:=not Chart1ConstantLine1.Active;

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

  //XY.Y.Min:= Chart1.LeftAxis.Range.Min;
  //XY.Y.Max:= Chart1.LeftAxis.Range.Max;
  //XY.Y.d:= XY.Y.Max-XY.Y.Min;
  //XY.Y.offsetMin:= XY.Y.d*Chart1.YImageToGraph(Mouse_.Y2);
  //XY.Y.offsetMax:= XY.Y.d*Chart1.YImageToGraph(Mouse_.Y1);
  //XY.Y.NewMin:= Chart1.LeftAxis.Range.Min+XY.Y.offsetMin;
  //XY.Y.NewMax:= Chart1.LeftAxis.Range.Min+XY.Y.offsetMax;
  //
  //XY.X.Min:= Chart1.BottomAxis.Range.Min;
  //XY.X.Max:= Chart1.BottomAxis.Range.Max;
  //XY.X.d:= XY.X.Max-XY.X.Min;
  //XY.X.offsetMin:= XY.X.d*Chart1.XImageToGraph(Mouse_.X1);
  //XY.X.offsetMax:= XY.X.d*Chart1.XImageToGraph(Mouse_.X2);
  //XY.X.NewMin:= Chart1.BottomAxis.Range.Min+XY.X.offsetMin;
  //XY.X.NewMax:= Chart1.BottomAxis.Range.Min+XY.X.offsetMax;
  //
  //Label1.Caption:= XY.X.offsetMin.ToString;
  //Label2.Caption:= XY.X.offsetMax.ToString;
  //Label3.Caption:= XY.X.NewMin.ToString;
  //Label4.Caption:= XY.X.NewMax.ToString;
  //
  //Label5.Caption:= XY.Y.offsetMin.ToString;
  //Label6.Caption:= XY.Y.offsetMax.ToString;
  //Label7.Caption:= XY.Y.NewMin.ToString;
  //Label8.Caption:= XY.Y.NewMax.ToString;

  //Label9.Caption:= Chart1.LeftAxis.ValueCount.ToString;
  //Label10.Caption:= Chart1.BottomAxis.ValueCount.ToString;
end;

procedure TForm1.ChartToolset1UserDefinedTool1AfterMouseUp(ATool: TChartTool;
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

  Chart1ConstantLine1.Active:=not Chart1ConstantLine1.Active;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  t:double;
  i:integer;
begin
  t:=now();
  t:=t-(0.000005*120);    //500ms x 120 =60sec
  for i := 0 to 119 do
  begin
    DefaultSource.Add(t,0);
    ListChartSource1.Add(t,RandG(56.1, 9.5));
    ListChartSource2.Add(t,RandG(56.1, 90.5));
    t:=t+0.000005
  end;

  ChartRec.X1:=Chart1.ClipRect.Left+1;
  ChartRec.X2:=Chart1.ClipRect.Right-1;
  ChartRec.Y1:=Chart1.ClipRect.Top+1;
  ChartRec.Y2:=Chart1.ClipRect.Bottom-1;

  ChartRec.ChartForwardCmd:=true;
  //0.000005 = 500ms
  ChartRec.HorizontalSpace:=0.000005*((120/100)*20); //20% of 60Sec
  ChartRec.HorizontalDistance:=0.000005*((120/100)*80);  //100%-HorizontalSpace  //80% of 60Sec

  Mouse_.IsDrag:=false;
  Mouse_.X1:=0;
  Mouse_.X2:=0;
  Mouse_.Y1:=0;
  Mouse_.Y2:=0;
  Chart1ConstantLine1.Position:=0;
  Chart1ConstantLine1.SeriesColor:=clNone;
  Chart1ConstantLine1.Pen.Color:=clNone;
  Chart1ConstantLine1.Pen.Style:=psClear;

  SetLength(V_Control, Chart1.AxisList.Count);
  for i:=0 to Chart1.AxisList.Count-1 do
  begin
    V_Control[i].ManualVartical:=false;
    V_Control[i].AutoRangeControl:=false;
    V_Control[i].AutoVartical:=true;
  end;
end;

procedure TForm1.ManualVarticalClick(Sender: TObject);
begin
  if Mouse_.LeftIndex >= 0 then
  begin
    V_Control[Mouse_.LeftIndex].ManualVartical:=true;
    V_Control[Mouse_.LeftIndex].AutoRangeControl:=false;
    V_Control[Mouse_.LeftIndex].AutoVartical:=false;
  end;

end;

procedure TForm1.UseCurrentHorizentalClick(Sender: TObject);
begin
  timer1.Enabled:=false;
  ChartRec.HorizontalDistance:= ListChartSource1.Extent.b.X - Chart1.BottomAxis.Range.Min;
  ChartRec.HorizontalSpace:=Chart1.BottomAxis.Range.Max-ListChartSource1.Extent.b.X;
  ChartRec.ChartForwardCmd:=true;
  timer1.Enabled:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  t:double;
  YMin:double;
  YMax:double;
  i:integer;
  ChartSeries_:TBasicChartSeries;
begin
  t:=Now();
  label1.Caption:='t : ' + t.ToString;
  label2.Caption:='Time : ' + TimeToStr(t);
  DefaultSource.Add(t,0);
  ListChartSource1.Add(t,RandG(56.1, 9.5));
  ListChartSource2.Add(t,RandG(56.1, 90.5));

  label3.Caption:=ListChartSource1.XOfMin().ToString;
  label4.Caption:=ListChartSource1.XOfMax(ListChartSource1.Count-1).ToString;
  label5.Caption:='Count : '+ListChartSource1.Count.ToString;
  label6.Caption:='Xmin/Xmax : '+ListChartSource1.Extent.a.X.ToString+' / '+ListChartSource1.Extent.b.X.ToString;
  label7.Caption:='XCount : '+ListChartSource1.XCount.ToString;
  label8.Caption:='ValuesTotal : '+ListChartSource1.ValuesTotal.ToString;
  label9.Caption:=ListChartSource1.Item[ListChartSource1.Count-1]^.Y.ToString;
  label10.Caption:='Ymin/Ymax : '+ListChartSource1.Extent.a.Y.ToString+' / '+ListChartSource1.Extent.b.Y.ToString;

  ListChartSource1.FindBounds(Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,ChartRec.ALB,ChartRec.AUB);
  label11.Caption:='ALB/AUB : '+ChartRec.ALB.ToString+' / '+ChartRec.AUB.ToString;

  //ListChartSource1.FindYRange(Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,true,YMin,YMax);
  FindSourceYRangeManually(ListChartSource1,Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,YMin,YMax);
  label12.Caption:='YMin/YMax : '+YMin.ToString+' / '+YMax.ToString;
  //chart1.AxisList[2].Range.Min:=ListChartSource1.Extent.a.Y;
  //chart1.AxisList[2].Range.Max:=ListChartSource1.Extent.b.Y;

  if ChartRec.ChartForwardCmd then
  begin
    chart1.AxisList[1].Range.Min:=t-ChartRec.HorizontalDistance;
    chart1.AxisList[1].Range.Max:=t+ChartRec.HorizontalSpace;
  end;

  for ChartSeries_ in Chart1.Series do
  begin
    if ChartSeries_ is TLineSeries then
    if ChartSeries_.Index>0 then
    if TLineSeries(ChartSeries_).AxisIndexY>=2 then
    begin
      i:=TLineSeries(ChartSeries_).AxisIndexY;
      if V_Control[i].AutoVartical then
      begin
        YMin:=TLineSeries(ChartSeries_).Source.Extent.a.Y;
        if (YMin+TLineSeries(ChartSeries_).Source.Extent.b.Y)<(YMin-TLineSeries(ChartSeries_).Source.Extent.b.Y) then
          YMin:=YMin+(TLineSeries(ChartSeries_).Source.Extent.b.Y/2)
        else
          YMin:=YMin-(TLineSeries(ChartSeries_).Source.Extent.b.Y/2);
        chart1.AxisList[i].Range.Min:=YMin;
        chart1.AxisList[i].Range.Max:=TLineSeries(ChartSeries_).Source.Extent.b.Y*1.5;
      end;
      if V_Control[i].AutoRangeControl then
      begin
        FindSourceYRangeManually(TListChartSource(TLineSeries(ChartSeries_).Source),Chart1.BottomAxis.Range.Min,Chart1.BottomAxis.Range.Max,YMin,YMax);
        if YMin>0 then YMin:=0;
        if YMin<0 then YMin:=YMin*1.5;
        chart1.AxisList[i].Range.Min:=YMin;
        chart1.AxisList[i].Range.Max:=YMax*1.5;
      end;
    end;
  end;


  //YMin:=ListChartSource1.Extent.a.Y;
  //if (YMin+ListChartSource1.Extent.b.Y)<(YMin-ListChartSource1.Extent.b.Y) then YMin:=YMin+(ListChartSource1.Extent.b.Y/2)  else  YMin:=YMin-(ListChartSource1.Extent.b.Y/2);
  //chart1.AxisList[2].Range.Min:=YMin;
  //chart1.AxisList[2].Range.Max:=ListChartSource1.Extent.b.Y*1.5;

  //YMin:=ListChartSource2.Extent.a.Y;
  //if (YMin+ListChartSource2.Extent.b.Y)<(YMin-ListChartSource2.Extent.b.Y) then YMin:=YMin+(ListChartSource2.Extent.b.Y/2)  else  YMin:=YMin-(ListChartSource2.Extent.b.Y/2);
  //label13.Caption:='YMin/YMax : '+ListChartSource2.Extent.a.Y.ToString+' / '+ListChartSource2.Extent.b.Y.ToString;
  //chart1.AxisList[3].Range.Min:=YMin;
  //chart1.AxisList[3].Range.Max:=ListChartSource2.Extent.b.Y*1.5;
end;

end.

