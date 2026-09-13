#Requires AutoHotkey v2.0

/**
 * @param {String} input
 * @param {String} to
 * @returns {String}
 */
ConvertFrom_Html(input, to := "commonmark")
{
  if RegExMatch(input, "(?s)<!--StartFragment-->(.*?)<!--EndFragment-->", &matched)
    input := matched[1]

  exitCode := Shell_Exec("pandoc -f html -t " to, input, &stdout, &stderr)
  if exitCode !== 0
    throw OSError(stderr, exitCode)

  return stdout
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_Json(input)
{
  tmp := input
  tmp := StrReplace(tmp, "\\", "\")
  tmp := StrReplace(tmp, "\n", "`n")
  tmp := StrReplace(tmp, "\t", "`t")
  tmp := StrReplace(tmp, '\"', '"')
  return tmp
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_SQL(input)
{
  tmp := input
  tmp := StrReplace(tmp, "''", "'")
  tmp := StrReplace(tmp, "' || CHR(10) || '", "`n")
  tmp := StrReplace(tmp, "' || CHR(9) || '", "`t")
  if (SubStr(tmp, 1, 1) == "'" && SubStr(tmp, 0, 1) == "'")
    tmp := SubStr(tmp, 2, -1)
  return tmp
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_PowerShell(input)
{
  tmp := input
  tmp := StrReplace(tmp, "````", "``")
  tmp := StrReplace(tmp, '``"', '"')
  tmp := StrReplace(tmp, "``$", "$")
  tmp := StrReplace(tmp, "``{", "{")
  tmp := StrReplace(tmp, "``}", "}")
  tmp := StrReplace(tmp, "``n", "`n")
  tmp := StrReplace(tmp, "``t", "`t")
  if (SubStr(tmp, 1, 1) == '"' && SubStr(tmp, 0, 1) == '"')
    tmp := SubStr(tmp, 2, -1)
  return tmp
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_VisualBasic(input)
{
  tmp := input
  tmp := StrReplace(tmp, '""', '"')
  tmp := StrReplace(tmp, '" & vbNewLine & "', "`n")
  tmp := StrReplace(tmp, '" & vbTab & "', "`t")
  if (SubStr(tmp, 1, 1) == '"' && SubStr(tmp, 0, 1) == '"')
    tmp := SubStr(tmp, 2, -1)
  return tmp
}

/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_Excel(input)
{
  tmp := input
  tmp := StrReplace(tmp, '""', '"')
  tmp := StrReplace(tmp, '" & CHAR(10) & "', "`n")
  tmp := StrReplace(tmp, '" & CHAR(9) & "', "`t")
  if (SubStr(tmp, 1, 1) == '"' && SubStr(tmp, 0, 1) == '"')
    tmp := SubStr(tmp, 2, -1)
  return tmp
}
