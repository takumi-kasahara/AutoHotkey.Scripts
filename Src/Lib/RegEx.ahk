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
