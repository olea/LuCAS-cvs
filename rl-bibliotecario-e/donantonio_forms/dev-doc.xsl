<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		  xmlns:rdf="http://www.w3.org/1999/XSL/rdf"
		  xmlns:xml="http://www.w3.org/1999/XSL/xml">

<xsl:output method="xml"/>
		  
<xsl:template match="/">
	<Doc rdf:about="">
	  <xsl:apply-templates select="//author"/>
	  <xsl:apply-templates select="//bookinfo/title"/>
	</Doc>
</xsl:template>

<xsl:template match="bookinfo">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="authorgroup">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author">
       <author rdf:resource="">
       <firstname><xsl:value-of select="firstname"/></firstname>
       <surname><xsl:value-of select="surname"/></surname>
       <address><xsl:value-of select="address"/></address>   
       </author>
</xsl:template>

<xsl:template match="title">
    <xsl:variable name="lang"><xsl:value-of select="//@lang"/></xsl:variable>
    <docTitle xml:lang="{$lang}">
       <xsl:value-of select="."/>
    </docTitle>
</xsl:template>

<xsl:template match="*">
</xsl:template>

</xsl:stylesheet>
