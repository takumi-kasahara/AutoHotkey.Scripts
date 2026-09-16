#Requires AutoHotkey v2.0

/**
 * @param {String | Array | Map | Func | BoundFunc} input
 * @param {String} [separator="`n"]
 * @returns {String}
 */
ConvertTo_String(input, separator := "`n")
{
  switch Type(input)
  {
    case "String":
      return input
    case "Array", "Map":
      return Enumerable_Join(input, separator)
    case "Func", "BoundFunc":
      return ConvertTo_String(input.Call(), separator)
    default:
      throw TypeError(Format('"{}" not supported.', Type(input)))
  }
}
/**
 * @param {String*} columns
 * @returns {String}
 */
ConvertTo_Csv(columns*) => Enumerable_Join(Stream(columns).ToArray(column => String_Enclose(StrReplace(column, '"', '""'))), ",")
/**
 * @param {String} input
 * @param {String} from
 * @returns {String}
 */
ConvertTo_Html(input, from := "markdown")
{
  exitCode := Shell_Exec("pandoc -f " from " -t html", input, &stdout, &stderr)
  if exitCode !== 0
    throw OSError(stderr, exitCode)

  return stdout
}
/**
 * @see {https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#string_literals}
 * @param {String} input
 * @returns {String}
 */
ConvertTo_Json(input)
{
  tmp := input
  tmp := StrReplace(tmp, "\", "\\")
  tmp := StrReplace(tmp, '"', '\"')
  tmp := StrReplace(tmp, "`b", "\b")
  tmp := StrReplace(tmp, "`f", "\f")
  tmp := StrReplace(tmp, "`n", "\n")
  tmp := StrReplace(tmp, "`r", "\r")
  tmp := StrReplace(tmp, "`t", "\t")
  tmp := StrReplace(tmp, "`v", "\v")
  tmp := StrReplace(tmp, Chr(0), "\0")
  return String_Enclose(tmp)
}
/**
 * @see {https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.6}
 * @param {String} input
 * @returns {String}
 */
ConvertTo_PowerShell(input)
{
  tmp := input
  tmp := StrReplace(tmp, "``", "````")
  tmp := StrReplace(tmp, '"', '``"')
  tmp := StrReplace(tmp, "$", "``$")
  tmp := StrReplace(tmp, "{", "``{")
  tmp := StrReplace(tmp, "}", "``}")
  tmp := StrReplace(tmp, "`a", "``a")
  tmp := StrReplace(tmp, "`b", "``b")
  tmp := StrReplace(tmp, Chr(27), "``e")
  tmp := StrReplace(tmp, "`f", "``f")
  tmp := StrReplace(tmp, "`r", "``r")
  tmp := StrReplace(tmp, "`n", "``n")
  tmp := StrReplace(tmp, "`t", "``t")
  tmp := StrReplace(tmp, "`v", "``v")
  return String_Enclose(tmp)
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertTo_SQL(input)
{
  tmp := input
  tmp := StrReplace(tmp, "'", "''")
  tmp := StrReplace(tmp, "`r", "CHR(13)")
  tmp := StrReplace(tmp, "`n", "CHR(10)")
  tmp := StrReplace(tmp, "`t", "CHR(9)")
  tmp := StrReplace(tmp, "`b", "CHR(8)")
  tmp := StrReplace(tmp, "`f", "CHR(12)")
  tmp := StrReplace(tmp, "`v", "CHR(11)")
  tmp := StrReplace(tmp, Chr(0), "CHR(0)")

  ; If the result contains only CHR calls, return as-is
  ; Otherwise, wrap string literals in quotes and join with ||
  if RegExMatch(tmp, "^(?:CHR\(\d+\))+$")
    return tmp

  ; Split by CHR calls and wrap string parts in quotes
  parts := []
  pos := 1
  while RegExMatch(tmp, "CHR\(\d+\)", &m, pos)
  {
    before := SubStr(tmp, pos, m.Pos - pos)
    if before != ""
      parts.Push("'" before "'")
    parts.Push(m[0])
    pos := m.Pos + m.Len
  }
  after := SubStr(tmp, pos)
  if after != ""
    parts.Push("'" after "'")

  return Enumerable_Join(parts, " || ")
}
/**
 * @see {https://learn.microsoft.com/en-us/dotnet/api/microsoft.visualbasic.constants?view=net-10.0}
 * @see {https://learn.microsoft.com/en-us/dotnet/visual-basic/programming-guide/language-features/strings/}
 * @param {String} input
 * @returns {String}
 */
ConvertTo_VisualBasic(input)
{
  tmp := input
  tmp := StrReplace(tmp, '"', '""')
  tmp := StrReplace(tmp, "`r`n", '" & vbCrLf & "')
  tmp := StrReplace(tmp, "`n", '" & vbLf & "')
  tmp := StrReplace(tmp, "`r", '" & vbCr & "')
  tmp := StrReplace(tmp, "`t", '" & vbTab & "')
  tmp := StrReplace(tmp, "`b", '" & vbBack & "')
  tmp := StrReplace(tmp, "`f", '" & vbFormFeed & "')
  tmp := StrReplace(tmp, Chr(0), '" & vbNullChar & "')
  tmp := StrReplace(tmp, "`v", '" & vbVerticalTab & "')
  return String_Enclose(tmp)
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertTo_Excel(input)
{
  tmp := input
  tmp := StrReplace(tmp, '"', '""')
  tmp := StrReplace(tmp, "`r", "CHAR(13)")
  tmp := StrReplace(tmp, "`n", "CHAR(10)")
  tmp := StrReplace(tmp, "`t", "CHAR(9)")
  tmp := StrReplace(tmp, "`b", "CHAR(8)")
  tmp := StrReplace(tmp, "`f", "CHAR(12)")
  tmp := StrReplace(tmp, "`v", "CHAR(11)")
  tmp := StrReplace(tmp, Chr(0), "CHAR(0)")

  parts := []
  pos := 1
  while RegExMatch(tmp, "CHAR\(\d+\)", &m, pos)
  {
    before := SubStr(tmp, pos, m.Pos - pos)
    if before != ""
      parts.Push('"' before '"')
    parts.Push(m[0])
    pos := m.Pos + m.Len
  }
  after := SubStr(tmp, pos)
  if after != ""
    parts.Push('"' after '"')

  if parts.Length = 0
    parts.Push('""')

  return Enumerable_Join(parts, " & ")
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertTo_ExcelFormula(input)
{
  input := StrReplace(input, "{{}", "{")
  input := StrReplace(input, "{}}", "}")
  parts := []
  fromIndex := 1
  implicitIndex := 1

  while RegExMatch(input, "\{(\d*)\}", &matched, fromIndex)
  {
    literal := SubStr(input, fromIndex, matched.Pos - fromIndex)
    if literal != ""
      parts.Push(String_Enclose(StrReplace(literal, '"', '""')))

    placeholderIndex := matched[1] != "" ? Integer(matched[1]) : implicitIndex++
    column := ""
    while placeholderIndex > 0
    {
      remainder := Mod(placeholderIndex - 1, 26)
      column := Chr(65 + remainder) column
      placeholderIndex := Floor((placeholderIndex - 1) / 26)
    }
    parts.Push(column "1")

    fromIndex := matched.Pos + matched.Len
  }

  suffix := SubStr(input, fromIndex)
  if suffix != ""
    parts.Push(String_Enclose(StrReplace(suffix, '"', '""')))

  if parts.Length = 0
    parts.Push('""')

  return "=" Enumerable_Join(parts, "&")
}
/**
 * @param {String} href
 * @param {String} text
 * @returns {String}
 */
ConvertTo_ExcelHyperlink(href, text := "")
{
  if !href
    return ""
  if !text
    return Format('=HYPERLINK("{}")', href)
  return Format('=HYPERLINK("{}", {})', href, ConvertTo_Excel(text))
}
/**
 * @param {String} href
 * @param {String} text
 * @returns {String}
 */
ConvertTo_MarkdownLink(href, text := "")
{
  if !href
    return ""
  if !text
    return "<" href ">"
  return "[" text "](" href ")"
}
