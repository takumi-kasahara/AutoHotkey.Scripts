#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_GetDateTime()

Dialog_GetDateTime()
{
  static BUTTON_MARGIN := 16
  static BUTTON_PADDING := 8
  static BUTTON_COUNT := 1
  static BUTTON_WIDTH := 80
  static BUTTON_HEIGHT := 32
  static CONTROL_MARGIN := 8
  static CONTROL_HEIGHT := 32
  static CONTROL_PADDING := 8

  myGui := Gui()
  myGui.Opt("-MinimizeBox -MaximizeBox")

  date := myGui.AddDateTime(, "LongDate")
  time := myGui.AddDateTime(, "Time")
  cbFormat := myGui.AddComboBox(, ["yyyy-MM-ddTHH:mm:ss", "yyyy-MM-dd", "HH:mm:ss"])
  cbFormat.Value := 1

  text := ""
  btnCopy := myGui.AddButton(Format("w{} h{} Default", BUTTON_WIDTH, BUTTON_HEIGHT), "&Copy")
  btnCopy.OnEvent("Click", (*) => (Clipboard_SetText(FormatTime(FormatTime(date.Value, "yyyyMMdd") FormatTime(time.Value, "HHmmss"), cbFormat.Text)), myGui.Destroy()))

  myGui.OnEvent("Escape", (*) => myGui.Destroy())

  date.GetPos(, , &dateW, &dateH)
  time.GetPos(, , &timeW, &timeH)
  cbFormat.GetPos(, , &cbFormatW, &cbFormatH)
  buttonsTotalWidth := BUTTON_COUNT * BUTTON_WIDTH + (BUTTON_COUNT - 1) * BUTTON_PADDING
  guiW := 2 * CONTROL_MARGIN + Max(dateW, timeW, cbFormatW, buttonsTotalWidth)
  guiH := 2 * CONTROL_MARGIN + dateH + CONTROL_PADDING + timeH + CONTROL_PADDING + cbFormatH + BUTTON_MARGIN + BUTTON_HEIGHT

  myGui.Show(Format("w{} h{} Hide", guiW, guiH))
  myGui.GetPos(, , &actualW, &actualH)
  guiW := Max(guiW, actualW)
  guiH := Max(guiH, actualH)

  Init(guiW, guiH)
  myGui.OnEvent("Size", (this, minMax, newW, newH) => Init(newW, newH))

  Monitor_Find(, &left, &top, &right, &bottom)
  Gui_ShowCentered(myGui, guiW, guiH, left, top, right, bottom)
  /**
   * @param {Integer} newW
   * @param {Integer} newH
   */
  Init(newW, newH)
  {
    date.Move(CONTROL_MARGIN, CONTROL_MARGIN, newW - 2 * CONTROL_MARGIN, CONTROL_HEIGHT)
    time.Move(CONTROL_MARGIN, CONTROL_MARGIN + CONTROL_HEIGHT + CONTROL_PADDING, newW - 2 * CONTROL_MARGIN, CONTROL_HEIGHT)
    cbFormat.Move(CONTROL_MARGIN, CONTROL_MARGIN + CONTROL_HEIGHT + CONTROL_PADDING + CONTROL_HEIGHT + CONTROL_PADDING, newW - 2 * CONTROL_MARGIN, CONTROL_HEIGHT)
    buttonsTotalWidth := BUTTON_COUNT * BUTTON_WIDTH + (BUTTON_COUNT - 1) * BUTTON_PADDING
    firstButtonX := (newW - buttonsTotalWidth) / 2
    offset := BUTTON_WIDTH + BUTTON_PADDING
    btnCopy.Move(firstButtonX + offset * 0, newH - BUTTON_MARGIN - BUTTON_HEIGHT)
  }
}
