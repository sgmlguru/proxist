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
    <p:variable name="prox-blueprint" select="//prox/blueprints/resource[@id='id-prox-blueprint']/url/text()">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- ProX Instance URL -->
    <p:variable name="prox-instance" select="//prox/instances/resource[@id='id-prox-saved-instance']/url/text()">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- XForm URL -->
    <p:variable name="xform-url" select="//wrapper-pipeline//resource[prox-id='id-loc-xform']/url/text()">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- prox2shell config URL -->
    <p:variable name="prox2shell-config" select="//wrapper-pipeline//resource[prox-id='id-prox2shell-config']/url">
        <p:pipe port="map" step="main"/>
    </p:variable>
    
    <!-- Temp URL -->
    <p:variable name="tmp-url" select="'xmldb:exist:///db/work/docs/test/'">
        <!-- substring-before(base-uri(/*),tokenize(base-uri(.),'/')[last()]) -->
        <!--<p:pipe port="map" step="main"/>-->
    </p:variable>
    
    <!-- OS ('osx', 'win', 'linux' allowed) -->
    <p:variable name="os" select="'exist'"/>


    
    <!-- Open ProX Blueprint in Browser -->
    <!-- Opens with an XForms profile in order
         to start a separate browser instance -->
    <p:choose name="browse">
        <!-- Linux -->
        <p:when test="$os='linux'">
            <p:exec command="/usr/bin/iceweasel">
                <p:input port="source">
                    <p:empty/>
                </p:input>
                <p:with-option name="args" select="concat('-P &#34;XForms&#34; -no-remote ',$xform-url)"/>
            </p:exec>
            <p:sink/>
        </p:when>
        
        <!-- eXist -->
        <p:when test="$os='exist'">
            <p:exec command="/usr/bin/iceweasel">
                <p:input port="source">
                    <p:empty/>
                </p:input>
                <p:with-option name="args" select="concat('-P &#34;xforms&#34; -no-remote ','http://localhost:8080/exist/rest/db/apps/form.xq?form=prox-xform.xml')"/>
            </p:exec>
            <cx:wait-for-update href="http://localhost:8080/exist/webdav/db/work/docs/test/prox-instance.xml" pause-after="3"/>
            <p:sink/>
        </p:when>
    </p:choose>
    
    
    
    <!-- Update ProX Instance -->
    <!-- Runtime values inserted from resource map. -->
    <p:xslt name="prox-urn2url" cx:depends-on="browse">
        <!--<p:input port="source" select="doc(//prox/instances/resource[@id='id-prox-saved-instance']/url/text())">
            <p:pipe port="map" step="main"/>
        </p:input>-->
        <p:input port="source">
            <p:document href="http://localhost:8080/exist/rest/db/work/docs/test/prox-instance.xml"/>
        </p:input>
        <!--<p:input port="stylesheet" select="doc(//wrapper-pipeline/package/resources/resource[prox-id='id-prox-fix']/url/text())">
            <p:pipe port="map" step="main"/>
        </p:input>-->
        <p:input port="stylesheet">
            <p:document href="http://localhost:8080/exist/rest/db/work/system/prox/xslt/prox-fix.xsl"/>
        </p:input>
        <!--<p:with-param name="map-url" select="base-uri()">
            <p:pipe port="map" step="main"/>
        </p:with-param>-->
        <p:input port="parameters">
            <p:pipe port="xsltparams" step="main"/>
        </p:input>
    </p:xslt>
    
    <p:identity name="id">
        <p:input port="source">
            <!--<p:document href="http://localhost:8080/exist/rest/db/work/docs/test/prox-instance.xml"/>-->
            <!--<p:inline>
                <p>Hello world</p>
            </p:inline>-->
        </p:input>
    </p:identity>
    
    <p:store name="save-prox">
        <p:with-option name="href" select="concat($tmp-url,'tmp-instance-prox-with-urls.xml')"/>
    </p:store>
    
    

    <!-- Add ProX instance validation here? -->
    
    
    
    <!-- Return Results -->
    <p:identity name="med">
        <!--<p:input port="source" select="//wrapper-pipeline/package/resources/resource[prox-id='id-wrapper-xpl']/url">
            <p:pipe port="map" step="main"/>
        </p:input>-->
        <p:input port="source">
            <p:pipe port="result" step="id"/>
        </p:input>
    </p:identity>
</p:declare-step>