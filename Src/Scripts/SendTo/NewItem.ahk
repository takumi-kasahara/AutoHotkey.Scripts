#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_NewItem()

Dialog_NewItem()
{
  defaultPrompt := "Enter a child path."
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
    if !Path_IsDirectory(path)
    {
      MsgBox(Format('"{}" is not a directory.', path), , 0x30)
      continue
    }
    prompt := defaultPrompt
    loop
    {
      input := InputBox(prompt, path)
      if input.Result == "Cancel"
        continue For
      if String_IsNullOrWhitespace(input.Value)
      {
        prompt := "Path is empty."
        continue
      }
      destination := Path_IsAbsolute(input.Value) ? input.Value : Path_Combine(path, input.Value)
      if !Stream(Path_GetParents(destination)).Some(DirExist)
      {
        prompt := Format('"{}" is invalid.', input.Value)
        continue
      }
      if FileExist(destination)
      {
        prompt := Format('"{}" already exists.', destination)
        continue
      }
      if MsgBox(Format('Create "{}" ?', destination), , 0x24) == "No"
      {
        prompt := defaultPrompt
        continue
      }
      try
        DirCreate(destination)
      catch as ex
        if MsgBox(ex.Message, , 0x35) == "Retry"
          continue
      break
    }
  }
}
