xquery version "1.0";
(:import module namespace config= "http://danmccreary.com/config" at "../modules/config.xqm";:)
 
declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace xf="http://www.w3.org/2002/xforms";
(:declare namespace dc="http://gov/grantsolutions/dc";:)

let $login := xmldb:login('xmldb:exist:///db/work/docs/test','admin','Favorit70')
 
let $log := util:log-system-out('running save.xq')
(: get-data() returns the document node.  We want the root node :)
let $formdata := request:get-data()/*
 
(: check to make sure we have valid post data :)
return
  if (not($formdata) or not(doc-available('http://localhost:8080/exist/rest/db/work/docs/test/test-resmap.xml')))
     then <save-results code="400">No Post Data</save-results>
     else 
 
let $save-data-collection := concat('xmldb:exist:///db/work/docs', '/test')
 
let $form-id :=
   if (exists($formdata/@code))
      then $formdata/@code/string()
      else
        if (exists($formdata/@form-id))
            then $formdata/@form-id/string()
            else 'unknown-form-id'
 
let $file-name := concat($form-id, '.xml')
let $path-name := concat($save-data-collection, '/', $file-name)
 
let $overwrite :=
  if (doc-available($path-name))
    then true()
    else false()

let $store := xmldb:store($save-data-collection, $file-name, $formdata)

return
    if (doc-available('http://localhost:8080/exist/rest/db/work/docs/test/test-resmap.xml')) 
        then (
        <save-results code="200">
            {
            if ($overwrite)
                then <message>ProX instance updated at {$path-name}.</message>
                else <message>New ProX instance saved to {$path-name}.</message>
            }
        </save-results>)
        else (<save-results code="400">
            {<message>No current resource map.</message>}
        </save-results>
        )

