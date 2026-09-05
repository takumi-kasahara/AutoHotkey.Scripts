#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..")
OnError(HandleError)
OnExit(HandleExit)

class Map_Tests extends Test
{
  Map_Equal()
  {
    m1 := Map("a", 1, "b", 1)
    m2 := Map("a", 1, "b", 2)
    Assert_IsTrue(m1 == m1)
    Assert_IsFalse(m1 == Map("a", 1, "b", 1))
    Assert_IsTrue(Map_Equal(m1, m1))
    Assert_IsFalse(Map_Equal(m1, m2))
  }
  Map_Keys() => Array_Equal(["a", "b"], Map_Keys(Map("a", 1, "b", 2)))
  Map_Values() => Assert_IsTrue(Array_Equal([1, 2], Map_Values(Map("a", 1, "b", 2))))
  Map_Union()
  {
    m1 := Map("a", 1, "b", 1)
    m2 := Map("b", 2, "c", 3)
    Assert_IsTrue(Map_Equal(m1, Map_Union(m1)))
    Assert_IsTrue(Map_Equal(Map("a", 1, "b", 1, "c", 3), Map_Union(m1, m2)))
  }
  Map_Intersect()
  {
    m1 := Map("a", 1, "b", 1)
    m2 := Map("b", 2, "c", 3)
    Assert_IsTrue(Map_Equal(Map(), Map_Intersect(m1)))
    Assert_IsTrue(Map_Equal(Map("b", 1), Map_Intersect(m1, m2)))
  }
  Map_Except()
  {
    m1 := Map("a", 1, "b", 1)
    m2 := Map("b", 2, "c", 3)
    Assert_IsTrue(Map_Equal(m1, Map_Except(m1)))
    Assert_IsTrue(Map_Equal(Map("a", 1), Map_Except(m1, m2)))
  }
}
Map_Tests()
