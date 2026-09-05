#Requires AutoHotkey v2.0

/**
 * @param {String} input
 * @param {String} to
 * @returns {String}
 */
ConvertFrom_Html(input, to := "commonmark")
{
  html := input
  if RegExMatch(input, "(?s)<!--StartFragment-->(.*?)<!--EndFragment-->", &matched)
    html := matched[1]

  wshShell := ComObject("WScript.Shell")
  exec := wshShell.Exec("pandoc -f html -t " to)
  exec.StdIn.Write(html)
  exec.StdIn.Close()
  return exec.StdOut.ReadAll()
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_Json(input) => StrReplace(input, "\\", "\")
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_SQL(input) => StrReplace(input, "''", "'")
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_PowerShell(input) => StrReplace(input, '``"', '"')
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_VisualBasic(input) => StrReplace(input, '""', '"')
