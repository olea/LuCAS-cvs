<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output omit-xml-declaration="yes" />

<xsl:template match="/clause">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<head><title>Estándar ECMA C#</title></head>
	<table width="100%" cellpadding="5">
		<tr bgcolor="#b0c4de"><td>
		<i>Especificación del lenguaje C#</i>

		<h3>
			<xsl:value-of select="@number"/>: <xsl:value-of select="@title"/>
			
			<xsl:if test="@informative">
				(informativo)
			</xsl:if>
		</h3>
		<a href="index.html">Indice</a>
		</td>
		</tr>
	</table>
	
	<xsl:apply-templates />
</html>
</xsl:template>

<xsl:template match="paragraph">
	<p>
		<xsl:apply-templates />
	</p>
</xsl:template>

<xsl:template match="hyperlink">
	<a href="{.}.html">
		<xsl:value-of select="." />
	</a>
</xsl:template>

<xsl:template match="list">
	<ul>
		<xsl:for-each select="list_item|list">
			<li><xsl:apply-templates /></li>
		</xsl:for-each>
	</ul>
</xsl:template>

<xsl:template match="table_line">
	<ul><li>
	<xsl:apply-templates/>
	</li></ul>
</xsl:template>

<xsl:template match="code_example">
  <table bgcolor="#f5f5dd" border="1" cellpadding="5">
	<tr>
	  <td>
	    <pre>
		  <xsl:apply-templates />
	    </pre>
	  </td>
	</tr>
  </table>
</xsl:template>

<xsl:template match="symbol">
	<code>
		<xsl:apply-templates />
	</code>
</xsl:template>

<xsl:template match="grammar_production">
	<dl id="nt_{name/non_terminal/.}">
		<dt><xsl:value-of select="name/non_terminal/." /></dt>
		
		<xsl:for-each select="rhs">
		<dd>
			<xsl:apply-templates select="node()" />
		</dd>
		</xsl:for-each>
	</dl>
</xsl:template>

<xsl:template match="non_terminal">

	<code><xsl:text> </xsl:text><xsl:value-of select="." /></code>
</xsl:template>

<xsl:template match="terminal">
	<code><xsl:text> </xsl:text><xsl:value-of select="." /></code>
</xsl:template>

<xsl:template match="opt">
	<sub>opt</sub>
</xsl:template>

<xsl:template match="toc">
<html>
	<table width="100%" cellpadding="5">
		<tr bgcolor="#b0c4de"><td>
		<i>Traducción de la  <a href="http://www.ecma-international.org/publications/standards/Ecma-334.htm">Especificación del lenguaje C#</a> en colaboración con el proyecto <a href="http://es.tldp.org">TLDP-ES</a> y <a href="http://monohispano.org">Monohispano</a></i>
		<h3>Especificación del lenguaje C#</h3>
		</td></tr>
	</table>

	<ul>
		<xsl:for-each select="node">
			<li><a href="{@number}.html">
			<xsl:value-of select="@number"/>: <xsl:value-of select="@name"/>
			</a></li>
			<ul><xsl:for-each select="node">
				<xsl:variable name="number"/>	
				<li><a href="{@number}.html">	
				<xsl:value-of select="@number"/>: <xsl:value-of select="@name"/>
				</a></li>
					<ul><xsl:for-each select="node">
					<xsl:variable name="number"/>	
					<li><a href="{@number}.html">	
					<xsl:value-of select="@number"/>: <xsl:value-of select="@name"/>
					</a></li>
					<xsl:apply-templates/>
					</xsl:for-each></ul>
				<xsl:apply-templates />
			</xsl:for-each></ul>
			<xsl:apply-templates/>
		</xsl:for-each>
	</ul>
</html>
</xsl:template>

</xsl:stylesheet>
