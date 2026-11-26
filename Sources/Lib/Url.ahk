#Requires AutoHotkey v2.0

/**
 * @param {String} url
 * @param {String*} [protocol]
 * @param {String*} [host]
 * @param {String*} [port]
 * @param {String*} [pathname]
 * @param {String*} [search]
 * @param {String*} [hash]
 */
Url_Split(url, &protocol?, &host?, &port?, &pathname?, &search?, &hash?)
{
  if RegExMatch(url, "(*UCP)^" RegEx_Http() "$", &matchs)
  {
    protocol := matchs.protocol
    host := matchs.host
    port := matchs.port
    pathname := matchs.pathname
    search := matchs.search
    hash := matchs.hash
    return
  }
  if RegExMatch(url, "(*UCP)^" RegEx_File() "$", &matchs)
  {
    protocol := matchs.protocol
    host := matchs.host
    port := ""
    pathname := matchs.pathname
    search := ""
    hash := ""
    return
  }
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetProtocol(url)
{
  Url_Split(url, &protocol)
  return protocol
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetHost(url)
{
  Url_Split(url, , &host)
  return host
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetPort(url)
{
  Url_Split(url, , , &port)
  return port
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetOrigin(url)
{
  Url_Split(url, &protocol, &host, &port)
  return port !== "" ? Format("{}://{}:{}", protocol, host, port) : Format("{}://{}", protocol, host)
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetPathname(url)
{
  Url_Split(url, , , , &pathname)
  return pathname
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetSearch(url)
{
  Url_Split(url, , , , , &search)
  return search
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetHash(url)
{
  Url_Split(url, , , , , , &hash)
  return hash
}
/**
 * @description Compares two URLs for sorting.
 * - `url1 == url2` => 0
 * - `url1 > url2` => 1
 * - `url1 < url2` => -1
 * @param {String} url1
 * @param {String} url2
 * @returns {Integer}
 */
Url_Compare(url1, url2, *)
{
  if url1 == url2
    return 0
  if String_StartsWith(url1, url2)
    return 1
  if String_StartsWith(url2, url1)
    return -1
  host1 := Stream(StrSplit(Url_GetHost(url1), ".")).Reverse().Join(".")
  host2 := Stream(StrSplit(Url_GetHost(url2), ".")).Reverse().Join(".")
  compare := StrCompare(host1, host2, "Logical")
  if compare !== 0
    return compare
  s1 := StrSplit(Url_GetPathname(url1), "/")
  s2 := StrSplit(Url_GetPathname(url2), "/")
  if s1.Length > s2.Length
    return 1
  if s1.Length < s2.Length
    return -1
  loop Max(s1.Length, s2.Length)
  {
    if A_Index == s1.Length && A_Index == s2.Length
      break
    compare := StrCompare(s1[A_Index], s2[A_Index], "Logical")
    if compare !== 0
      return compare
  }
  return StrCompare(url1, url2, "Logical")
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_Encode(url)
{
  static document := ComObject("HTMLFile")
  static window := document.parentWindow
  static initialized := false
  if !initialized
  {
    /** @see {@link https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa741364(v=vs.85) } */
    window.execScript("function _encodeURI(value) { return encodeURI(value); }")
    initialized := true
  }
  return window._encodeURI(url)
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_Decode(url)
{
  static document := ComObject("HTMLFile")
  static window := document.parentWindow
  static initialized := false
  if !initialized
  {
    /** @see {@link https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa741364(v=vs.85) } */
    window.execScript("function _decodeURI(value) { return decodeURI(value); }")
    initialized := true
  }
  return window._decodeURI(url)
}
/**
 * @param {String} path
 * @returns {String}
 */
Url_Load(path) => IniRead(path, "InternetShortcut", "URL", "")
/**
 * @see {@link https://learn.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/stream-object-ado-reference}
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/winhttp/winhttprequest}
 * @param {String} url
 * @param {String} target
 * @param {String} name
 * @param {Boolean} [overwrite=false]
 * @returns {Boolean}
 * */
Url_Download(url, target, name, overwrite := false)
{
  if !Array_Contains(["http", "https"], Url_GetProtocol(url))
    throw Error("Unsupported URL protocol: " Url_GetProtocol(url))

  whr := ComObject("WinHttp.WinHttpRequest.5.1")
  Notify_ToolTip("Fetching:" url)
  try
  {
    whr.Open("HEAD", url, false)
    whr.Send()
    if whr.Status < 200 || whr.Status >= 300
      throw Error("Failed to fetch URL: " url " with status: " whr.Status)
  }
  finally
    Notify_ToolTip()

  name := Path_GetName(name)
  if name == ""
    throw Error("Invalid file name.")
  ext := Path_GetExtensionName(name)
  if ext == ""
  {
    mimeType := StrSplit(whr.GetResponseHeader("Content-Type"), ";")[1]
    ext := ContentType_ToExtension(mimeType)
    if ext == ""
      throw Error("Failed to determine file extension for URL: " url " with MIME type: " mimeType)

    name .= ext
  }
  path := Path_Combine(target, name)
  if FileExist(path)
  {
    if !overwrite
      switch MsgBox(Format('"{}" already exists.`nDo you want to overwrite?', path), , 0x23)
      {
        case "No":
          return false
        case "Cancel":
          throw Error("Canceled by user.")
      }
  }
  Notify_ToolTip("Downloading:" url " as " name)
  try
  {
    whr.Open("GET", url, false)
    whr.Send()
    if whr.Status < 200 || whr.Status >= 300
      throw Error("Failed to download URL: " url " with status: " whr.Status)
    fs := ComObject("ADODB.Stream")
    fs.Type := 1  ; adTypeBinary
    fs.Open()
    fs.Write(whr.ResponseBody)
    fs.SaveToFile(path, 2)  ; adSaveCreateOverWrite
    fs.Close()
    return true
  }
  finally
    Notify_ToolTip()
}
/**
 * @see {@link https://learn.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/stream-object-ado-reference}
 * @param {ComObject} whr
 * @returns {String}
 */
Url_GetResponseText(whr)
{
  text := ""
  try
    text := whr.ResponseText
  catch
    text := ""
  charset := Url_GetResponseCharset(whr.GetResponseHeader("Content-Type"), text)
  try
    return Url_DecodeResponseBody(whr.ResponseBody, charset)
  catch
    return text
}
/**
 * Resolves the charset of a response body.
 * The `Content-Type` header takes precedence, then the `<meta>` declarations, and finally the default `utf-8`.
 * @param {String} contentType
 * @param {String} text
 * @returns {String}
 */
Url_GetResponseCharset(contentType, text)
{
  charset := Url_GetCharsetFromContentType(contentType)
  if charset !== ""
    return charset
  charset := Url_GetCharsetFromMetaElement(text)
  if charset !== ""
    return charset
  return "utf-8"
}
/**
 * @param {String} contentType
 * @returns {String}
 */
Url_GetCharsetFromContentType(contentType)
{
  if RegExMatch(contentType, "i)\bcharset\s*=\s*([^;\s]+)", &match)
    return Url_NormalizeCharset(Trim(match[1], "`"'"))
  return ""
}
/**
 * @param {String} text
 * @returns {String}
 */
Url_GetCharsetFromMetaElement(text)
{
  try
  {
    document := ComObject("HTMLfile")
    document.write(text)
    metas := document.getElementsByTagName("meta")
    loop metas.length
    {
      meta := metas.item(A_Index - 1)
      charset := ""
      try
        charset := meta.charset
      catch
        charset := ""
      if charset !== ""
        return Url_NormalizeCharset(charset)
      try
        if StrLower(meta.httpEquiv) == "content-type"
          charset := Url_GetCharsetFromContentType(meta.content)
      catch
        charset := ""
      if charset !== ""
        return charset
    }
  }
  catch
    return ""
  return ""
}
/**
 * Normalizes a charset name to one accepted by `ADODB.Stream`.
 * @param {String} charset
 * @returns {String}
 */
Url_NormalizeCharset(charset)
{
  static aliases := Map(
    "ascii", "us-ascii",
    "cp1252", "windows-1252",
    "cp932", "shift_jis",
    "eucjp", "euc-jp",
    "latin1", "iso-8859-1",
    "ms_kanji", "shift_jis",
    "shift-jis", "shift_jis",
    "sjis", "shift_jis",
    "utf-16", "unicode",
    "utf-16be", "unicodeFFFE",
    "utf-16le", "unicode",
    "utf16", "unicode",
    "utf8", "utf-8",
    "windows-31j", "shift_jis",
    "x-sjis", "shift_jis",
  )
  key := StrLower(Trim(charset))
  return aliases.Has(key) ? aliases[key] : key
}
/**
 * @param {Any} body
 * @param {String} charset
 * @returns {String}
 */
Url_DecodeResponseBody(body, charset)
{
  try
    return Url_DecodeResponseBodyWith(body, charset)
  catch
    return Url_DecodeResponseBodyWith(body, "utf-8")
}
/**
 * @param {Any} body
 * @param {String} charset
 * @returns {String}
 */
Url_DecodeResponseBodyWith(body, charset)
{
  fs := ComObject("ADODB.Stream")
  try
  {
    fs.Type := 1  ; adTypeBinary
    fs.Open()
    fs.Write(body)
    fs.Position := 0
    fs.Type := 2  ; adTypeText
    fs.Charset := charset
    return fs.ReadText()
  }
  finally
    fs.Close()
}
/**
 * @see {@link https://learn.microsoft.com/ja-jp/windows/win32/winhttp/winhttprequestoption}
 * @param {String} url
 * @returns {{ href: String, text: String }}
 */
Url_GetTitle(url)
{
  static cache := Map()
  if cache.Has(url)
    return cache.Get(url)

  try
    switch Url_GetProtocol(url)
    {
      case "file":
        path := Path_FromURL(url)
        if !FileExist(path)
          path := Path_FromURL(Url_Decode(url))
        if !FileExist(path)
          throw Error("File not found: " path)
        value := { href: url, text: Path_GetName(path) }
        cache.Set(url, value)
        return value
      default:
        Notify_ToolTip("Fetching:" url)
        static WinHttpRequestOption_URL := 1
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, false)
        whr.Send()
        Log_Trace("Fetch", url, whr.Status)
        if whr.Status < 200 || whr.Status >= 300
        {
          value := { href: url, text: url }
          cache.Set(url, value)
          return value
        }
        document := ComObject("HTMLfile")
        document.write(Url_GetResponseText(whr))
        value := { href: whr.Option(WinHttpRequestOption_URL), text: document.title }
        cache.Set(url, value)
        return value
    }
  finally
    Notify_ToolTip()
}
