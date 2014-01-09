<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns=""
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Mapping Document -->
    <xsl:param name="map-url"/>
    <xsl:param name="map" select="doc($map-url)"/>
    
    
    
    <!-- Root -->
    <xsl:template match="/*">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:copy-of select="attribute::*"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:copy-of select="attribute::*"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Runtime values in instance -->
    <xsl:template match="*[@type='external']">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:copy-of select="attribute::*"/>
            <xsl:call-template name="add-ext-url">
                <xsl:with-param name="id" select="./@id"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <!-- URL value based on @ID -->
    <xsl:template name="add-ext-url">
        <xsl:param name="id"/>
        <xsl:value-of select="$map//*[prox-id=$id]/url"/>
    </xsl:template>
    
    <!-- URN value based on @ID -->
    <xsl:template name="add-ext-urn">
        <xsl:param name="id"/>
        <xsl:value-of select="$map//*[prox-id=$id]/urn"/>
    </xsl:template>
    
    <!-- locator URN to URL in @xlink:href -->
    <xsl:template match="locator">
        <xsl:element name="{local-name(.)}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:apply-templates select="attribute::*" mode="attr"/>
            <xsl:attribute name="xlink:href">
                <xsl:call-template name="add-ext-url">
                    <xsl:with-param name="id" select="./@id"/>
                </xsl:call-template>    
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="attr">
        <xsl:attribute name="{name(.)}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>