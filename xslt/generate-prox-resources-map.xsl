<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs xlink"
    version="2.0">
    
    <!-- Uses a ProX document as input -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/*">
        <resource-map>
            
            <!-- Runtime docs -->
            <docs>
                <doc>
                    <xsl:call-template name="root"/>
                </doc>
            </docs>
            
            <targets>
                <xsl:call-template name="target"/>
            </targets>
            
            <prox-resources>
                <xsl:apply-templates select=".//package[not(@id='id-wrapper-resources')]"/>
            </prox-resources>
            
            <!-- Fixed values for the wrapper -->
            <xsl:call-template name="wrapper-resources"/>
            <!--<wrapper-pipeline>
                <resource>
                    <urn>URN-XSLT2BAT<!-\- XSLT for ProX to bat conversion -\-></urn>
                    <url>file://home/ari/mystuff/SGML/DTD/Process-XML/XSLT/process2bat.xsl</url>
                    <name>xslt2bat</name>
                </resource>
                <resource>
                    <urn>URN-CONFIG-XML-XSLT2BAT<!-\- XML file with CLASSPATH -\-></urn>
                    <url>file://home/ari/mystuff/SGML/DTD/Process-XML/XSLT/prox-xslt2bat-configuration.xml</url>
                    <name>xslt2bat-config</name>
                </resource>
                <resource>
                    <urn>URN-WRAPPER-XPROC<!-\- XProc Wrapper Pipeline -\-></urn>
                    <url>file://home/ari/mystuff/SGML/DTD/Process-XML/XSLT/prox-wrap.xpl</url>
                    <name>wrapper-xpl</name>
                </resource>
            </wrapper-pipeline>-->
        </resource-map>
    </xsl:template>
    
    <xsl:template name="root">
        <root>
            <resource>
                <urn><!-- Generated target URN --></urn>
                <url><!-- Generated temp URL incl filename --></url>
                <type>doc-root</type>
                <prox-id>
                    <xsl:value-of select="//*[@value='external'][@input-type='doc-root']/@id"/>
                </prox-id>
            </resource>
        </root>
    </xsl:template>
    
    <xsl:template name="target">
        <xsl:for-each select=".//value[@type='external'][@output-type='primary']">
            <resource>
                <urn><!-- Generated URN --></urn>
                <url><!-- Generated URL, incl filename --></url>
                <type>primary</type>
                <prox-id>
                    <xsl:value-of select="@id"/>
                </prox-id>
            </resource>
        </xsl:for-each>
        <xsl:for-each select=".//value[@type='external'][@output-type='secondary']">
            <resource>
                <urn><!-- Generated URN --></urn>
                <url><!-- Generated URL, incl filename --></url>
                <type>primary</type>
                <prox-id>
                    <xsl:value-of select="@id"/>
                </prox-id>
            </resource>
        </xsl:for-each>
        <xsl:for-each select=".//value[@type='external'][@output-type='log']">
            <resource>
                <urn><!-- Generated URN --></urn>
                <url><!-- Generated URL, incl filename --></url>
                <type>log</type>
                <prox-id>
                    <xsl:value-of select="@id"/>
                </prox-id>
            </resource>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="prox">
        <!-- ProX blueprint and saved instance(s) -->
        <prox>
            <!-- Blueprint used to get instance is here -->
            <xsl:comment>Enter ProX Blueprint URN and URL here</xsl:comment>
            <blueprints>
                <resource id="id-prox-blueprint">
                    <urn><!--URN-OF-PROX-BLUEPRINT--></urn>
                    <url><!--file:/home/ari/mystuff/SGML/DTD/Process-XML/XSLT/processes-normalized-cosml-demo-nu.xml--></url>
                    <name></name>
                </resource>    
            </blueprints>
            
            <!-- Saved instance to run with wrapper is here -->
            <!-- All these are associated with .config files -->
            <!-- Input to wrapper pipeline -->
            <xsl:comment>Enter name of saved ProX instance here</xsl:comment>
            <instances>
                <resource id="id-prox-saved-instance">
                    <urn><!--URN-OF-SAVED-PROX-INSTANCE--></urn>
                    <url><!--file:///e:/SGML/DTD/Process-XML/XSLT/prox-instance.xml--></url>
                    <name></name>
                </resource>
            </instances>
        </prox>
    </xsl:template>
    
    <xsl:template name="wrapper-resources">
        <wrapper-pipeline>
            <xsl:apply-templates select="/processes/packages/package[@id='id-wrapper-resources']"/>
        </wrapper-pipeline>
    </xsl:template>
    
    <xsl:template match="package">
        <package>
            <name>
                <xsl:value-of select="metadata/title"/>
            </name>
            <resources>
                <xsl:apply-templates select=".//locator"/>
            </resources>
        </package>
    </xsl:template>
    
    <xsl:template match="locator">
        <resource>
            <urn>
                <xsl:value-of select="@xlink:href"/>
            </urn>
            <url>
                <!-- tmp url here -->
            </url>
            <prox-id>
                <xsl:value-of select="@id"/>
            </prox-id>
        </resource>
    </xsl:template>
    
    
</xsl:stylesheet>