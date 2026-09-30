#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)
OnExit(HandleExit)

ContextMenu_Edit(Clipboard_GetText()).Show()

/**
 * @param {String} input
 * @returns {ContextMenu}
 */
ContextMenu_Edit(input)
{
  ctx := ContextMenu()
  if String_IsNullOrWhitespace(input)
    return ctx
  paths := Clipboard_ExtractPath()
  if paths.Length > 0
  {
    ctxPath := ContextMenu()
    baseNames := Array_Unique(Stream(paths).Map(Path_GetBaseName).Filter(name => !String_IsNullOrWhitespace(name)).ToArray())
    if baseNames.Length > 0
      ctxPath.Add("BaseName", () => Gui_TextView(baseNames))
    fileNames := Array_Unique(Stream(paths).Map(Path_GetName).Filter(name => !String_IsNullOrWhitespace(name)).ToArray())
    if fileNames.Length > 0
      ctxPath.Add("FileName", () => Gui_TextView(fileNames))
    ctxPath.AddSubMenu("FullName", ContextMenu_FormatPath(Array_Unique(paths)))
    parents := Array_Unique(Stream(paths).ToArray(Path_GetParent))
    if parents.Length > 0
      ctxPath.AddSubMenu("Parent", ContextMenu_FormatPath(parents))
    ctxPath.AddSubMenu("Local", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(Path_ToLocal))))
    ctxPath.AddSubMenu("Network", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(Path_ToNetwork))))
    ctxPath.AddSubMenu("URL", ContextMenu_FormatPath(Array_Unique(Stream(paths).Map(Path_ToURL).ToArray(Url_Encode))))
    ctxPath.AddSubMenu("Replace \ -> /", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(path => StrReplace(path, "\", "/")))))
    ctxPath.Add("Property", () => Gui_CsvView(Path_GetProperty(paths), 1))
    ctx.AddSubMenu(Format("Path ({})", paths.Length), ctxPath)
    ctx.AddSeparator()
  }
  urls := Clipboard_ExtractUrl(true)
  if urls.Length > 0
  {
    ctxUrl := ContextMenu()
    if urls.Length == 1
      ctxUrl.Add("Edit", Edit_Hyperlink.Bind(Url_GetTitle.Bind(urls[1])))
    else
    {
      ctxEdit := ContextMenu()
      for url in urls
        ctxEdit.Add(Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, url), Edit_Hyperlink.Bind(Url_GetTitle.Bind(url)))
      ctxUrl.AddSubMenu("Edit", ctxEdit)
    }
    ctxUrl.AddSeparator()
    ctxUrl.Add("Copy as Plaintext", () => Gui_TextView(Stream(urls).ToArray(url => Url_Decode(url))))
    ctxUrl.Add("Copy as Markdown", () => Gui_TextView(Stream(urls).ToArray(url => ConvertTo_MarkdownLink(Url_Decode(url)))))
    ctxUrl.Add("Copy as Excel", () => Gui_TextView(Stream(urls).ToArray(url => ConvertTo_ExcelHyperlink(Url_Decode(url)))))
    ctx.AddSubMenu(Format("URL ({})", urls.Length), ctxUrl)
    ctx.AddSeparator()
  }
  links := Clipboard_ExtractLink(true)
  if links.Length > 0
  {
    ctxLink := ContextMenu()
    if links.Length == 1
    {
      link := links[1]
      ctxLink.Add("Edit", () => Edit_Hyperlink(link))
      ctxLink.AddSeparator()
      ctxLink.Add("Copy Link as HTML", () => Gui_TextView(Document_CreateAnchorElement(link), "html"))
      ctxLink.Add("Copy Link as Markdown", () => Gui_TextView(ConvertTo_MarkdownLink(link.href, link.text)), "md")
      ctxLink.Add("Copy Link as Excel", () => Gui_TextView(ConvertTo_ExcelHyperlink(link.href, link.text)))
    }
    else
    {
      ctxEdit := ContextMenu()
      for link in links
        ctxEdit.Add(Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, link.text), Edit_Hyperlink.Bind(link))
      ctxLink.AddSubMenu("Edit", ctxEdit)
      ctxLink.AddSeparator()
      ctxLink.Add("Copy Link as HTML List", () => Gui_TextView(Document_CreateListElement(links), "html"))
      ctxLink.Add("Copy Link as HTML List (Ordered)", () => Gui_TextView(Document_CreateOrderedListElement(links), "html"))
      ctxLink.Add("Copy Link as Markdown List", () => Gui_TextView(Stream(links).ToArray(link => "- " ConvertTo_MarkdownLink(link.href, link.text)), "md"))
      ctxLink.Add("Copy Link as Markdown List (Ordered)", () => Gui_TextView(Stream(links).ToArray(link => "1. " ConvertTo_MarkdownLink(link.href, link.text)), "md"))
      ctxLink.Add("Copy Link as Excel", () => Gui_TextView(Stream(links).ToArray(link => ConvertTo_ExcelHyperlink(link.href, link.text))))
    }
    ctxLink.AddSeparator()
    ctxLink.Add("Download", Dialog_Download.Bind(links))
    ctxLink.Add("Save", Dialog_SaveUrl.Bind(links))
    ctx.AddSubMenu(Format("Links ({})", links.Length), ctxLink)
    ctx.AddSeparator()
  }
  html := Clipboard_GetHtml()
  if html
  {
    ctxLink := ContextMenu()
    ctxLink.Add("Blockquote", () => Gui_TextView(Clipboard_GetBlockquote(), "html"))
    ctxLink.Add("Code", () => Gui_TextView(Document_CreateCodeElement(input), "html"))
    ctxLink.Add("Markdown (CommonMark)", () => Gui_TextView(ConvertFrom_Html(html)), "md")
    ctxLink.Add("Markdown (GFM)", () => Gui_TextView(ConvertFrom_Html(html), "gfm"), "md")
    ctxLink.Add("Raw", () => Gui_TextView(html, "html"))
    ctx.AddSubMenu("HTML", ctxLink)
    ctx.AddSeparator()
  }

  ctxText := ContextMenu()

  ctxMarkdown := ContextMenu()
  ctxMarkdown.Add("HTML", () => Gui_TextView(ConvertTo_Html(input), "html"))
  ctxMarkdown.Add("Blockquote", () => Gui_TextView(String_Edit(input, field => "> " field), "md"))
  ctxMarkdown.Add("Code", () => Gui_TextView(StrSplit(input, "`n").Length == 1 ? "``" input "``" : "```````n" input "`n``````", "md"))
  ctxText.AddSubMenu("Markdown", ctxMarkdown)

  ctxText.AddSeparator()

  ctxText.Add("Sort", () => Gui_TextView(Array_Sort(StrSplit(input, "`n"))))
  ctxText.Add("Sort (Unique)", () => Gui_TextView(Array_Unique(StrSplit(input, "`n"))))

  ctxCase := ContextMenu()
  ctxCase.Add("Lower", () => Gui_TextView(StrLower(input)))
  ctxCase.Add("Upper", () => Gui_TextView(StrUpper(input)))
  ctxCase.Add("Title", () => Gui_TextView(StrTitle(input)))
  ctxText.AddSubMenu("Case", ctxCase)

  ctxNormalize := ContextMenu()
  ctxNormalize.Add("NFC", () => Gui_TextView(String_Normalize(input, "NFC")))
  ctxNormalize.Add("NFD", () => Gui_TextView(String_Normalize(input, "NFD")))
  ctxNormalize.Add("NFKC", () => Gui_TextView(String_Normalize(input, "NFKC")))
  ctxNormalize.Add("NFKD", () => Gui_TextView(String_Normalize(input, "NFKD")))
  ctxText.AddSubMenu("Normalize", ctxNormalize)

  ctxText.AddSeparator()

  ctxConvert := ContextMenu()
  ctxConvert.AddSubMenu("Plaintext", ContextMenu_ConvertTo(input))
  ctxConvert.AddSubMenu("AutoHotkey", ContextMenu_ConvertTo(ConvertFrom_AutoHotkey(input)))
  ctxConvert.AddSubMenu("Json", ContextMenu_ConvertTo(ConvertFrom_Json(input)))
  ctxConvert.AddSubMenu("PowerShell", ContextMenu_ConvertTo(ConvertFrom_PowerShell(input)))
  ctxConvert.AddSubMenu("Excel", ContextMenu_ConvertTo(ConvertFrom_Excel(input)))
  ctxConvert.AddSubMenu("Visual Basic", ContextMenu_ConvertTo(ConvertFrom_VisualBasic(input)))
  ctxConvert.AddSubMenu("SQL", ContextMenu_ConvertTo(ConvertFrom_SQL(input)))
  ctxText.AddSubMenu("Convert from", ctxConvert)

  ctxSplit := ContextMenu()
  ctxSplit.AddSubMenu("EOL", ContextMenu_Join(input, "\r?\n"))
  ctxSplit.AddSubMenu("TAB", ContextMenu_Join(input, "(*UCP)\s+"))
  ctxSplit.AddSubMenu("comma", ContextMenu_Join(input, "(*UCP)\s*,\s*"))
  ctxSplit.AddSubMenu("period", ContextMenu_Join(input, "(*UCP)\s*\.\s*"))
  ctxSplit.AddSubMenu("colon", ContextMenu_Join(input, "(*UCP)\s*:\s*"))
  ctxSplit.AddSubMenu("semi", ContextMenu_Join(input, "(*UCP)\s*;\s*"))
  ctxText.AddSubMenu("Split by", ctxSplit)

  ctx.AddSubMenu("Plaintext", ctxText)

  return ctx
}
/**
 * @param {Array<String>} values
 * @returns {ContextMenu}
 */
