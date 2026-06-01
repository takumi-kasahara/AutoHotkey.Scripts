#Requires AutoHotkey v2.0

/**
 * @param {String} url
 * @param {String*} [protocol]
 * @param {String*} [host]
 * @param {String*} [port]
 * @param {String*} [pathname]
 * @param {String*} [search]
 * @param {String*} [hash]
 */
Url_Split(url, &protocol?, &host?, &port?, &pathname?, &search?, &hash?)
{
  if RegExMatch(url, "(*UCP)^" RegEx_Http() "$", &matchs)
  {
    protocol := matchs.protocol
    host := matchs.host
    port := matchs.port
    pathname := matchs.pathname
    search := matchs.search
    hash := matchs.hash
    return
  }
  if RegExMatch(url, "(*UCP)^" RegEx_File() "$", &matchs)
  {
    protocol := matchs.protocol
    host := matchs.host
    port := ""
    pathname := matchs.pathname
    search := ""
    hash := ""
    return
  }
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetProtocol(url)
{
  Url_Split(url, &protocol)
  return protocol
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetHost(url)
{
  Url_Split(url, , &host)
  return host
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetPort(url)
{
  Url_Split(url, , , &port)
  return port
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetOrigin(url)
{
  Url_Split(url, &protocol, &host, &port)
  return port !== "" ? Format("{}://{}:{}", protocol, host, port) : Format("{}://{}", protocol, host)
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetPathname(url)
{
  Url_Split(url, , , , &pathname)
  return pathname
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetSearch(url)
{
  Url_Split(url, , , , , &search)
  return search
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_GetHash(url)
{
  Url_Split(url, , , , , , &hash)
  return hash
}
/**
 * @description Compares two URLs for sorting.
 * - `url1 == url2` => 0
 * - `url1 > url2` => 1
 * - `url1 < url2` => -1
 * @param {String} url1
 * @param {String} url2
 * @returns {Integer}
 */
Url_Compare(url1, url2, *)
{
  if url1 == url2
    return 0
  if String_StartsWith(url1, url2)
    return 1
  if String_StartsWith(url2, url1)
    return -1
  host1 := Stream(StrSplit(Url_GetHost(url1), ".")).Reverse().Join(".")
  host2 := Stream(StrSplit(Url_GetHost(url2), ".")).Reverse().Join(".")
  compare := StrCompare(host1, host2, "Logical")
  if compare !== 0
    return compare
  s1 := StrSplit(Url_GetPathname(url1), "/")
  s2 := StrSplit(Url_GetPathname(url2), "/")
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
  return StrCompare(url1, url2, "Logical")
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_Encode(url)
{
  static document := ComObject("HTMLFile")
  static window := document.parentWindow
  static initialized := false
  if !initialized
  {
    window.execScript("function _encodeURI(value) { return encodeURI(value); }")
    initialized := true
  }
  /** @see {@link https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa741364(v=vs.85) } */
  return window._encodeURI(url)
}
/**
 * @param {String} url
 * @returns {String}
 */
Url_Decode(url)
{
  static document := ComObject("HTMLFile")
  static window := document.parentWindow
  static initialized := false
  if !initialized
  {
    window.execScript("function _decodeURI(value) { return decodeURI(value); }")
    initialized := true
  }
  /** @see {@link https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa741364(v=vs.85) } */
  return window._decodeURI(url)
}
/**
 * @param {String} path
 * @returns {String}
 */
Url_Load(path) => IniRead(path, "InternetShortcut", "URL", "")
