#Requires AutoHotkey v2.0

class Test
{
  __Init()
  {
    this.Failed := 0
    this.Passed := 0
    Log_Trace(this.__Class)
  }
  __New()
  {
    for name in ObjOwnProps(this.Base)
      if !(name ~= "^_")
      {
        if A_Args.Length > 0 && !Array_Contains(A_Args, name)
          continue

        method := this.Base.GetMethod(name)
        try
        {
          method.Call(this)
          this.Passed++
        }
        catch as ex
        {
          this.Failed++
          if State_Debug()
            throw ex
          else
            Log_Error(ex)
        }
      }
  }
  __Delete()
  {
    Log_Trace("Passed", this.Passed, "Failed", this.Failed)
    Exit(this.Failed > 0)
  }
}
