#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_CopyItem()

Dialog_CopyItem()
{
  defaultPrompt := "Enter a new name."
  paths := Stream(A_Args).Filter(FileExist).ToArray()
  if paths.Length == 0
    paths := Clipboard_ExtractPath()

For:
  for path In paths
  {
    if !FileExist(path)
    {
      MsgBox(Format('"{}" is not found.', path), , 0x30)
      continue
    }
    prompt := defaultPrompt
    loop
    {
      input := InputBox(prompt, Path_GetParent(path), , Path_GetName(path))
      if input.Result == "Cancel"
        continue For
      if String_IsNullOrWhitespace(input.Value)
      {
        prompt := "Path is empty."
        continue
      }
      destination := Path_IsAbsolute(input.Value) ? input.Value : Path_Combine(path, input.Value)
      if !DirExist(Path_GetParent(destination))
      {
        prompt := Format('"{}" is invalid.', input.Value)
        continue
      }
      if FileExist(destination)
      {
        prompt := Format('"{}" already exists.', destination)
        continue
      }
      if MsgBox(Format('Copy from "{}" to "{}" ?', path, destination), , 0x24) == "No"
      {
        prompt := defaultPrompt
        continue
      }
      try
        if Path_IsDirectory(path)
          DirCopy(path, destination)
        else
          FileCopy(path, destination)
      catch as ex
        if MsgBox(ex.Message, , 0x35) == "Retry"
          continue
      break
    }
  }
}
