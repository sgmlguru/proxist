xquery version "1.0";
declare namespace fo="http://www.w3.org/1999/XSL/Format";
declare namespace xslfo="http://exist-db.org/xquery/xslfo";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
 
let $config := util:expand(doc("/db/xep.xml")/*)

let $fo :=
<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="my-page">
            <fo:region-body margin="1in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>
    <fo:page-sequence master-reference="my-page">
        <fo:flow flow-name="xsl-region-body">
            <fo:block>Hello World2!</fo:block>
        </fo:flow>
    </fo:page-sequence>
</fo:root>
 
let $pdf := xslfo:render($fo, "application/pdf", (), $config)

(:  return xmldb:store("/db/work/docs/test", "out.pdf", $pdf, "B64/application/pdf/string()"):) 
 
return response:stream-binary($pdf, "media-type=application/pdf","out.pdf") 