<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    exclude-result-prefixes="#all" 
    version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:strip-space elements="cmdline script engine-config inputs options params"/>
    
    <!-- This XSLT converts a ProX instance XML to a child process XQuery.
         The instance is the result of the ProX XForm after config and save,
         and invoked by the wrapper XProc script that is part of save.xq. -->
    
    
    <xsl:param name="map-url"/><!--  select="'http://localhost:8080/exist/rest/db/work/tmp/resource-map.xml'" -->
    
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="processes"/>
    </xsl:template>
    
    <xsl:template match="processes">
        <c:query>
            <xsl:text>xquery version "1.0";
</xsl:text>
            <xsl:text>import module namespace xproc="http://exist-db.org/xproc";
</xsl:text>
            <xsl:text>(: ProXist child process</xsl:text>
            <xsl:text> :)</xsl:text>
            <xsl:apply-templates/>
        </c:query>
    </xsl:template>
    
    <xsl:template match="process">
        <!-- Metadata comment here -->
        <!--<xsl:apply-templates select=".//metadata"/>-->
        <xsl:text>
(: </xsl:text>
        <xsl:value-of select="metadata//title"/>
        <xsl:text> :)
</xsl:text>
        
        <xsl:apply-templates select="pipelines/pipeline"/>
        
    </xsl:template>
    
    <xsl:template match="pipeline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <xsl:apply-templates select="cmdlines/cmdline"/>
        <xsl:apply-templates select="script"/>
    </xsl:template>
    
    <!-- The actual pipeline -->
    <xsl:template match="script">
        <!-- @xlink:href refers to package -->
        <xsl:text>let $result := xproc:process("</xsl:text>
        <xsl:choose>
            <xsl:when test="@type='pkg'">
                <xsl:call-template name="fragment-id">
                    <xsl:with-param name="href" select="@xlink:href"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>",$opts)</xsl:text>
        <xsl:text>
</xsl:text>
        <xsl:text>return
</xsl:text>
        <xsl:text>  $result</xsl:text>
    </xsl:template>
    
    
    
    <!-- Bindings and Options -->
    <xsl:template match="cmdline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <!--<xsl:apply-templates select="engine-config"/>-->
        
        <!-- Inputs, outputs grouped together -->
        <xsl:text>let $opts := (</xsl:text>
        <xsl:apply-templates select="inputs|outputs|options|params"/>
        <!-- End of opts -->
        <xsl:text>)
</xsl:text>
        
    </xsl:template>
    
    
    
    <!-- XProc Engine-specific Configuration -->
    <!--    <xsl:template match="enginge-config">
        <xsl:apply-templates select="config"/>
    </xsl:template>
    
    <xsl:template match="config">
        <xsl:text>-\-config</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:call-template name="fragment-id"/>
        <xsl:text> </xsl:text>
    </xsl:template>-->
    
    
    
    <!-- Inputs -->
    <xsl:template match="inputs">
        <xsl:apply-templates select="input"/>
    </xsl:template>
    
    <xsl:template match="input">
        <xsl:choose>
            <xsl:when test="matches(port,'map')">
                <!-- Standard input for map URL -->
                <input>
                    <xsl:attribute name="type">xml</xsl:attribute>
                    <xsl:attribute name="port">map</xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$map-url"/>
                    </xsl:attribute>
                </input>
                <xsl:if test="following::input|following::output|following::option|following::param">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>
</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                
                <input>
                    <xsl:attribute name="type">xml</xsl:attribute>
                    <xsl:attribute name="port">
                        <xsl:value-of select="port"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:apply-templates select="value"/>
                    </xsl:attribute>
                </input>
                
                <xsl:if test="following::input|following::output|following::option|following::param">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                
                <xsl:text>
</xsl:text>
                <xsl:apply-templates select="params"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <!-- Parameters for XSLT -->
    <xsl:template match="params">
        <!--<xsl:apply-templates select="param"/>-->
    </xsl:template>
    
    <xsl:template match="param">
        <!--<xsl:text>"-p</xsl:text>
        <xsl:value-of select="port"/>
        <xsl:text>@</xsl:text>
        <xsl:value-of select="name"/>
        <xsl:text>=</xsl:text>
        <xsl:apply-templates select="value"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="following-sibling::* or following::input[port and value]">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>
</xsl:text>-->
    </xsl:template>
    
    
    
    <!-- Outputs -->
    <xsl:template match="outputs">
        <xsl:apply-templates select="output"/>
    </xsl:template>
    
    <xsl:template match="output">
        <output>
            <xsl:attribute name="port">
                <xsl:value-of select="port"/>
            </xsl:attribute>
            <xsl:attribute name="value">
                <xsl:apply-templates select="value"/>
            </xsl:attribute>
        </output>
        <xsl:if test="following::input|following::output|following::option|following::param">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    
    
    <!-- Options -->
    <xsl:template match="options">
        <xsl:apply-templates select="option"/>
    </xsl:template>
    
    <xsl:template match="option">
        
        <option>
            <xsl:attribute name="name">
                <xsl:value-of select="name"/>
            </xsl:attribute>
            <xsl:attribute name="value">
                <xsl:apply-templates select="value"/>
            </xsl:attribute>
        </option>
        
        <xsl:if test="following::input|following::output|following::option|following::param">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    
    
    <!-- Values -->
    <xsl:template match="value">
        <xsl:choose>
            <xsl:when test="@type='pkg'">
                <xsl:text></xsl:text>
                <xsl:call-template name="fragment-id">
                    <xsl:with-param name="href" select="@xlink:href"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@type='external'">
                <!-- "ti" previously -->
                <!-- External value -->
                <xsl:value-of select="." exclude-result-prefixes="#all"/>
            </xsl:when>
            <xsl:when test="@type='uri'">
                <!-- Single-resource URI -->
                <xsl:value-of select="."/>
            </xsl:when>
            <!-- Fallback: single file assumed -->
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="fragment-id">
        <xsl:param name="href"/>
        <xsl:choose>
            <xsl:when test="contains($href,'#')">
                <xsl:value-of select="//package[@id=substring-after($href,'#')]/locator[@type='main']/@xlink:href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//package[@id=$href]/locator[@type='main']/@xlink:href"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <!-- Metadata Handling -->
    <xsl:template match="metadata">
        <!--<xsl:apply-templates/>-->
    </xsl:template>
    
    <xsl:template match="title">
        <xsl:text>(: </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text> :)
</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>