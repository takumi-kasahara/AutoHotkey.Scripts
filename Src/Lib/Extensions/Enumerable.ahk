#Requires AutoHotkey v2.0

/**
 * @param {Enumerable} this
 * @param {String | Integer | Float} search
 * @returns {Integer}
 */
Enumerable_IndexOf(this, search)
{
  for key, value in this
    if value == search
      return key
}
/**
 * @param {Enumerable} this
 * @param {String} [separator="`n"]
 * @returns {String}
 */
Enumerable_Join(this, separator := "`n")
{
  joined := ""
  for key, value in this
    if value is Object
      throw ValueError("Value must be primitive.")
    else if value !== ""
      joined .= value separator
  return SubStr(joined, 1, -StrLen(separator))
}
