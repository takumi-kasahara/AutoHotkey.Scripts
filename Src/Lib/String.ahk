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
    edited .= editor.Call(A_LoopField)
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
String_Dedent(input)
{
  commonIndent := ""
  loop parse, input, "`n", "`r"
  {
    line := A_LoopField
    if String_IsNullOrWhitespace(line)
      continue
    if !RegExMatch(line, "(*UCP)^(?<indent>\s*)\S", &match)
      continue
    indent := match.indent
    if commonIndent == ""
    {
      commonIndent := indent
      continue
    }
    while commonIndent != "" && SubStr(indent, 1, StrLen(commonIndent)) != commonIndent
      commonIndent := SubStr(commonIndent, 1, -1)
    if commonIndent == ""
      return input
  }
  if commonIndent == ""
    return input
  return String_Edit(input, line => String_StartsWith(line, commonIndent) ? SubStr(line, StrLen(commonIndent) + 1) : line)
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
  path := Path_Canonicalize(RTrim(matchs[1], "\"))
  if FileExist(path) && Path_IsAbsolute(path)
    return path
  loop
  {
    parent := Path_GetParent(path)
    if FileExist(parent)
      return parent
    path := parent
    if Path_IsRoot(path)
      return
  }
  while Path_IsRoot(path)
  {
    if FileExist(path)
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
  url := String_ExtractHttpUrl(urlLike)
  if url !== ""
    return url
  url := String_ExtractFileUrl(urlLike)
  if url !== ""
    return url
}
/**
 * @param {String} urlLike
 * @returns {String}
 */
String_ExtractHttpUrl(urlLike)
{
  ; e.g. [title](href)
  if RegExMatch(urlLike, "(*UCP)\[(?<title>[^\]]*)\]\((?<href>" RegEx_Http() ")\)", &matchs)
    return matchs.href
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
