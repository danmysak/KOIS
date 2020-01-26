program standard;

uses classes, windows, sysutils;

{$APPTYPE CONSOLE}

var inFile, outFile, ansFile, resultFile: string;
  f: text;
  result: string;

function CompareFiles(FirstFile, SecondFile: string; addLineBreakToFirst: boolean): Boolean;
var
  f1, f2: TMemoryStream;
  newFile: string;
  f: text;
begin
  Result := false;
  f1 := TMemoryStream.Create;
  f2 := TMemoryStream.Create;
  try
    if addLineBreakToFirst then begin
      newFile:=firstFile+'_lb';
      copyFile(pchar(firstFile),pchar(newFile),false);
      assignfile(f,newFile);
      append(f);
      writeln(f);
      closefile(f);
      firstFile:=newFile;
    end;
    f1.LoadFromFile(FirstFile);
    f2.LoadFromFile(SecondFile);
    if f1.Size = f2.Size then
      Result := CompareMem(f1.Memory, f2.memory, f1.Size);
    if addLineBreakToFirst and fileexists(newFile) then deletefile(newFile);
  finally
    f2.Free;
    f1.Free;
  end;
end;

begin
  inFile := paramstr(1);
  outFile := paramstr(2);
  ansFile := paramstr(3);
  resultFile := paramstr(4);

  if comparefiles(outFile, ansFile, false) then
    result := ''
  else if comparefiles(outFile, ansFile, true) then
    result := 'у вих≥дному файл≥ бракуЇ ознаки к≥нц€ р€дка п≥сл€ останнього символу'
  else
    result := 'неправильний вих≥дний файл';

  assign(f, resultFile);
  rewrite(f);
  writeln(f, result);
  close(f);
end.
