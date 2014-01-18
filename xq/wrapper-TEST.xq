xquery version "3.0";
(:let $login := xmldb:login("/db","admin","Favorit70"):)

let $result := xmlcalabash:process("xmldb:exist:///db/work/docs/xproc/WRAP-2.xpl",
("-imap=http://localhost:8080/exist/rest/db/work/system/common/xml/resource-map.xml",
"-oresult=-"),
("normalized=xmldb:exist:///db/work/docs/test/test.xml"))
return
   $result