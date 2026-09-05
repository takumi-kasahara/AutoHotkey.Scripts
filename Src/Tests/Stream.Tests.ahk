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

class Stream_Tests extends Test
{
  ToArray_1()
  {
    a := [1, 2, 3]
    Assert_IsTrue(Array_Equal(a, Stream(a).ToArray()))
  }
  ToMap_1()
  {
    m := Map("a", 1, "b", 2, "c", 3)
    Assert_IsTrue(Map_Equal(m, Stream(m).ToMap()))
  }
  Map_1()
  {
    a := [1, 2, 3]
    b := [1, 4, 9]
    Assert_IsTrue(Array_Equal(b, Stream(a).ToArray(x => x * x)))
    Assert_IsTrue(Array_Equal(b, Stream(a).Map(x => x * x).ToArray()))
  }
  Filter_1() => Assert_IsTrue(Array_Equal([2, 4], Stream([1, 2, 3, 4, 5]).Filter(x => Mod(x, 2) == 0).ToArray()))
  Reduce() => Assert_IsTrue(Stream([1, 2, 3, 4, 5]).Reduce((acc, x) => acc + x) == 15)
}
Stream_Tests()
