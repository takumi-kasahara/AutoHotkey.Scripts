#Requires AutoHotkey v2.0

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
