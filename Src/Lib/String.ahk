#Requires AutoHotkey v2.0

/**
 * @param {String} this
 */
String_IsNullOrWhitespace(this) => this ~= "(*UCP)^\s*$"
/**
 * @param {String} this
 * @param {Func | BoundFunc} editor
 */
String_Edit(this, editor)
{
  edited := ""
  sep := ""
  loop parse, this, "`n", "`r"
  {
    edited .= sep
    edited .= editor.Call(RegExReplace(A_LoopField, "(*UCP)\s+$"))
    sep := "`n"
  }
  return edited
}
/**
 * @param {String} this
 * @param {String} enclosure
 * @returns {String}
 */
String_Enclose(this, enclosure := '"') => enclosure this enclosure
/**
 * @param {String} separator
 * @param {String*} segments
 * @returns {String}
 */
String_Join(separator, segments*) => Enumerable_Join(segments, separator)
/**
 * @param {String} this
 * @param {String} value
 * @returns {Integer}
 */
String_Strip(this, enclosure := '"')
{
  tmp := Trim(this)
  if SubStr(tmp, 1, 1) == enclosure && SubStr(tmp, -1) == enclosure
    tmp := SubStr(tmp, 2, -1)
  return tmp
}
String_StartsWith(this, value) => StrLen(value) <= StrLen(this) && SubStr(this, 1, StrLen(value)) == value
/**
 * @param {String} this
 * @param {String} value
 * @returns {Integer}
 */
String_EndsWith(this, value) => StrLen(value) <= StrLen(this) && SubStr(this, -StrLen(value) + 1) == value
/**
 * @param {String} this
 * @param {String} [form="NFC"] NFC | NFD | NFKC | NFKD
 * @returns {String}
 */
String_Normalize(this, form := "NFC")
{
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winnls/ne-winnls-norm_form} */
  static NORM_FORM := Map(
    "NFC", 0x1,
    "NFD", 0x2,
    "NFKC", 0x5,
    "NFKD", 0x6,
  )
  if !NORM_FORM.Has(form)
    throw ValueError("Invalid:`t" form)
  buf := ""
  bufSize := 0
  bufSize := NormalizeString()
  if bufSize <= 0
    throw OSError()
  VarSetStrCapacity(&buf, bufSize * 2)
  bufSize := NormalizeString()
  return buf

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-normalizestring} */
  NormalizeString() => DllCall("Normaliz\NormalizeString"
    , "UInt", NORM_FORM.Get(form) ; NORM_FORM NormForm
    , "WStr", this                ; LPCWSTR   lpSrcString
    , "Int", -1                   ; int       cwSrcLength
    , "WStr", buf                 ; LPWSTR    lpDstString
    , "Int", bufSize              ; int       cchDstLength
    , "Int"                       ; int
  )
}
/**
 * @param {String} input
 */
String_Clean(input)
{
  baseIndent := ""
  loop parse, Trim(input, "`r`n"), "`n", "`r"
  {
    line := A_LoopField
    if String_IsNullOrWhitespace(line)
      continue
    if !RegExMatch(line, "(*UCP)^(?<indent>\s*)\S", &match)
      continue
    indent := match.indent
    if indent == ""
    {
      baseIndent := ""
      break
    }
    if baseIndent == ""
    {
      baseIndent := indent
      continue
    }
    while baseIndent !== "" && SubStr(indent, 1, StrLen(baseIndent)) !== baseIndent
      baseIndent := SubStr(baseIndent, 1, -1)
  }
  if baseIndent == ""
    return String_Edit(Trim(input, "`r`n"), line => line)
  else
    return String_Edit(Trim(input, "`r`n"), line => String_StartsWith(line, baseIndent) ? SubStr(line, StrLen(baseIndent) + 1) : line)
}
/**
 * @param {String} pathLike
 * @returns {String}
 */
