#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)
OnExit(HandleExit)

ContextMenu_Open(Trim(A_Clipboard, "`r`n")).Show()

/**
 * @param {String} input
 * @returns {ContextMenu}
 */
ContextMenu_Open(input)
{
  static MAX_SUBMENU := Integer(Config_Get("Path", "MAX_SUBMENU"))
  ctx := ContextMenu()
  if String_IsNullOrWhitespace(input)
    return ctx
  paths := Clipboard_ExtractPath()
  urls := Clipboard_ExtractUrl()
  if paths.Length == 0 && urls.Length == 0
    return ctx
  try
  {
    if paths.Length == 0 && urls.Length > 0
    {
      Dialog_OpenUrl(urls)
      return ctx
    }
    if paths.Length == 1
      ctx := ContextMenu_OpenPath(paths[1])
    else if paths.Length > 0
    {
      if paths.Length <= MAX_SUBMENU
      {
        ctxPath := ContextMenu()
        for path in paths
          ctxPath.AddSubMenu(Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, (Path_IsRoot(path) ? path : Path_GetName(path)) (Path_IsLink(path) ? "*" : "")), ContextMenu_OpenPath(path, 1), path)
        ctx.AddSubMenu(Format("Open", paths.Length), ctxPath)
      }
      ctx.Add(Format("Open ({})", paths.Length), Dialog_OpenPath.Bind(paths))
      ctx.AddSubMenu(Format("Send to ({})", paths.Length), ContextMenu_SendTo(paths*))
      targets := Array_Unique(Stream(paths).ToArray(path => Path_IsDirectory(path) ? path : Path_GetParent(path)), , , Path_Compare)
      ctx.Add(Format("Open with Terminal ({})", targets.Length), (xs => Stream(xs).Each(x => Open('wt.exe -d "{}"', x))).Bind(targets), Path_Resolve("pwsh.exe"))
      find := Reg_Find()
      if find !== ""
        ctx.Add(Format("Find ({})", targets.Length), Open_Find.Bind(targets*), find)
      grep := Reg_Grep()
      if grep !== ""
        ctx.Add(Format("Grep ({})", targets.Length), (xs => Stream(xs).Each(x => Open_Grep(x))).Bind(targets), grep)
    }
    if urls.Length > 0
    {
      ctx.AddSeparator()
      ctx.Add(Format("Open URL ({})", urls.Length), Dialog_OpenUrl.Bind(urls))
    }
    return ctx
  }
  finally
    ToolTip()
}
/**
 * @param {String} path
 * @param {Integer} [depth=0]
 * @returns {ContextMenu}
 */
ContextMenu_OpenPath(path, depth := 0)
{
  static MAX_DEPTH := Integer(Config_Get("Path", "MAX_DEPTH"))
  ctx := ContextMenu()
  if !FileExist(path)
    return ctx
  ToolTip(path)
  friendlyName := Path_IsDirectory(path) ? "" : Path_FriendlyDocName(path)
  ctx.Add(friendlyName == "" ? "Open" : "Open " friendlyName, Path_IsDirectory(path) ? Open_Explorer.Bind(path) : Open.Bind(path), path)
  target := Path_GetLinkTarget(path)
  if target !== path
    ctx.AddSubMenu("Open target", ContextMenu_OpenPath(target, depth + 1))
  if Path_GetExtensionName(path) ~= "^(?i:library-ms)$"
  {
    locations := Path_GetLibraryLocations(path)
    ctxLocations := ContextMenu()
    for location in locations
    {
      name := Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, Path_GetName(location))
      ctxLocations.AddSubMenu(name, ContextMenu_OpenPath(location, depth + 1))
    }
    ctx.AddSubMenu(Format("Open in locations ({})", locations.Length), ctxLocations)
  }
  if Path_IsDirectory(path) && depth < MAX_DEPTH
  {
    ctxChild := ContextMenu()
    children := Path_GetChildren(path, , 'FD')
    for child in children
    {
      name := Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, Path_GetName(child))
      ctxChild.AddSubMenu(name, ContextMenu_OpenPath(child, depth + 1), child)
    }
    ctx.AddSubMenu(Format("Open children ({})", children.Length), ctxChild)
  }
  if depth == 0
  {
    ctxParents := ContextMenu()
    parents := Path_GetParents(path)
    for parent in parents
    {
      name := Format("{:-3}{}", (StrLen(A_Index) == 1 ? "&" : "") A_Index, Path_IsRoot(parent) ? parent : Path_GetName(parent))
      ctxParents.AddSubMenu(name, ContextMenu_OpenPath(parent, depth + A_Index), parent)
    }
    ctx.AddSubMenu(Format("Open parents ({})", parents.Length), ctxParents)
  }
  target := Path_IsDirectory(path) ? path : Path_GetParent(path)
  find := Reg_Find()
  if find !== ""
    ctx.Add("Find", Open_Find.Bind(target), Reg_Find())
  grep := Reg_Grep()
  if grep !== ""
    ctx.Add("Grep", Open_Grep.Bind(target), Reg_Grep())
  ctx.AddSubMenu("Shell", ContextMenu_Shell(path))
  ctx.AddSubMenu("Send to", ContextMenu_SendTo(path))
  ctx.AddSubMenu("Copy to clipboard", ContextMenu_CopyPath(path))
  if Path_IsText(path)
    ctx.Add("View", () => (
      content := FileRead(path),
      ext := Path_GetExtensionName(path),
      ext ~= "^(?i:csv)$" ? View_Csv(content) : View_Text(content, ext ?? "txt")
    ))
  ctx.Add("Properties", Open_Property.Bind(path))
  return ctx
}
/**
 * @param {Array<String>} paths
 * @returns {ContextMenu}
 */
ContextMenu_SendTo(paths*)
{
  static items := Path_GetChildren(Reg_FolderDescriptions("SendTo"), "*.lnk")
  ctx := ContextMenu()
  for item in items
    ctx.Add(Path_GetBaseName(item), Open.Bind(item ' "{}"', Enumerable_Join(paths, '" "')), item)
  return ctx
}
/**
 * @param {String} path
 * @returns {ContextMenu}
 */
ContextMenu_Shell(path)
{
  static shell := ComObject("Shell.Application")
  ctx := ContextMenu()
  try
    for verb in shell.NameSpace(path).Self.Verbs
      if verb.Name !== ""
        ctx.Add(verb.Name, (v => v.DoIt()).Bind(verb))
  catch
    for verb in shell.NameSpace(Path_GetParent(path)).ParseName(Path_GetName(path)).Verbs
      if verb.Name !== ""
        ctx.Add(verb.Name, (v => v.DoIt()).Bind(verb))
  return ctx
}
/**
 * @param {String} path
 * @returns {ContextMenu}
 */
ContextMenu_CopyPath(path)
{
  ctx := ContextMenu()
  ctx.Add("BaseName", Clipboard_SetText.Bind(Path_GetBaseName(path)))
  ctx.Add("FileName", Clipboard_SetText.Bind(Path_GetName(path)))
  ctx.Add("FullName", Clipboard_SetText.Bind((path)))
  ctx.Add("Parent", Clipboard_SetText.Bind(Path_GetParent(path)))
  ctx.Add("Local", Clipboard_SetText.Bind(Path_ToLocal(path)))
  ctx.Add("Network", Clipboard_SetText.Bind(Path_ToNetwork(path)))
  ctx.Add("URL", Clipboard_SetText.Bind(Url_Encode(Path_ToURL(path))))
  ctx.Add("Replace \ -> /", Clipboard_SetText.Bind(StrReplace.Bind(path, "\", "/")))
  return ctx
}
