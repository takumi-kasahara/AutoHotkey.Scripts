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

ContextMenu_Edit(String_Dedent(Trim(A_Clipboard, "`r`n"))).Show()

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
      ctxPath.Add("BaseName", () => View_Text(baseNames))
    fileNames := Array_Unique(Stream(paths).Map(Path_GetName).Filter(name => !String_IsNullOrWhitespace(name)).ToArray())
    if fileNames.Length > 0
      ctxPath.Add("FileName", () => View_Text(fileNames))
    ctxPath.AddSubMenu("FullName", ContextMenu_FormatPath(Array_Unique(paths)))
    parents := Array_Unique(Stream(paths).ToArray(Path_GetParent))
    if parents.Length > 0
      ctxPath.AddSubMenu("Parent", ContextMenu_FormatPath(parents))
    ctxPath.AddSubMenu("Local", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(Path_ToLocal))))
    ctxPath.AddSubMenu("Network", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(Path_ToNetwork))))
    ctxPath.AddSubMenu("URL", ContextMenu_FormatPath(Array_Unique(Stream(paths).Map(Path_ToURL).ToArray(Url_Encode))))
    ctxPath.AddSubMenu("Replace \ -> /", ContextMenu_FormatPath(Array_Unique(Stream(paths).ToArray(path => StrReplace(path, "\", "/")))))
    ctxPath.Add("Property", () => View_Csv(Path_GetProperty(paths), 1))
    ctx.AddSubMenu(Format("Path ({})", paths.Length), ctxPath)
    ctx.AddSeparator()
  }
  urls := Clipboard_ExtractUrl()
  if urls.Length > 0
  {
    ctxUrl := ContextMenu()
    ctxUrl.Add("Plaintext", () => View_Text(Stream(urls).ToArray(url => Url_Decode(url))))
    links := Stream(Clipboard_ExtractLink()).Filter(link => Url_GetProtocol(link.href) ~= "^(?i:https?)$").ToArray()
    if links.Length > 0
    {
      ctxHtml := ContextMenu()
      ctxHtml.Add("Copy Title", () => View_Text(Stream(links).ToArray(link => link.title)))
      ctxHtml.Add("Copy Link as HTML", () => View_Text(Stream(links).ToArray(link => Document_CreateAnchorElement(link.href, link.title)), "html"))
      ctxHtml.Add("Copy Link as Markdown", () => View_Text(Stream(links).ToArray(link => Format("[{}]({})", link.title, link.href)), "md"))
      ctxHtml.Add("Save", Dialog_SaveUrl.Bind(links))
      ctxUrl.AddSeparator()
      ctxUrl.AddSubMenu(Format("Links ({})", links.Length), ctxHtml)
    }
    ctx.AddSubMenu(Format("URL ({})", urls.Length), ctxUrl)
    ctx.AddSeparator()
  }
  ctx.Add(Format("Plaintext ({} Chars)", StrLen(input)), () => View_Text(input))
  html := Clipboard_GetHtml()
  if html
    ctx.Add(Format("HTML ({} Chars)", StrLen(html)), () => View_Text(html, "html"))
  ctx.AddSeparator()
  ctx.Add("Sort", () => View_Text(Array_Sort(StrSplit(input, "`n"))))
  ctx.Add("Sort (Unique)", () => View_Text(Array_Unique(StrSplit(input, "`n"))))

  ctxCase := ContextMenu()
  ctxCase.Add("Lower", () => View_Text(StrLower(input)))
  ctxCase.Add("Upper", () => View_Text(StrUpper(input)))
  ctxCase.Add("Title", () => View_Text(StrTitle(input)))
  ctx.AddSubMenu("Case", ctxCase)

  ctxNormalize := ContextMenu()
  ctxNormalize.Add("NFC", () => View_Text(String_Normalize(input, "NFC")))
  ctxNormalize.Add("NFD", () => View_Text(String_Normalize(input, "NFD")))
  ctxNormalize.Add("NFKC", () => View_Text(String_Normalize(input, "NFKC")))
  ctxNormalize.Add("NFKD", () => View_Text(String_Normalize(input, "NFKD")))
  ctx.AddSubMenu("Normalize", ctxNormalize)

  ctxConvert := ContextMenu()
  ctxConvertFrom := ContextMenu()
  ctxConvertFrom.Add("Json", () => View_Text(ConvertFrom_Json(input)))
  ctxConvertFrom.Add("SQL", () => View_Text(ConvertFrom_SQL(input)))
  ctxConvertFrom.Add("PowerShell", () => View_Text(ConvertFrom_PowerShell(input)))
  ctxConvertFrom.Add("Visual Basic", () => View_Text(ConvertFrom_VisualBasic(input)))
  ctxConvert.AddSubMenu("From", ctxConvertFrom)

  ctxConvertTo := ContextMenu()
  ctxConvertTo.Add("Json", () => View_Text(ConvertTo_Json(input)))
  ctxConvertTo.Add("Json (Array)", () => View_Text(String_Edit(input, field => ConvertTo_Json(field) ",")))
  ctxConvertTo.Add("SQL", () => View_Text(ConvertTo_SQL(input)))
  ctxConvertTo.Add("PowerShell", () => View_Text(ConvertTo_PowerShell(input)))
  ctxConvertTo.Add("PowerShell (Array)", () => View_Text(String_Edit(input, ConvertTo_PowerShell)))
  ctxConvertTo.Add("Visual Basic", () => View_Text(ConvertTo_VisualBasic(input)))
  ctxConvertTo.Add("Visual Basic (Array)", () => View_Text(String_Edit(input, field => ConvertTo_VisualBasic(field) ",")))
  ctxConvert.AddSubMenu("To", ctxConvertTo)
  ctx.AddSubMenu("Convert", ctxConvert)

  ctxMarkdown := ContextMenu()
  ctxMarkdown.Add("Code (Blockquote)", () => View_Text("```````n" input "`n``````", "md"))
  ctxMarkdown.Add("Code (Inline)", () => View_Text("``" input "``", "md"))
  ctxMarkdown.Add("Quote", () => View_Text(String_Edit(input, field => "> " field), "md"))
  ctx.AddSubMenu("Markdown", ctxMarkdown)

  ctxSplit := ContextMenu()
  ctxSplit.AddSubMenu("EOL", ContextMenu_Join(input, "\r?\n"))
  ctxSplit.AddSubMenu("TAB", ContextMenu_Join(input, "(*UCP)\s+"))
  ctxSplit.AddSubMenu("comma", ContextMenu_Join(input, "(*UCP)\s*,\s*"))
  ctxSplit.AddSubMenu("period", ContextMenu_Join(input, "(*UCP)\s*\.\s*"))
  ctxSplit.AddSubMenu("colon", ContextMenu_Join(input, "(*UCP)\s*:\s*"))
  ctxSplit.AddSubMenu("semi", ContextMenu_Join(input, "(*UCP)\s*;\s*"))
  ctx.AddSubMenu("Split by", ctxSplit)

  return ctx
}
/**
 * @param {Array<String>} values
 * @returns {ContextMenu}
 */
ContextMenu_FormatPath(values)
{
  ctx := ContextMenu()
  ctx.Add("Copy as Plaintext", () => View_Text(values))
  ctx.Add("Copy as Markdown List", () => View_Text(Stream(values).ToArray(v => "- " v), "md"))
  ctx.Add("Copy as Markdown List (Ordered)", () => View_Text(Stream(values).ToArray(v => "1. " v), "md"))
  ctx.Add("Copy as HTML List", () => View_Text(Document_CreateListElement(values), "html"))
  ctx.Add("Copy as HTML List (Ordered)", () => View_Text(Document_CreateOrderedListElement(values), "html"))
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
  ctxJoin.Add("EOL", () => View_Text(RegExReplace(input, regex, "`n")))
  ctxJoin.Add("TAB", () => View_Text(RegExReplace(input, regex, "`t")))
  ctxJoin.Add("comma", () => View_Text(RegExReplace(input, regex, ",")))
  ctxJoin.Add("period", () => View_Text(RegExReplace(input, regex, ".")))
  ctxJoin.Add("colon", () => View_Text(RegExReplace(input, regex, ":")))
  ctxJoin.Add("semi", () => View_Text(RegExReplace(input, regex, ";")))
  ctx.AddSubMenu("Join by", ctxJoin)
  return ctx
}
