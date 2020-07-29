(:~
 : modify xhtml
 : do some conversions/replacements
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

let $doc := db:open($C:WIKI-DB)
return (
  (: remove edit links :)
  delete node $doc//*:span[@class = "mw-editsection"],
  (: no hr, no br equivalent in docbook. remove all empty tags :)
  delete node ($doc//(br, hr, code, dl, dd, tr, td)[string-length(.) = 0]),
  (: delete table of contents :)
  delete node $doc//div[@id = "toc"],
  (: delete magifying lense -- put on images :)
  delete node $doc//div[@class = "magnify"],
  (: insert separators between multi-line code blocks:)
  for $br in $doc//br
  where $br/preceding-sibling::node()[1][self::code]
  return replace node $br with ', ',
  (: remove syntax markup in code examples :)
  for $pre in $doc//pre
  return replace node $pre with element pre { string($pre) }
),

C:log(static-base-uri(), "modified html of all wiki pages")
