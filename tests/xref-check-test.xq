xquery version "3.0";

let $result := xmlcalabash:process("xmldb:exist:///db/work/system/cosml/xproc/xref-check-cosml.xpl",
("-istylesheet=http://localhost:8080/exist/rest/db/work/system/cosml/xslt/link-target-check-multifile.xsl",
"-imap=http://localhost:8080/exist/rest/db/work/system/common/xml/resource-map.xml"),
("file-url=xmldb:exist:///db/work/docs/test/files.xml",
"htm=xmldb:exist:///db/work/docs/test/xrefs-broken.htm"))
return
   $result
  