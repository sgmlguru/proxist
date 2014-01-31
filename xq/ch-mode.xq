xquery version "1.0";
let $login := xmldb:login("xmldb:exist:///db","admin","Favorit70")
let $path := "xmldb:exist:///db/work/tmp/out.xq"
let $mode := "rwxrwxrwx"
let $group := sm:chgrp($path,"dba")
let $owner := sm:chown($path,"admin")
let $result := sm:chmod($path,$mode)
return
    <result>{$result}</result>