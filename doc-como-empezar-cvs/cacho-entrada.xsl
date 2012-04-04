<?xml version="1.0"?>
<!-- $Id:$
Esto genera un cacho html con el registro de cada documento.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="PDF">Ruta a la versión PDF</xsl:param>
	<xsl:param name="ORIGINAL">Ruta al módulo CVS</xsl:param>
	<xsl:param name="DOCUMENTO-HTML">Ruta a la versión HTML</xsl:param>

<xsl:template match="resource">  
	<div class="entrada">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="$DOCUMENTO-HTML"/></xsl:attribute>
			<xsl:attribute name="class">titulo</xsl:attribute>
			<xsl:value-of select="title"/>
		</xsl:element>
		<span class="autor">
			<xsl:value-of select="creator/person/firstname"/> 	 
			<xsl:text> </xsl:text>
			<xsl:value-of select="creator/person/surname"/> 
		</span>
		<div class="enlaces">
			[<xsl:element name="a">
			    <xsl:attribute name="href"><xsl:value-of select="$PDF"/></xsl:attribute>PDF</xsl:element>]
			[<xsl:element name="a"><xsl:attribute name="href">http://cvs.hispalinux.es/cgi-bin/cvsweb/<xsl:value-of select="$ORIGINAL"/></xsl:attribute>Original
	                 </xsl:element>]
		</div>
		<div class="descripcion">
			<xsl:value-of select="description"/> 
		</div>
		      
	</div>
</xsl:template>
</xsl:stylesheet>
