#Requires AutoHotkey v2.0

/**
 * @param {{ href: String, title: String, text: String, target: String }} link
 */
Edit_Hyperlink(link)
{
  static CONTROL_X := 16
  static CONTROL_WIDTH := 300
  static CONTROL_HEIGHT := 24
  static LABEL_HEIGHT := 20
  static ROW_GAP := 12
  static BUTTON_WIDTH := 80
  static BUTTON_HEIGHT := 32
  static BUTTON_MARGIN := 16
  static WINDOW_WIDTH := CONTROL_X + CONTROL_WIDTH + BUTTON_MARGIN
  static WINDOW_HEIGHT := 4 * (LABEL_HEIGHT + ROW_GAP + CONTROL_HEIGHT) + 2 * BUTTON_MARGIN + BUTTON_HEIGHT

  textY := CONTROL_X
  editTextY := textY + LABEL_HEIGHT
  screenTipTextY := editTextY + CONTROL_HEIGHT + ROW_GAP
  screenTipEditY := screenTipTextY + LABEL_HEIGHT
  addressTextY := screenTipEditY + CONTROL_HEIGHT + ROW_GAP
  addressEditY := addressTextY + LABEL_HEIGHT
  targetTextY := addressEditY + CONTROL_HEIGHT + ROW_GAP
  targetEditY := targetTextY + LABEL_HEIGHT
  buttonY := targetEditY + CONTROL_HEIGHT + ROW_GAP

  myGui := Gui("+Resize", "Edit Hyperlink")
  myGui.Opt("-MinimizeBox -MaximizeBox")

  myGui.AddText(Format("x{} y{} w{} h{}", CONTROL_X, textY, CONTROL_WIDTH, LABEL_HEIGHT), "Text to display:")
  editText := myGui.AddEdit(Format("x{} y{} w{} h{}", CONTROL_X, editTextY, CONTROL_WIDTH, CONTROL_HEIGHT), link.text ? link.text : link.href)

  myGui.AddText(Format("x{} y{} w{} h{}", CONTROL_X, screenTipTextY, CONTROL_WIDTH, LABEL_HEIGHT), "ScreenTip text:")
  editScreenTip := myGui.AddEdit(Format("x{} y{} w{} h{}", CONTROL_X, screenTipEditY, CONTROL_WIDTH, CONTROL_HEIGHT), link.HasOwnProp("title") ? link.title : "")

  myGui.AddText(Format("x{} y{} w{} h{}", CONTROL_X, addressTextY, CONTROL_WIDTH, LABEL_HEIGHT), "Address:")
  editAddress := myGui.AddEdit(Format("x{} y{} w{} h{}", CONTROL_X, addressEditY, CONTROL_WIDTH, CONTROL_HEIGHT), link.href)

  choices := ["_self", "_blank", "_parent", "_top"]
  myGui.AddText(Format("x{} y{} w{} h{}", CONTROL_X, targetTextY, CONTROL_WIDTH, LABEL_HEIGHT), "Target Frame:")
  editTarget := myGui.AddDDL(Format("x{} y{} w{} h{}", CONTROL_X, targetEditY, CONTROL_WIDTH, CONTROL_HEIGHT), choices)
  if link.HasOwnProp("target")
    editTarget.Value := Array_IndexOf(choices, link.target)

  baseX := CONTROL_X + (CONTROL_WIDTH - BUTTON_WIDTH * 3 - BUTTON_MARGIN * 2) / 2
  offset := BUTTON_WIDTH + BUTTON_MARGIN
  myGui.AddButton(Format("x{} y{} w{} h{}", baseX + offset * 0, buttonY, BUTTON_WIDTH, BUTTON_HEIGHT), "HTML (&1)").OnEvent("Click", (*) => (CopyHtml(), myGui.Destroy()))
  myGui.AddButton(Format("x{} y{} w{} h{}", baseX + offset * 1, buttonY, BUTTON_WIDTH, BUTTON_HEIGHT), "Markdown (&2)").OnEvent("Click", (*) => (CopyMarkdown(), myGui.Destroy()))
  myGui.AddButton(Format("x{} y{} w{} h{}", baseX + offset * 2, buttonY, BUTTON_WIDTH, BUTTON_HEIGHT), "Excel (&3)").OnEvent("Click", (*) => (CopyExcel(), myGui.Destroy()))

  myGui.OnEvent("Escape", (*) => myGui.Destroy())

  myGui.Show(Format("w{} h{} AutoSize", WINDOW_WIDTH, WINDOW_HEIGHT))

  CopyHtml() => Clipboard_SetHtml(Document_CreateAnchorElement({ href: editAddress.Value, title: editScreenTip.Value, text: editText.Value, target: editTarget.Value }))
  CopyMarkdown() => Clipboard_SetText("[" editText.Value "](" editAddress.Value ")")
  CopyExcel() => Clipboard_SetText(Format('=HYPERLINK("{}", "{}")', editAddress.Value, editText.Value))
}
