unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls,
  ExtCtrls, Grids, BaseGrid, AdvGrid, checkPrevious, ComCtrls, routines,
  Dialogs, Dialogs_ukr, Math, PsAPI, ShellAPI, AdvObj;

type
  Tmainfrm = class(TForm)
    sendbtn: TButton;
    infobtn: TButton;
    grid: TAdvStringGrid;
    od1: TOpenDialog;
    memo: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure gridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gridMouseLeave(Sender: TObject);
    procedure infobtnClick(Sender: TObject);
    procedure sendbtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gridTopLeftChanged(Sender: TObject);

  private
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
  end;

type submittedProblem = record
  tests, time, compiler, size, filename: string;
  testsPassed, testsOverall: integer;
end;

const
  problemsFile = 'problems.rar';
  problemsDir = 'problems';
  problemsInfoFile = 'problems.txt';
  contestTemplate = 'contest-template.txt';
  contestDir = 'contest';
  contestFile = 'contest.txt';
  contestSubmittedFile = 'submitted.txt';
  compilersInfoFile = 'compilers.txt';
  testingDir = 'testing';
  compilationTime = 60000;
  checkingTime = 5000;

var
  mainfrm: Tmainfrm;
  cellClicked: boolean;
  problemsCount, compilersCount: integer;
  problemNames, problemNamesUkr, problemCheckers, compilerNames, compilerSignatures, compilerPaths, compilerArguments: array of string;
  problemTimeLimits, problemMemoryLimits, problemTestsCounts: array of integer;
  submittedInfo: array of submittedProblem;
  mainDir: string;

implementation

uses Unit2, Unit4, Unit5;

{$R *.dfm}

procedure debug(str: string);
  var f: textfile;
begin
  if not fileexists(mainDir + '\debug.txt')
    then exit;
  assignfile(f, mainDir + '\debug.txt');
  rewrite(f);
  writeln(f, str);
  closefile(f);
  showmessage(str);
end;

procedure refreshSubmittedInfo;
var filename: string;
  f: textfile;
  i: integer;
  rec: submittedProblem;
  color: tcolor;
  parts: TArrayOfString;
begin
  filename := mainDir + '\' + contestDir + '\' + contestSubmittedFile;
  if not fileexists(filename) then begin
    assignfile(f, filename);
    rewrite(f);
    close(f);
  end;
  mainfrm.memo.Lines.LoadFromFile(filename);
  setlength(submittedInfo, problemsCount);
  for i := 0 to problemsCount - 1 do begin
    if (mainfrm.memo.Lines.Count <= i) or (mainfrm.memo.Lines[i] = '') then begin
      rec.testsPassed := 0;
      rec.testsOverall := 0;
      rec.tests := '—';
      rec.time := '—';
      rec.compiler := '—';
      rec.size := '—';
      rec.filename := '';
    end else begin
      parts := SplitString(' || ', mainfrm.memo.Lines[i]);
      rec.testsPassed := strtoint(parts[0]);
      rec.testsOverall := strtoint(parts[1]);
      rec.tests := inttostr(rec.testsPassed) + '/' + inttostr(rec.testsOverall);
      rec.time := parts[2];
      rec.compiler := parts[3];
      rec.size := parts[4];
      rec.filename := parts[5];
    end;
    submittedInfo[i] := rec;
    mainfrm.grid.Cells[1, i + 1] := rec.tests;
    if rec.testsOverall = 0 then
      color := clBlack
    else if rec.testsPassed < rec.testsOverall then
      color := clRed
    else
      color := clGreen;
    mainfrm.grid.FontColors[1, i + 1] := color;
    mainfrm.grid.Cells[2, i + 1] := rec.time;
    mainfrm.grid.Cells[3, i + 1] := rec.compiler;
    mainfrm.grid.Cells[4, i + 1] := rec.size;
  end;
end;

procedure saveSubmittedInfo;
var f: textfile;
  filename: string;
  i: integer;
  info: submittedProblem;
begin
  filename := mainDir + '\' + contestDir + '\' + contestSubmittedFile;
  assignfile(f, filename);
  rewrite(f);
  for i := 0 to problemsCount - 1 do begin
    info := submittedInfo[i];
    if info.filename = '' then
      writeln(f, '')
    else
      writeln(f, inttostr(info.testsPassed) + ' || ' + inttostr(info.testsOverall) + ' || ' + info.time + ' || ' + info.compiler + ' || ' + info.size + ' || ' + info.filename);
  end;
  closefile(f);
