<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"
>
	<xsl:output method="html" encoding="UTF-8" indent="yes" />

	<xsl:template match="/traducciones">
<html>
	<head>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8" />
		<style>
			table {background-color:#F0F0F0;font-family:sans-serif}
		</style>
		<title>Distintas traducciones de no terminales</title>
	</head>
	<body>
		<table border="1px solid">
			<tr>
				<td><b>Atributo <i>where</i></b></td>
				<td><b>Textos originales</b></td>
				<td><b>Traducciones</b></td>
			</tr>
			<xsl:apply-templates select="non_terminal">
				<xsl:sort select="." />
			</xsl:apply-templates>
		</table>
	</body>
</html>
	</xsl:template>

	<xsl:template match="non_terminal">
		<tr>
			<td><xsl:value-of select="@where"/></td>
			<td>
				<xsl:for-each select="original">
					<xsl:sort/>
					<xsl:value-of select="."/><br/>
				</xsl:for-each>
			</td>
			<td>
				<xsl:for-each select="traduccion">
					<xsl:sort select="texto" />
					<xsl:value-of select="texto"/>
					( <xsl:for-each select="fichero">
						<xsl:value-of select="."/><xsl:text>
						</xsl:text>
					</xsl:for-each>)<br/>
				</xsl:for-each>
				<xsl:if test="not(traduccion)">&#160;</xsl:if>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
