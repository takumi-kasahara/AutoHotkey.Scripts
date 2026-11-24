#Requires AutoHotkey v2.0

class Test
{
  __Init()
  {
    this.Failed := 0
    this.Passed := 0
    this.TickCount := A_TickCount
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
          Log_Trace("Failed", name)
          if State_Debug()
            throw ex
          else
            Log_Error(ex)
        }
      }
  }
  __Delete()
  {
    status := "[" (this.Passed >= 0 && this.Failed == 0 ? "+" : "-") "]"
    time := A_TickCount - this.TickCount
    Log_Trace(status " " this.__Class " " time "ms (" this.Passed + this.Failed " tests)")
    Log_Trace("Passed:", this.Passed ", Failed:", this.Failed)
    Exit(this.Failed > 0)
  }
}
