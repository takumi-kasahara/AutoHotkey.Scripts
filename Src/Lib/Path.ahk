#Requires AutoHotkey v2.0

/**
 * @param {String*} segments
 * @returns {String}
 */
Path_Combine(segments*) => String_Join("\", segments*)
/**
 * @param {String} pattern
 * @returns {String}
 */
Path_Resolve(pattern)
{
  if Path_IsAbsolute(pattern) && FileExist(pattern)
    return pattern
  dirs := StrSplit(EnvGet("PATH"), ";")
  exts := Path_GetExtensionName(pattern) !== "" ? [""] : StrSplit(EnvGet("PATHEXT"), ";")
  for dir in dirs
    if DirExist(dir)
      for ext in exts
        loop files, Path_Combine(dir, pattern ext)
          return A_LoopFileFullPath
}
/**
 * @param {Array<String>} paths
 * @param {String} [delimiter=","]
 * @returns {String}
 */
Path_GetProperty(paths, delimiter := ",")
{
  if paths.Length == 1
    paths := Path_GetChildren(paths[1], , "R")
  text := "Path"
    . delimiter "CreationTime"
    . delimiter "LastWriteTime"
    . delimiter "LastAccessTime"
    . delimiter "Attribute"
    . "`n"
  for path in paths
    text .= path
      . delimiter FileGetTime(path, "C")
      . delimiter FileGetTime(path, "M")
      . delimiter FileGetTime(path, "A")
      . delimiter FileGetAttrib(path)
      . "`n"
  return text
}
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsAbsolute(path) => path ~= "^(?:[a-zA-Z]:|\\\\[^\\]+)\\"
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsFileSpec(fileName) => !(fileName ~= '[<>:"/\\|?*\x00-\x1F]')
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsRoot(path) =>
  path ~= "^(?:[a-zA-Z]:(?:\\)?)$" ; e.g. "C:"
  || path ~= "^(?:\\\\[^\\]+\\[^\\]+(?:\\)?)$" ; e.g. "\\server\share"
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsLiteral(path) =>
  Stream(StrSplit(path, "\")).Every(part => Path_IsRoot(part) || Path_IsFileSpec(part))
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsDirectory(path) => InStr(FileGetAttrib(path), "D")
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsLink(path)
{
  try
  {
    if InStr(FileGetAttrib(path), "L")
      return true
    FileGetShortcut(path, &target)
    return target !== ""
  }
  catch
    return false
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetAssociation(path)
{
  static cache := Map()
  ext := StrLower(Path_GetExtensionName(path))
  if cache.Has(ext)
    return cache.Get(ext)
  value := RegRead("HKCR\." ext, "", "")
  cache.Set(ext, value)
  Log_Trace("Association", ext, value)
  return value
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetContentType(path)
{
  static cache := Map()
  ext := StrLower(Path_GetExtensionName(path))
  if cache.Has(ext)
    return cache.Get(ext)
  value := RegRead("HKCR\." ext, "Content Type", "")
  cache.Set(ext, value)
  Log_Trace("ContentType", ext, value)
  return value
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetPerceivedType(path)
{
  static cache := Map()
  ext := StrLower(Path_GetExtensionName(path))
  if cache.Has(ext)
    return cache.Get(ext)
  value := RegRead("HKCR\." ext, "PerceivedType", "")
  cache.Set(ext, value)
  Log_Trace("PerceivedType", ext, value)
  return value
}
/**
 * @param {String} path
 * @returns {Integer}
 */
Path_IsText(path)
{
  if !FileExist(path)
    throw TargetError(Format('"{}" not found.', path))
  if Path_IsDirectory(path)
    return false
  static cache := Map()
  ext := StrLower(Path_GetExtensionName(path))
  if cache.Has(ext)
    return cache.Get(ext)
  switch Path_GetAssociation(path)
  {
    case "batfile", "regfile":
      cache.Set(ext, true)
      return true
    case "exefile", "dllfile", "sysfile":
      cache.Set(ext, false)
      return false
  }
  ; https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types/Common_types
  contentType := Path_GetContentType(path)
  if contentType !== ""
    switch StrSplit(contentType, "/")[1]
    {
      case "text":
        cache.Set(ext, true)
        return true
      case "application":
        switch StrSplit(contentType, "/")[2]
        {
          case "json", "ld+json", "manifest+json", "xhtml+xml", "xml":
            cache.Set(ext, true)
            return true
          default:
            cache.Set(ext, false)
            return false
        }
      case "image":
        switch StrSplit(contentType, "/")[2]
        {
          case "svg+xml":
            cache.Set(ext, true)
            return true
          default:
            cache.Set(ext, false)
            return false
        }
      case "audio", "font", "video":
        cache.Set(ext, false)
        return false
    }
  switch Path_GetPerceivedType(path)
  {
    case "text":
      cache.Set(ext, true)
      return true
  }
  switch Path_FriendlyAppName(path)
  {
    case "Notepad", "Notepad++", "WinMerge":
      cache.Set(ext, true)
      return true
  }
  cache.Set(ext, false)
  return false
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetName(path)
{
  SplitPath(path, &fileName)
  return fileName
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetBaseName(path)
{
  SplitPath(path, , , , &baseName)
  return baseName
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetParent(path)
{
  SplitPath(path, , &dir)
  return dir
}
/**
 * @param {String} path
 * @returns {Array<String>}
 */
Path_GetParents(path)
{
  parents := []
  loop
    parents.Push(Path_GetParent(parents.Length > 0 ? parents[-1] : path))
  until Path_IsRoot(parents[-1])
  return Stream(parents).Filter(parent => parent !== path).ToArray()
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetExtensionName(path)
{
  SplitPath(path, , , &ext)
  return ext
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_FriendlyDocName(path)
{
  ext := StrLower(Path_GetExtensionName(path))
  if ext == ""
    return
  static cache := Map()
  if cache.Has(ext)
    return cache.Get(ext)
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/shell/assocf_str} */
  static ASSOCF_NONE := 0x00000000
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/ne-shlwapi-assocstr} */
  static ASSOCSTR_FRIENDLYDOCNAME := 0x00000003
  bufSize := 0
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-assocquerystringw} */
  if DllCall("shlwapi.dll\AssocQueryStringW"
    , "UInt", ASSOCF_NONE               ; ASSOCF    flags
    , "UInt", ASSOCSTR_FRIENDLYDOCNAME  ; ASSOCSTR  str
    , "WStr", "." ext                   ; LPCWSTR   pszAssoc
    , "Ptr", 0                          ; LPCWSTR   pszExtra
    , "Ptr", 0                          ; LPWSTR    pszOut
    , "UInt*", &bufSize                 ; DWORD     *pcchOut
    , "HRESULT"                         ; HRESULT
  ) == S_FALSE
  {
    VarSetStrCapacity(&buf, bufSize * 2)
    if DllCall("shlwapi.dll\AssocQueryStringW"
      , "UInt", ASSOCF_NONE               ; ASSOCF    flags
      , "UInt", ASSOCSTR_FRIENDLYDOCNAME  ; ASSOCSTR  str
      , "WStr", "." ext                   ; LPCWSTR   pszAssoc
      , "Ptr", 0                          ; LPCWSTR   pszExtra
      , "WStr", buf                       ; LPWSTR    pszOut
      , "UInt*", &bufSize                 ; DWORD     *pcchOut
      , "HRESULT"                         ; HRESULT
    ) == S_OK
    {
      cache.Set(ext, buf)
      Log_Trace("FriendlyDocName", ext, buf)
      return buf
    }
  }
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_FriendlyAppName(path)
{
  ext := StrLower(Path_GetExtensionName(path))
  if ext == ""
    return
  static cache := Map()
  if cache.Has(ext)
    return cache.Get(ext)
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/shell/assocf_str} */
  static ASSOCF_NONE := 0x00000000
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/ne-shlwapi-assocstr} */
  static ASSOCSTR_FRIENDLYAPPNAME := 0x00000004
  bufSize := 0
  try
  {
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-assocquerystringw} */
    if DllCall("shlwapi.dll\AssocQueryStringW"
      , "UInt", ASSOCF_NONE               ; ASSOCF   flags
      , "UInt", ASSOCSTR_FRIENDLYAPPNAME  ; ASSOCSTR str
      , "WStr", "." ext                   ; LPCWSTR  pszAssoc
      , "Ptr", 0                          ; LPCWSTR  pszExtra
      , "Ptr", 0                          ; LPWSTR   pszOut
      , "UInt*", &bufSize                 ; DWORD    *pcchOut
      , "HRESULT"                         ; HRESULT
    ) == S_FALSE
    {
      VarSetStrCapacity(&buf, bufSize * 2)
      if DllCall("shlwapi.dll\AssocQueryStringW"
        , "UInt", ASSOCF_NONE               ; ASSOCF   flags
        , "UInt", ASSOCSTR_FRIENDLYAPPNAME  ; ASSOCSTR str
        , "WStr", "." ext                   ; LPCWSTR  pszAssoc
        , "Ptr", 0                          ; LPCWSTR  pszExtra
        , "WStr", buf                       ; LPWSTR   pszOut
        , "UInt*", &bufSize                 ; DWORD    *pcchOut
        , "HRESULT"                         ; HRESULT
      ) == S_OK
      {
        cache.Set(ext, buf)
        Log_Trace("FriendlyAppName", ext, buf)
        return buf
      }
    }
  }
  catch as ex
    if ex.Number !== ERROR_NO_ASSOCIATION
      throw ex
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetDrive(path)
{
  SplitPath(path, , , , , &drive)
  return drive
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_GetLinkTarget(path)
{
  if InStr(FileGetAttrib(path), "L")
    return GetFinalPathName(path)
  loop
  {
    try
      FileGetShortcut(path, &target)
    catch
      return path
    if target == ""
      return path
    path := target
  }
  /**
   * @param {String} path
   * @returns {String}
   */
  GetFinalPathName(path)
  {
    static access := 0x80000000 ; GENERIC_READ
    static share := 0x00000007 ; FILE_SHARE_READ | WRITE | DELETE
    static creation := 0x3 ; OPEN_EXISTING
    static flags := 0 ; Don't add FILE_FLAG_OPEN_REPARSE_POINT so CreateFile follows the reparse point (resolves the link)
    if Path_IsDirectory(path)
      flags |= 0x02000000 ; FILE_FLAG_BACKUP_SEMANTICS
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew} */
    hFile := DllCall("CreateFileW"
      , "WStr", path     ; LPCWSTR                lpFileName
      , "UInt", access   ; DWORD                  dwDesiredAccess
      , "UInt", share    ; DWORD                  dwShareMode
      , "Ptr", 0         ; LPSECURITY_ATTRIBUTES  lpSecurityAttributes
      , "UInt", creation ; DWORD                  dwCreationDisposition
      , "UInt", flags    ; DWORD                  dwFlagsAndAttributes
      , "Ptr", 0         ; HANDLE                 hTemplateFile
      , "Ptr"            ; HANDLE
    )
    if hFile == INVALID_HANDLE_VALUE
      throw OSError()
    try
    {
      bufSize := MAX_PATH
      static FILE_NAME_NORMALIZED := 0x0
      loop
      {
        VarSetStrCapacity(&buf, bufSize * 2)
        /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfinalpathnamebyhandlew} */
        bufSize := DllCall("GetFinalPathNameByHandleW"
          , "Ptr", hFile                  ; HANDLE  hFile
          , "WStr", buf                   ; LPWSTR  lpszFilePath
          , "UInt", bufSize               ; DWORD   cchFilePath
          , "UInt", FILE_NAME_NORMALIZED  ; DWORD   dwFlags
          , "UInt"                        ; DWORD
        )
        if bufSize == 0
          throw OSError()
      }
      until bufSize <= MAX_PATH || A_Index == 2
    }
    finally
      CloseHandle(hFile)
    return String_StartsWith(buf, "\\?\UNC\")
      ? "\\" SubStr(buf, StrLen("\\?\UNC\") + 1) ; "\\?\UNC\Server\Share" -> "\\Server\Share"
      : RegExReplace(buf, "^\\\\\?\\") ; "\\?\C:\" -> "C:\"
  }
}
/**
 * @param {String} dir
 * @param {String} [pattern="*"]
 * @param {String} [mode="F"]
 * @returns {Array<String>}
 */
Path_GetChildren(dir, pattern := "*", mode := "F", filter := () => !(A_LoopFileAttrib ~= "i)[HS]"))
{
  static MAX_CHILDREN := Integer(Config_Get("Path", "MAX_CHILDREN"))
  children := []
  loop files, Path_Combine(dir, pattern), mode
    if filter.Call() && (!IsSet(MAX_CHILDREN) || children.Length < MAX_CHILDREN)
      children.Push(A_LoopFileFullPath)
  return Array_Sort(children, , , Path_Compare)
}
/**
 * @param {String} path
 * @returns {Array<String>}
 */
Path_GetLibraryLocations(path)
{
  folder := ComObject("Shell.Application").NameSpace(path)
  locations := []
  for item in folder.Items()
    locations.Push(item.Path)
  return Array_Unique(locations, , , Path_Compare)
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_Expand(path)
{
  if !FileExist(path)
  {
    loop
    {
      old := path
      path := ComObject("WScript.Shell").ExpandEnvironmentStrings(path)
    }
    until old == path
  }
  drive := Path_GetDrive(path)
  if drive == "" || !FileExist(path)
    return
  if drive ~= "^[^A-Z]"
    return path
  ; not DriveType.Network
  if ComObject("Scripting.FileSystemObject").GetDrive(drive).DriveType !== 3
    return path
  match := false
  for letter in ComObject("WScript.Network").EnumNetworkDrives
  {
    if match
      return StrReplace(path, drive, letter)
    match := drive == letter
  }
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_ToLocal(path)
{
  drive := Path_GetDrive(path)
  if drive !== "\\" A_ComputerName
    return Resolve(path)
  for networkPath, localPath in Win32_Share()
    if String_StartsWith(path, networkPath)
      path := StrReplace(path, networkPath, localPath)
  return Resolve(path)
  /**
   * @param {String} path
   * @returns {String}
   */
  Resolve(path)
  {
    minDepth := MAX_PATH
    resolved := path
    for name, value in Win32_Environment()
    {
      if path == value
        return name
      if !String_StartsWith(path, value "\")
        continue
      replaced := StrReplace(path, value "\", name "\")
      depth := StrLen(RegExReplace(replaced, "[^\\]+"))
      if depth < minDepth
      {
        minDepth := depth
        resolved := replaced
        continue
      }
      if depth == minDepth && StrLen(replaced) < StrLen(resolved)
      {
        resolved := replaced
        continue
      }
    }
    return RTrim(resolved, "\")
  }
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_ToNetwork(path)
{
  network := "\\" A_ComputerName
  switch Path_GetDrive(path), false
  {
    case network:
      return path
    case "\\localhost":
      return StrReplace(path, "\\localhost", network)
    default:
      for ip in SysGetIPAddresses()
        if Path_GetDrive(path) == "\\" ip
          return StrReplace(path, "\\" ip, network)
  }
  return Resolve(path)
  /**
   * @param {String} path
   * @returns {String}
   */
  Resolve(path)
  {
    minDepth := MAX_PATH
    resolved := path
    for networkPath, localPath in Win32_Share()
    {
      if path == localPath
        return networkPath
      if !String_StartsWith(path "\", localPath)
        continue
      replaced := StrReplace(path "\", localPath, networkPath)
      depth := StrLen(RegExReplace(replaced, "[^\\]+"))
      if depth < minDepth
      {
        minDepth := depth
        resolved := replaced
        continue
      }
      if depth == minDepth && StrLen(replaced) < StrLen(resolved)
      {
        resolved := replaced
        continue
      }
    }
    return RTrim(resolved, "\")
  }
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-pathcreatefromurlw}
 * @param {String} url
 * @returns {String}
 */
Path_FromURL(url)
{
  bufSize := MAX_PATH
  VarSetStrCapacity(&path, bufSize * 2)
  if DllCall("shlwapi.dll\PathCreateFromUrlW"
    , "WStr", url       ; PCWSTR  pszUrl
    , "WStr", path      ; PWSTR   pszPath
    , "UInt*", &bufSize ; DWORD   *pcchPath
    , "UInt", 0         ; DWORD   dwFlags
    , "HRESULT"         ; HRESULT
  ) == S_OK
    return path
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-urlcreatefrompathw}
 * @param {String} path
 * @returns {String}
 */
Path_ToURL(path)
{
  bufSize := INTERNET_MAX_URL_LENGTH
  VarSetStrCapacity(&url, bufSize * 2)
  switch DllCall("shlwapi.dll\UrlCreateFromPathW"
    , "WStr", path      ; PCWSTR  pszPath
    , "WStr", url       ; PWSTR   pszUrl
    , "UInt*", &bufSize ; DWORD   *pcchUrl
    , "UInt", 0         ; DWORD   dwFlags
    , "HRESULT"         ; HRESULT
  )
  {
    case S_OK, S_FALSE:
      return url
  }
}
/**
 * @param {String} path
 * @returns {String}
 */
Path_Canonicalize(path)
{
  bufSize := MAX_PATH
  VarSetStrCapacity(&buf, bufSize * 2)
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-pathcanonicalizew} */
  if !DllCall("shlwapi.dll\PathCanonicalizeW"
    , "WStr", buf   ; LPWSTR  pszBuf
    , "WStr", path  ; LPCWSTR pszPath
    , "Int"         ; BOOL
  )
    throw OSError()
  return RegExReplace(RegExReplace(buf, "^\\{3,}", "\\"), "(?<!^)\\{2,}", "\")
}
/**
 * @description Compares two paths for sorting.
 * - `path1 == path2` => 0
 * - `path1 > path2` => 1
 * - `path1 < path2` => -1
 * @param {String} path1
 * @param {String} path2
 * @returns {Integer}
 */
Path_Compare(path1, path2, *)
{
  if path1 == path2
    return 0
  if String_StartsWith(path1, path2)
    return 1
  if String_StartsWith(path2, path1)
    return -1
  s1 := StrSplit(Path_GetParent(path1), "\")
  s2 := StrSplit(Path_GetParent(path2), "\")
  if s1.Length > s2.Length
    return 1
  if s1.Length < s2.Length
    return -1
  loop Max(s1.Length, s2.Length)
  {
    if A_Index == s1.Length && A_Index == s2.Length
      break
    compare := StrCompare(s1[A_Index], s2[A_Index], "Logical")
    if compare !== 0
      return compare
  }
  isDirectory1 := Path_IsDirectory(path1)
  isDirectory2 := Path_IsDirectory(path2)
  if isDirectory1 && !isDirectory2
    return -1
  if !isDirectory1 && isDirectory2
    return 1
  if isDirectory1 && isDirectory2
    return StrCompare(Path_GetName(path1), Path_GetName(path2), "Logical")
  name1 := Path_FriendlyDocName(path1)
  name2 := Path_FriendlyDocName(path2)
  if name1 == name2
    return StrCompare(Path_GetBaseName(path1), Path_GetBaseName(path2), "Logical")
  return StrCompare(name1, name2, "Logical")
}
