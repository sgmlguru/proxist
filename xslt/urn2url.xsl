<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns=""
    exclude-result-prefixes="xs xlink"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Mapping Document -->
    <xsl:param name="map-url"/>
    <xsl:param name="map" select="doc($map-url)"/>
    
    
    
    <!-- Root -->
    <xsl:template match="/*">
        <xsl:element name="{local-name(.)}">
            <!--<xsl:copy-of select="namespace::*"/>-->
            <xsl:copy-of select="attribute::*"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{local-name(.)}">
            <!--<xsl:copy-of select="namespace::*"/>-->
            <xsl:copy-of select="attribute::*"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- URL value based on URN -->
    <xsl:template name="add-ext-url">
        <xsl:param name="urn"/>
        <xsl:param name="fragment-id"/>
        <xsl:if test="starts-with($urn,'urn:')">
            <xsl:value-of select="concat(distinct-values($map//*[urn=$urn][1]/url),$fragment-id)"/>
            <!--<xsl:value-of select="concat($map//*[urn=$urn][1]/url,$fragment-id)"/>-->
        </xsl:if>
    </xsl:template>
    
    <!-- URN value based on URL -->
    <xsl:template name="add-ext-urn">
        <xsl:param name="url"/>
        <xsl:param name="fragment-id"/>
        <xsl:value-of select="concat($map//*[url=$url][1]/urn,'#')"/>
    </xsl:template>
    
    <!-- inset URN to URL in @xlink:href -->
    <xsl:template match="inset|block-inset">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:apply-templates select="attribute::*" mode="attr"/>
            <xsl:attribute name="xlink:href">
                <xsl:call-template name="add-ext-url">
                    <xsl:with-param name="urn" select="substring-before(./@xlink:href,'#')"/>
                    <xsl:with-param name="fragment-id" select="concat('#',substring-after(./@xlink:href,'#'))"/>
                </xsl:call-template>    
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- graphics URN to URL in @xlink:href -->
    <xsl:template match="graphics">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:apply-templates select="attribute::*" mode="attr"/>
            <xsl:attribute name="xlink:href">
                <xsl:call-template name="add-ext-url">
                    <xsl:with-param name="urn" select="./@xlink:href"/>
                    <xsl:with-param name="fragment-id" select="''"/>
                </xsl:call-template>    
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="attr">
        <xsl:attribute name="{name(.)}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- Module URN/URL handling -->
    <!--<xsl:template name="module-refs">
        <xsl:for-each select="$map//modules/resource[type='xml']">
<!-\-            <xsl:apply-templates select="doc(concat($targeturi,url))/*"/>-\->
            <!-\-<p>
                <xsl:value-of select="base-uri(doc(concat($targeturi,url))/*)"></xsl:value-of>
            </p>-\->
        </xsl:for-each>
    </xsl:template>-->
    
    
    
    
</xsl:stylesheet>