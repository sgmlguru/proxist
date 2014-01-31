<p:declare-step xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:xf="http://www.w3.org/2002/xforms" name="main" version="1.0">
    
    
    <!-- Wrapper XProc for ProX
         Requires resource map file as an input. 
         The platform used must be set in the $os
         variable, below. -->
    
    <!-- Inputs -->
    
    <!-- Mapping document -->
    <!-- Contains all URN/URL for XSLT, XPL, XML modules, targets, etc -->
    <p:input port="map" sequence="true">
        <!--<p:document href="http://localhost:8080/exist/rest/db/work/system/common/xml/resource-map.xml"/>-->
    </p:input>
    
    <!-- Global XSLT params -->
    <!-- (Not needed) -->
    <p:input port="xsltparams" kind="parameter"/>
    
    <!-- Outputs -->
    <p:output port="result" sequence="true">
        <p:pipe port="result" step="med"/>
    </p:output>
    
    
    
    <!-- Extension steps -->
    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
    
    
    
    <!-- ProX Blueprint URL -->
    <p:variable name="prox-blueprint" select="//prox/blueprints/resource[@id='id-prox-blueprint']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- ProX XForm Target Instance URL (webdav) -->
    <p:variable name="target-prox-instance" select="//prox/instances/resource[@id='id-prox-xform-target-instance']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- ProX XForm Target Instance URL (xmldb) -->
    <p:variable name="xmldb-target-prox-instance" select="//prox/instances/resource[@id='id-prox-xform-xmldb-instance']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- ProX Saved Instance URL (rest) -->
    <p:variable name="saved-prox-instance" select="//prox/instances/resource[@id='id-prox-saved-instance']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- XForm URL -->
    <p:variable name="xform-url" select="//wrapper-pipeline//resource[prox-id='id-loc-xform']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- prox2shell config URL -->
    <p:variable name="prox2shell-config" select="//wrapper-pipeline//resource[prox-id='id-prox2shell-config']/url/normalize-space(text())">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- Temp URL -->
    <p:variable name="tmp-url" select="'xmldb:exist:///db/work/docs/test/'">
        <!-- substring-before(base-uri(/*),tokenize(base-uri(.),'/')[last()]) -->
        <!--<p:pipe port="map" step="main"/>-->
        <!-- Should use base URI of a target output (ensures writable collection) -->
    </p:variable>
    
    <!-- OS ('osx', 'win', 'linux' allowed) -->
    <p:variable name="os" select="'exist'"/>
    
    
    
    <!-- Open ProX Blueprint in Browser -->
    <!-- Opens with an XForms profile in order
         to start a separate browser instance -->
<!--    <p:choose name="browse">
        <!-\- Linux -\->
        <p:when test="$os='linux'">
            <p:exec command="/usr/bin/iceweasel">
                <p:input port="source">
                    <p:empty/>
                </p:input>
                <p:with-option name="args" select="concat('-P &#34;XForms&#34; -no-remote ',$xform-url)"/>
            </p:exec>
            <p:sink/>
        </p:when>
        
        <!-\- eXist -\->
        <p:when test="$os='exist'">
            <p:exec command="/usr/bin/iceweasel">
                <p:input port="source">
                    <p:empty/>
                </p:input>
                <!-\- Add variable ref to the following? -\->
                <p:with-option name="args" select="concat('-P &#34;xforms&#34; -no-remote ','http://localhost:8080/exist/rest/db/apps/form.xq?form=prox-xform.xml')"/>
            </p:exec>
            <cx:wait-for-update pause-after="3">
                <!-\- Needs to monitor webdav URI of ProX instance, changed by XForm -\->
                <!-\-<p:with-option name="href" select="'http://localhost:8080/exist/webdav/db/work/docs/test/prox-instance.xml'"/>-\->
                <p:with-option name="href" select="$target-prox-instance"/>
            </cx:wait-for-update>
            <p:sink/>
        </p:when>
    </p:choose>-->
    
    
    
    <!-- Update ProX Instance with URLs -->
    <!-- Runtime values inserted from resource map. -->
    <p:xslt name="prox-urn2url">
        <!-- Input source is ProX instance saved in XForm -->
        <p:input port="source" select="doc(//prox/instances/resource[@id='id-prox-saved-instance']/url/normalize-space(text()))">
            <p:pipe port="map" step="main"/>
        </p:input>
        <p:input port="stylesheet" select="doc(//wrapper-pipeline/package/resources/resource[prox-id='id-prox-fix']/url/normalize-space(text()))">
            <p:pipe port="map" step="main"/>
        </p:input>
        <p:with-param name="map-url" select="base-uri()">
            <p:pipe port="map" step="main"/>
        </p:with-param>
    </p:xslt>
    <p:identity name="id">
        <p:input port="source"/>
    </p:identity>
    
    <!-- Store ProX instance with URLs -->
    <p:store name="save-prox" cx:depends-on="id">
        <!--<p:with-option name="href" select="concat($tmp-url,'tmp-instance-prox-with-urls.xml')"/>-->
        <p:with-option name="href" select="'xmldb:exist:///db/work/docs/test/tmp-prox-instance.xml'"/>
    </p:store>
    
    <!-- Convert instance to XQ -->
    <p:xslt name="xsltbat" cx:depends-on="id">
        <p:input port="source">
            <p:pipe port="result" step="id"/>
        </p:input>
        <p:input port="stylesheet" select="doc(//wrapper-pipeline/package/resources/resource[prox-id='id-prox2xq']/url/normalize-space(text()))">
            <p:pipe port="map" step="main"/>
        </p:input>
        <p:with-param name="map-url" select="base-uri()">
            <p:pipe port="map" step="main"/>
        </p:with-param>
    </p:xslt>
    <p:store name="save-xq" cx:depends-on="xsltbat" media-type="text/plain" method="text"><!-- media-type="text/plain" method="text" -->
        <p:with-option name="href" select="'xmldb:exist:///db/work/docs/test/out.xq'"/>
    </p:store>
    
<!--    <p:xquery name="xq">
        <p:input port="source">
            <p:pipe port="result" step="xsltbat"/>
        </p:input>
        <p:input port="query">
            <!-\-<p:data href="http://localhost:8080/exist/rest/db/work/docs/test/test-xproc.xq" content-type="text/plain"/>-\->
            <p:inline>
                <c:query>
                    xquery version "1.0";
                    declare namespace xmldb = "http://exist-db.org/xquery/xmldb";
                    declare namespace sm = "http://exist-db.org/xquery/securitymanager";
                    let $login := xmldb:login("/db","admin","Favorit70")
                    let $path := "xmldb:exist:///db/work/docs/test/out.xq"
                    let $mode := "rwxr-xr-x"
                    let $xq := sm:chmod($path,$mode)
                    return 
                    <out>Success!</out>
                </c:query>
            </p:inline>
        </p:input>
    </p:xquery>-->
    <p:xquery name="xq">
        <p:input port="source">
            <p:pipe port="result" step="xsltbat"/>
        </p:input>
        <p:input port="query">
            <!-- Change permissions, group and owner -->
            <p:data href="http://localhost:8080/exist/rest/db/work/docs/xq/chown-test.xq" content-type="text/plain"/>
        </p:input>
    </p:xquery>
    <p:xquery name="run-xq">
        <p:input port="query">
            <!-- Run generated XQuery -->
            <p:data href="http://localhost:8080/exist/rest/db/work/docs/test/out.xq" content-type="text/plain"/>
        </p:input>
    </p:xquery>
    <!--<p:sink/>
    -->
    <!-- Return Results -->
    <p:identity name="med">
        <p:input port="source">
            <!--<p:pipe port="result" step="xq"/>-->
            <!--<p:inline>
                <p>Success!</p>
                
            </p:inline>-->
        </p:input>
    </p:identity>
</p:declare-step>