<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">

    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space 
        elements="cmdline script engine-config inputs options params"/>
<!--    <xsl:strip-space elements="*"/>-->
    <!--<xsl:preserve-space elements="cmdline"/>-->
    
    <xsl:param 
        name="map-url"/>
    <!-- select="'file:/home/ari/mystuff/SGML/DTD/Process-XML/XSLT/resource-map-prox-blueprint-demo-cassis-nu.xml'" -->
    
    <xsl:param 
        name="os"/>
    
    <xsl:param 
        name="prox2shell-config"/>

    <xsl:param 
        name="debug" 
        select="'yes'"/>
    
    <xsl:template match="/">
        <bat>
            <xsl:choose>
                <xsl:when test="$os='win'">
                    <xsl:text>REM Generated for Windows</xsl:text>
                    <xsl:text>&#x0A;</xsl:text>
                </xsl:when>
                <xsl:when test="$os='osx'">
                    <xsl:value-of
                        select="document('prox-xslt2bat-configuration.xml')/config/calabash/shell[@os='osx']/text()"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:text># Generated for OS X</xsl:text>
                    <xsl:text>&#x0A;</xsl:text>
                </xsl:when>
                <xsl:when test="$os='linux'">
                    <xsl:value-of
                        select="document('prox-xslt2bat-configuration.xml')/config/calabash/shell[@os='linux']/text()"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:text># Generated for Linux</xsl:text>
                    <xsl:text>&#x0A;</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>    
        </bat>
    </xsl:template>

    <xsl:template match="processes">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="process">
        <xsl:apply-templates select=".//metadata"/>
        <xsl:text>java -classpath </xsl:text>
        <!--<xsl:choose>
            <xsl:when test="$os='win'">
                <xsl:value-of
                    select="document('prox2shell-config.xml')/config/calabash/classpath[@os='win']/text()"/>        
            </xsl:when>
            <xsl:when test="$os='osx'">
                <xsl:value-of
                    select="document('prox2shell-config.xml')/config/calabash/classpath[@os='osx']/text()"/>
            </xsl:when>
            <xsl:when test="$os='linux'">
                <xsl:value-of
                    select="document('prox2shell-config.xml')/config/calabash/classpath[@os='linux']/text()"/>
            </xsl:when>
        </xsl:choose>-->
        
        <xsl:choose>
            <xsl:when test="$os='win'">
                <xsl:value-of
                    select="document($prox2shell-config)/config/calabash/classpath[@os='win']/text()"/>        
            </xsl:when>
            <xsl:when test="$os='osx'">
                <xsl:value-of
                    select="document($prox2shell-config)/config/calabash/classpath[@os='osx']/text()"/>
            </xsl:when>
            <xsl:when test="$os='linux'">
                <xsl:value-of
                    select="document($prox2shell-config)/config/calabash/classpath[@os='linux']/text()"/>
            </xsl:when>
        </xsl:choose>
        
        <!--        <xsl:text>java -classpath "C:\xmlcalabash-1.0.3-94\calabash.jar;C:\xmlcalabash-1.0.3-94\lib\saxon9he.jar;C:\xmlcalabash-1.0.3-94\lib\commons-logging-1.1.1.jar;C:\xmlcalabash-1.0.3-94\lib\commons-httpclient-3.1.jar;C:\xmlcalabash-1.0.3-94\lib\commons-codec-1.6.jar;C:\xmlcalabash-1.0.3-94\lib\commons-io-1.3.1.jar;C:\XEP\lib\xep.jar;C:\XEP\lib\xt.jar;C:\lib\jing.jar"</xsl:text>-->
        <xsl:text> com.xmlcalabash.drivers.Main </xsl:text>
        <xsl:apply-templates select="pipelines/pipeline"/>

        <!-- Debug mode -->
        <xsl:if test="$debug='yes'">
            <xsl:choose>
                <xsl:when test="$os='osx' or $os='linux'">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:text>read -p "Press [Enter] to continue..."</xsl:text>
                </xsl:when>
                <xsl:when test="$os='win'">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:text>pause</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="pipeline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <xsl:apply-templates select="cmdlines/cmdline"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="script"/>
    </xsl:template>

    <xsl:template match="script">
        <!-- @xlink:href refers to package -->
        <xsl:choose>
            <xsl:when test="@type='pkg'">
                <xsl:call-template name="fragment-id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="cmdline">
        <!--        <xsl:apply-templates select="metadata"/>-->
        <xsl:apply-templates select="engine-config"/>
        <xsl:apply-templates select="inputs"/>
        <xsl:apply-templates select="outputs"/>
        <xsl:apply-templates select="options"/>
        <xsl:apply-templates select="params"/>
    </xsl:template>

    <!-- XProc Engine-specific Configuration -->

    <xsl:template match="enginge-config">
        <xsl:apply-templates select="config"/>
    </xsl:template>

    <xsl:template match="config">
        <xsl:text>--config</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:call-template name="fragment-id"/>
        <xsl:text> </xsl:text>
    </xsl:template>



    <!-- Inputs -->

    <xsl:template match="inputs">
        <xsl:apply-templates select="input"/>
    </xsl:template>

    <xsl:template match="input">
        <xsl:choose>
            <xsl:when test="matches(port,'map')">
                <!-- Standard input for map URL -->
                <xsl:text>--input map=</xsl:text>
                <xsl:value-of select="$map-url"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>--input </xsl:text>
                <xsl:value-of select="port"/>
                <xsl:text>=</xsl:text>
                <xsl:apply-templates select="value"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="params"/>        
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- Options -->

    <xsl:template match="options">
        <xsl:apply-templates select="option"/>
    </xsl:template>

    <xsl:template match="option">
        <xsl:value-of select="name"/>
        <xsl:text>=</xsl:text>
        <xsl:apply-templates select="value"/>
        <xsl:text> </xsl:text>
    </xsl:template>



    <!-- Parameters for XSLT -->

    <xsl:template match="params">
        <xsl:apply-templates select="param"/>
    </xsl:template>

    <xsl:template match="param">
        <xsl:text>--with-param </xsl:text>
        <xsl:value-of select="port"/>
        <xsl:text>@</xsl:text>
        <xsl:value-of select="name"/>
        <xsl:text>=</xsl:text>
        <xsl:apply-templates select="value"/>
        <xsl:text> </xsl:text>
    </xsl:template>

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
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title">
        <xsl:text>echo </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="description">
        <xsl:apply-templates select="p"/>
    </xsl:template>

    <xsl:template match="p">
        <xsl:text>echo </xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    
</xsl:stylesheet>
