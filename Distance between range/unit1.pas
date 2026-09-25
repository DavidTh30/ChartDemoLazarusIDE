unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
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
begin
  Label1.Caption:=  Chart1.LogicalExtent.a.X.ToString;
  Label2.Caption:=  Chart1.LogicalExtent.b.X.ToString;
  Label3.Caption:=  Chart1.LogicalExtent.a.Y.ToString;
  Label4.Caption:=  Chart1.LogicalExtent.b.Y.ToString;

  Label5.Caption:=  Chart1.CurrentExtent.a.X.ToString;
  Label6.Caption:=  Chart1.CurrentExtent.b.X.ToString;
end;

end.

