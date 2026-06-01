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

Notification_Show(Format("
(
A_AhkVersion`t{}
A_OSVersion`t{}
)", A_AhkVersion, A_OSVersion))
