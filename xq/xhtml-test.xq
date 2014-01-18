xquery version "3.0";

let $result := xmlcalabash:process("xmldb:exist:///db/work/system/cosml/xproc/publish-cosml-html.xpl",
("-istylesheet=http://localhost:8080/exist/rest/db/work/system/cosml/xslt/cosml2html-ti.xsl",
"-istylesheet-norm=http://localhost:8080/exist/rest/db/work/system/cosml/xslt/normalize-2.xsl",
"-idocument=http://localhost:8080/exist/rest/db/work/docs/pdftest/test-root.xml"),
("normalized=xmldb:exist:///db/work/docs/test/test-htm-normalized.xml",
"htm=xmldb:exist:///db/work/docs/test/test-htm.htm"))
return
   $result
  