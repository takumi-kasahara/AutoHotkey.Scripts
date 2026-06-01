#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
OnError(HandleError)
OnExit(HandleExit)

class Array_Tests extends Test
{
  Array_Equal()
  {
    a1 := [1, 1]
    a2 := [1, 2]
    a3 := [2, 1]
    Assert_IsTrue(a1 == a1)
    Assert_IsFalse(a1 == [1, 1])
    Assert_IsTrue(Array_Equal(a1, a1))
    Assert_IsFalse(Array_Equal(a1, a2))
    Assert_IsFalse(Array_Equal(a2, a3))
  }
  Array_Contains()
  {
    a := [1, 2, 3]
    Assert_IsTrue(Array_Contains(a, 1))
    Assert_IsTrue(Array_Contains(a, 2))
    Assert_IsTrue(Array_Contains(a, 3))
    Assert_IsFalse(Array_Contains(a, 4))
  }
  Array_Reverse() => Assert_IsTrue(Array_Equal([3, 2, 1], Array_Reverse([1, 2, 3])))
  Array_Slice()
  {
    a := [1, 2, 3, 4, 5]
    Assert_IsTrue(Array_Equal(a, Array_Slice(a, 1)))
    Assert_IsTrue(Array_Equal(a, Array_Slice(a, 1, 5)))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Slice(a, 1, 3)))
    Assert_IsTrue(Array_Equal([3, 4, 5], Array_Slice(a, -3, -1)))
    Assert_IsTrue(Array_Equal([5], Array_Slice(a, 5)))
    Assert_IsTrue(Array_Equal([5], Array_Slice(a, -1)))
    Assert_Throws(() => Array_Slice([1, 2, 3], 0), ValueError)
  }
  Array_Unique()
  {
    a := [1, 2, 2, 3, 3, 3]
    Assert_IsTrue(Array_Equal([], Array_Unique([])))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Unique(a)))
  }
  Array_Union()
  {
    a1 := [1, 2, 3]
    a2 := [3, 4, 5]
    a3 := [5, 6, 7]
    Assert_IsTrue(Array_Equal([], Array_Union()))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Union(a1)))
    Assert_IsTrue(Array_Equal([1, 2, 3, 4, 5], Array_Union(a1, a2)))
    Assert_IsTrue(Array_Equal([1, 2, 3, 4, 5, 6, 7], Array_Union(a1, a2, a3)))
  }
  Array_Intersect()
  {
    a1 := [1, 2, 3]
    a2 := [3, 4, 5]
    a3 := [5, 6, 7]
    Assert_IsTrue(Array_Equal([], Array_Intersect([], [])))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Intersect(a1)))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Intersect(a1, a1)))
    Assert_IsTrue(Array_Equal([3], Array_Intersect(a1, a2)))
    Assert_IsTrue(Array_Equal([], Array_Intersect(a1, a2, a3)))
  }
  Array_Except()
  {
    a1 := [1, 2, 3]
    a2 := [3, 4, 5]
    a3 := [5, 6, 7]
    Assert_IsTrue(Array_Equal([], Array_Except([])))
    Assert_IsTrue(Array_Equal([1, 2, 3], Array_Except(a1)))
    Assert_IsTrue(Array_Equal([1, 2], Array_Except(a1, a2)))
    Assert_IsTrue(Array_Equal([1, 2], Array_Except(a1, a2, a3)))
  }
}
Array_Tests()
