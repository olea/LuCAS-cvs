<?xml version="1.0" encoding="utf-8"?>
<!-- mn2db.xsl -->
<!-- a sample xsl transform to turn Monodoc into DocBook format -->
<!-- phobeo at ieee dot org -->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

<xsl:output method="xml"/>

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="clause">
	<xsl:variable name="clause_number"><xsl:value-of select="@number"/></xsl:variable>
	<chapter id="cap{$clause_number}" lang='es' label="{$clause_number}">
	<title><xsl:value-of select="@title"/></title>
	<xsl:apply-templates/>
	</chapter>
</xsl:template>

<xsl:template match="paragraph">
	<para>
	<xsl:apply-templates/>
	</para>	
</xsl:template>

<xsl:template match="list">
	<itemizedlist>
	<xsl:apply-templates/>
	</itemizedlist>
</xsl:template>	

<xsl:template match="list_item">
	<listitem>
	<xsl:apply-templates/>
	</listitem>
</xsl:template>

<xsl:template match="term_definition">
	<emphasis>
	<xsl:apply-templates/>
	</emphasis>
</xsl:template>

<xsl:template match="hyperlink">
	<link>
	<xsl:apply-templates/>
	</link>
</xsl:template>

<xsl:template match="code_example">
	<programlisting>
	<xsl:apply-templates/>
	</programlisting>
</xsl:template>

<xsl:template match="non_terminal">
	<emphasis>
	<xsl:apply-templates/>
	</emphasis>
</xsl:template>

<xsl:template match="rhs">
	<listitem>
	<xsl:apply-templates/>
	</listitem>
</xsl:template>

<xsl:template match="grammar_production">
	<programlisting><itemizedlist>
	<xsl:apply-templates/>
	</itemizedlist></programlisting>
</xsl:template>

<xsl:template match="table_line">
	<itemizedlist><listitem><para>
	<xsl:apply-templates/>
	</para></listitem></itemizedlist>
</xsl:template>

</xsl:stylesheet>

