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

class Url_Tests extends Test
{
  Url_Split_FileScheme_1()
  {
    Url_Split("file:///C:/日本語.txt", &protocol, &host, &port, &pathname, &search, &hash)
    Assert_AreEqual(protocol, "file")
    Assert_AreEqual(host, "")
    Assert_AreEqual(port, "")
    Assert_AreEqual(pathname, "/C:/日本語.txt")
    Assert_AreEqual(search, "")
    Assert_AreEqual(hash, "")
  }
  Url_Split_FileScheme_2()
  {
    Url_Split("file:///C:/%E6%97%A5%E6%9C%AC%E8%AA%9E.txt", &protocol, &host, &port, &pathname, &search, &hash)
    Assert_AreEqual(protocol, "file")
    Assert_AreEqual(host, "")
    Assert_AreEqual(port, "")
    Assert_AreEqual(pathname, "/C:/%E6%97%A5%E6%9C%AC%E8%AA%9E.txt")
    Assert_AreEqual(search, "")
    Assert_AreEqual(hash, "")
  }
  Url_Split_FileScheme_3()
  {
    Url_Split("file://server/share/日本語.txt", &protocol, &host, &port, &pathname, &search, &hash)
    Assert_AreEqual(protocol, "file")
    Assert_AreEqual(host, "server")
    Assert_AreEqual(port, "")
    Assert_AreEqual(pathname, "/share/日本語.txt")
    Assert_AreEqual(search, "")
    Assert_AreEqual(hash, "")
  }
  Url_Split_HttpScheme_1()
  {
    Url_Split("https://example.com/path", &protocol, &host, &port, &pathname, &search, &hash)
    Assert_AreEqual(protocol, "https")
    Assert_AreEqual(host, "example.com")
    Assert_AreEqual(port, "")
    Assert_AreEqual(pathname, "/path")
    Assert_AreEqual(search, "")
    Assert_AreEqual(hash, "")
  }
  Url_Split_HttpScheme_2()
  {
    Url_Split("https://example.com:8080/path?query#hash", &protocol, &host, &port, &pathname, &search, &hash)
    Assert_AreEqual(protocol, "https")
    Assert_AreEqual(host, "example.com")
    Assert_AreEqual(port, "8080")
    Assert_AreEqual(pathname, "/path")
    Assert_AreEqual(search, "query")
    Assert_AreEqual(hash, "hash")
  }
  Url_Compare()
  {
    Assert_IsNegative(Url_Compare("file:///C:/", "file:///C:/path/to/file.txt"))
    Assert_IsNegative(Url_Compare("https://example.com", "https://example.com/path"))
    Assert_IsNegative(Url_Compare("https://example.com", "https://example.co.jp"))
    Assert_IsNegative(Url_Compare("https://example.com", "https://www.example.com"))
    Assert_IsNegative(Url_Compare("https://example.com/p1?k=v", "https://example.com/p1/p2"))
  }
  Url_Download_Example()
  {
    folder := Reg_FolderDescriptions("Downloads")
    name := "example_" A_Now ".html"
    path := Path_Combine(folder, name)
    try
    {
      Url_Download("https://www.example.com/", folder, name)
      Assert_IsTrue(FileExist(path) !== "")
    }
    finally
      if FileExist(path)
        FileDelete(path)
  }
  Url_Download_JsonPlaceholder()
  {
    folder := Reg_FolderDescriptions("Downloads")
    name := "jsonplaceholder_" A_Now ".json"
    path := Path_Combine(folder, name)
    try
    {
      Url_Download("https://jsonplaceholder.typicode.com/posts/1", folder, name)
      Assert_IsTrue(FileExist(path) !== "")
    }
    finally
      if FileExist(path)
        FileDelete(path)
  }
}
Url_Tests()
