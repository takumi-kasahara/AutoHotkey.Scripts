#Requires AutoHotkey v2.0

/**
 * @param {String} href
 * @param {String} text
 * @returns {String}
 */
Document_CreateAnchorElement(url, text)
{
  document := ComObject("HTMLFile")
  a := document.createElement("a")
  a.href := url
  a.rel := 'noreferrer'
  a.target := '_blank'
  a.innerText := text ? text : url
  return a.outerHTML
}
/**
 * @param {Array<String>} items
 * @returns {String}
 */
Document_CreateListElement(items)
{
  document := ComObject("HTMLFile")
  ul := document.createElement("ul")
  for item in items
  {
    li := document.createElement("li")
    li.innerText := item
    ul.appendChild(li)
  }
  return ul.outerHTML
}
/**
 * @param {Array<String>} items
 * @returns {String}
 */
Document_CreateOrderedListElement(items)
{
  document := ComObject("HTMLFile")
  ol := document.createElement("ol")
  for item in items
  {
    li := document.createElement("li")
    li.innerText := item
    ol.appendChild(li)
  }
  return ol.outerHTML
}
/**
 * @param {String} html
 * @returns {Array<{ url: String, title: String }>}
 */
Document_ExtractLinks(html)
{
  links := []
  document := ComObject("HTMLFile")
  document.write(html)
  anchors := document.getElementsByTagName("a")
  loop anchors.length
  {
    a := anchors.item(A_Index - 1)
    if !(a.protocol ~= "(?:https?|file)")
      continue
    title := Trim(a.innerText)
    if !title
      title := a.href
    links.Push({ href: a.href, title: title })
  }
  return links
}
