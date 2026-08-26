#Requires AutoHotkey v2.0
/**
 * @see {@link https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec}
 */
; #region Win + FunctionKey
#HotIf !(GetKeyState("Ctrl") || GetKeyState("Shift") || GetKeyState("Alt"))
#F1::#^+1
#F2::#^+2
#F3::#^+3
#F4::#^+4
#F5::#^+5
#F6::#^+6
#F7::#^+7
#F8::#^+8
#F9::#^+9
#F10::#^+0
#HotIf
; #endregion
; #region Win + Alt + FunctionKey
/**
 * Open KeyHistory.
 * @hotkey Win + Alt + F1
 */
#!F1:: KeyHistory()
/**
 * Exit App.
 * @hotkey  Win + Alt + F4
 */
#!F4:: MsgBox(Format("{} will be exited.", A_ScriptName), , 0x131) == "OK" ? ExitApp() : 0
/**
 * Restart App.
 * @hotkey  Win + Alt + F5
 */
#!F5:: MsgBox(Format("{} will be reloaded.", A_ScriptName), , 0x131) == "OK" ? Reload() : 0
/**
 * List History of lines.
 * @hotkey  Win + Alt + F8
 */
#!F8:: ListLines()
/**
 * List Hotkey and Hotstring.
 * @hotkey  Win + Alt + F9
 */
#!F9:: ListHotkeys()
/**
 * Run WindowSpy.
 * @hotkey  Win + Alt + F12
 */
#!F12:: Open(Path_Combine(Path_GetParent(A_AhkPath), "..\WindowSpy.ahk"))
; #endregion
; #region Win
/**
 * Show Open Context Menu.
 * @hotkey    Win + C
 * @override  Open Copilot.
 * @alter     Win + Ctrl + Shift + C
 */
#c::
{
  static root := Path_Combine(A_WorkingDir, "Scripts", "ContextMenu")
  if A_IsCompiled
    Open(Path_Combine(root, "Open.exe"))
  else
    Open(Path_Combine(root, "Open.ahk"))
}
#^+c::#c
/**
 * Run Event Viewer.
 * @hotkey  Win + Ctrl + E
 */
#^e:: Open("eventvwr.msc")
/**
 * Run Everything.
 * @hotkey    Win + F
 * @override  Open Feedback Hub.
 */
#f:: Open_Find()
/**
 * Run AstroGrep.
 * @hotkey  Win + Ctrl + F
 */
#^f:: Open_Grep()
/**
 * Minimize Window.
 * @hotkey  Win + M
 */
#m:: Window_Minimize()
/**
 * Run Paint.
 * @hotkey  Win + Ctrl + P
 */
#^p::
{
  try
    WinActivate("ahk_exe mspaint.exe")
  catch
    Open("mspaint.exe")
}
/**
 * Run Terminal.
 * @hotkey  Win + Ctrl + X
 */
#^x:: Open(Config_Get("Path", "TERMINAL"))
/**
 * Run Terminal as Administrator.
 * @hotkey  Win + Ctrl + Shift + X
 */
#^+x:: Open_RunAs(Config_Get("Path", "TERMINAL"))
/**
 * Run Registry Editor.
 * @hotkey  Win + Ctrl + R
 */
#^r:: Open("regedit.exe")
/**
 * Run Computer Management.
 * @hotkey    Win + Ctrl + S
 * @override  Voice access.
 */
#^s:: Open("compmgmt.msc")
/**
 * Run Task Scheduler.
 * @hotkey Win + Ctrl + T
 */
#^t:: Open("taskschd.msc")
/**
 * Show Edit Context Menu.
 * @hotkey    Win + Ctrl + V
 * @override  Sound output.
 */
#^v::
{
  static root := Path_Combine(A_WorkingDir, "Scripts", "ContextMenu")
  if A_IsCompiled
    Open(Path_Combine(root, "Edit.exe"))
  else
    Open(Path_Combine(root, "Edit.ahk"))
}
/**
 * Paste as Plaintext.
 * @hotkey  Win + Alt + V
 */
#!v:: Paste(Trim(A_Clipboard, "`r`n"))
/**
 * Paste as HTML.
 * @hotkey  Win + Ctrl + Alt + V
 */
#^!v::
{
  html := Trim(Clipboard_GetHtml(), "`r`n")
  Paste(html ? html : Trim(A_Clipboard, "`r`n"))
}
/**
 * Show WindowSelect Context Menu.
 * @hotkey    Win + W
 * @override  Open widgets.
 * @alter     Win + Ctrl + W
 */
#w:: WinActivateBottom("ahk_exe " WinGetProcessName("A"))
#^w::#w
/**
 * Maximize Window
 * @hotkey  Win + Up
 */
#Up:: Window_Maximize()
/**
 * Minimize Window
 * @hotkey  Win + Down
 */
#Down:: Window_Minimize()
/**
 * Maximize Window
 * @hotkey  Win + Z
 */
#z:: Window_Maximize()
/**
 * Show WindowResize Context Menu.
 * @hotkey    Win + Ctrl + Z
 * @override  Open snap layouts.
 */
#^z::
{
  static root := Path_Combine(A_WorkingDir, "Scripts", "ContextMenu")
  if A_IsCompiled
    Open(Path_Combine(root, "Window.exe"))
  else
    Open(Path_Combine(root, "Window.ahk"))
}
; #endregion
