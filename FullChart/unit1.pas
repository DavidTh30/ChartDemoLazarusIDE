unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  StdCtrls, TASources, math, TASeries, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    Actual02: TLabel;
    Gain02: TLabel;
    AutoManualMenu: TMenuItem;
    AutoMenu: TMenuItem;
    ManualMenu: TMenuItem;
    AutoManual01: TLabel;
    Name02: TLabel;
    AutoManual02: TLabel;
    Panel2: TPanel;
    Set02: TLabel;
    EnableDisable01: TShape;
    EnableDisable02: TShape;
    StartMenu: TMenuItem;
    StopMenu: TMenuItem;
    DisableMenu: TMenuItem;
    EnableMenu: TMenuItem;
    HistoryMenu: TMenuItem;
    PopupMenu1: TPopupMenu;
    Separator1: TMenuItem;
    Set01: TLabel;
    Gain01: TLabel;
    MainMenu1: TMainMenu;
    ChartMenu: TMenuItem;
    Panel1: TPanel;
    Actual01: TLabel;
    Name01: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure AutoMenuClick(Sender: TObject);
    procedure ChartMenuClick(Sender: TObject);
    procedure DisableMenuClick(Sender: TObject);
    procedure EnableMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HistoryMenuClick(Sender: TObject);
    procedure ManualMenuClick(Sender: TObject);
    procedure StartMenuClick(Sender: TObject);
    procedure StopMenuClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private

  public
    procedure InitData(Index_:integer);
    procedure HeaterEvents(ObjectNumber:string; Index_:integer);
    procedure HeaterProcess(ObjectNumber:string; Index_:integer);
    procedure AddData(Index_:integer);
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2;

{$R *.lfm}

{ TForm1 }

procedure TForm1.AddData(Index_:integer);
var
t:double;
i:integer;
begin

  if (Index_ < Low(Heater)) or (Index_> High(Heater)) then exit;

  t:=Now();
  Heater[Index_].Enable_.Source.Add(t,Heater[Index_].Enable.ToInteger);
  Heater[Index_].Start_.Source.Add(t,Heater[Index_].Start.ToInteger);  //Add(t,RandG(56.1, 9.5));
  Heater[Index_].Auto_.Source.Add(t,Heater[Index_].Auto.ToInteger);  //Add(t,RandG(56.1, 90.5));
  Heater[Index_].Fault_.Source.Add(t,Heater[Index_].Fault.ToInteger);
  Heater[Index_].Setpoint_.Source.Add(t,Heater[Index_].Setpoint);  //Add(t,RandG(56.1, 9.5));
  Heater[Index_].Actual_.Source.Add(t,Heater[Index_].Actual);  //Add(t,RandG(56.1, 90.5));
  Heater[Index_].Gain_.Source.Add(t,Heater[Index_].Gain);
end;

