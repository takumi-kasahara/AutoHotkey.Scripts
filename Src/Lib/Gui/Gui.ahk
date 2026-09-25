#Requires AutoHotkey v2.0

/**
 * @param {Gui} gui
 * @param {Integer} width
 * @param {Integer} height
 * @param {Integer} left
 * @param {Integer} top
 * @param {Integer} right
 * @param {Integer} bottom
 */
Gui_ShowCentered(gui, width, height, left, top, right, bottom)
{
  screenW := right - left
  screenH := bottom - top
  loop 2
  {
    gui.Show(Format("w{} h{} Hide", width, height))
    gui.GetPos(, , &windowW, &windowH)
    widthOverflow := Max(0, windowW - screenW)
    heightOverflow := Max(0, windowH - screenH)
    if !widthOverflow && !heightOverflow
      break
    width -= widthOverflow
    height -= heightOverflow
  }
  x := left + Max(0, Floor((screenW - windowW) / 2))
  y := top + Max(0, Floor((screenH - windowH) / 2))
  gui.Show("x" x " y" y)
}
/**
 * @param {String | Array | Func | BoundFunc} input
 * @param {String} [extension="txt"]
 */
Gui_TextView(input, extension := "txt")
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
    editText := myGui.AddEdit("Multi ReadOnly -Wrap", value)
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

  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/controls/em-getmargins} */
  static EM_GETMARGINS := 0x00D4
  static SIZE_EPSILON := 6
  static CARET_PADDING := 2

  margins := SendMessage(EM_GETMARGINS, 0, 0, editText.Hwnd)
  leftMargin := margins & 0xFFFF
  rightMargin := (margins >> 16) & 0xFFFF

  lineHeight := GetLineHeight(editText.Hwnd)
  maxLineWidth := GetMaxLineWidth(editText.Hwnd, value)
  contentW := leftMargin + maxLineWidth + rightMargin + CARET_PADDING + SIZE_EPSILON
  contentH := lineCount * lineHeight + SIZE_EPSILON

  if contentW <= 0 || contentH <= 0
    editText.GetPos(, , &contentW, &contentH)

  calculatedGuiW := Max(contentW, 2 * BUTTON_MARGIN + BUTTON_COUNT * BUTTON_WIDTH)
  calculatedGuiH := contentH + 2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT
  Monitor_Find(, &left, &top, &right, &bottom)
  width := Min(calculatedGuiW, right - left)
  height := Min(calculatedGuiH, bottom - top)

  myGui.OnEvent("Escape", (*) => myGui.Destroy())

  btnCopy := myGui.AddButton(Format("w{} h{} Default", BUTTON_WIDTH, BUTTON_HEIGHT), "&Copy")
  btnCopy.OnEvent("Click", (*) => (OnCopy(), myGui.Destroy()))
  btnSave := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "&Save")
  btnSave.OnEvent("Click", (*) => (OnSave(), myGui.Destroy()))

  Init(width, height)
  myGui.OnEvent("Size", (this, minMax, newW, newH) => Init(newW, newH))

  Gui_ShowCentered(myGui, width, height, left, top, right, bottom)
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
  }
  OnSave() => Dialog_Save(editText.Value, extension)
  /**
   * @param {Integer} hwnd
   * @returns {Integer}
   */
  GetLineHeight(hwnd)
  {
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-getfont} */
    static WM_GETFONT := 0x0031
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getdc} */
    hdc := DllCall("GetDC"
      , "Ptr", hwnd ; HWND hWnd
      , "Ptr"       ; HDC
    )
    if hdc == 0
      throw OSError()
    oldFont := 0
    try
    {
      hFont := SendMessage(WM_GETFONT, 0, 0, hwnd)
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-selectobject} */
      if hFont
        oldFont := DllCall("SelectObject"
          , "Ptr", hdc    ; HDC     hdc
          , "Ptr", hFont  ; HGDIOBJ h
          , "Ptr"         ; HGDIOBJ
        )
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-textmetricw} */
      textMetrics := Buffer(4 * 11 + 2 * 4 + 1 * 5, 0)
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-gettextmetricsw} */
      if !DllCall("GetTextMetricsW"
        , "Ptr", hdc          ; HDC           hdc
        , "Ptr", textMetrics  ; LPTEXTMETRICW lptm
        , "Int"               ; BOOL
      )
        throw OSError()

      tmHeight := NumGet(textMetrics, 0, "Int")
      tmExternalLeading := NumGet(textMetrics, 16, "Int")
      return Max(1, tmHeight + tmExternalLeading)
    }
    finally
    {
      if oldFont
        DllCall("SelectObject"
          , "Ptr", hdc      ; HDC     hdc
          , "Ptr", oldFont  ; HGDIOBJ h
          , "Ptr"           ; HGDIOBJ
        )
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-releasedc} */
      DllCall("ReleaseDC"
        , "Ptr", hwnd ; HWND hWnd
        , "Ptr", hdc  ; HDC  hDC
        , "Int"       ; int
      )
    }
  }
  /**
   * @param {Integer} hwnd
   * @param {String} text
   * @returns {Integer}
   */
  GetMaxLineWidth(hwnd, text)
  {
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-getfont} */
    static WM_GETFONT := 0x0031

    hdc := DllCall("GetDC"
      , "Ptr", hwnd ; HWND hWnd
      , "Ptr"       ; HDC
    )
    if hdc == 0
      throw OSError()
    oldFont := 0
    maxWidth := 0
    try
    {
      hFont := SendMessage(WM_GETFONT, 0, 0, hwnd)
      if hFont
        oldFont := DllCall("SelectObject"
          , "Ptr", hdc
          , "Ptr", hFont
          , "Ptr"
        )
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size} */
      lineSize := Buffer(4 * 2, 0)
      loop parse, text, "`n", "`r"
      {
        line := A_LoopField
        /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-gettextextentpoint32w} */
        if !DllCall("GetTextExtentPoint32W"
          , "Ptr", hdc          ; HDC     hdc
          , "WStr", line        ; LPCWSTR lpString
          , "Int", StrLen(line) ; int     c
          , "Ptr", lineSize     ; LPSIZE  psizl
          , "Int"               ; BOOL
        )
          throw OSError()
        lineWidth := NumGet(lineSize, 0, "Int")
        maxWidth := Max(maxWidth, lineWidth)
      }
      return maxWidth
    }
    finally
    {
      if oldFont
        DllCall("SelectObject"
          , "Ptr", hdc      ; HDC     hdc
          , "Ptr", oldFont  ; HGDIOBJ h
          , "Ptr"           ; HGDIOBJ
        )
      /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-releasedc} */
      DllCall("ReleaseDC"
        , "Ptr", hwnd ; HWND  hWnd
        , "Ptr", hdc  ; HDC   hDC
        , "Int"       ; int
      )
    }
  }
}
/**
 * @param {String} input
 * @param {Integer} [header=0]
 */
