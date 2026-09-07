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
