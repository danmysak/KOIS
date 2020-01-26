{
********************************************
Zarko Gajic
About.com Guide to Delphi Programming
http://delphi.about.com
email: delphi.guide@about.com
free newsletter: http://delphi.about.com/library/blnewsletter.htm
forum: http://forums.about.com/ab-delphi/start/
********************************************
}

unit CheckPrevious;

interface
uses Windows, SysUtils;

function RestoreIfRunning(
                const AppHandle : THandle;
                MaxInstances : integer = 1) : boolean;
procedure UpdateHandle(
             const handle : THandle);

implementation

type
  PInstanceInfo = ^TInstanceInfo;
  TInstanceInfo = packed record
    PreviousHandle : THandle;
    RunCounter : integer;
  end;

var
  MappingHandle: THandle;
  InstanceInfo: PInstanceInfo;
  MappingName : string;

  RemoveMe : boolean = True;

function ForceForegroundWindow(hwnd: THandle): boolean;
const
SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
ForegroundThreadID: DWORD;
ThisThreadID: DWORD;
timeout: DWORD;
begin
if IsIconic(hwnd) then
  ShowWindow(hwnd, SW_RESTORE);

if GetForegroundWindow = hwnd then
  Result := True
else
begin
  // Windows 98/2000 doesn"t want to foreground a window when some other
  // window has keyboard focus
  if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4))
    or
    ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
    ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
    (Win32MinorVersion > 0)))) then
  begin
    // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
    // Converted to Delphi by Ray Lischner
    // Published in The Delphi Magazine 55, page 16
    Result := False;
    ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow,
      nil);
    ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
    if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
      AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
      Result := (GetForegroundWindow = hwnd);
    end;

    if not Result then
    begin
      // Code by Daniel P. Stasinski
      SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hWnd);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
    end;
  end
  else
  begin
    BringWindowToTop(hwnd); // IE 5.5 related hack
    SetForegroundWindow(hwnd);
  end;

  Result := (GetForegroundWindow = hwnd);
end;
end; { ForceForegroundWindow }


function RestoreIfRunning(
             const AppHandle : THandle;
             MaxInstances : integer = 1) : boolean;
begin
  Result := True;

  MappingName := StringReplace(
                   ParamStr(0),
                   '\',
                   '',
                   [rfReplaceAll, rfIgnoreCase]);

  MappingHandle := CreateFileMapping($FFFFFFFF,
                                     nil,
                                     PAGE_READWRITE,
                                     0,
                                     SizeOf(TInstanceInfo),
                                     PChar(MappingName));

  if MappingHandle = 0 then
    RaiseLastOSError
  else
  begin
    if GetLastError <> ERROR_ALREADY_EXISTS then
    begin
      InstanceInfo := MapViewOfFile(MappingHandle,
                                    FILE_MAP_ALL_ACCESS,
                                    0,
                                    0,
                                    SizeOf(TInstanceInfo));

      InstanceInfo^.PreviousHandle := AppHandle;
      InstanceInfo^.RunCounter := 1;

      Result := False;
    end
    else //already runing
    begin
      MappingHandle := OpenFileMapping(
                                FILE_MAP_ALL_ACCESS,
                                False,
                                PChar(MappingName));
      if MappingHandle <> 0 then
      begin
        InstanceInfo := MapViewOfFile(MappingHandle,
                                      FILE_MAP_ALL_ACCESS,
                                      0,
                                      0,
                                      SizeOf(TInstanceInfo));

        if InstanceInfo^.RunCounter >= MaxInstances then
        begin
          RemoveMe := False;
          ForceForegroundWindow(InstanceInfo^.PreviousHandle);
        end
        else
        begin
          InstanceInfo^.PreviousHandle := AppHandle;
          InstanceInfo^.RunCounter := 1 + InstanceInfo^.RunCounter;

          Result := False;
        end
      end;
    end;
  end;
end; (*RestoreIfRunning*)

procedure UpdateHandle(
             const handle : THandle);
begin
  MappingName := StringReplace(
                   ParamStr(0),
                   '\',
                   '',
                   [rfReplaceAll, rfIgnoreCase]);

  MappingHandle := CreateFileMapping($FFFFFFFF,
                                     nil,
                                     PAGE_READWRITE,
                                     0,
                                     SizeOf(TInstanceInfo),
                                     PChar(MappingName));

      InstanceInfo := MapViewOfFile(MappingHandle,
                                    FILE_MAP_ALL_ACCESS,
                                    0,
                                    0,
                                    SizeOf(TInstanceInfo));

      InstanceInfo^.PreviousHandle := handle;
end; (*UpdateHandle*)

initialization
//nothing special here
//we need this section because we have the
//finalization section

finalization
  //remove this instance
  if RemoveMe then
  begin
    MappingHandle := OpenFileMapping(
                        FILE_MAP_ALL_ACCESS,
                        False,
                        PChar(MappingName));
    if MappingHandle <> 0 then
    begin
      InstanceInfo := MapViewOfFile(MappingHandle,
                                  FILE_MAP_ALL_ACCESS,
                                  0,
                                  0,
                                  SizeOf(TInstanceInfo));

      InstanceInfo^.RunCounter := -1 + InstanceInfo^.RunCounter;
    end
    else
      RaiseLastOSError;
  end;

  if Assigned(InstanceInfo) then UnmapViewOfFile(InstanceInfo);
  if MappingHandle <> 0 then CloseHandle(MappingHandle);

end.