end;

procedure haltWithMessage(msg: string);
begin
  messagedlg(msg, mtError, [mbOk], 0);
  halt;
end;

procedure haltIfNotFound(filename: string);
begin
  if not fileexists(filename) then
    haltWithMessage('Критична помилка: відсутній файл ' + filename + '.');
end;

function getTrimmedFirstLine(filename: string): string;
var f: textfile;
begin
  assignfile(f, filename);
  reset(f);
  readln(f, result);
  closefile(f);
  result := trim(result);
end;


procedure delete_dir(dir: string);
var sr: tsearchrec;
begin
  if not directoryexists(dir) then
    exit;
  if findfirst(dir + '\*', faanyfile, sr) = 0 then
    repeat
      if (sr.name <> '.') and (sr.name <> '..') then begin
        if fileexists(dir + '\' + sr.Name) then
          deletefile(dir + '\' + sr.Name)
        else if directoryexists(dir + '\' + sr.Name) then
          delete_dir(dir + '\' + sr.Name);
      end;
    until FindNext(sr) <> 0;
  FindClose(sr);
  rmdir(dir);
end;

procedure delete_testingDir;
begin
  delete_dir(mainDir + '\' + testingDir);
end;

// 0 — усе гаразд
// 1 — невідома помилка
// 2 — порушене обмеження на час
// 3 — порушене обмеження на пам’ять
// 4 — ненульовий код виходу

function TestProcess(Hand: THandle; TimeLimit, MemoryLimit: DWORD): integer;
var
    WaitCode, ExitCode: DWORD;
    CreationTime, ExitTime, KernelTime, UserTime: FILETIME;
    UserNano100: Int64 absolute UserTime;
    KernelNano100: Int64 absolute KernelTime;
    Time,Our_Time,Last_Time,Porog: Int64;
    MemoryData: PROCESS_MEMORY_COUNTERS;
    kill: Boolean;
begin
    MemoryData.cb := SizeOf(MemoryData);
    Result := 0;

    kill := False;
    Our_Time := GetTickCount;
    Porog := 0;
    Last_Time := 0;
    repeat
        WaitCode := WaitForSingleObject(Hand, 0);
        if WaitCode = WAIT_FAILED then
        begin
            Result := 1;
            Exit;
        end;

        GetProcessTimes(Hand, CreationTime, ExitTime, KernelTime, UserTime);
        Time := (UserNano100 div 10000) + (KernelNano100 div 10000);

        GetProcessMemoryInfo(Hand, @MemoryData, SizeOf(MemoryData));


        if (MemoryLimit > 0) and (MemoryData.PeakWorkingSetSize > MemoryLimit) then
        begin
            Result := 3;
            kill := True;
            Break;
        end;
        if(Time = Last_Time) then
        begin
          Porog := Porog + (GetTickCount - Our_Time);
        end
        else Last_Time := Time;
        Our_Time := GetTickCount;

        if Porog > TimeLimit then
        begin
          Result := 2;
          kill := True;
          break;
        end;
    until (Time > TimeLimit) or (WaitCode = WAIT_OBJECT_0);

    if (WaitCode <> WAIT_OBJECT_0) or (Time > TimeLimit) or kill then
        TerminateProcess(Hand, 0);

    if kill then
    begin
        sleep(500);
        Exit;
    end;

    if (Time > TimeLimit) then
    begin
        Result := 2;
        Exit;
    end;

    if GetExitCodeProcess(Hand, ExitCode) then
	    if ExitCode <> 0 then
    	begin
        	Result := 4;
	        Exit;
    	end;
end;

// 0 — усе гаразд
// 1 — невідома помилка
// 2 — порушене обмеження на час
// 3 — порушене обмеження на пам’ять
// 4 — ненульовий код виходу

function run(filename, params: string; time: longint; memory: longint = 0): integer;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;
  SetErrorMode(SEM_FAILCRITICALERRORS);

  debug(CmdLine);

  if CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFilePath(Filename)),StartInfo,ProcInfo)
  then begin
    if memory = 0 then begin
      result := 0;
      if WaitForSingleObject(ProcInfo.hProcess, time) = WAIT_TIMEOUT then
        result := 2;
    end else
      result := TestProcess(ProcInfo.hProcess, time, memory);
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end else
    result := 1;
end;

function ReplaceSub(str, sub1, sub2: string; prefix: string = ''): string;
var
  aPos: Integer;
  rslt,ssub2: string;
  i,lsub1: integer;
begin
  aPos := Pos(sub1, str);
  rslt := '';
  while (aPos <> 0) do
  begin
    ssub2:=sub2;
    lsub1:=length(sub1);
    if (prefix<>'') and (length(str)>=aPos+2) and (str[aPos+length(sub1)]=':') and (str[aPos+length(sub1)+1]>='0') and (str[aPos+length(sub1)+1]<='9') then begin
      for i:=1 to (ord(str[aPos+length(sub1)+1])-ord('0')-length(sub2)) do ssub2:=prefix+sub2;
      lsub1:=lsub1+2;
    end;
    rslt := rslt + Copy(str, 1, aPos - 1) + ssub2;
    Delete(str, 1, aPos + lsub1 - 1);
    aPos := Pos(sub1, str);
  end;
  Result := rslt + str;
end;

function GetFileSize(const strFile: string): Int64;
var
  h: THandle;
  FindData:TWin32FindData;
begin
  result := -1;
  h := windows.FindFirstFile(PChar(strFile), FindData);
  if (h > 0) then begin
    result := (Int64(FindData.nFileSizeHigh) shl 32) + FindData.nFileSizeLow;
  end;
  windows.FindClose(h);
end;

function fsize(fileName : wideString): string;
var size: integer;
  cbytes: integer;
begin
  size := GetFileSize(fileName);
  if size > - 1 then begin
    if size < 1024 then
      result := inttostr(size) + ' Б'
    else if size < 10189 then begin
      cbytes := round(size / 102.4);
      result := inttostr(floor(cbytes / 10));
      if cbytes mod 10 <> 0 then
        result := result + ',' + inttostr(cbytes mod 10);
      result := result + ' КБ';
    end else
      result := inttostr(round(size / 1024)) + ' КБ';
  end else
    result := 'Файл не знайдено';
end;

procedure checkFile(efname: string);
var fileName, fileExt, problemName, messageStr, s, firstLine, testIn, testAns: string;
  i, problemIndex, compilerIndex, r: integer;
  program_name, program_exe, error, checker_exe, result_file: string;
  results: array of string;
  passedCount, testsCount: integer;
  rec: submittedProblem;
begin
    error := '';
    fileName := ExtractFileName(efname);
    fileExt := lowercase(ExtractFileExt(fileName));
    if (fileExt <> '.pas') and (fileExt <> '.cpp') then begin
      if fileExt <> '' then
        messageStr := 'Розширення вибраного файла' + #10 + #13 + #10 + #13 + fileExt + #10 + #13 + #10 + #13 + 'не відповідає жодній допустимій мові програмування.'
      else
        messageStr := 'Вибраний файл не має розширення.';
      messageStr := messageStr +  #10 + #13 + 'Файл із розв’язком повинен мати одне з таких розширень:' + #10 + #13;
      messageStr := messageStr + #10 + #13 + '.pas' + #10 + #13 + '.cpp';
      messagedlg(messageStr, mtError, [mbOk], 0);
      exit;
    end;
    problemName := lowercase(copy(fileName, 0, length(fileName) - length(fileExt)));
    problemIndex := -1;
    for i := 0 to problemsCount - 1 do
      if problemNames[i] = problemName then begin
        problemIndex := i;
        break;
      end;
    if problemIndex = -1 then begin
      messageStr := 'Ім’я вибраного файла' + #10 + #13 + #10 + #13 + fileName + #10 + #13 + #10 + #13 + 'не відповідає жодній із задач.' + #10 + #13 + 'Файл із розв’язком може називатися одним із таких імен:' + #10 + #13;
      for i := 0 to problemsCount - 1 do
        messageStr := messageStr + #10 + #13 + problemNames[i] + '.*';
      messagedlg(messageStr, mtError, [mbOk], 0);
      exit;
    end;
    firstLine := getTrimmedFirstLine(efname);
    compilerIndex := -1;
    for i := 0 to compilersCount - 1 do
      if compilerSignatures[i] = firstLine then begin
        compilerIndex := i;
        break;
      end;
    if compilerIndex = -1 then begin
      if firstLine <> '' then
        messageStr := #10 + #13 + #10 + #13 + firstLine + #10 + #13 + #10 + #13 + 'не відповідає жодному з компіляторів.'
      else
        messageStr := ' порожній.';
      messageStr := 'Перший рядок вибраного файла' + messageStr + #10 + #13 + 'Перший рядок розв’язку має збігатися з одним із таких варіантів:' + #10 + #13;
      for i := 0 to compilersCount - 1 do
        messageStr := messageStr + #10 + #13 + compilerSignatures[i];
      messagedlg(messageStr, mtError, [mbOk], 0);
      exit;
    end;
    mainfrm.Enabled := false;
    progressfrm := tprogressfrm.Create(mainfrm);
    progressfrm.Panel.Caption := 'Компіляція...';
    progressfrm.Show;
    mainfrm.Repaint;
    progressfrm.Repaint;

    delete_testingDir;
    mkdir(mainDir + '\' + testingDir);
    program_name := mainDir + '\' + testingDir + '\' + fileName;
    program_exe := mainDir + '\' + testingDir + '\' + problemName + '.exe';
    copyfile(pchar(efname), pchar(program_name), false);

    testsCount := problemTestsCounts[problemIndex];
    passedCount := 0;

    r := run(replacesub(compilerPaths[compilerIndex], '$kdir', mainDir), replacesub(replacesub(compilerArguments[compilerIndex], '$file', '"' + program_name + '"'), '$exec', '"' + program_exe + '"'), compilationTime);
    if r = 2 then
      error := 'Час компіляції вичерпано.'
    else if not fileexists(program_exe) then
      error := 'Під час компілювання виникла помилка (' + compilerNames[compilerIndex] + ').'
    else begin
      if testsCount = 1 then
        progressfrm.Panel.Caption := 'Випробовування на тесті з умови...'
      else
        progressfrm.Panel.Caption := 'Випробовування на тестах з умови...';
      progressfrm.Repaint;
      setlength(results, testsCount);
      for i := 1 to testsCount do begin
        results[i - 1] := '';

        if fileexists(mainDir + '\' + testingDir + '\' + problemName + '.in')
          then deletefile(mainDir + '\' + testingDir + '\' + problemName + '.in');
        if fileexists(mainDir + '\' + testingDir + '\' + problemName + '.out')
          then deletefile(mainDir + '\' + testingDir + '\' + problemName + '.out');
        if fileexists(mainDir + '\' + testingDir + '\' + problemName + '.result')
          then deletefile(mainDir + '\' + testingDir + '\' + problemName + '.result');

        testIn := mainDir + '\' + problemsDir + '\' + problemName + '\' + inttostr(i) + '.in';
        if not fileexists(testIn) then
          testIn := mainDir + '\' + problemsDir + '\' + problemName + '\0' + inttostr(i) + '.in';
        if not fileexists(testIn) then
          haltWithMessage('Критична помилка: бракує файла ' + testIn + '.');

        testAns := mainDir + '\' + problemsDir + '\' + problemName + '\' + inttostr(i) + '.ans';
        if not fileexists(testAns) then
          testAns := mainDir + '\' + problemsDir + '\' + problemName + '\0' + inttostr(i) + '.ans';
        if not fileexists(testAns) then
          haltWithMessage('Критична помилка: бракує файла ' + testAns + '.');

        copyfile(pchar(testIn), pchar(mainDir + '\' + testingDir + '\' + problemName + '.in'), false);
        r := run(program_exe, '', problemTimeLimits[problemIndex], problemMemoryLimits[problemIndex]);
        if r > 0 then begin
          case r of
            1: results[i - 1] := 'невідома помилка';
            2: results[i - 1] := 'перевищено обмеження на час';
            3: results[i - 1] := 'перевищено обмеження на пам’ять';
            4: results[i - 1] := 'під час роботи програми виникла помилка';
          end;
        end else if not fileexists(mainDir + '\' + testingDir + '\' + problemName + '.out') then
          results[i - 1] := 'програма не створила вихідного файла або створений файл має неправильне ім’я'
        else begin
          checker_exe := mainDir + '\' + problemsDir + '\checker-' + problemCheckers[problemIndex] + '.exe';
          if not fileexists(checker_exe) then
            haltWithMessage('Критична помилка: бракує файла ' + checker_exe + '.');
          result_file := mainDir + '\' + testingDir + '\' + problemName + '.result';
          r := run(checker_exe, '"' + mainDir + '\' + testingDir + '\' + problemName + '.in' + '"' + ' ' + '"' + mainDir + '\' + testingDir + '\' + problemName + '.out' + '"' + ' ' + '"' + testAns + '"' + ' ' + '"' + result_file + '"', checkingTime);
          if r = 2 then
            results[i - 1] := 'програма перевірки вихідного файла виконується надто довго'
          else if (r > 0) or not fileexists(result_file) then
            results[i - 1] := 'невідома помилка під час перевірки вихідного файла'
          else begin
            results[i - 1] := getTrimmedFirstLine(result_file);
            if results[i - 1] = '' then
              inc(passedCount);
          end;
        end;
      end;
    end;

    mainfrm.Enabled := true;
    progressfrm.Destroy;
    if error <> '' then begin
      delete_testingDir;
      messagedlg(error, mtError, [mbOk], 0);
    end else begin
      rec.testsPassed := passedCount;
      rec.testsOverall := testsCount;
      rec.tests := inttostr(rec.testsPassed) + '/' + inttostr(rec.testsOverall);
      rec.time := timetostr(time);
      rec.compiler := compilerNames[compilerIndex];
      rec.size := fsize(program_name);
      rec.filename := fileName;
      if (submittedInfo[problemIndex].filename <> '') and fileexists(mainDir + '\' + contestDir + '\' + submittedInfo[problemIndex].filename)
        then deletefile(mainDir + '\' + contestDir + '\' + submittedInfo[problemIndex].filename);
      submittedInfo[problemIndex] := rec;
      copyfile(pchar(program_name), pchar(mainDir + '\' + contestDir + '\' + fileName), false);
      saveSubmittedInfo;
      refreshSubmittedInfo;

      delete_testingDir;

      messageStr := 'Ви здали розв’язок задачі «' + problemNamesUkr[problemIndex] + '».' + #10 + #13;
      if passedCount = testsCount then begin
        if testsCount = 1 then
          messageStr := messageStr + 'Тест з умови задачі пройдено.'
        else
          messageStr := messageStr + 'Тести з умови задачі пройдено.';
        messagedlg(messageStr, mtInformation, [mbOk], 0)
      end else begin
        if testsCount = 1 then
          s := 'тесті'
        else
          s := 'тестах';
        messageStr := messageStr + 'Результати випробовування на ' + s + ' з умови наведено нижче.';
        for i := 0 to testsCount - 1 do begin
          messageStr := messageStr + #10 + #13 + #10 + #13 + 'Тест ' + inttostr(i + 1) + ': ';
          if results[i] = '' then
            messageStr := messageStr + 'пройдено'
          else
            messageStr := messageStr + results[i];
          messageStr := messageStr + '.';
        end;
        messageDlg(messageStr, mtWarning, [mbOk], 0);
      end;
    end;
end;

procedure Tmainfrm.sendbtnClick(Sender: TObject);
begin
  if od1.Execute then
    checkFile(od1.FileName);
end;

procedure Tmainfrm.infobtnClick(Sender: TObject);
begin
  infofrm := tinfofrm.Create(self);
  checkPrevious.UpdateHandle(infofrm.handle);
  infofrm.ShowModal;
end;

procedure Tmainfrm.FormCreate(Sender: TObject);
var i, j: integer;
  parts: TArrayOfString;
begin
  DragAcceptFiles(Handle, true);
  mainDir := extractfiledir(application.ExeName);

  haltIfNotFound(mainDir + '\' + compilersInfoFile);
  haltIfNotFound(mainDir + '\' + problemsDir + '\' + problemsInfoFile);

  memo.Lines.LoadFromFile(mainDir + '\' + problemsDir + '\' + problemsInfoFile);
  problemsCount := memo.Lines.Count;
  setlength(problemNames, problemsCount);
  setlength(problemNamesUkr, problemsCount);
  setlength(problemTimeLimits, problemsCount);
  setlength(problemMemoryLimits, problemsCount);
  setlength(problemTestsCounts, problemsCount);
  setlength(problemCheckers, problemsCount);
  for i := 0 to problemsCount - 1 do begin
    parts := splitstring(' / ', memo.Lines[i]);
    problemNames[i] := lowercase(parts[0]);
    problemNamesUkr[i] := parts[1];
    problemTimeLimits[i] := strtoint(parts[2]);
    problemMemoryLimits[i] := strtoint(parts[3]);
    problemTestsCounts[i] := strtoint(parts[4]);
    problemCheckers[i] := parts[5];
  end;

  memo.Lines.LoadFromFile(compilersInfoFile);
  compilersCount := ceil(memo.Lines.Count / 5);
  setlength(compilerNames, compilersCount);
  setlength(compilerSignatures, compilersCount);
  setlength(compilerPaths, compilersCount);
  setlength(compilerArguments, compilersCount);
  for i := 0 to compilersCount - 1 do begin
    compilerNames[i] := memo.Lines[5 * i];
    compilerSignatures[i] := trim(memo.Lines[5 * i + 1]);
    compilerPaths[i] := memo.Lines[5 * i + 2];
    compilerArguments[i] := memo.Lines[5 * i + 3];
  end;

  grid.RowCount := problemsCount + 1;
  cellClicked := false;
  for i := 0 to grid.ColCount - 1 do
    for j := 0 to grid.RowCount - 1 do
      grid.Alignments[i, j] := taCenter;
  for i := 0 to problemsCount - 1 do begin
    grid.Alignments[0, i + 1] := taLeftJustify;
    grid.FontStyles[0, i + 1] := [fsBold];
    grid.Cells[0, i + 1] := problemNamesUkr[i];
  end;
  refreshSubmittedInfo;
end;

procedure Tmainfrm.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);
end;

procedure Tmainfrm.gridClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow > 0 then begin
    cellClicked := true;
    grid.ShowSelection := true;
  end;
end;

procedure Tmainfrm.gridMouseLeave(Sender: TObject);
begin
  cellClicked := false;
  grid.ShowSelection := false;
end;

procedure Tmainfrm.gridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var problemIndex: integer;
  color: tcolor;
begin
  if cellClicked then begin
    problemIndex := grid.Selection.top - 1;
    if submittedInfo[problemIndex].filename = ''
      then messagedlg('Розв’язку задачі «' + problemNamesUkr[problemIndex] + '» ви ще не здали.', mtInformation, [mbOk], 0)
    else begin
      color := grid.FontColors[1, problemIndex + 1];
      solfrm := tsolfrm.Create(self);
      solfrm.HTMLabel1.HTMLText.Text := solfrm.HTMLabel1.HTMLText[0] + ' ' + '<b>' + grid.Cells[0, problemIndex + 1] + '</b>';
      solfrm.HTMLabel2.HTMLText.Text := solfrm.HTMLabel2.HTMLText[0] + ' ' + '<b><font color="#' + IntToHex(GetRValue(color), 2) + IntToHex(GetGValue(color), 2) + IntToHex(GetBValue(color), 2) + '">' + grid.Cells[1, problemIndex + 1] + '</font></b>';
      solfrm.HTMLabel3.HTMLText.Text := solfrm.HTMLabel3.HTMLText[0] + ' ' + '<b>' + grid.Cells[2, problemIndex + 1] + '</b>';
      solfrm.HTMLabel4.HTMLText.Text := solfrm.HTMLabel4.HTMLText[0] + ' ' + '<b>' + grid.Cells[3, problemIndex + 1] + '</b>';
      solfrm.HTMLabel5.HTMLText.Text := solfrm.HTMLabel5.HTMLText[0] + ' ' + '<b>' + submittedInfo[problemIndex].filename + '</b>' + ' (' + grid.Cells[4, problemIndex + 1] + ')';
      solfrm.memo.Lines.LoadFromFile(mainDir + '\' + contestDir + '\' + submittedInfo[problemIndex].filename);
      if lowercase(extractfileext(submittedInfo[problemIndex].filename)) = '.cpp' then
        solfrm.memo.Highlighter := solfrm.cppsyn
      else
        solfrm.memo.Highlighter := solfrm.passyn;
      checkPrevious.UpdateHandle(solfrm.Handle);
      solfrm.ShowModal;
      checkPrevious.UpdateHandle(mainfrm.Handle);
      solfrm.Destroy;
    end;
  end;
  cellClicked := false;
  grid.ShowSelection := false;
end;

procedure Tmainfrm.gridTopLeftChanged(Sender: TObject);
begin
grid.TopRow := 1;
grid.LeftCol := 0;
end;

procedure TMainfrm.WMDropFiles(var Msg: TWMDropFiles);
const
  maxlen = 10000;
var
  h: THandle;
  pchr: array[0..maxlen] of char;
  fname: string;
begin
  h := Msg.Drop;
  DragQueryFile(h, 0, pchr, maxlen);
  fname := string(pchr);
  DragFinish(h);
  if fileexists(fname) then
  if messagedlg('Ви хочете здати для перевірки файл ' + #10 + #13 + fname + '?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
    checkFile(fname);
end;

end.