procedure TForm1.InitData(Index_:integer);
var
t:double;
i:integer;
begin

  if Index_ < 0 then
  begin
    DefaultData:=TListChartSource.Create(Form1);
    DefaultData.Name:='DefaultData_';
    t:=Now();
    t:=t-(0.000005*120*7);    //500ms x 120 x 7 = 60sec x 7
    for i := 0 to 119*7 do
    begin
      DefaultData.Add(t,0);
      t:=t+0.000005
    end;
    exit;
  end;

  Heater[Index_].Enable_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Enable_.Source.Name:='Enable_'+IntToStr(Index_);
  Heater[Index_].Enable_.PropertyName:='Enable';
  Heater[Index_].Enable_.PropertyIndex:=0;
  Heater[Index_].Enable_.GuideMin:=-0.5;
  Heater[Index_].Enable_.GuideMax:=1.5;
  Heater[Index_].Enable_.IsDigital:=true;

  Heater[Index_].Start_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Start_.Source.Name:='Start_'+IntToStr(Index_);
  Heater[Index_].Start_.PropertyName:='Start';
  Heater[Index_].Start_.PropertyIndex:=1;
  Heater[Index_].Start_.GuideMin:=-0.5;
  Heater[Index_].Start_.GuideMax:=1.5;
  Heater[Index_].Start_.IsDigital:=true;

  Heater[Index_].Auto_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Auto_.Source.Name:='Auto_'+IntToStr(Index_);
  Heater[Index_].Auto_.PropertyName:='Auto';
  Heater[Index_].Auto_.PropertyIndex:=2;
  Heater[Index_].Auto_.GuideMin:=-0.5;
  Heater[Index_].Auto_.GuideMax:=1.5;
  Heater[Index_].Auto_.IsDigital:=true;

  Heater[Index_].Fault_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Fault_.Source.Name:='Fault_'+IntToStr(Index_);
  Heater[Index_].Fault_.PropertyName:='Fault';
  Heater[Index_].Fault_.PropertyIndex:=3;
  Heater[Index_].Fault_.GuideMin:=-0.5;
  Heater[Index_].Fault_.GuideMax:=1.5;
  Heater[Index_].Fault_.IsDigital:=true;

  Heater[Index_].Setpoint_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Setpoint_.Source.Name:='Setpoint_'+IntToStr(Index_);
  Heater[Index_].Setpoint_.PropertyName:='Setpoint';
  Heater[Index_].Setpoint_.PropertyIndex:=4;
  Heater[Index_].Setpoint_.GuideMin:=0;
  Heater[Index_].Setpoint_.GuideMax:=0;
  Heater[Index_].Setpoint_.IsDigital:=false;

  Heater[Index_].Actual_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Actual_.Source.Name:='Actual_'+IntToStr(Index_);
  Heater[Index_].Actual_.PropertyName:='Actual';
  Heater[Index_].Actual_.PropertyIndex:=5;
  Heater[Index_].Actual_.GuideMin:=0;
  Heater[Index_].Actual_.GuideMax:=0;
  Heater[Index_].Actual_.IsDigital:=false;

  Heater[Index_].Gain_.Source:=TListChartSource.Create(Form1);
  Heater[Index_].Gain_.Source.Name:='Gain_'+IntToStr(Index_);
  Heater[Index_].Gain_.PropertyName:='Gain';
  Heater[Index_].Gain_.PropertyIndex:=6;
  Heater[Index_].Gain_.GuideMin:=-110;
  Heater[Index_].Gain_.GuideMax:=110;
  Heater[Index_].Gain_.IsDigital:=false;

  t:=Now();

  t:=t-(0.000005*120*7);    //500ms x 120 x 7 = 60sec x 7
  for i := 0 to 119*7 do
  begin
    Heater[Index_].Enable_.Source.Add(t,0);
    Heater[Index_].Start_.Source.Add(t,0);  //Add(t,RandG(56.1, 9.5));
    Heater[Index_].Auto_.Source.Add(t,0);  //Add(t,RandG(56.1, 90.5));
    Heater[Index_].Fault_.Source.Add(t,0);
    Heater[Index_].Setpoint_.Source.Add(t,0);  //Add(t,RandG(56.1, 9.5));
    Heater[Index_].Actual_.Source.Add(t,0);  //Add(t,RandG(56.1, 90.5));
    Heater[Index_].Gain_.Source.Add(t,0);
    t:=t+0.000005
  end;
end;

procedure TForm1.HeaterEvents(ObjectNumber:string; Index_:integer);
var
  AutoManual_: TLabel;
  Name_: TLabel;
  Set_: TLabel;
  Gain_: TLabel;
  Actual_: TLabel;
  EnableDisable_:Tshape;
