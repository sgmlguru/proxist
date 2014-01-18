xquery version "1.0";
let $login := xmldb:login("/db","admin","Favorit70")
let $path := "xmldb:exist:///db/work/docs/test/out.xq"
let $mode := "rwxrwxrwx"
let $group := sm:chgrp($path,"dba")
let $owner := sm:chown($path,"admin")
let $result := sm:chmod($path,$mode)
return
    <result>{$result}</result>