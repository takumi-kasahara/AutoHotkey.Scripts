#Requires AutoHotkey v2.0

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-environment}
 * @returns {Map}
 */
Win32_Environment()
{
  envs := Map()
  for env in ComObject("WScript.Shell").Environment("Process")
  {
    parts := StrSplit(env, "=", , 2)
    name := parts[1]
    path := parts[2]
    if FileExist(path)
      envs.Set("%" StrUpper(name) "%", path)
  }
  return envs
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-share}
 * @returns {Map}
 */
Win32_Share()
{
  shares := Map()
  for record in ComObjGet("winmgmts:").ExecQuery("Select * From Win32_Share")
  {
    networkPath := Path_Combine("\\" A_ComputerName, record.Properties_.Item("Name").Value)
    localPath := record.Properties_.Item("Path").Value
    if FileExist(localPath)
      shares.Set(networkPath, localPath)
  }
  return shares
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-useraccount}
 * @returns {String}
 */
Win32_UserAccount()
{
  for record in ComObjGet("winmgmts:").ExecQuery("Select * From Win32_UserAccount")
    if record.Properties_.Item("Name").Value == A_UserName
      return record.Properties_.Item("SID").Value
}
