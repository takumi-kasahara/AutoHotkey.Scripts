#Requires AutoHotkey v2.0

#HotIf !IME_Get()
::`:`:admin::administrator
::`:`:ahk::AutoHotkey
::`:`:app::application
::`:`:attr::attribute
::`:`:db::database
::`:`:def::definition
::`:`:dic::dictionary
::`:`:doc::document
::`:`:env::environment
::`:`:fn::function
::`:`:gh::GitHub
::`:`:js::JavaScript
::`:`:misc::miscellaneous
::`:`:ms::microsoft
::`:`:npp::notepad{+}{+}
::`:`:org::organization
::`:`:pg::PostgreSQL
::`:`:pp::PowerPoint
::`:`:proc::procedure
::`:`:prop::property
::`:`:pwsh::PowerShell
::`:`:reg::registry
::`:`:rev::revision
::`:`:sh::ShellScript
::`:`:ssms::SQL Server Management Studio
::`:`:svn::subversion
::`:`:temp::temporary
::`:`:tmpl::template
::`:`:ts::TypeScript
::`:`:util::utility
::`:`:vb::Visual Basic
::`:`:vs::Visual Studio
::`:`:wd::Word
::`:`:wm::WinMerge
::`:`:ws::workspace
::`:`:wt::Windows Terminal
::`:`:xl::Excel
:X:`:`:date::
{
  if WinActive("ahk_group grpExplorer")
    Paste(Date_ToString("yyyyMMdd"))
  else
    Paste(Date_ToString("yyyy-MM-dd"))
}
:X:`:`:time::
{
  if WinActive("ahk_group grpExplorer")
    Paste(Date_ToString("HHmmss"))
  else
    Paste(Date_ToString("HH:mm:ss"))
}
:X:`:`:code::
{
  input := Clipboard_GetText()
  StrSplit(input, "`n").Length == 1
    ? Paste("``" input "``")
    : Paste("```````n" input "`n``````")
}
:X:`:`:quot::
{
  input := Clipboard_GetText()
  if input
    Paste("> " StrReplace(input, "`n", "`n> "))
}
:X:`:`:link::
{
  links := Stream(Clipboard_ExtractLink()).Filter(link => Url_GetProtocol(link.href) ~= "^(?i:https?)$").ToArray(link => Format("[{}]({})", link.title, link.href))
  if links.Length > 0
    Paste(ConvertTo_String(links))
}
#HotIf