ContextMenu_FormatPath(values)
{
  ctx := ContextMenu()
  ctx.Add("Copy as Plaintext", () => Gui_TextView(values))
  ctx.Add("Copy as Markdown List", () => Gui_TextView(Stream(values).ToArray(v => "- " v), "md"))
  ctx.Add("Copy as Markdown List (Ordered)", () => Gui_TextView(Stream(values).ToArray(v => "1. " v), "md"))
  ctx.Add("Copy as HTML List", () => Gui_TextView(Document_CreateListElement(values), "html"))
  ctx.Add("Copy as HTML List (Ordered)", () => Gui_TextView(Document_CreateOrderedListElement(values), "html"))
  return ctx
}
/**
 * @param {String} input
 * @returns {ContextMenu}
 */
ContextMenu_ConvertTo(input)
{
  ctx := ContextMenu()
  ctxConvertTo := ContextMenu()
  ctxConvertTo.Add("Plaintext", () => Gui_TextView(input))
  ctxConvertTo.Add("AutoHotkey", () => Gui_TextView(ConvertTo_AutoHotkey(input)))
  ctxConvertTo.Add("Json", () => Gui_TextView(ConvertTo_Json(input)))
  ctxConvertTo.Add("PowerShell", () => Gui_TextView(ConvertTo_PowerShell(input)))
  ctxConvertTo.Add("Excel", () => Gui_TextView(String_Edit(input, field => ConvertTo_Excel(field) ",")))
  ctxConvertTo.Add("Visual Basic", () => Gui_TextView(ConvertTo_VisualBasic(input)))
  ctxConvertTo.Add("SQL", () => Gui_TextView(ConvertTo_SQL(input)))
  ctx.AddSubMenu("Convert to", ctxConvertTo)
  return ctx
}
/**
 * @param {String} input
 * @param {String} regex
 * @returns {ContextMenu}
 */
ContextMenu_Join(input, regex)
{
  ctx := ContextMenu()
  ctxJoin := ContextMenu()
  ctxJoin.Add("EOL", () => Gui_TextView(RegExReplace(input, regex, "`n")))
  ctxJoin.Add("TAB", () => Gui_TextView(RegExReplace(input, regex, "`t")))
  ctxJoin.Add("comma", () => Gui_TextView(RegExReplace(input, regex, ",")))
  ctxJoin.Add("period", () => Gui_TextView(RegExReplace(input, regex, ".")))
  ctxJoin.Add("colon", () => Gui_TextView(RegExReplace(input, regex, ":")))
  ctxJoin.Add("semi", () => Gui_TextView(RegExReplace(input, regex, ";")))
  ctx.AddSubMenu("Join by", ctxJoin)
  return ctx
}