begin

  AutoManual_ := TLabel(Form1.FindComponent('AutoManual'+ObjectNumber));
  Name_ := TLabel(Form1.FindComponent('Name'+ObjectNumber));
  Set_ := TLabel(Form1.FindComponent('Set'+ObjectNumber));
  Gain_ := TLabel(Form1.FindComponent('Gain'+ObjectNumber));
  Actual_ := TLabel(Form1.FindComponent('Actual'+ObjectNumber));
  EnableDisable_ := Tshape(Form1.FindComponent('EnableDisable'+ObjectNumber));

  if AutoManual_ = nil then exit;
  if Name_ = nil then exit;
  if Set_ = nil then exit;
  if Gain_ = nil then exit;
  if Actual_ = nil then exit;
  if EnableDisable_ = nil then exit;

  Name_.Caption:=Heater[Index_].DeviceName;
  if ABS(Heater[Index_].Setpoint-Heater[Index_].Actual)>5 then Heater[Index_].InRange:=false else Heater[Index_].InRange:=true;
  Set_.Caption:=Heater[Index_].Setpoint.ToString + ' C';
  Actual_.Caption:=Heater[Index_].Actual.ToString + ' C';
  Gain_.Caption:=Heater[Index_].Gain.ToString + '%';

  if Heater[Index_].Auto then
  begin
    AutoManual_.Caption:='Auto';
    Gain_.Color:=AutoColor;
    Gain_.Transparent:=false;
  end
  else
  begin
    AutoManual_.Caption:='Manual';
    Gain_.Color:=ManualColor;
    Gain_.Transparent:=false;
  end;

  if Heater[Index_].Enable then
  begin
    EnableDisable_.Brush.Color:=EnableColor;
    EnableDisable_.Brush.Style:=bsSolid;
  end
  else
  begin
    Name_.Transparent:=true;
    if Heater[Index_].Auto then Gain_.Transparent:=true;
    if Not Heater[Index_].Auto then Gain_.Transparent:=false;
    EnableDisable_.Brush.Color:=DisableColor;
    EnableDisable_.Brush.Style:=bsDiagCross;
  end;

  if Heater[Index_].InRange then
  begin
    Actual_.Color:=InRangeColor;
    Actual_.Transparent:=false;
  end
  else
  begin
    Actual_.Color:=OutRangeColor;
    Actual_.Transparent:=false;
  end;

  if Heater[Index_].Start then
  begin
    Name_.Color:=StartColor;
    Name_.Transparent:=false;
  end
  else
  begin
    Name_.Color:=StopColor;
  end;

  if Heater[Index_].Fault then
  begin
    Name_.Transparent:=true;
    Gain_.Transparent:=true;
    EnableDisable_.Brush.Color:=FaultColor;
    EnableDisable_.Brush.Style:=bsDiagCross;
  end
  else
  begin

  end;
end;

procedure TForm1.HeaterProcess(ObjectNumber:string; Index_:integer);
var
  AutoManual_: TLabel;
  Name_: TLabel;
  Set_: TLabel;
  Gain_: TLabel;
  Actual_: TLabel;
  EnableDisable_:Tshape;
begin

  AutoManual_ := TLabel(Form1.FindComponent('AutoManual'+ObjectNumber));
  Name_ := TLabel(Form1.FindComponent('Name'+ObjectNumber));
  Set_ := TLabel(Form1.FindComponent('Set'+ObjectNumber));
  Gain_ := TLabel(Form1.FindComponent('Gain'+ObjectNumber));
  Actual_ := TLabel(Form1.FindComponent('Actual'+ObjectNumber));
  EnableDisable_ := Tshape(Form1.FindComponent('EnableDisable'+ObjectNumber));

  if AutoManual_ = nil then exit;
  if Name_ = nil then exit;
  if Set_ = nil then exit;
  if Gain_ = nil then exit;
  if Actual_ = nil then exit;
  if EnableDisable_ = nil then exit;


end;

procedure TForm1.DisableMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      Heater[i].Start:=false;
      Heater[i].Enable:=false;
    end;

  end;
end;

procedure TForm1.ChartMenuClick(Sender: TObject);
var
  ChartHistory: TForm;
begin
  Unit2.ObjIndex:=-1;
  Unit2.ObjName:='';
  ChartHistory:=Unit2.TForm2.Create(self);
  ChartHistory.Show;
end;

procedure TForm1.AutoMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      if Not Heater[i].Fault then
      Heater[i].Auto:=true;
    end;

  end;
end;

