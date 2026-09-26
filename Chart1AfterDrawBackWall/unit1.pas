unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, TAGraph, TADrawUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    procedure Chart1AfterCustomDrawBackWall(ASender: TChart;
      ADrawer: IChartDrawer; const ARect: TRect);
    procedure Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Chart1AfterDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect);
begin
  ACanvas.Brush.Color := RgbToColor(255, 240, 240);;
    ACanvas.FillRect(
      Chart1.XGraphToImage(-0.8),   //LeftLine
      Chart1.YGraphToImage(0.8),  //TopLine
      Chart1.XGraphToImage(0.8), //RightLine
      Chart1.YGraphToImage(-0.8) //BottomLine
    );

    ACanvas.Pen.Color := clBlue;
  ACanvas.Line(ARect.Left, (ARect.Top + ARect.Bottom) div 2, ARect.Right, (ARect.Top + ARect.Bottom) div 2);


end;

procedure TForm1.Chart1AfterCustomDrawBackWall(ASender: TChart;
  ADrawer: IChartDrawer; const ARect: TRect);
begin
  ADrawer.SetBrushColor(clMoneyGreen);
  //ADrawer.SetBrushStyle(bsSolid);
  ADrawer.FillRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

end.

