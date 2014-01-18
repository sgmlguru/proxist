<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:strip-space elements="cmdline script engine-config inputs options params"/>
    
    <xsl:param name="map-url"/><!--  select="'http://localhost:8080/exist/rest/db/work/system/common/xml/resource-map.xml'" -->
    
    <xsl:param name="os" select="'exist'"/>
    
    <xsl:param name="prox2shell-config"/>
    
    <xsl:param name="debug" select="'no'"/>
    
    
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="processes"/>
    </xsl:template>
    
    <xsl:template match="processes">
        <c:query>
            <xsl:text>xquery version "1.0";</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>(: ProXist child process</xsl:text>
            <xsl:text> :)</xsl:text>
            <xsl:apply-templates/>
        </c:query>
    </xsl:template>
    
    <xsl:template match="process">
        <!-- Metadata comment here -->
        <!--<xsl:apply-templates select=".//metadata"/>-->
        <xsl:text>&#xa;(: </xsl:text>
        <xsl:value-of select="metadata//title"/>
        <xsl:text> :)&#xa;</xsl:text>
        <xsl:apply-templates select="pipelines/pipeline"/>

        <!-- Debug mode -->
        <xsl:if test="$debug='yes'">
            <xsl:choose>
                <xsl:when test="$os='osx' or $os='linux'">
                    <xsl:text></xsl:text>
                    <xsl:text>read -p "Press [Enter] to continue..."</xsl:text>
                </xsl:when>
                <xsl:when test="$os='win'">
                    <xsl:text></xsl:text>
                    <xsl:text>pause</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="pipeline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <xsl:apply-templates select="script"/>
        <xsl:apply-templates select="cmdlines/cmdline"/>
    </xsl:template>
    
    <!-- The actual pipeline -->
    <xsl:template match="script">
        <!-- @xlink:href refers to package -->
        <xsl:text>let $result := xmlcalabash:process("</xsl:text>
        <xsl:choose>
            <xsl:when test="@type='pkg'">
                <xsl:call-template name="fragment-id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>",&#xa;</xsl:text>
    </xsl:template>
    
    
    
    <!-- Bindings and Options -->
    
    <xsl:template match="cmdline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <!--<xsl:apply-templates select="engine-config"/>-->

        <!-- Inputs, outputs grouped together -->
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="inputs"/>
        <xsl:apply-templates select="params"/>
        <xsl:apply-templates select="outputs"/>
        <xsl:text>),</xsl:text>

        <!-- Options grouped together -->
        <xsl:text>&#xa;(</xsl:text>
        <xsl:apply-templates select="options"/>
        <xsl:text>)</xsl:text>
        <!-- End of funct call -->
        <xsl:text>)&#xa;</xsl:text>
        <xsl:text>return&#xa;</xsl:text>
        <xsl:text>  $result</xsl:text>
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
                <xsl:text>"-imap=</xsl:text>
                <xsl:value-of select="$map-url"/>
                <xsl:text>"</xsl:text>
                <xsl:if test="following-sibling::*">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>&#xa;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"-i</xsl:text>
                <xsl:value-of select="port"/>
                <xsl:text>=</xsl:text>
                <xsl:apply-templates select="value"/>
                <xsl:text>"</xsl:text>
                <xsl:if test="following-sibling::*">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>&#xa;</xsl:text>
                <xsl:apply-templates select="params"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- Parameters for XSLT -->
    
    <xsl:template match="params">
        <xsl:apply-templates select="param"/>
    </xsl:template>
    
    <xsl:template match="param">
        <xsl:text>"-p</xsl:text>
        <xsl:value-of select="port"/>
        <xsl:text>@</xsl:text>
        <xsl:value-of select="name"/>
        <xsl:text>=</xsl:text>
        <xsl:apply-templates select="value"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="following-sibling::* or following::input[port and value]">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>



    <!-- Options -->
    <xsl:template match="options">
        <xsl:apply-templates select="option"/>
    </xsl:template>
    
    <xsl:template match="option">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="name"/>
        <xsl:text>=</xsl:text>
        <xsl:apply-templates select="value"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="following-sibling::*">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>



    <!-- Values -->
    <xsl:template match="value">
        <xsl:choose>
            <xsl:when test="@type='pkg'">
                <xsl:call-template name="fragment-id"/>
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
        <xsl:variable name="href" select="./@xlink:href"/>
        <xsl:choose>
            <xsl:when test="contains(@xlink:href,'#')">
                <xsl:value-of
                    select="//package[@id=substring-after($href,'#')]/locator[@type='main']/@xlink:href"/>
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
        <xsl:text> :)&#xa;</xsl:text>
    </xsl:template>
    
    <!--<xsl:template match="description">
        <xsl:apply-templates select="p"/>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:text>(: </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text> :)&#xa;</xsl:text>
    </xsl:template>-->
    
</xsl:stylesheet>
