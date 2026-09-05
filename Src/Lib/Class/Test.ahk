#Requires AutoHotkey v2.0

class Test
{
  __Init() => Log_Trace(this.__Class)
  __New()
  {
    for name in ObjOwnProps(this.Base)
      if !(name ~= "^_")
      {
        if A_Args.Length > 0 && !Array_Contains(A_Args, name)
          continue

        method := this.Base.GetMethod(name)
        Log_Trace("Test", name)
        try
          method.Call(this)
        catch as ex
          if State_Debug()
            throw ex
          else
            Log_Error(ex)
      }
  }
}
