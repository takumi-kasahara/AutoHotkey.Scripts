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
 * @see {https://www.autohotkey.com/docs/v2/misc/EscapeChar.htm}
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_AutoHotkey(input)
{
  tmp := input
  tmp := StrReplace(tmp, "````", "``")
  tmp := StrReplace(tmp, "``,", ",")
  tmp := StrReplace(tmp, "``;", ";")
  tmp := StrReplace(tmp, "``%", "%")
  tmp := StrReplace(tmp, "``#", "#")
  tmp := StrReplace(tmp, "``:", ":")
  tmp := StrReplace(tmp, '``"', '"')
  tmp := StrReplace(tmp, "``0", Chr(0))
  return tmp
}
/**
 * @see {https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#string_literals}
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_Json(input)
{
  tmp := String_Strip(input)
  parsed := ""
  fromIndex := 1

  while RegExMatch(tmp, '\\(?:u\{[0-9A-Fa-f]{1,6}\}|u[0-9A-Fa-f]{4}|x[0-9A-Fa-f]{2}|["\\/bfnrtv0])', &matched, fromIndex)
  {
    parsed .= SubStr(tmp, fromIndex, matched.Pos - fromIndex)

    escaped := SubStr(matched[0], 2)
    switch
    {
      case escaped = '"':
        parsed .= '"'
      case escaped = "\":
        parsed .= "\"
      case escaped = "/":
        parsed .= "/"
      case escaped = "b":
        parsed .= "`b"
      case escaped = "f":
        parsed .= "`f"
      case escaped = "n":
        parsed .= "`n"
      case escaped = "r":
        parsed .= "`r"
      case escaped = "t":
        parsed .= "`t"
      case escaped = "v":
        parsed .= "`v"
      case escaped = "0":
        parsed .= Chr(0)
      case SubStr(escaped, 1, 1) = "x":
        parsed .= Chr(Integer("0x" SubStr(escaped, 2)))
      case SubStr(escaped, 1, 1) = "u":
      {
        if SubStr(escaped, 2, 1) = "{"
        {
          codePoint := Integer("0x" SubStr(escaped, 3, -1))
          parsed .= Chr(codePoint)
        }
        else
        {
          high := Integer("0x" SubStr(escaped, 2))
          nextIndex := matched.Pos + matched.Len

          ; Surrogate pair: \uD800-\uDBFF followed by \uDC00-\uDFFF
          if (0xD800 <= high && high <= 0xDBFF)
          && RegExMatch(tmp, "\\u([0-9A-Fa-f]{4})", &nextMatched, nextIndex)
          && nextMatched.Pos = nextIndex
          {
            low := Integer("0x" nextMatched[1])
            if 0xDC00 <= low && low <= 0xDFFF
            {
              codePoint := ((high - 0xD800) << 10) + (low - 0xDC00) + 0x10000
              parsed .= Chr(codePoint)
              fromIndex := nextMatched.Pos + nextMatched.Len
              continue
            }
          }

          parsed .= Chr(high)
        }
      }
    }

    fromIndex := matched.Pos + matched.Len
  }

  parsed .= SubStr(tmp, fromIndex)
  return parsed
}
/**
 * @see {https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters?view=powershell-7.6}
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_PowerShell(input)
{
  tmp := String_Strip(input)
  parsed := ""
  fromIndex := 1
  tick := Chr(96)
  pattern := tick '(?:u\{[0-9A-Fa-f]{1,6}\}|[0abefnrtv\x60"$\{\}])'

  while RegExMatch(tmp, pattern, &matched, fromIndex)
  {
    parsed .= SubStr(tmp, fromIndex, matched.Pos - fromIndex)

    escaped := SubStr(matched[0], 2)
    switch
    {
      case escaped = "0":
        parsed .= Chr(0)
      case escaped = "a":
        parsed .= "`a"
      case escaped = "b":
        parsed .= "`b"
      case escaped = "e":
        parsed .= Chr(27)
      case escaped = "f":
        parsed .= "`f"
      case escaped = "n":
        parsed .= "`n"
      case escaped = "r":
        parsed .= "`r"
      case escaped = "t":
        parsed .= "`t"
      case escaped = "v":
        parsed .= "`v"
      case escaped = Chr(96):
        parsed .= Chr(96)
      case escaped = '"':
        parsed .= '"'
      case escaped = "$":
        parsed .= "$"
      case escaped = "{":
        parsed .= "{"
      case escaped = "}":
        parsed .= "}"
      case SubStr(escaped, 1, 2) = "u{":
        parsed .= Chr(Integer("0x" SubStr(escaped, 3, -1)))
    }

    fromIndex := matched.Pos + matched.Len
  }

  parsed .= SubStr(tmp, fromIndex)
  return parsed
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_SQL(input)
{
  tmp := String_Strip(input, "'")
  tmp := StrReplace(tmp, "''", "'")
  tmp := StrReplace(tmp, "' || CHR(13) || CHR(10) || '", "`r`n")
  tmp := StrReplace(tmp, "' || CHR(13) || '", "`r")
  tmp := StrReplace(tmp, "' || CHR(10) || '", "`n")
  tmp := StrReplace(tmp, "' || CHR(9) || '", "`t")
  tmp := StrReplace(tmp, "' || CHR(8) || '", "`b")
  tmp := StrReplace(tmp, "' || CHR(12) || '", "`f")
  tmp := StrReplace(tmp, "' || CHR(11) || '", "`v")
  tmp := StrReplace(tmp, "' || CHR(0) || '", Chr(0))
  return tmp
}
/**
 * @see {https://learn.microsoft.com/en-us/dotnet/api/microsoft.visualbasic.constants?view=net-10.0}
 * @see {https://learn.microsoft.com/en-us/dotnet/visual-basic/programming-guide/language-features/strings/}
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_VisualBasic(input)
{
  tmp := String_Strip(input)
  tmp := StrReplace(tmp, '""', '"')
  tmp := StrReplace(tmp, '" & vbCrLf & "', "`r`n")
  tmp := StrReplace(tmp, '" & vbCr & "', "`r")
  tmp := StrReplace(tmp, '" & vbLf & "', "`n")
  tmp := StrReplace(tmp, '" & vbTab & "', "`t")
  tmp := StrReplace(tmp, '" & vbBack & "', "`b")
  tmp := StrReplace(tmp, '" & vbFormFeed & "', "`f")
  tmp := StrReplace(tmp, '" & vbVerticalTab & "', "`v")
  tmp := StrReplace(tmp, '" & vbNullChar & "', Chr(0))
  return tmp
}
/**
 * @param {String} input
 * @returns {String}
 */
ConvertFrom_Excel(input)
{
  tmp := String_Strip(input, '"')
  tmp := StrReplace(tmp, '" & CHAR(13) & CHAR(10) & "', "`r`n")
  tmp := StrReplace(tmp, '" & CHAR(13) & "', "`r")
  tmp := StrReplace(tmp, '" & CHAR(10) & "', "`n")
  tmp := StrReplace(tmp, '" & CHAR(9) & "', "`t")
  tmp := StrReplace(tmp, '" & CHAR(8) & "', "`b")
  tmp := StrReplace(tmp, '" & CHAR(12) & "', "`f")
  tmp := StrReplace(tmp, '" & CHAR(11) & "', "`v")
  tmp := StrReplace(tmp, '" & CHAR(0) & "', Chr(0))
  tmp := StrReplace(tmp, '""', '"')
  return tmp
}
