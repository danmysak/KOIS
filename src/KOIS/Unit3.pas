unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, RAR, Dialogs_ukr;

type
  Tauxfrm = class(TForm)
    RAR1: TRAR;
    procedure RAR1Error(Sender: TObject; const ErrorCode: Integer;
      const Operation: TRAROperation);
    procedure RAR1PasswordRequired(Sender: TObject;
      const HeaderPassword: Boolean; const FileName: WideString;
      out NewPassword: AnsiString; out Cancel: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  auxfrm: Tauxfrm;
  problemsFileOpened: boolean;
  lastPassword: AnsiString;

implementation

{$R *.dfm}

procedure Tauxfrm.RAR1Error(Sender: TObject; const ErrorCode: Integer;
  const Operation: TRAROperation);
begin
  if errorcode <> 0 then
    problemsFileOpened := false;
end;

procedure Tauxfrm.RAR1PasswordRequired(Sender: TObject;
  const HeaderPassword: Boolean; const FileName: WideString;
  out NewPassword: AnsiString; out Cancel: Boolean);
begin
  if lastPassword = '' then
  begin
    NewPassword := ansistring(inputbox('Пароль', 'Уведіть пароль:', ''));
    if (NewPassword = '') then
      halt;
    lastPassword := newPassword;
  end else
    NewPassword := lastPassword;
end;

end.
