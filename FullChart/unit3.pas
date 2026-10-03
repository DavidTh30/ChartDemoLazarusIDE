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
  Heater_ = record
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
    EnableData:TListChartSource;
    StartData:TListChartSource;
    AutoData:TListChartSource;
    FaultData:TListChartSource;
    SetpointData:TListChartSource;
    ActualData:TListChartSource;
    GainData:TListChartSource;
  end;

  var
    Heater : array of Heater_;
    DefaultData:TListChartSource;
    Standard16Colors: array[0..15] of TColor;

implementation

end.

