#Requires AutoHotkey v2.0

/**
 * @param {String} name
 * @returns {String}
 */
Reg_FolderDescriptions(name)
{
  static root := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions"
  loop reg, root, "K"
  {
    loop reg, Path_Combine(A_LoopRegKey, A_LoopRegName), "V"
    {
      switch A_LoopRegName
      {
        case "Name":
          if name !== RegRead()
            continue
          path := Traverse(A_LoopRegKey)
          if FileExist(path)
            return path
      }
    }
  }
  /**
   * @param {String} key
   * @param {String} [rel=""]
   */
  Traverse(key, rel := "")
  {
    name := RegRead(key, "Name", "")
    parentFolder := RegRead(key, "ParentFolder", "")
    relativePath := RegRead(key, "RelativePath", "")
    path := ComObject("Shell.Application").NameSpace(Format("shell:{}", name)).Self.Path
    if FileExist(path)
      return Path_Combine(path, rel)
    else
      return Traverse(Path_Combine(root, parentFolder), Path_Combine(relativePath, rel))
  }
}
/**
 * @returns {String}
 */
Reg_Find()
{
  static exe := RegRead("HKLM\SOFTWARE\voidtools\Everything 1.5a", "ExePath")
  if !FileExist(exe)
    throw TargetError(Format('Everything.exe not found at "{}"', exe))
  return exe
}
/**
 * @returns {String}
 */
Reg_Grep()
{
  static exe := Path_Combine(RegRead("HKCU\Software\AstroGrep"), "AstroGrep.exe")
  if !FileExist(exe)
    throw TargetError(Format('AstroGrep.exe not found at "{}"', exe))
  return exe
}
