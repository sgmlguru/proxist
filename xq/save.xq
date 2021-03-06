xquery version "1.0";

declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace xf="http://www.w3.org/2002/xforms";
declare namespace fo="http://www.w3.org/1999/XSL/Format";
declare namespace xslfo="http://exist-db.org/xquery/xslfo";
declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

let $config := util:expand(doc("/db/xep.xml")/*)

let $log := util:log-system-out('running save.xq')
(: get-data() returns the document node.  We want the root node :)
let $formdata := request:get-data()/*
 
(: check to make sure we have valid post data :)
return
  if (not($formdata) or not(doc-available('http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml')))
     then <save-results code="400">No Post Data</save-results>
     else 
 
let $save-data-collection := concat('xmldb:exist:///db/work', '/tmp')
 
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

(: Runs wrapper XProc that generates XQ for child process, runs child process XProc :)
let $result := xmlcalabash:process("xmldb:exist:///db/work/system/prox/xproc/proxist-wrapper.xpl",
    ("-imap=http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml",
    "-oresult=-"),
    ("normalized=xmldb:exist:///db/work/tmp/debug-normalized.xml"))


(: Analyse result from child process :)
let $output := if (name($result/*)='fo:root')
   then "out.pdf"
   else if (name($result/*)='xhtml:html')
       then "out.xhtml"
       else if (name($result/*)='html')
            then "out.htm"
            else if (name($result/*)='map')
                then "out.mm"
                else "out.xml"

let $out := if ($output='out.pdf')
    then xslfo:render($result, "application/pdf", (), $config)
    else $result
    
(:let $save :=  if ($output='FO') 
    then xmldb:store('/db/work/tmp','out.pdf',$out)
    else if ($output='XHTML')
        then xmldb:store('/db/work/tmp','out.xhtml',$out)
            else if ($output='HTML')
                then xmldb:store('/db/work/tmp','out.htm',$out)
                    else if ($output='MM')
                        then xmldb:store('/db/work/tmp','out.mm',$out)
                        else xmldb:store('/db/work/tmp','out.xml',$out):)

let $save := xmldb:store('/db/work/tmp',$output,$out)

(: Returns result info :)
return
    if (doc-available('http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml')) 
        then (
            <save-results code="200">
                {
                    (:if ($overwrite)
                        then <message>ProX instance updated at {$path-name}. Output is {$output}.</message>
                        else <message>New ProX instance saved to {$path-name}. Output is {$output}.</message>:)
                        <message>{concat('http://localhost:8080/exist/rest/db/work/tmp','/',$output)}</message>
                }
            </save-results>
            )
        else (<save-results code="400">
            {<message>No current resource map. ProX child process did not finish.</message>}
        </save-results>
        )
        
