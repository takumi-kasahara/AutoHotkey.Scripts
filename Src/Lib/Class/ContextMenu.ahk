#Requires AutoHotkey v2.0

class ContextMenu
{
  /**
   * @see {@link https://www.autohotkey.com/docs/v2/misc/ImageHandles.htm#ExHICON}
   * @param {String} path
   * @returns {String}
   */
  static SHGetFileInfo(pszPath)
  {
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shfileinfow} */
    buf := Buffer(bufSize := A_PtrSize + 4 + 4 + MAX_PATH * 2 + 80 * 2)
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shgetfileinfow} */
    static SHGFI_ICON := 0x000000100
    if DllCall("shell32.dll\SHGetFileInfoW"
      , "WStr", pszPath     ; LPCWSTR     pszPath
      , "UInt", 0x00000000  ; DWORD       dwFileAttributes
      , "Ptr", buf.Ptr      ; SHFILEINFOW *psfi
      , "UInt", bufSize     ; UINT        cbFileInfo
      , "UInt", SHGFI_ICON  ; UINT        uFlags
      , "UInt"              ; DWORD_PTR
    )
      return "hIcon:" NumGet(buf, 0, "Ptr")
  }
  /**
   * @constructor
   */
  __New() => this._menu := Menu()
  /**
   * @param {String} itemName
   * @param {Func | BoundFunc} fn
   * @param {String} iconName
   * @param {Integer} [iconNumber=1]
   */
  Add(itemName, fn, iconName?, iconNumber := 1)
  {
    this._menu.Add(itemName, (itemName, itemPos, myMenu) => fn.Call())
    if IsSet(iconName)
      this.SetIcon(itemName, iconName, iconNumber)
  }
  /**
   * @param {String} itemName
   * @param {ContextMenu} that
   * @param {String} iconName
   * @param {Integer} [iconNumber=1]
   */
  AddSubMenu(itemName, that, iconName?, iconNumber := 1)
  {
    this._menu.Add(itemName, that._menu)
    if IsSet(iconName)
      this.SetIcon(itemName, iconName, iconNumber)
  }
  SetIcon(itemName, iconName, iconNumber := 1)
  {
    try
      switch Path_GetExtensionName(iconName), false
      {
        case "lnk":
          FileGetShortcut(iconName, &target, , , , &iconFile, &iconIndex)
          if iconFile !== ""
            this._menu.SetIcon(itemName, Path_Resolve(iconFile), iconIndex)
          else
            this.SetIcon(itemName, target, iconNumber)
        case "url":
          iconFile := IniRead(iconName, "InternetShortcut", "IconFile", "")
          iconIndex := IniRead(iconName, "InternetShortcut", "IconIndex", 0)
          if iconFile !== ""
            this._menu.SetIcon(itemName, iconFile, iconIndex)
          else if FileExist(iconName)
            this._menu.SetIcon(itemName, ContextMenu.SHGetFileInfo(iconName))
        default:
          if FileExist(iconName)
            this._menu.SetIcon(itemName, ContextMenu.SHGetFileInfo(iconName))
          else
            this._menu.SetIcon(itemName, iconName, iconNumber)
      }
    catch as ex
      Log_Trace(ex.What, ex.Message)
  }
  AddSeparator() => this._menu.Add()
  /**
   * @see {@link https://www.autohotkey.com/boards/viewtopic.php?p=426437#p426437}
   * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/}
   */
  Show()
  {
    mode := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme")
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew} */
    hModule := DllCall("GetModuleHandleW"
      , "WStr", "uxtheme" ; LPCWSTR lpModuleName
      , "Ptr"             ; HMODULE
    )
    if hModule == NULL
      throw OSError()
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getprocaddress} */
    DllCall(DllCall("GetProcAddress", "Ptr", hModule, "Ptr", 135, "Ptr"), "Int", !mode)
    DllCall(DllCall("GetProcAddress", "Ptr", hModule, "Ptr", 136, "Ptr"))
    this._menu.Show()
  }
}
