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
  wshShell := ComObject("WScript.Shell")
  exec := wshShell.Exec("pandoc -f " from " -t html")
  exec.StdIn.Write(input)
  exec.StdIn.Close()
  return exec.StdOut.ReadAll()
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertTo_Json(input)
{
  tmp := input
  tmp := StrReplace(tmp, "\", "\\")
  tmp := StrReplace(tmp, '"', '\"')
  tmp := StrReplace(tmp, "`r", "")
  tmp := StrReplace(tmp, "`n", "\n")
  tmp := StrReplace(tmp, "`t", "\t")
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
  tmp := StrReplace(tmp, "`r", "")
  tmp := StrReplace(tmp, "`n", "' || CHR(10) || '")
  tmp := StrReplace(tmp, "`t", "' || CHR(9) || '")
  return String_Enclose(tmp, "'")
}
/**
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
  tmp := StrReplace(tmp, "`r", "")
  tmp := StrReplace(tmp, "`n", "``n")
  tmp := StrReplace(tmp, "`t", "``t")
  return String_Enclose(tmp)
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertTo_VisualBasic(input)
{
  tmp := input
  tmp := StrReplace(tmp, '"', '""')
  tmp := StrReplace(tmp, "`r", "")
  tmp := StrReplace(tmp, "`n", '" & vbNewLine & "')
  tmp := StrReplace(tmp, "`t", '" & vbTab & "')
  return String_Enclose(tmp)
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
