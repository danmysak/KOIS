unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, SynHighlighterPas, SynEditHighlighter,
  SynHighlighterCpp, SynEdit, HTMLabel;

type
  Tsolfrm = class(TForm)
    cppsyn: TSynCppSyn;
    passyn: TSynPasSyn;
    panel: TPanel;
    memo: TSynEdit;
    HTMLabel1: THTMLabel;
    HTMLabel2: THTMLabel;
    HTMLabel3: THTMLabel;
    HTMLabel4: THTMLabel;
    HTMLabel5: THTMLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  solfrm: Tsolfrm;

implementation

{$R *.dfm}

end.
