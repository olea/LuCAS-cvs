<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                
<xsl:output method="xml" encoding="iso-8859-1"/>

<xsl:template match="/rss" name="rss">

	<xsl:text disable-output-escaping="yes">
        &lt;xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"&gt;
		&lt;!-- este es un documento autogenerado, para cambios sobre la plantilla acudir a news.xsl --&gt;
		&lt;xsl:template match="noticias"&gt;
		&lt;xsl:variable name="num_max" select="@num_max"/&gt;
	</xsl:text>

		<xsl:for-each select="//channel/item">
		<xsl:variable name="pos" select="position()"/>
			<xsl:text disable-output-escaping="yes">
				&lt;xsl:if test="</xsl:text> <xsl:value-of select="$pos"/> <xsl:text> &lt;= $num_max or $num_max=-1</xsl:text><xsl:text disable-output-escaping="yes">"&gt;
			</xsl:text>
			
				<xsl:variable name="url"><xsl:value-of select="link"/></xsl:variable>	
					<p>
							<b><a href="{$url}"><xsl:value-of select="title" disable-output-escaping="yes"/></a></b>:<br/>
							<xsl:value-of select="description"  disable-output-escaping="yes"/>
					</p>
					
			<xsl:text disable-output-escaping="yes">
				&lt;/xsl:if&gt;
			</xsl:text>
		</xsl:for-each>
		
	<xsl:text disable-output-escaping="yes">		
        &lt;/xsl:template&gt;
        &lt;/xsl:stylesheet&gt;
	</xsl:text>
	
</xsl:template>


</xsl:stylesheet>
