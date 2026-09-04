#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
OnError(HandleError)
OnExit(HandleExit)

class Path_Tests extends Test
{
  Path_Resolve()
  {
    Assert_AreEqual(A_ScriptFullPath, Path_Resolve(A_ScriptFullPath))
    Assert_AreEqual("C:\Windows\explorer.exe", Path_Resolve("explorer.exe"))
    Assert_IsTrue(Path_Resolve(Path_GetName(A_ScriptFullPath)) == "")
  }
  Path_GetName_1()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "C:"
    path2 := "C:\Windows"
    path3 := "C:\Windows\explorer.exe"
    Assert_AreEqual(fso.GetFileName(path1), Path_GetName(path1))
    Assert_IsTrue(Path_GetName(path1) == "")
    Assert_AreEqual(fso.GetFileName(path2), Path_GetName(path2))
    Assert_AreEqual(fso.GetFileName(path3), Path_GetName(path3))
  }
  Path_GetName_2()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "\\server\share"
    path2 := "\\server\share\folder"
    path3 := "\\server\share\folder\file.txt"
    Assert_AreNotEqual(fso.GetFileName(path1), Path_GetName(path1))
    Assert_AreEqual("share", Path_GetName(path1))
    Assert_AreEqual(fso.GetFileName(path2), Path_GetName(path2))
    Assert_AreEqual(fso.GetFileName(path3), Path_GetName(path3))
  }
  Path_GetBaseName_1()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "C:"
    path2 := "C:\Windows"
    path3 := "C:\Windows\explorer.exe"
    Assert_AreEqual(fso.GetBaseName(path1), Path_GetBaseName(path1))
    Assert_AreEqual(fso.GetBaseName(path2), Path_GetBaseName(path2))
    Assert_AreEqual(fso.GetBaseName(path3), Path_GetBaseName(path3))
  }
  Path_GetBaseName_2()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "\\server\share"
    path2 := "\\server\share\folder"
    path3 := "\\server\share\folder\file.txt"
    Assert_AreNotEqual(fso.GetBaseName(path1), Path_GetBaseName(path1))
    Assert_AreEqual("share", Path_GetBaseName(path1))
    Assert_AreEqual(fso.GetBaseName(path2), Path_GetBaseName(path2))
    Assert_AreEqual(fso.GetBaseName(path3), Path_GetBaseName(path3))
  }
  Path_GetParent_1()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "C:"
    path2 := "C:\Windows"
    path3 := "C:\Windows\explorer.exe"
    Assert_AreEqual(path1, Path_GetParent(path1))
    Assert_AreEqual(fso.GetParentFolderName(path2), Path_GetParent(path2) "\")
    Assert_AreEqual(fso.GetParentFolderName(path3), Path_GetParent(path3))
  }
  Path_GetParent_2()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "\\server\share"
    path2 := "\\server\share\folder"
    path3 := "\\server\share\folder\file.txt"
    Assert_AreNotEqual(fso.GetParentFolderName(path1), Path_GetParent(path1))
    Assert_AreEqual("\\server", Path_GetParent(path1))
    Assert_AreEqual(fso.GetParentFolderName(path2), Path_GetParent(path2))
    Assert_AreEqual(fso.GetParentFolderName(path3), Path_GetParent(path3))
  }
  Path_GetExtensionName_1()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "C:"
    path2 := "C:\Windows"
    path3 := "C:\Windows\explorer.exe"
    Assert_AreEqual(fso.GetExtensionName(path1), Path_GetExtensionName(path1))
    Assert_IsTrue(Path_GetExtensionName(path1) == "")
    Assert_AreEqual(fso.GetExtensionName(path2), Path_GetExtensionName(path2))
    Assert_IsTrue(Path_GetExtensionName(path2) == "")
    Assert_AreEqual(fso.GetExtensionName(path3), Path_GetExtensionName(path3))
  }
  Path_GetExtensionName_2()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "\\server\share"
    path2 := "\\server\share\folder"
    path3 := "\\server\share\folder\file.txt"
    Assert_AreEqual(fso.GetExtensionName(path1), Path_GetExtensionName(path1))
    Assert_AreEqual(fso.GetExtensionName(path2), Path_GetExtensionName(path2))
    Assert_AreEqual(fso.GetExtensionName(path3), Path_GetExtensionName(path3))
  }
  Path_GetDrive_1()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "C:"
    path2 := "C:\Windows"
    path3 := "C:\Windows\explorer.exe"
    Assert_AreEqual(fso.GetDriveName(path1), Path_GetDrive(path1))
    Assert_AreEqual(fso.GetDriveName(path2), Path_GetDrive(path2))
    Assert_AreEqual(fso.GetDriveName(path3), Path_GetDrive(path3))
  }
  Path_GetDrive_2()
  {
    fso := ComObject("Scripting.FileSystemObject")
    path1 := "\\server\share"
    path2 := "\\server\share\folder"
    path3 := "\\server\share\folder\file.txt"
    Assert_AreNotEqual(fso.GetDriveName(path1), Path_GetDrive(path1))
    Assert_AreEqual("\\server", Path_GetDrive(path1))
    Assert_AreNotEqual(fso.GetDriveName(path2), Path_GetDrive(path2))
    Assert_AreEqual("\\server", Path_GetDrive(path2))
    Assert_AreNotEqual(fso.GetDriveName(path3), Path_GetDrive(path3))
    Assert_AreEqual("\\server", Path_GetDrive(path3))
  }
  Path_IsAbsolute()
  {
    Assert_IsTrue(Path_IsAbsolute("C:\Windows\*.exe"))
    Assert_IsTrue(Path_IsAbsolute("C:\Windows\explorer.exe"))
    Assert_IsFalse(Path_IsAbsolute("*.exe"))
    Assert_IsFalse(Path_IsAbsolute("explorer.exe"))
  }
  Path_IsFileSpec()
  {
    Assert_IsTrue(Path_IsFileSpec("explorer.exe"))
    Assert_IsFalse(Path_IsFileSpec("foo/bar.txt"))
  }
  Path_IsRoot_1()
  {
    path := "C:"
    Assert_IsTrue(Path_IsRoot(path))
    Assert_IsTrue(Path_IsRoot(path "\"))
    Assert_IsFalse(Path_IsRoot(path "\Windows"))
  }
  Path_IsRoot_2()
  {
    path := "\\localhost\C$"
    Assert_IsTrue(Path_IsRoot(path))
    Assert_IsTrue(Path_IsRoot(path "\"))
    Assert_IsFalse(Path_IsRoot(path "\Windows"))
  }
  Path_ToLocal_1()
  {
    v := "USERPROFILE"
    Assert_AreEqual("%" v "%", Path_ToLocal(EnvGet(v)))
    Assert_AreEqual("%" v "%", Path_ToLocal(EnvGet(v) "\"))
  }
  Path_ToLocal_2()
  {
    v := "USERPROFILE"
    Assert_AreEqual("%" v "%", Path_ToLocal(Path_ToLocal(EnvGet(v))))
    Assert_AreEqual("%" v "%", Path_ToLocal(Path_ToNetwork(EnvGet(v))))
  }
  Path_ToNetwork_1()
  {
    c := "C:"
    Assert_AreEqual(Path_ToNetwork(c), Path_ToNetwork(c "\"))
    Assert_AreEqual(Path_ToNetwork(c), Path_ToNetwork(Path_ToNetwork(c)))
  }
  Path_ToNetwork_2()
  {
    c := "C:"
    Assert_AreEqual(Path_ToNetwork(c), Path_ToNetwork("\\localhost\C$"))
    for ip in SysGetIPAddresses()
      Assert_AreEqual(Path_ToNetwork(c), Path_ToNetwork("\\" ip "\C$"))
  }
  Path_FromURL()
  {
    Assert_AreEqual("C:\Windows\explorer.exe", Path_FromURL("file:///C:/Windows/explorer.exe"))
    Assert_AreEqual("C:\日本語.txt", Path_FromURL("file:///C:/日本語.txt"))
    Assert_AreEqual("C:\日本語.txt", Path_FromURL(Url_Decode("file:///C:/%E6%97%A5%E6%9C%AC%E8%AA%9E.txt")))
  }
  Path_ToURL()
  {
    Assert_AreEqual("file:///C:/Windows/explorer.exe", Path_ToURL("C:\Windows\explorer.exe"))
    Assert_AreEqual("file:///C:/日本語.txt", Path_ToURL("C:\日本語.txt"))
    Assert_AreEqual("file:///C:/%E6%97%A5%E6%9C%AC%E8%AA%9E.txt", Url_Encode(Path_ToURL("C:\日本語.txt")))
  }
  Path_Escape()
  {
    Assert_AreEqual('foo.txt', Path_Escape('foo.txt'))
    Assert_AreEqual('foo：bar.txt', Path_Escape('foo:bar.txt'))
    Assert_AreEqual('foo？bar.txt', Path_Escape('foo?bar.txt'))
    Assert_AreEqual('foo＊bar.txt', Path_Escape('foo*bar.txt'))
    Assert_AreEqual('foo／bar.txt', Path_Escape('foo/bar.txt'))
    Assert_AreEqual('foo＼bar.txt', Path_Escape('foo\bar.txt'))
    Assert_AreEqual('foo＂bar.txt', Path_Escape('foo"bar.txt'))
    Assert_AreEqual('foo＜bar.txt', Path_Escape('foo<bar.txt'))
    Assert_AreEqual('foo＞bar.txt', Path_Escape('foo>bar.txt'))
    Assert_AreEqual('foo｜bar.txt', Path_Escape('foo|bar.txt'))
  }
  Path_Compare()
  {
    ; path1 < path2 < path3
    path1 := "C:\Windows"
    path2 := "C:\Windows\explorer.exe"
    path3 := "C:\Windows\System32\cmd.exe"
    Assert_IsNegative(Path_Compare(path1, path1 "\"))
    Assert_IsNegative(Path_Compare(path1, path2))
    Assert_IsNegative(Path_Compare(path2, path3))
    Assert_IsNegative(Path_Compare(path1, path3))
  }
}
Path_Tests()
