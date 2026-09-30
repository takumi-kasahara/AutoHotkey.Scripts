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
#Escape:: WinActivateBottom("ahk_exe " WinGetProcessName("A"))
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
 * Close Window.
 * @hotkey    Win + Q
 * @override  Open Search.
 */
#q:: Window_Close()
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
#!v:: Paste(String_Clean(A_Clipboard))
/**
 * Paste as HTML.
 * @hotkey  Win + Ctrl + Alt + V
 */
#^!v::
{
  html := String_Clean(Clipboard_GetHtml())
  Paste(html ? html : String_Clean(A_Clipboard))
}
/**
 * Run Terminal.
 * @hotkey  Win + Ctrl + X
 */
#^x:: Open(Config_Get("Path", "TERMINAL"), EnvGet("USERPROFILE"))
/**
 * Run Terminal as Administrator.
 * @hotkey  Win + Ctrl + Shift + X
 */
#^+x:: Open("*RunAs " Config_Get("Path", "TERMINAL"), EnvGet("USERPROFILE"))
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
/**
 * @hotkey  Win + /
 * @send    無変換
 */
#vkBF::sc079
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
; #endregion
