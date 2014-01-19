xquery version "3.0";
let $result := xmlcalabash:process("xmldb:exist:///db/work/docs/xproc/publish-cosml-pdf-TEST.xpl",
("-istylesheet=http://localhost:8080/exist/rest/db/work/system/cosml/fo/cos-fo-internal.xsl",
"-istylesheet-norm=http://localhost:8080/exist/rest/db/work/system/cosml/xslt/normalize-2.xsl",
"-idocument=http://localhost:8080/exist/rest/db/work/docs/pdftest/test-root.xml"),
("normalized=xmldb:exist:///db/work/docs/test/test.xml",
"pdf=xmldb:exist:///db/work/docs/test/out.pdf"))
return
   $result
  