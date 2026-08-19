#Requires AutoHotkey v2.0

/**
 * @param {String} fmt
 * @param {String*} args
 * @returns {Integer} PID
 */
Open(fmt, args*) => (Run(Format(fmt, args*), A_Desktop, , &pid), pid)
/**
 * @param {String} path
 * @returns {Integer} PID
 */
Open_RunAs(path) => Open('*RunAs "{}"', path)
/**
 * @param {String} default
 * @param {Object} [dictionary={}]
 * @returns {Integer} PID
 */
Open_Choice(default, dictionary := {})
{
  for key, value in dictionary.OwnProps()
    if GetKeyState(key)
      return Open(value)
  return Open(default)
}
/**
 * @param {String} path
 * @returns {Integer} PID
 */
Open_Property(path) => (
  Open('*Properties "{}"', path),
  WinWaitClose(Format("ahk_id {}", WinWait("ahk_class #32770")))
)
/**
 * @param {String} path
 * @returns {Integer} PID
 */
Open_File(path)
{
  static EDITOR := Config_Get("Path", "EDITOR", "{}")
  switch Path_GetPerceivedType(path), false
  {
    case "compressed":
      return Open('7zFM.exe "{}"', path)
  }
  /** @see {@link https://support.microsoft.com/en-us/office/command-line-switches-for-microsoft-office-products-079164cd-4ef5-4178-b235-441737deb3a6} */
  switch Path_FriendlyAppName(path), false
  {
    case "Excel":
      return Open('EXCEL.EXE /h /r "{}"', path)
    case "Word":
      return Open('WINWORD.EXE /h /n "{}"', path)
    case "PowerPoint":
      return Open('POWERPNT.EXE /vp "{}"', path)
    case "Access":
      return Open('MSACCESS.EXE /ro /nostartup "{}"', path)
  }
  switch Path_GetExtensionName(path), false
  {
    case "code-workspace", "sln", "ssmssln":
      return Open(path)
    case "rdp":
      return Open('mstsc.exe /edit "{}"', path)
    case "lnk":
      try
        return Open(path)
      catch
        return Open_Property(path)
    case "htm", "html":
      return Open(path)
    case "url":
      url := Url_Load(path)
      if url !== ""
        return Open(url)
      else
        return Open_Property(path)
  }
  if Path_IsText(path)
  {
    try
      return Open(EDITOR, path)
    catch
      return Open('notepad.exe "{}"', path)
  }
  return Open(path)
}
/**
 * @param {String} path
 * @returns {Integer} PID
 */
Open_Explorer(path)
{
  try
    return Open('files-preview.exe "{}" ', path)
  catch
  {
    try
      return Open('files-stable.exe "{}" ', path)
    catch
      return Open(path)
  }
}
/**
 * @param {String*} paths
 * @returns {Integer} PID
 */
Open_Find(paths*)
{
  static exe := Reg_Find()
  if exe == ""
    return 0
  if paths.Length == 0
    return Open(exe)
  else
    return Open(exe ' "{}"', Enumerable_Join(paths, '" "'))
}
/**
 * @see {@link https://astrogrep.sourceforge.net/help/commandline.php}
 * @param {String*} paths
 * @returns {Integer} PID
 */
Open_Grep(paths*)
{
  id := "ahk_exe AstroGrep.exe"
  if WinExist(id)
  {
    WinActivate(id)
    return WinGetPID(id)
  }
  static exe := Reg_Grep()
  if exe == ""
    return 0
  if paths.Length = 0
    return Open(exe)
  else
    return Open(exe ' /spath="{}"', Enumerable_Join(paths, '|'))
}
