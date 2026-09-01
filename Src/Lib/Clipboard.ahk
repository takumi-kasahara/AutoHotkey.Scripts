#Requires AutoHotkey v2.0

Clipboard_Load()
{
  clip := FileSelect(0x1 ^ 0x2, A_Temp, "Clipboard", "Clipboard (*.clip)")
  if clip !== ""
    A_Clipboard := ClipboardAll(FileRead(clip, "RAW"))
}
/**
 * @param {String | Array | Func | BoundFunc} input
 */
Clipboard_SetText(input)
{
  value := ConvertTo_String(input)
  if !String_IsNullOrWhitespace(value)
    A_Clipboard := value
}
/**
 * @returns {String}
 */
Clipboard_GetText() => String_Dedent(Trim(A_Clipboard, "`r`n"))
/**
 * @returns {String}
 */
Clipboard_GetHtml()
{
  static CF_HTML := RegisterClipboardFormat("HTML Format")
  return GetClipboardData(CF_HTML)
  /**
   * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclipboarddata}
   * @param {Integer} uFormat
   * @returns {String}
   */
  GetClipboardData(uFormat)
  {
    if !OpenClipboard()
      return
    try
    {
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclipboarddata} */
      hMem := DllCall("GetClipboardData"
        , "UInt", uFormat ; UINT  uFormat
        , "Ptr"           ; HANDLE
      )
      if hMem == NULL
        return
      try
      {
        pMem := GlobalLock(hMem)
        data := StrGet(pMem, "UTF-8")
        return data
      }
      finally
        GlobalUnlock(hMem)
    }
    finally
      CloseClipboard()
  }
}
/**
 * @returns {String}
 */
Clipboard_GetBlockquote()
{
  html := Clipboard_GetHtml()
  if !html
    return ""
  sourceUrl := ""
  if RegExMatch(html, "(?m)^SourceURL:(.+?)[\r\n]", &m)
    sourceUrl := Trim(m[1])
  return Document_CreateBlockquoteElement(sourceUrl, A_Clipboard)
}
/**
 * @param {String | Array | Func | BoundFunc} input
 */
Clipboard_SetHtml(input)
{
  value := ConvertTo_String(input)
  if String_IsNullOrWhitespace(value)
    return
  if !OpenClipboard()
    return
  try
  {
    if !EmptyClipboard()
      return
    static CF_UNICODETEXT := 13
    if !SetClipboardData(CF_UNICODETEXT, value, "UTF-16")
      return
    static CF_HTML := RegisterClipboardFormat("HTML Format")
    if !SetClipboardData(CF_HTML, GetClipboardFormat(value), "UTF-8")
      return
  }
  finally
    CloseClipboard()
  /**
   * @see {@link https://learn.microsoft.com/en-us/windows/win32/dataxchg/html-clipboard-format}
   * @param {String} html
   * @returns {String}
   */
  GetClipboardFormat(html)
  {
    prefix := "<html><body><!--StartFragment-->"
    suffix := "<!--EndFragment--></body></html>"
    fragment := prefix html suffix
    template := "
    (
    Version:0.9
    StartHTML:{:010}
    EndHTML:{:010}
    StartFragment:{:010}
    EndFragment:{:010}
    )" "`n"
    header := Format(template, 0, 0, 0, 0)
    startHTML := StrPut(header, "UTF-8") - 1
    startFragment := startHTML + StrPut(prefix, "UTF-8") - 1
    endFragment := startFragment + StrPut(html, "UTF-8") - 1
    endHTML := startHTML + StrPut(fragment, "UTF-8") - 1
    return Format(template, startHTML, endHTML, startFragment, endFragment) fragment
  }
  /**
   * @param {Integer} uFormat
   * @param {String} value
   * @param {String} encoding
   * @returns {Integer}
   */
  SetClipboardData(uFormat, value, encoding)
  {
    try
    {
      hMem := GlobalAlloc(StrPut(value, encoding), encoding)
      if hMem == NULL
        return false
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setclipboarddata} */
      if DllCall("SetClipboardData"
        , "UInt", uFormat ; UINT    uFormat
        , "Ptr", hMem     ; HANDLE  hMem
        , "Ptr"           ; HANDLE
      ) == NULL
        return false
      return true
    }
    catch as ex
    {
      Log_Error(ex)
      GlobalFree(hMem)
    }
    /**
     * @param {Integer} size
     * @param {String} encoding
     * @returns {Integer} HGLOBAL
     */
    GlobalAlloc(size, encoding)
    {
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globalalloc} */
      static GMEM_MOVEABLE := 0x0002
      hMem := DllCall("GlobalAlloc"
        , "UInt", GMEM_MOVEABLE ; UINT    uFlags
        , "UPtr", size          ; SIZE_T  dwBytes
        , "Ptr"                 ; HGLOBAL
      )
      if hMem == NULL
        return hMem
      pMem := GlobalLock(hMem)
      try
        StrPut(value, pMem, encoding)
      finally
        GlobalUnlock(hMem)
      return hMem
    }
  }
}
/**
 * @param {String} input
 * @returns {Array<String>}
 */
Clipboard_ExtractPath()
{
  paths := []
  loop parse, A_Clipboard, "`n", "`r"
  {
    path := String_ExtractPath(A_LoopField)
    if path == ""
      continue
    Log_Trace("Extracted", path)
    paths.Push(path)
  }
  return Array_Unique(paths, , , Path_Compare)
}
/**
 * @param {Boolean} [allowFileURI=false]
 * @returns {Array<String>}
 */
Clipboard_ExtractUrl(allowFileURI := false)
{
  urls := []
  loop parse, A_Clipboard, "`n", "`r"
  {
    url := String_ExtractUrl(A_LoopField)
    if url == ""
      continue
    Log_Trace("Extracted", url)
    urls.Push(url)
  }
  return Array_Sort(Array_Unique(Array_Union(urls, Stream(Clipboard_ExtractLink(allowFileURI)).ToArray(link => link.href))), , , Url_Compare)
}
/**
 * @param {Boolean} [allowFileURI=false]
 * @returns {Array<{ href: String, title: String }>}
 */
Clipboard_ExtractLink(allowFileURI := false)
{
  html := Clipboard_GetHtml()
  if html
    return Document_ExtractLinks(html)
  paths := Clipboard_ExtractPath()
  if paths.Length == 0
    return []

  if allowFileURI
    return Stream(paths).Map(path => Path_GetExtensionName(path) ~= "^(?i:url)$" ? ({ href: Url_Load(path), title: Path_GetBaseName(path) }) : ({ href: Url_Encode(Path_ToURL(path)), title: Path_GetName(path) })).ToArray()
  else
    return Stream(paths).Filter(path => Path_GetExtensionName(path) ~= "^(?i:url)$").Map(path => { href: Url_Load(path), title: Path_GetBaseName(path) }).ToArray()
}
