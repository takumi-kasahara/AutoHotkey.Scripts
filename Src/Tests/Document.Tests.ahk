#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
OnError(HandleError)
OnExit(HandleExit)

class Document_Tests extends Test
{
  Document_CreateAnchorElement()
  {
    url := "https://www.example.com"
    html := Document_CreateAnchorElement(url, "example")
    document := ComObject("HTMLFile")
    document.write(html)
    anchor := document.getElementsByTagName("a").item(0)

    Assert_IsTrue(anchor.href ~= "^https://www\.example\.com/?$")
    Assert_AreEqual("noreferrer", anchor.rel)
    Assert_AreEqual("_blank", anchor.target)
    Assert_AreEqual("example", anchor.innerText)
  }
  Document_CreateBlockquoteElement_1()
  {
    url := "https://www.example.com"
    text := "lorem ipsum"
    html := Document_CreateBlockquoteElement(url, text)
    document := ComObject("HTMLFile")
    document.write(html)
    blockquote := document.getElementsByTagName("blockquote").item(0)

    Assert_AreEqual(url, blockquote.cite)
    Assert_AreEqual(text, blockquote.innerText)
  }
  Document_CreateBlockquoteElement_2()
  {
    url := ""
    text := "lorem ipsum"
    html := Document_CreateBlockquoteElement(url, text)
    document := ComObject("HTMLFile")
    document.write(html)
    blockquote := document.getElementsByTagName("blockquote").item(0)

    Assert_AreEqual(url, blockquote.cite)
    Assert_AreEqual(text, blockquote.innerText)
  }
  Document_CreateCodeElement()
  {
    text := "lorem ipsum"
    html := Document_CreateCodeElement(text)
    document := ComObject("HTMLFile")
    document.write(html)
    code := document.getElementsByTagName("code").item(0)

    Assert_AreEqual(text, code.innerText)
  }
  Document_CreateListElement()
  {
    items := ["alpha", "bravo", "charlie"]
    html := Document_CreateListElement(items)
    document := ComObject("HTMLFile")
    document.write(html)
    list := document.getElementsByTagName("ul").item(0)
    listItems := list.getElementsByTagName("li")

    Assert_AreEqual(3, listItems.length)
  }
  Document_CreateOrderedListElement()
  {
    items := ["one", "two", "three"]
    html := Document_CreateOrderedListElement(items)
    document := ComObject("HTMLFile")
    document.write(html)
    list := document.getElementsByTagName("ol").item(0)
    listItems := list.getElementsByTagName("li")

    Assert_AreEqual(3, listItems.length)
  }
  Document_ExtractLinks()
  {
    html := ""
      . "<a href='https://example.com'>url</a>"
      . "<a href='mailto:postmaster@example.com'>mail</a>"
      . "<a href='file:///C:/Windows/explorer.exe'></a>"
    links := Document_ExtractLinks(html)

    Assert_AreEqual(2, links.Length)
    Assert_IsTrue(links[1].href ~= "^https://example\.com/?$")
    Assert_AreEqual("url", links[1].title)
    Assert_IsTrue(links[2].href ~= "^file:///C:/Windows/explorer\.exe$")
    Assert_AreEqual(links[2].href, links[2].title)
  }
}
Document_Tests()
