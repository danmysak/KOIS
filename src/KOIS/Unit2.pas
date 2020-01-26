unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grids, BaseGrid, AdvGrid, Dialogs_ukr, StdCtrls, ExtCtrls, Unit1, ComCtrls, routines,
  AdvObj;

type
  Tinfofrm = class(TForm)
    grid: TAdvStringGrid;
    memo: TRichEdit;
    savebtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure gridEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure FormShow(Sender: TObject);
    procedure gridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure savebtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure gridTopLeftChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  infofrm: Tinfofrm;
  closed: boolean;
  infoChanged: boolean;

implementation

{$R *.dfm}

procedure gridRequiredRecompute(row: integer = -1; value: string = '');
var i: integer;
  color, requiredColor: tcolor;
  disable: boolean;
begin
  requiredColor := rgb(255, 50, 50);
  if row >= 0 then begin
    if value = '' then
      color := requiredColor
    else
      color := clBlack;
    infofrm.grid.FontColors[0, row] := color;
    disable := (value = '');
  end else begin
    for i := 0 to infofrm.grid.RowCount - 1 do
    begin
      if infofrm.grid.Cells[1, i] = '' then
        color := requiredColor
      else
        color := clBlack;
      infofrm.grid.FontColors[0, i] := color;
    end;
    disable := false;
  end;

  if not disable then
    for i := 0 to infofrm.grid.RowCount - 1 do
      if (i <> row) and (infofrm.grid.Cells[1, i] = '') then begin
        disable := true;
        break;
      end;

  infofrm.savebtn.Enabled := not disable;
end;

procedure Tinfofrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var result: integer;
begin
  if closed and infoChanged then begin
    if savebtn.Enabled then begin
      result := messagedlg('Зміни не були збережені.' + chr(10) + chr(13) + 'Зберегти оновлену інформацію?', mtWarning, [mbYes, mbNo, mbCancel], 0);
      if result = mrYes then
        savebtn.Click
      else if result = mrCancel then
        canClose := false;
    end else begin
      result := messagedlg('Зміни не були збережені.' + chr(10) + chr(13) + 'Усе одно вийти?', mtWarning, [mbYes, mbNo], 0, mbNo);
      if result <> mrYes then
        canClose := false;
    end;
  end;
end;

procedure Tinfofrm.FormCreate(Sender: TObject);
var i: integer;
  parts: TArrayOfString;
begin
  closed := true;
  infoChanged := false;
  if fileexists(contestDir + '\' + contestFile) then
  begin
    memo.Lines.LoadFromFile(contestDir + '\' + contestFile);
    if memo.Lines.Count > 0 then
    begin
      parts := splitstring(' ', memo.Lines[0]);
      for i := 0 to 2 do
        if length(parts) > i then
          grid.Cells[1, i] := parts[i];
    end;
    if memo.Lines.Count > 1 then
      grid.Cells[1, 3] := memo.Lines[1];
    if memo.Lines.Count > 2 then
      grid.Cells[1, 4] := memo.Lines[2];
    if memo.Lines.Count > 6 then
      grid.Cells[1, 5] := memo.Lines[6];
    if memo.Lines.Count > 3 then
      grid.Cells[1, 6] := memo.Lines[3];
    if memo.Lines.Count > 5 then begin
      parts := splitstring(' || ', memo.Lines[5]);
      for i := 0 to 1 do
        if length(parts) > i then
          grid.Cells[1, 7 + i] := parts[i];
    end;
    if memo.Lines.Count > 4 then begin
      parts := splitstring('-', memo.Lines[4]);
      for i := 0 to 1 do
        if length(parts) > i then
          grid.Cells[1, 9 + i] := parts[i];
    end;
  end else if fileexists(contestTemplate) then
  begin
    memo.Lines.LoadFromFile(contestTemplate);
    for i := 0 to grid.RowCount - 1 do
      if memo.Lines.Count > i then
        grid.Cells[1, i] := memo.Lines[i];
  end;
end;

procedure Tinfofrm.FormShow(Sender: TObject);
begin
  gridRequiredRecompute;
end;

procedure Tinfofrm.gridClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ACol = 0 then begin
    grid.Row := ARow;
    grid.Col := 1;
  end;
end;

procedure Tinfofrm.gridEditChange(Sender: TObject; ACol, ARow: Integer;
  Value: string);
begin
  infoChanged := true;
  gridRequiredRecompute(ARow, value);
end;

procedure Tinfofrm.gridTopLeftChanged(Sender: TObject);
begin
grid.TopRow := 0;
grid.LeftCol := 1;
end;

procedure Tinfofrm.savebtnClick(Sender: TObject);
var f: textfile;
begin
  assignfile(f, contestDir + '\' + contestFile);
  rewrite(f);
  writeln(f, grid.Cells[1, 0] + ' ' + grid.Cells[1, 1] + ' ' + grid.Cells[1, 2]);
  writeln(f, grid.Cells[1, 3]);
  writeln(f, grid.Cells[1, 4]);
  writeln(f, grid.Cells[1, 6]);
  writeln(f, grid.Cells[1, 9] + '-' + grid.Cells[1, 10]);
  writeln(f, grid.Cells[1, 7] + ' || ' + grid.Cells[1, 8]);
  writeln(f, grid.Cells[1, 5]);
  closefile(f);
  closed := false;
  close();
end;

end.
