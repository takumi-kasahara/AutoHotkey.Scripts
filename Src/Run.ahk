#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#HotString *
#UseHook
#Include "Lib.ahk"
#Include "Modules.ahk"
SetWorkingDir(A_ScriptDir)
OnClipboardChange(HandleClipboardChange)
OnError(HandleError)
OnExit(HandleExit)

InstallKeybdHook()
InstallMouseHook()
SendMode("Input")
SetCapsLockState("AlwaysOff")
SetNumLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")

Log_Trace("A_AhkVersion", A_AhkVersion)
Log_Trace("A_OSVersion", A_OSVersion)