procedure TForm1.EnableMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      Heater[i].Enable:=true;
    end;

  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Standard16Colors[0] := clBlack;
  Standard16Colors[1] := clMaroon;
  Standard16Colors[2] := clGreen;
  Standard16Colors[3] := clOlive;
  Standard16Colors[4] := clNavy;
  Standard16Colors[5] := clPurple;
  Standard16Colors[6] := clTeal;
  Standard16Colors[7] := clGray;
  Standard16Colors[8] := clSilver-TColor($050505);;
  Standard16Colors[9] := clRed;
  Standard16Colors[10] := clLime;
  Standard16Colors[11] := clYellow-TColor($000505);
  Standard16Colors[12] := clBlue;
  Standard16Colors[13] := clFuchsia;
  Standard16Colors[14] := clAqua;
  Standard16Colors[15] := clMoneyGreen; //clWhite-TColor($080808);

  SetLength(Heater, 2);
  for i:=Low(Heater) to High(Heater) do
  begin
    Heater[i].DeviceType:='Heater';
    Heater[i].DeviceIndex:=i;
    Heater[i].DeviceName:=Heater[i].DeviceType+FormatFloat('00', i+1);
    Heater[i].ObjectNumber:=FormatFloat('00', i+1);
    Heater[i].Auto:=true;
    Heater[i].Enable:=true;
    Heater[i].InRange:=false;
    Heater[i].Start:=false;
    Heater[i].Fault:=false;
    Heater[i].Gain:=0;
    Heater[i].Actual:=31;
  end;

  InitData(-1);

  Heater[0].Setpoint:=100;
  InitData(0);
  Heater[1].Setpoint:=200;
  InitData(1);

  HeaterEvents(Heater[0].ObjectNumber,0);
  HeaterEvents(Heater[1].ObjectNumber,1);

end;

procedure TForm1.HistoryMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
  ChartHistory: Unit2.TForm2;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      Unit2.ObjIndex:=i;
      Unit2.ObjName:=ClickedControl.Name;
      ChartHistory:=Unit2.TForm2.Create(Form1);
      ChartHistory.Show;
    end;

  end;
end;

procedure TForm1.ManualMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      if Not Heater[i].Fault then
      Heater[i].Auto:=false;
    end;

  end;
end;

procedure TForm1.StartMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
  if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      if Not Heater[i].Fault then
      if Heater[i].Enable then Heater[i].Start:=true;
    end;

  end;
end;

procedure TForm1.StopMenuClick(Sender: TObject);
var
  ClickedControl: TControl;
  i:integer;
begin
if PopupMenu1.PopupComponent <> nil then
  begin
    ClickedControl := TControl(PopupMenu1.PopupComponent);
    i:=strToInt('0'+RightStr(ClickedControl.Name,2))-1;

    if i >= Low(Heater) then
    if i <= High(Heater) then
    begin
      Heater[i].Start:=false;
    end;

  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  HeaterEvents(Heater[0].ObjectNumber,0);
  HeaterEvents(Heater[1].ObjectNumber,1);

  if Heater[0].Start then
  begin
    if RandG(10, 1) > Heater[0].Gain then
      Heater[0].Gain:=StrToFloat(FormatFloat('0.0', Heater[0].Gain+0.1))
    else
      Heater[0].Gain:=StrToFloat(FormatFloat('0.0', Heater[0].Gain-0.1))
  end
  else  Heater[0].Gain:=0;

  if  Heater[0].Gain > 10.1 then Heater[0].Actual:=Heater[0].Actual+0.1;
  if  (Heater[0].Gain < 10.1) and (Heater[0].Actual>32) then Heater[0].Actual:=Heater[0].Actual-0.1;

  if Heater[1].Start then
  begin
    if RandG(10, 1) > Heater[1].Gain then
      Heater[1].Gain:=StrToFloat(FormatFloat('0.0', Heater[1].Gain+0.1))
    else
      Heater[1].Gain:=StrToFloat(FormatFloat('0.0', Heater[1].Gain-0.1))
  end
  else  Heater[1].Gain:=0;

  if  Heater[1].Gain > 10.1 then Heater[1].Actual:=Heater[1].Actual+0.1;
  if  (Heater[1].Gain < 10.1) and (Heater[1].Actual>32) then Heater[1].Actual:=Heater[1].Actual-0.1;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  t:double;
begin
  t:=Now();
  DefaultData.Add(t,0);
  AddData(0);
  AddData(1);
end;

end.

