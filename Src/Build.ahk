#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon

Build()

Build()
{
  dest_x86 := "..\Bin\x86"
  if DirExist(dest_x86)
    DirDelete(dest_x86, true)
  DirCreate(dest_x86)
  dest_x64 := "..\Bin\x64"
  if DirExist(dest_x64)
    DirDelete(dest_x64, true)
  DirCreate(dest_x64)
  installDir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir")
  ahk2exe := installDir '\Compiler\Ahk2Exe.exe'
  base_x86 := installDir '\v2\AutoHotkey32.exe'
  base_x64 := installDir '\v2\AutoHotkey64.exe'
  RunWait(Format(ahk2exe ' /in "{1}.ahk" /out "' dest_x86 '\{1}.exe" /base "{2}"', "Run", base_x86))
  RunWait(Format(ahk2exe ' /in "{1}.ahk" /out "' dest_x64 '\{1}.exe" /base "{2}"', "Run", base_x64))

  ctx_x86 := dest_x86 "\Scripts\ContextMenu"
  DirCreate(ctx_x86)
  ctx_x64 := dest_x64 "\Scripts\ContextMenu"
  DirCreate(ctx_x64)
  loop files, "Scripts\ContextMenu\*.ahk", "F"
  {
    name := StrReplace(A_LoopFileName, ".ahk")
    RunWait(Format(ahk2exe ' /in "{1}" /out "' ctx_x86 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x86))
    RunWait(Format(ahk2exe ' /in "{1}" /out "' ctx_x64 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x64))
  }

  program_x86 := dest_x86 "\Scripts\Programs"
  DirCreate(program_x86)
  program_x64 := dest_x64 "\Scripts\Programs"
  DirCreate(program_x64)
  loop files, "Scripts\Programs\*.ahk", "F"
  {
    name := StrReplace(A_LoopFileName, ".ahk")
    RunWait(Format(ahk2exe ' /in "{1}" /out "' program_x86 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x86))
    RunWait(Format(ahk2exe ' /in "{1}" /out "' program_x64 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x64))
  }

  sendto_x86 := dest_x86 "\Scripts\SendTo"
  DirCreate(sendto_x86)
  sendto_x64 := dest_x64 "\Scripts\SendTo"
  DirCreate(sendto_x64)
  loop files, "Scripts\SendTo\*.ahk", "F"
  {
    name := StrReplace(A_LoopFileName, ".ahk")
    RunWait(Format(ahk2exe ' /in "{1}" /out "' sendto_x86 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x86))
    RunWait(Format(ahk2exe ' /in "{1}" /out "' sendto_x64 '\{2}.exe" /base "{3}"', A_LoopFileFullPath, name, base_x64))
  }
}
