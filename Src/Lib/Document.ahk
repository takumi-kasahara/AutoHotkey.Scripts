#Requires AutoHotkey v2.0

/**
 * @param {{ href: String, title: String, text: String, target: String }} link
 * @returns {String}
 */
Document_CreateAnchorElement(link)
{
  document := ComObject("HTMLFile")
  a := document.createElement("a")
  a.href := link.href
  a.rel := 'noreferrer'
  if link.HasOwnProp("target") && link.target
    a.target := link.target
  if link.HasOwnProp("title") && link.title
    a.title := link.title
  a.innerText := link.text ? link.text : link.href
  return a.outerHTML
}
/**
 * @param {String} url
 * @param {String} text
 * @returns {String}
 */
Document_CreateBlockquoteElement(url, text)
{
  document := ComObject("HTMLFile")
  blockquote := document.createElement("blockquote")
  if url
    blockquote.cite := url
  blockquote.innerText := text
  return blockquote.outerHTML
}
/**
 * @param {String} text
 * @returns {String}
 */
Document_CreateCodeElement(text)
{
  document := ComObject("HTMLFile")
  pre := document.createElement("pre")
  code := document.createElement("code")
  code.innerText := text
  pre.appendChild(code)
  return pre.outerHTML
}
/**
 * @param {Array<String> | Array<{href: String, title: String, text: String, target: String}>} items
 * @returns {String}
 */
Document_CreateListElement(items)
{
  document := ComObject("HTMLFile")
  ul := document.createElement("ul")
  for item in items
  {
    li := document.createElement("li")
    if IsObject(item)
    {
      a := document.createElement("a")
      a.href := item.href
      a.rel := 'noreferrer'
      if item.HasOwnProp("target") && item.target
        a.target := item.target
      if item.HasOwnProp("title") && item.title
        a.title := item.title
      a.innerText := item.text ? item.text : item.href
      li.appendChild(a)
    }
    else
      li.innerText := item
    ul.appendChild(li)
  }
  return ul.outerHTML
}
/**
 * @param {Array<String> | Array<{href: String, title: String, text: String, target: String}>} items
 * @returns {String}
 */
Document_CreateOrderedListElement(items)
{
  document := ComObject("HTMLFile")
  ol := document.createElement("ol")
  for item in items
  {
    li := document.createElement("li")
    if IsObject(item)
    {
      a := document.createElement("a")
      a.href := item.href
      a.rel := 'noreferrer'
      if item.HasOwnProp("target") && item.target
        a.target := item.target
      if item.HasOwnProp("title") && item.title
        a.title := item.title
      a.innerText := item.text ? item.text : item.href
      li.appendChild(a)
    }
    else
      li.innerText := item
    ol.appendChild(li)
  }
  return ol.outerHTML
}
/**
 * @param {String} html
 * @returns {Array<{ href: String, title: String, text: String, target: String }>}
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
    text := Trim(a.innerText)
    if !text
      text := a.href
    links.Push({ href: a.href, title: a.title, text: text, target: a.target })
  }
  return links
}
