program koi;

uses
  Forms,
  checkPrevious,
  SysUtils,
  Unit1 in 'Unit1.pas' {mainfrm},
  Unit2 in 'Unit2.pas' {infofrm},
  Unit3 in 'Unit3.pas' {auxfrm},
  Unit4 in 'Unit4.pas' {progressfrm},
  Unit5 in 'Unit5.pas' {solfrm};

{$R *.res}

begin
  if not CheckPrevious.RestoreIfRunning(application.Handle) then begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := 'Олімпіада з інформатики Солом’янського району';
  if not directoryexists(contestDir)
      then createdir(contestDir);


    if not fileexists(contestDir + '\' + contestFile)
    then begin
      infofrm := tinfofrm.Create(nil);
      CheckPrevious.UpdateHandle(infofrm.Handle);
      infofrm.ShowModal;
      infofrm.Destroy;
      if unit2.closed then
        halt;
    end;

    if fileexists(problemsFile) then begin
      auxfrm := tauxfrm.Create(nil);
      repeat
        unit3.problemsFileOpened := true;
        unit3.lastPassword := '';
        auxfrm.RAR1.OpenFile(problemsFile);
      until unit3.problemsFileOpened;

      auxfrm.RAR1.Extract(problemsDir + '\', true, nil);
      deletefile(problemsFile);
      auxfrm.Destroy;
    end;

    Application.CreateForm(Tmainfrm, mainfrm);
  CheckPrevious.UpdateHandle(mainfrm.Handle);
    Application.Run;
  end;
end.
