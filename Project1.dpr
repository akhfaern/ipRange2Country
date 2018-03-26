program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {IP2Location};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TIP2Location, IP2Location);
  Application.Run;
end.
