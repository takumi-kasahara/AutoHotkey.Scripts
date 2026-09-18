#Requires AutoHotkey v2.0

RegEx_Http()
{
  static host := "[\w!+\-_~=;.,*&@$%()[\]]+"
  static port := "\d+"
  static pathname := "[\w!/+\-_~=:;.,*&@$%()[\]]*"
  static search := "[\w!?/+\-_~=:;.,*&@$%()[\]]*"
  static hash := "[\w!?/+\-_~=:;.,*&@#$%()[\]]*"
  return "(?<protocol>https?)://(?<host>" host ")(?::(?<port>" port "))?(?<pathname>/" pathname ")?(?:\?(?<search>" search "))?(?:#(?<hash>" hash "))?"
}
RegEx_File()
{
  static host := "[\w!+\-_~=;.,*&@$%()[\]]*"
  static pathname := "[\w!/+\-_~=:;.,*&@$%()[\]]*"
  return "(?<protocol>file)://(?<host>" host ")(?<pathname>/" pathname ")?"
}
RegEx_Split(input, regex)
{
  if regex == ""
    return [input]

  parts := []
  remaining := input

  while RegExMatch(remaining, regex, &match) > 0
  {
    ; Add substring before delimiter (from original input perspective)
    ; Since remaining shrinks, match.Pos is relative to remaining
    if match.Pos > 1
      parts.Push(SubStr(remaining, 1, match.Pos - 1))
    else if match.Pos == 1
      parts.Push("")

    ; Remove delimiter and everything before it from remaining
    remaining := SubStr(remaining, match.Pos + match.Len)
  }

  ; Add remaining substring after last delimiter
  parts.Push(remaining)

  return parts
}
