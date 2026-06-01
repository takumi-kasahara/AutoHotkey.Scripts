#Requires AutoHotkey v2.0

class Test
{
  /**
   * @param {String*} text
   */
  Log_Write(text)
  {
    if State_Debug()
      OutputDebug(text)
    else
      try
        FileAppend(text, "*")
      catch
        FileAppend(text, this.Log)
  }
  __Init() => this.Log := Path_Combine(Path_Combine(A_WorkingDir, "Tests", "Log"), StrReplace(this.__Class, "_", ".") ".log")
  __New()
  {
    if FileExist(this.Log)
      FileDelete(this.Log)
    for name in ObjOwnProps(this.Base)
      if !(name ~= "^_")
      {
        method := this.Base.GetMethod(name)
        try
          method.Call(this)
        catch as ex
          if State_Debug()
            throw ex
          else
            this.Log_Write(ex.Stack)
      }
  }
}
