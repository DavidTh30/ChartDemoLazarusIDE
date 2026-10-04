unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, TASources, graphics;

const
  AutoColor = $00F0F0F0;
  ManualColor = $000080FF;
  StartColor = $00C0DCC0;
  StopColor = $00F0F0F0;
  InRangeColor = $0000BE00;
  OutRangeColor = $000505FF;
  EnableColor = $00F0F0F0;
  DisableColor = $00C8C8C8;
  FaultColor= $000000FF;

type
  N_Property= record   //Sub Property
    PropertyName:string;
    Source: TListChartSource;
    GuideMin: double;   // Make easy for vertical axis
    GuideMax: double;   // Make easy for vertical axis
    IsDigital:boolean;
    PropertyIndex:integer;  // Make easy to find
  end;

type
  Device_ = record
    DeviceType:string;
    DeviceIndex:integer; // Make easy to find
    Enable: boolean;
    InRange: boolean;
    Start: boolean;
    Auto: boolean;
    Fault: boolean;
    Setpoint:double;
    Actual:double;
    Gain:double;
    DeviceName:string;
    ObjectNumber:string;
    Enable_:N_Property;
    Start_:N_Property;
    Auto_:N_Property;
    Fault_:N_Property;
    Setpoint_:N_Property;
    Actual_:N_Property;
    Gain_:N_Property;
  end;

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

    VerDevProName:string;  //Vertical Device Property Name
    DeviceIndex:integer;
    PropertyIndex:integer;
    IsDigital:boolean;
    GuideMin:double;
    GuideMax:double;
    OffsetMin:double;
    OffsetMax:double;
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

  var
    Heater : array of Device_;
    DefaultData:TListChartSource;
    Standard16Colors: array[0..15] of TColor;

implementation

end.

