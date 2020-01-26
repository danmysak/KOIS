unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  Tprogressfrm = class(TForm)
    Panel: TPanel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  progressfrm: Tprogressfrm;

implementation

{$R *.dfm}

procedure Tprogressfrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
end;

end.
