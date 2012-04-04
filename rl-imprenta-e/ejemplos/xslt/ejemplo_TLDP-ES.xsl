<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="ISO-8859-1" doctype-public="-//W3C//DTD
	      HTML 4.0 Transitional//EN" />
	
	<xsl:template match="index_doc">
		<html lang="es">
			<head>
				<title>
	  				<xsl:text>Ejemplo TLDP-ES de resultados producidos por la imprenta-e - </xsl:text>
					<xsl:value-of select="title"/>
				</title>
			</head>
      		<body bgcolor="#ffffff" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0">
				<br/><br/><br/><br/><br/>
				<table align="center" border="1" cellpadding="0" cellspacing="0" width="50%">
					<tr>
						<td bgcolor="#fff2c5" align="center">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:value-of select="destino"/>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
      							</xsl:attribute>
								<h1><xsl:value-of select="title"/></h1>
    						</xsl:element>	
						</td>
					</tr>
				</table>
				<br/><br/>
				<table bgcolor="#fff2c5" align="center" border="1" cellpadding="0" cellspacing="0" width="50%">
					<tr>
						<td align="left">
							<h3><xsl:text>Autor</xsl:text></h3>
						</td>
						<td align="center">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:text>mailto:</xsl:text>
									<xsl:value-of select="email"/>
      							</xsl:attribute>
								<xsl:value-of select="author"/>	
    						</xsl:element>	
						</td>						
					</tr>
					<tr>
						<td align="left">
							<h3><xsl:text>Ultima versión</xsl:text></h3>
						</td>
						<td align="center">
							<xsl:value-of select="version"/>
						</td>						
					</tr>
					<tr>
						<td align="left">
							<h3><xsl:text>Fecha de la última versión</xsl:text></h3>
						</td>
						<td align="center">
							<xsl:value-of select="date"/>
						</td>						
					</tr>
					<tr>
						<td align="left">
							<h3><xsl:text>Tipo de documentación</xsl:text></h3>
						</td>
						<td align="center">
							<xsl:value-of select="type"/>
						</td>						
					</tr>
				</table>	
				<table bgcolor="#fff2c5" align="center" border="1" cellpadding="0" cellspacing="0" width="50%">
					<tr>
						<td align="center">
							<h3><xsl:text>Descripción</xsl:text></h3>
						</td>
					</tr>	
					<tr>
						<td align="left">
							<xsl:value-of select="description"/>
						</td>						
					</tr>
				</table>				
				<table bgcolor="#fff2c5" align="center" border="1" cellpadding="0" cellspacing="0" width="50%">
					<tr>
						<td align="center">
							<h3><xsl:text>Formatos</xsl:text></h3>
						</td>
					</tr>	
				</table>	
				<table bgcolor="#fff2c5" align="center" border="1" cellpadding="0" cellspacing="0" width="50%">
					<tr>
						<td align="center">
							<xsl:if test="formatos/@ps='si'">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:value-of select="destino"/>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="doc_name"/>
									<xsl:text>.ps</xsl:text>
      							</xsl:attribute>
								<xsl:text>PS</xsl:text>
    						</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tamaño/@ps"/>
							<xsl:text> Kb</xsl:text>
							</xsl:if>
						</td>						
						<td align="center">
							<xsl:if test="formatos/@pdf='si'">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:value-of select="destino"/>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="doc_name"/>
									<xsl:text>.pdf</xsl:text>
      							</xsl:attribute>
								<xsl:text>PDF</xsl:text>
    						</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tamaño/@pdf"/>
							<xsl:text> Kb</xsl:text>							
							</xsl:if>
						</td>						
						<td align="center">
							<xsl:if test="formatos/@htmltgz='si'">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:value-of select="destino"/>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="doc_name"/>
									<xsl:text>-html.tar.gz</xsl:text>
      							</xsl:attribute>
								<xsl:text>HTML Comprimido</xsl:text>
    						</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tamaño/@htmltgz"/>
							<xsl:text> Kb</xsl:text>							
							</xsl:if>
						</td>						
						<td align="center">
    						<xsl:element name="a">
      							<xsl:attribute name="href">
									<xsl:value-of select="destino"/>
									<xsl:value-of select="doc_name"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="dist_name"/>
									<xsl:text>.src.tar.gz</xsl:text>
      							</xsl:attribute>
								<xsl:text>SRC</xsl:text>
    						</xsl:element>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tamaño/@source"/>
							<xsl:text> Kb</xsl:text>							
						</td>
					</tr>						
				</table>
			</body>
		</html>
	</xsl:template>	
</xsl:stylesheet>