String_ExtractPath(pathLike)
{
  if String_ExtractUrl(pathLike) !== ""
    return ""
  path := StrReplace(RegExReplace(pathLike, "(*UCP)^\s+|\s+$"), "/", "\")
  if FileExist(path) && Path_IsAbsolute(path) && Path_IsLiteral(path)
    return Path_Canonicalize(RTrim(path, "\"))
  pattern := '[:*?"<>|]*((?:[a-zA-Z]:|\\\\[^\\]+)\\[^:*?"<>|]*).*'
  if !RegExMatch(path, pattern, &matchs)
    if !RegExMatch(StrReplace(path, "\\", "\"), pattern, &matchs)
      return
  extractedPath := matchs[1]
  trimmedPath := String_TrimUnmatchedClosingWrapper(extractedPath)
  if trimmedPath !== extractedPath
  {
    prefix := SubStr(path, 1, InStr(path, extractedPath) - 1)
    if InStr(prefix, '"') || InStr(prefix, "'") || InStr(prefix, "(") || InStr(prefix, "[") || InStr(prefix, "{") || InStr(prefix, "<")
      extractedPath := trimmedPath
  }
  path := Path_Canonicalize(RTrim(extractedPath, "\"))
  if Path_IsAbsolute(path) && Path_IsLiteral(path)
    return path
  loop
  {
    parent := Path_GetParent(path)
    if parent == ""
      return
    if FileExist(parent) && Path_IsAbsolute(parent) && Path_IsLiteral(parent)
      return parent
    path := parent
    if Path_IsRoot(path)
      return
  }
  while Path_IsRoot(path)
  {
    if FileExist(path) && Path_IsAbsolute(path) && Path_IsLiteral(path)
      return RTrim(path, "\")
    path := RTrim(SubStr(path, 1, StrLen(path) - 1), "\")
    if path == parent
      return path
  }
}
/**
 * @param {String} urlLike
 * @returns {String}
 */
String_ExtractUrl(urlLike)
{
  if RegExMatch(urlLike, "\]\((?<href>.*)\)$", &matchs)
  {
    href := matchs.href
    if String_ExtractHttpUrl(href) !== "" || String_ExtractFileUrl(href) !== ""
      return href
  }
  url := String_ExtractHttpUrl(urlLike)
  if url !== ""
    return String_ExtractUrlValue(urlLike, url)
  url := String_ExtractFileUrl(urlLike)
  if url !== ""
    return String_ExtractUrlValue(urlLike, url)
}
/**
 * @param {String} urlLike
 * @param {String} url
 * @returns {String}
 */
String_ExtractUrlValue(urlLike, url)
{
  urlPosition := InStr(urlLike, url)
  prefix := SubStr(urlLike, 1, urlPosition - 1)
  trimmedUrl := String_TrimUnmatchedClosingWrapper(url)
  if !InStr(prefix, '"') && !InStr(prefix, "'") && !InStr(prefix, "(") && !InStr(prefix, "[") && !InStr(prefix, "{") && !InStr(prefix, "<")
  {
    suffix := SubStr(urlLike, urlPosition + StrLen(url))
    if suffix !== ""
      return url suffix
    return url
  }
  return trimmedUrl
}
/**
 * @param {String} url
 * @returns {String}
 */
String_TrimUnmatchedClosingWrapper(url)
{
  static wrappers := Map(
    ")", "(",
    "]", "[",
    "}", "{",
    "'", "'",
    '"', '"'
  )
  while wrappers.Has(SubStr(url, -1))
  {
    closing := SubStr(url, -1)
    opening := wrappers[closing]
    closingCount := StrLen(url) - StrLen(StrReplace(url, closing))
    openingCount := StrLen(url) - StrLen(StrReplace(url, opening))
    if opening == closing
    {
      if Mod(closingCount, 2) == 0
        break
    }
    else if closingCount <= openingCount
      break
    url := SubStr(url, 1, -1)
  }
  return url
}
/**
 * @param {String} urlLike
 * @returns {String}
 */
String_ExtractHttpUrl(urlLike)
{
  if RegExMatch(urlLike, "(*UCP)(?<href>" RegEx_Http() ")", &matchs)
    return matchs.href
}
/**
 * @param {String} urlLike
 * @returns {String}
 */
String_ExtractFileUrl(urlLike)
{
  if RegExMatch(urlLike, "(*UCP)\[(?<title>[^\]]*)\]\((?<href>" RegEx_File() ")\)", &matchs)
    return matchs.href
  if RegExMatch(urlLike, "(*UCP)(?<href>" RegEx_File() ")", &matchs)
    return matchs.href
}
