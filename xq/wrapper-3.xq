xquery version "3.0";
(:let $login := xmldb:login("/db","admin","Favorit70"):)

let $result := xmlcalabash:process("xmldb:exist:///db/work/system/prox/xproc/proxist-wrapper.xpl",
("-imap=http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml",
"-oresult=-"),
("normalized=xmldb:exist:///db/work/tmp/debug-test.xml"))

let $output := if (local-name($result/*)='root')
   then <p>FO</p>
   else if (local-name($result/*)='html')
       then <p>HTML</p>
       else <p>XML</p>
       
return $output