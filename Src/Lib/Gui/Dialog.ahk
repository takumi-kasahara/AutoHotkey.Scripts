#Requires AutoHotkey v2.0

/**
 * @param {String} text
 * @param {String} [extension="txt"]
 */
Dialog_Save(text, extension := "txt")
{
  switch extension, false
  {
    case "txt":
      filter := "Text documents (*.txt)"
    case "html":
      filter := "HTML documents (*.html;*.htm)"
    case "md":
      filter := "Markdown documents (*.md)"
    case "json":
      filter := "JSON files (*.json)"
    case "csv":
      filter := "CSV files (*.csv)"
  }
  path := FileSelect("S" 0x10, Path_Combine(A_Desktop, A_Now "." extension), "Save as", filter)
  if path == ""
    return
  if extension !== "" && !(Path_GetExtensionName(path) ~= "^(?i:" extension ")$")
    path .= "." extension
  if FileExist(path)
    FileDelete(path)
  FileAppend(text, path)
}
/**
 * @param {Array<{ href: String, title: String }>} links
 */
Dialog_SaveUrl(links)
{
  if links.Length == 0
    return
  if links.Length == 1
  {
    path := FileSelect("S" 0x10, Path_Combine(A_Desktop, links[1].title ".url"), "Create Shortcut", "Url shortcut (*.url)")
    if path == ""
      return
    Save(path, links[1].href, true)
  }
  else
  {
    target := DirSelect(, , "Create Shortcuts")
    if target == ""
      return
    if MsgBox(Format('Create {} shortcuts in "{}" ?', links.Length, target), , 0x21) != "Yes"
      return
    for link in links
      Save(Path_Combine(target, link.title ".url"), link.href, false)
  }
  /**
   * @param {String} path
   * @param {String} url
   * @param {Boolean} [overwrite=false]
   */
  Save(path, url, overwrite := false)
  {
    if !(Path_GetExtensionName(path) ~= "^(?i:url)$")
      path .= ".url"
    if FileExist(path)
    {
      if Url_Load(path) == url
        return
      if !overwrite
        switch MsgBox(Format('"{}" already exists.`nDo you want to overwrite?', path), , 0x23)
        {
          case "No":
            return
          case "Cancel":
            throw Error("Canceled by user.")
        }
    }
    try
    {
      IniWrite(url, path, "InternetShortcut", "URL")
      Log_Trace("Saved", path)
    }
    catch as ex
    {
      path := FileSelect("S" 0x10, path, "Create Shortcut", "Url shortcut (*.url)")
      if path == ""
        throw ex
      Save(path, url, false)
    }
  }
}
/**
 * @param {Array<String>} paths
 */
Dialog_OpenPath(paths)
{
  if paths.Length == 0
    return
  static PAGE_SIZE := Integer(Config_Get("Path", "PAGE_SIZE"))
  digits := StrLen(String(paths.Length))
  for path in paths
  {
    remaining := paths.Length - A_Index + 1
    if (
      paths.Length > 1
      && remaining > 0
      && Mod(A_Index - 1, PAGE_SIZE) == 0
    )
      switch MsgBox(Format("Open {} path(s)? ({:0" digits "} / {})", Min(remaining, PAGE_SIZE), A_Index - 1, paths.Length), , 0x23)
      {
        case "No":
          continue
        case "Cancel":
          View_Text(Array_Slice(paths, A_Index))
          return
      }
    if !FileExist(path)
      continue
    Log_Trace("Opened", path)
    if Path_IsDirectory(path)
      Open_Explorer(path)
    else
      Open_File(path)
  }
}
/**
 * @param {Array<String>} urls
 */
Dialog_OpenUrl(urls)
{
  if urls.Length == 0
    return
  static PAGE_SIZE := Integer(Config_Get("Url", "PAGE_SIZE"))
  static BROWSER := Config_Get("Url", "BROWSER", "{}")
  digits := StrLen(String(urls.Length))
  for url in urls
  {
    remaining := urls.Length - A_Index + 1
    if (
      urls.Length > 1
      && remaining > 0
      && Mod(A_Index - 1, PAGE_SIZE) == 0
    )
      switch MsgBox(Format("Open {} URL(s)? ({:0" digits "} / {})", Min(remaining, PAGE_SIZE), A_Index - 1, urls.Length), , 0x23)
      {
        case "No":
          continue
        case "Cancel":
          View_Text(Array_Slice(urls, A_Index))
          return
      }
    Log_Trace("Opened", url)
    switch Url_GetProtocol(url), false
    {
      case "file":
        path := Path_FromURL(url)
        if !FileExist(path)
          path := Path_FromURL(Url_Decode(url))
        if !FileExist(path)
          continue
        else if Path_IsDirectory(path)
          Open_Explorer(path)
        else
          Open_File(path)
        continue
      default:
        try
          Open(BROWSER, url)
        catch
          Open(url)
    }
  }
}
