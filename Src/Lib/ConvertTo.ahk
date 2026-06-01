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
 * @param {String*} colomuns
 * @returns {String}
 */
ConvertTo_Csv(colomuns*) => Enumerable_Join(Stream(colomuns).ToArray(column => String_Enclose(StrReplace(column, '"', '""'))), ",")
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
