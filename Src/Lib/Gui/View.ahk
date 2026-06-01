#Requires AutoHotkey v2.0

/**
 * @param {String | Array | Func | BoundFunc} input
 * @param {String} [extension="txt"]
 */
View_Text(input, extension := "txt")
{
  value := Trim(ConvertTo_String(input), "`r`n")
  if String_IsNullOrWhitespace(value)
    return

  static BUTTON_MARGIN := 16
  static BUTTON_PADDING := 8
  static BUTTON_COUNT := 2
  static BUTTON_WIDTH := 80
  static BUTTON_HEIGHT := 32

  myGui := Gui("+Resize", "Edit")
  myGui.Opt("-MinimizeBox")

  try
    editText := myGui.AddEdit("Multi ReadOnly Wrap", value)
  catch as ex
  {
    OnCopy()
    throw ex
  }

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/em-getlinecount} */
  static EM_GETLINECOUNT := 0x00BA
  lineCount := SendMessage(EM_GETLINECOUNT, 0, 0, editText.Hwnd)
  if lineCount == 1
  {
    OnCopy()
    return
  }

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/em-getrect} */
  static EM_GETRECT := 0x00B2
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/em-getmargins} */
  static EM_GETMARGINS := 0x00D4
  editRect := Buffer(16, 0)
  SendMessage(EM_GETRECT, 0, editRect.Ptr, editText.Hwnd)
  textAreaW := NumGet(editRect, 8, "Int") - NumGet(editRect, 0, "Int")
  textAreaH := NumGet(editRect, 12, "Int") - NumGet(editRect, 4, "Int")
  margins := SendMessage(EM_GETMARGINS, 0, 0, editText.Hwnd)
  leftMargin := margins & 0xFFFF
  rightMargin := (margins >> 16) & 0xFFFF
  contentW := textAreaW + leftMargin + rightMargin
  contentH := textAreaH

  if contentW <= 0 || contentH <= 0
    editText.GetPos(, , &contentW, &contentH)

  calculatedGuiW := Max(contentW, 2 * BUTTON_MARGIN + BUTTON_COUNT * BUTTON_WIDTH)
  calculatedGuiH := contentH + 2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT
  Monitor_Find(, &left, &top, &right, &bottom)
  screenW := right - left
  screenH := bottom - top
  width := Min(calculatedGuiW, screenW)
  height := Min(calculatedGuiH, screenH)

  myGui.OnEvent("Escape", (*) => myGui.Destroy())

  btnCopy := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "Copy")
  btnCopy.OnEvent("Click", (*) => OnCopy())

  btnSave := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "Save")
  btnSave.OnEvent("Click", (*) => (
    OnSave(),
    myGui.Destroy()
  ))

  Init(width, height)
  myGui.OnEvent("Size", (this, minMax, newW, newH) => Init(newW, newH))

  windowLeft := left
  windowRight := right - width
  windowTop := top
  windowBottom := bottom - height
  myGui.Show(Format("w{} h{} x{} y{}", width, height, (windowLeft + windowRight) / 2, (windowTop + windowBottom) / 2))
  /**
   * @param {Integer} newW
   * @param {Integer} newH
   */
  Init(newW, newH)
  {
    editW := newW - (2 * BUTTON_MARGIN)
    editH := newH - (2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT)
    editText.Move(BUTTON_MARGIN, BUTTON_MARGIN, editW, editH)
    buttonsTotalWidth := BUTTON_COUNT * BUTTON_WIDTH + (BUTTON_COUNT - 1) * BUTTON_PADDING
    firstButtonX := (newW - buttonsTotalWidth) / 2
    offset := BUTTON_WIDTH + BUTTON_PADDING
    btnCopy.Move(firstButtonX + offset * 0, newH - BUTTON_MARGIN - BUTTON_HEIGHT)
    btnSave.Move(firstButtonX + offset * 1, newH - BUTTON_MARGIN - BUTTON_HEIGHT)
  }
  OnCopy()
  {
    if extension ~= "^(?i:html)$"
      Clipboard_SetHtml(value)
    else
      Clipboard_SetText(value)
    myGui.Destroy()
  }
  OnSave() => Dialog_Save(editText.Value, extension)
}
/**
 * @param {String} input
 * @param {Integer} [header=0]
 */
