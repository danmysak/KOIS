unit routines;

interface

type
  TArrayOfString = array of String;

  function SplitString(const aSeparator, aString: String; aMax: Integer = 0): TArrayOfString;

implementation

  function SplitString(const aSeparator, aString: String; aMax: Integer = 0): TArrayOfString;
  var
    i, strt, cnt: Integer;
    sepLen: Integer;

    procedure AddString(aEnd: Integer = -1);
    var
      endPos: Integer;
    begin
      if (aEnd = -1) then
        endPos := i
      else
        endPos := aEnd + 1;

      if (strt < endPos) then
        result[cnt] := Copy(aString, strt, endPos - strt)
      else
        result[cnt] := '';

      Inc(cnt);
    end;

  begin
    if (aString = '') or (aMax < 0) then
    begin
      SetLength(result, 0);
      EXIT;
    end;

    if (aSeparator = '') then
    begin
      SetLength(result, 1);
      result[0] := aString;
      EXIT;
    end;

    sepLen := Length(aSeparator);
    SetLength(result, (Length(aString) div sepLen) + 1);

    i     := 1;
    strt  := i;
    cnt   := 0;
    while (i <= (Length(aString)- sepLen + 1)) do
    begin
      if (aString[i] = aSeparator[1]) then
        if (Copy(aString, i, sepLen) = aSeparator) then
        begin
          AddString;

          if (cnt = aMax) then
          begin
            SetLength(result, cnt);
            EXIT;
          end;

          Inc(i, sepLen - 1);
          strt := i + 1;
        end;

      Inc(i);
    end;

    AddString(Length(aString));

    SetLength(result, cnt);
  end;

end.
