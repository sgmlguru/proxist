<p:declare-step xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:p="http://www.w3.org/ns/xproc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:xf="http://www.w3.org/2002/xforms" name="main" version="1.0">
    
    
    <!-- Wrapper XProc for ProX
         Requires resource map file as an input. 
         The platform used must be set in the $os
         variable, below. -->
    
    <!-- Inputs -->
    
    <!-- Resource map XML -->
    <!-- Contains all URN/URL for XSLT, XPL, XML modules, targets, etc -->
    <p:input port="map" sequence="true">
        <!--<p:document href="http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml"/>-->
        <!-- Points to tmp output collection, generated resource map -->
    </p:input>
    
    <!-- Global XSLT params -->
    <!-- (Not needed for now) -->
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
    <p:variable name="tmp-url" select="'xmldb:exist:///db/work/tmp/'">
        <!-- substring-before(base-uri(/*),tokenize(base-uri(.),'/')[last()]) -->
        <!--<p:pipe port="map" step="main"/>-->
        <!-- Should use base URI of a target output (ensures writable collection) -->
    </p:variable>
    
    <!-- OS ('osx', 'win', 'linux', 'exist' allowed) -->
    <p:variable name="os" select="'exist'"/>
    
    
    
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
    
    <!-- ProX instance for debug -->
    <p:store name="save-prox" cx:depends-on="id">
        <p:with-option name="href" select="'xmldb:exist:///db/work/tmp/debug-prox-instance.xml'"/>
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
    
    
    <!-- Save generated child process XQ in tmp collection -->
    <!-- Should use $tmp-url -->
    <p:store name="save-xq" cx:depends-on="xsltbat" media-type="text/plain" method="text">
        <p:with-option name="href" select="concat($tmp-url,'out.xq')"/>
    </p:store>
    

    <!-- Change ownership, group, permissions of generated XQ -->
    <p:xquery name="xq">
        <p:input port="source">
            <p:pipe port="result" step="xsltbat"/>
        </p:input>
        <p:input port="query">
            <!-- Change permissions, group and owner -->
            <p:data href="http://localhost:8080/exist/rest/db/work/system/prox/xq/ch-mode.xq" content-type="text/plain"/>
        </p:input>
    </p:xquery>
    
    <!-- Run child process -->
    <p:xquery name="run-xq">
        <p:input port="query">
            <!-- Run generated XQuery -->
            <!-- Should use $tmp-url -->
            <p:data href="http://localhost:8080/exist/rest/db/work/tmp/out.xq" content-type="text/plain"/>
        </p:input>
    </p:xquery>
    
    <!-- Return Results -->
    <p:identity name="med">
        <p:input port="source"/>
    </p:identity>
    
    <!-- Output used to determine further processing in invoking XQuery (proxist/modules/save.xq) -->
</p:declare-step>