View_Csv(input, header := 0)
{
  value := Trim(input, "`r`n")
  if value == ""
    return

  headers := []
  rows := []
  maxColumns := 0
  loop parse, value, "`n", "`r"
  {
    if A_Index < header
      continue
    if A_Index == header
    {
      loop parse, A_LoopField, "CSV"
        headers.Push(A_LoopField)
      continue
    }
    row := []
    loop parse, A_LoopField, "CSV"
      row.Push(A_LoopField)

    rows.Push(row)
    if row.Length > maxColumns
      maxColumns := row.Length
  }

  if headers.Length == 0
    loop maxColumns
      headers.Push(Format("Column {}", A_Index))

  static BUTTON_MARGIN := 16
  static BUTTON_PADDING := 8
  static BUTTON_COUNT := 2
  static BUTTON_WIDTH := 80
  static BUTTON_HEIGHT := 32

  myGui := Gui("+Resize", "ListView")
  myGui.Opt("-MinimizeBox")
  listView := myGui.AddListView("Grid ReadOnly -Multi", headers)

  myGui.OnEvent("Escape", (*) => myGui.Destroy())

  btnCopy := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "Copy")
  btnCopy.OnEvent("Click", (*) => (
    Clipboard_SetText(value),
    myGui.Destroy()
  ))

  btnSave := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "Save")
  btnSave.OnEvent("Click", (*) => (
    OnSave(),
    myGui.Destroy()
  ))

  for row in rows
  {
    values := row.Clone()
    while values.Length < maxColumns
      values.Push("")
    listView.Add(, values*)
  }

  loop maxColumns
    listView.ModifyCol(A_Index, "AutoHdr")

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/lvm-getcolumnwidth} */
  static LVM_GETCOLUMNWIDTH := 0x101D
  contentW := 0
  loop maxColumns
    contentW += SendMessage(LVM_GETCOLUMNWIDTH, A_Index - 1, 0, listView.Hwnd)

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/lvm-getheader} */
  static LVM_GETHEADER := 0x101F
  headerHwnd := SendMessage(LVM_GETHEADER, 0, 0, listView.Hwnd)
  headerRect := Buffer(16, 0)
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclientrect} */
  if !DllCall("GetClientRect"
    , "Ptr", headerHwnd ; HWND    hWnd
    , "Ptr", headerRect ; LPRECT  lpRect
    , "Int"             ; BOOL
  )
    throw OSError()
  headerHeight := NumGet(headerRect, 12, "Int") - NumGet(headerRect, 4, "Int")

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/lvm-getitemrect} */
  static LVM_GETITEMRECT := 0x100E
  rowRect := Buffer(16, 0)
  NumPut("Int", 0, rowRect, 0)
  SendMessage(LVM_GETITEMRECT, 0, rowRect.Ptr, listView.Hwnd)
  rowHeight := NumGet(rowRect, 12, "Int") - NumGet(rowRect, 4, "Int")
  contentH := headerHeight + rows.Length * rowHeight

  calculatedGuiW := Max(contentW, 2 * BUTTON_MARGIN + BUTTON_COUNT * BUTTON_WIDTH)
  calculatedGuiH := contentH + 2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT
  Monitor_Find(, &left, &top, &right, &bottom)
  screenW := right - left
  screenH := bottom - top
  width := Min(calculatedGuiW, screenW)
  height := Min(calculatedGuiH, screenH)

  Init(width, height)
  myGui.OnEvent("Size", (this, minMax, newW, newH) => Init(newW, newH))
  windowLeft := left
  windowRight := right - width
  windowTop := top
  windowBottom := bottom - height
  myGui.Show(Format("w{} h{} x{} y{}", width, height, (windowLeft + windowRight) / 2, (windowTop + windowBottom) / 2))
  /**
   * @param {Integer} newW
   * @param {Integer} newH
   */
  Init(newW, newH)
  {
    listView.Move(BUTTON_MARGIN, BUTTON_MARGIN, newW - 2 * BUTTON_MARGIN, newH - (2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT))
    buttonsTotalWidth := BUTTON_COUNT * BUTTON_WIDTH + (BUTTON_COUNT - 1) * BUTTON_PADDING
    firstButtonX := (newW - buttonsTotalWidth) / 2
    offset := BUTTON_WIDTH + BUTTON_PADDING
    btnCopy.Move(firstButtonX + offset * 0, newH - BUTTON_MARGIN - BUTTON_HEIGHT)
    btnSave.Move(firstButtonX + offset * 1, newH - BUTTON_MARGIN - BUTTON_HEIGHT)
  }
  OnSave() => Dialog_Save(value, "csv")
}