Gui_CsvView(input, header := 0)
{
  value := Trim(input, "`r`n")
  if value == ""
    return

  static delay := Integer(Config_Get("Delay", "KEY"))
  headers := []
  rows := []
  maxColumns := 0
  try
    loop parse, value, "`n", "`r"
    {
      ToolTip(Format("Parsing:{}", A_Index))
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
  finally
    SetTimer(() => ToolTip(), -delay)

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

  btnCopy := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "&Copy")
  btnCopy.OnEvent("Click", (*) => (Clipboard_SetText(value), myGui.Destroy()))

  btnSave := myGui.AddButton(Format("w{} h{}", BUTTON_WIDTH, BUTTON_HEIGHT), "&Save")
  btnSave.OnEvent("Click", (*) => (OnSave(), myGui.Destroy()))

  digits := StrLen(String(rows.Length))
  try
    for row in rows
    {
      ToolTip(Format("Adding:{:0" digits "}/{}", A_Index, rows.Length))
      values := row.Clone()
      while values.Length < maxColumns
        values.Push("")
      listView.Add(, values*)
    }
  finally
    SetTimer(() => ToolTip(), -delay)

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
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-rect} */
  headerRect := Buffer(4 * 4, 0)
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
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-rect} */
  rowRect := Buffer(4 * 4, 0)
  NumPut("Int", 0, rowRect, 0)
  SendMessage(LVM_GETITEMRECT, 0, rowRect.Ptr, listView.Hwnd)
  rowHeight := NumGet(rowRect, 12, "Int") - NumGet(rowRect, 4, "Int")
  contentH := headerHeight + rows.Length * rowHeight

  calculatedGuiW := Max(contentW, 2 * BUTTON_MARGIN + BUTTON_COUNT * BUTTON_WIDTH)
  calculatedGuiH := contentH + 2 * BUTTON_MARGIN + BUTTON_PADDING + BUTTON_HEIGHT
  Monitor_Find(, &left, &top, &right, &bottom)
  width := Min(calculatedGuiW, right - left)
  height := Min(calculatedGuiH, bottom - top)

  Init(width, height)
  myGui.OnEvent("Size", (this, minMax, newW, newH) => Init(newW, newH))
  Gui_ShowCentered(myGui, width, height, left, top, right, bottom)
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
