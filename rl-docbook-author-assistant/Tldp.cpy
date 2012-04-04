# $Id: Tldp.cpy,v 1.8 2004/06/14 09:19:09 luismiguel.morillas Exp $	
# (c) Luis Miguel Morillas. 2003, 2004
# GPL
# Original idea of Stein Gjoen (see http://www.nyx.net/~sgjoen/The_LDP_HOWTO_Generator.html)
# and a proposal of Ismael Olea.
# The tool has been developped with Cherrypy plus pythonic tools
# to process xml+xslt
# The idea is to have a tool to generate Howto's in
# Docbook-xml
# First developper: Luis Miguel Morillas [luismiguel.morillas@hispalinux.es]
# If you have any suggestion tell us for improving the tool.
#

def onError():
	
    # Get the error in a string
    import traceback, cStringIO
    bodyFile=cStringIO.StringIO()
    traceback.print_exc(file=bodyFile)
    errorBody=bodyFile.getvalue()
	print errorBody
    bodyFile.close()
    # 
    # TODO Send an email with the error
    # See tutorial at http://www.cherrypy.org	
	#
    response.body="<html><body><br><br><center>"
    response.body+="Sorry, an error occured<br>"
    response.body+="An email has been sent to the webmaster"
    response.body+="</center></body></html>"


CherryClass Root:

from tldpDoc import Documento, Processor4Suite
from Ft.Xml import InputSource
from TldpData import *
#from itools.i18n import accept 
import gettext
from gettext import gettext as _
from xml.sax.saxutils import escape
import tempfile, os
from cStringIO import StringIO

variable:
	processorHtml = Processor4Suite()  #init xslt Processor, a customized Processor object
	processorXhtml = Processor4Suite('/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/xhtml/docbook.xsl')
	processorFo = Processor4Suite('/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/fo/docbook.xsl')
	language="en"
	

function:
	def dame(self, campo):
		""" Devuelve el valor del campo (si existe)
		"""
		return request.sessionMap.get(campo,"")
	
view:
	# -----------------------------------defs of navigation Bars ---------------------------
	def navBarX(self):
		model = """<div class="navhead">
			<table width="100%%" border="0" cellpadding="0" cellspacing="0" bgcolor="#606080" summary="Navigation">
			<tr>
            <td >%s</td>
			<td align="center" >%s</td>
			<td align="center" >%s</td>
			<td align="right" >%s</td>
			</tr>
			</table>
			</div>"""
		actualPage=request.sessionMap.get('actualPage', 0)
		prevText=_('Previous')
		if actualPage == 0:
			prev=prevText
		else:
			prev='<a href="previous">%s</a>' %  prevText
		nextText = _('Next')
		next=nextText
		
		clear=_('Clear Form')
		createXml=('Create docbook-xml')
		clearRef='''<input type="submit" value="%s" name="Clear" >''' % clear
		createXmlRef='''<input type="submit" value="%s" >'''  % createXml
		
		myValues = (prev, clearRef, createXmlRef , next)		
		print myValues
		return  model % myValues
	
	def navBar1(self):
		model = """<div class="navhead">
			<table width="100%%" border="0" cellpadding="0" cellspacing="0" bgcolor="#606080" summary="Navigation">
			<tr>
            <td >%s</td>
			<td >%s</td>
			<td align="right" >%s</td>
			</tr>
			</table>
			</div>"""
		clear=_('Clear Form')
		createXml=('Create docbook-xml')
		clearRef='''<input type="submit" tabindex="2" value="%s" name="Clear" >''' % clear
		createXmlRef='''<input type="submit" tabindex="1"  value="%s" name="toXml">'''  % createXml
		uploadRef='''<input type="submit" value="%s" name="upload" >''' % _('Upload docbook-xml file')
		
		myValues = (clearRef, createXmlRef, uploadRef)		
		return  model % myValues
	
	def navBar2(self):
		model = """<div class="navhead">
			<table width="100%%" border="0" cellpadding="0" cellspacing="0" bgcolor="#606080" summary="Navigation">
			<tr>
            <td >%s</td>
			<td >%s</td>
			<td >%s</td>
			<td align="right" >%s</td>
			</tr>
			</table>
			</div>"""
		cont='''<input type="button" value="%s" name="continue" onClick="history.go(-1)">''' % _('Continue editing')
		createHtml='''<input type="submit" value="%s" name="toHtml" >''' % _('Create Html')
		createXhtml='''<input type="submit" value="%s" name="toXhtml" >''' % _('Create Xhtml')
		createPdf='''<input type="submit" value="%s" name="toPdf" >''' % _('Create Pdf')
		myValues = (cont, createHtml, createXhtml, createPdf)		
		return  model % myValues
	
	
	def index(self):
		newPage=self.modelPage(self.cuerpo(), self.navBar1())
		return newPage
		
	# ---------------------- model of pages --------------------
	def modelPage(self, myBody="", navBar=""):
		actualPage=request.sessionMap.get('actualPage', 0) # don't use
					
		doc = """<html><head><title>%s</title></head><body>""" % (_("Docbook Author Assistant"))
		form="""<FORM NAME="theLinuxDocform" action="creaDoc" method="POST"> """
		endForm="""</FORM>"""
		return doc + self.mainHeader(self.language)+ '<br/>'+ form+ navBar+'<br/>' +myBody + '<br/>'+ navBar+'<br/>'+endForm+self.footer()
		#end modelPage
		
	def mainHeader(self,lang):
		""" i18n function. change the base language with itools
		
		"""
		formato="""<div class="header">
		<center>
		<h1>%s</h1>
		%s&nbsp;&nbsp;
		%s&nbsp;&nbsp;
		%s
		</center>
		"""
		#valores
				
		titulo=_("The Linux Documentation Project HOWTO Generator")
		about=_('About')
		
		aboutRef='<a href="about">%s</a>' % about
		return formato % (titulo, 'Español', 'English', aboutRef)
		
	def footer(self):
		pie = """
		<div class="footer">
		<center>
		<a href="http://www.python.org"><img src="%s" border=0></a>&nbsp;&nbsp
		<a href="http://www.cherrypy.org"><img src="%s" border=0></a>&nbsp&nbsp
		<a href="http://www.4suite.org"><img src="%s" border=0></a>
		</center>
		</div>""" % (request.base+'/static/PythonPoweredSmall.gif', request.base+'/static/poweredByCherryPy.gif',request.base+'/static/4Suite-org.png')
		return pie
		
	def about(self):
		"""Very provisional description of the tool"""
		textAbout="""<p>[only spanish]</p><h3>Programa generador de esqueletos de howtos</h3>.
		<small><font color=gray>Copyright &copy; 2003,2004 by Luis Miguel Morillas
		<!-- Comments and questions to <a href="mailto:morillas@unizar.es"><font color=gray>morillas@unizar.es</font></a>-->
		</font></small>		
		<br/>Genera howtos en formato docbook-xml y permiten convertirlos a html, xhtml y pdf.<br>
		Desarrollado por Luis Miguel Morillas a partir de un script de Stein Gjoen<br>
		<br><br>
		La versión original de Stein Gjoen se encuentra en <a href="http://www.nyx.net/~sgjoen/The_LDP_HOWTO_Generator.html">http://www.nyx.net/~sgjoen/The_LDP_HOWTO_Generator.html</a>
		<br><br>
		Versión: 0.05 1-marzo-2004
		<br><br>
		Licencia: Úsalo sin restricciones.
		<br><br>
		Sin garantías.
		<br><br>
		<h3>Características</h3>
		Servidor: <a href="http://www.python.org">python</a> y <a href="http://www.cherrypy.org">cherrypy</a> <br>
		Procesado de xml/xsl <a href="http://www.4suite.org">4Suite libs.</a><br>
		Hojas de estilo xsl (html/xhtml/fo) <a href="http://docbook.sourceforge.net/projects/xsl/">Docbook</a><br>
		<br>		
		Aquí puedes descargar el código:<i>
		<br>cvs -d :pserver:anoncvs@cvs.hispalinux.es:/cvs/lucas login
		<br>[password: anoncvs]
		<br>cvs -d :pserver:anoncvs@cvs.hispalinux.es:/cvs/lucas co rl-docbook-author-assistant</i>
		<br>
		Envía tus comentarios y sugerencias a <a href="mailto:luismiguel.morillas@hispalinux.es">Luis Miguel Morillas</a>
		o a <a href="mailto:lucas-desarrollo@listas.hispalinux.es"> Lista de lucas-desarrollo</a>
		Puedes colaborar añadiendo comentarios en el <a href="http://155.210.19.185:8080/ccia/nodes/2004-03-04/howtoGen">wiki </a>
		<br><br>
		[Por Hacer]
		<br>
		* Refinar creación de docbook-xml<br>
		<br>
		* Traducción del programa
		<br>
		* Mucho más
		<br>
		"""
		newPage=self.modelPage(textAbout)
		return newPage
		
	def uploadFile(self):
		form = """<div class="formUpload"> <form method=post action=postFile enctype="multipart/form-data">
            <center>
			<h3>Select the docbook-xml file to upload</h3>
			<br/>
            File:&nbsp;&nbsp;<input type=file name=xmlfile><br>
			<br>
            <input type=submit value="Upload">
			</center>
        </form>
		</div>"""
		return self.mainHeader(self.language)+ '<br/>'+ form + '<br/>' +self.footer()
		
		
	def postFile(self, xmlfile):
		print type(xmlfile)
		request.sessionMap['docXml']=xmlfile
		#return "hellow"
		#source = InputSource.DefaultFactory.fromString(xmlfile, "file:///usr/share/sgml/docbook/dtd/4.2.cr1/docbook.dtd")
		#PrettyPrint(source, stream=out, encoding='iso-8859-1')
		#return self.modelPage(xmlfile, self.navBar2())
		docXml="""<table> <tr><td><pre>\n%s
				</pre></td></tr></table>""" % escape(request.sessionMap['docXml'])
		return self.modelPage(docXml, self.navBar2())
			
	def creaDoc(self, **kw):
		"""
		creaDoc(diccionario)
		Devuelve una página html con el documento generado a partir de los datos 
		recogidos del formulario. Utiliza variable formulario.
		"""
		if kw.has_key('Clear'): # Hay que borrar todo. Clear Form
			for k in kw.keys():
				if request.sessionMap.has_key(k):
					del(request.sessionMap[k])
			return self.index()
		elif kw.has_key('toXml'):
			doc=Documento(kw)
			request.sessionMap['docXml']=doc.imprimir() #save docXml
			docXml="""<table> <tr><td><pre>\n%s
				</pre></td></tr></table>""" % escape(request.sessionMap['docXml'])
			return self.modelPage(docXml, self.navBar2())
		elif kw.has_key('upload'):
			return self.uploadFile()
		
		elif kw.has_key('toHtml'):
			docXml = InputSource.DefaultFactory.fromString(request.sessionMap['docXml'], "file:///")
			return self.processorHtml.run(docXml)
		elif kw.has_key('toXhtml'):
			docXml = InputSource.DefaultFactory.fromString(request.sessionMap['docXml'], "file:///")
			response.headerMap['content-type'] = "application/xhtml+xml"
			return self.processorXhtml.run(docXml)
		elif kw.has_key('toPdf'):
			docXml = InputSource.DefaultFactory.fromString(request.sessionMap['docXml'], "file:///")
			nomFich=tempfile.mktemp()
			f=open(nomFich+'.fo', 'w')
			f.write(self.processorFo.run(docXml))
			f.close()
			os.system('fop  %s %s' % (nomFich+'.fo', nomFich+'.pdf'))
			if os.path.exists(nomFich+'.pdf'):
				response.headerMap['content-disposition'] ="filename=tldpHowto.pdf"
				response.headerMap['content-type'] = "application/pdf"
				return open(nomFich +'.pdf').read()
			else:
				print "somethin is wrong. user will see an error, because i don't return a string"
				
	
		
		
		


mask:
	def cuerpo(self, datos=""):
		
		<div align="Right" py-eval="'Version 0.05  ' + fechaVersion()"> </div>
              Welcome to the LDP HOWTO Generator. By following through this form
        you will be able to generate the skeleton of your new HOWTO, customised
        to your particular needs. Examples of markup used can be found in the
        <a href="http://www.nyx.net/~sgjoen/template.sgml">HOWTO Template SGML source</a>
        along with the resulting
        <a href="http://www.nyx.net/~sgjoen/template.html">HOWTO Template HTML output</a>.
        <p>
        <!-- Note: This Generator requires JavaScript.<br> 
        Note: Currently this is only a mock-up, only limited functionality is
        implemented yet, nor is functionality fully tested.
        Please read the <a href="http://www.nyx.net/~sgjoen/home.html">home page</a> for updates. -->
        <!-- <FORM NAME="theHOWTOform" action="creaDoc" method="POST">-->
	    <h2>Heading Definition</h2>
		All HOWTOs have to have a number of fields defined in order to be usable
        by others and also to be easily maintained. The following fields are therefore
        mandatory:<br>
		<br>
        <table cellpadding="2" cellspacing="2" border="1" width="100%">
           <tbody>
             <tr>
               <td valign="Top">Title<br>
               </td>
               <td valign="Top" bgcolor="#606080"><input type="text" name="TITLE" size="72" py-attr="self.dame('TITLE')"  value=""><br>
               </td>
               <td valign="Top">This will be the title of your HOWTO. For practical
           reasons it should not be more than one line (72 characters) long, preferrably less.
           It is important to be precise as well as concise.<br>
               </td>
             </tr>
             <tr>
               <td valign="Top">Author<br>
               </td>
               <td valign="Top" bgcolor="#606080" style="color: rgb(255, 255, 255);">Name:&nbsp;<input type="text" name="FIRSTNAME" size="20">
	       Surname: <input type="text" name="SURNAME" size="30"> <br>
               </td>
               <td valign="Top">Your name(s)<br>
               </td>
             </tr>
             <tr>
               <td valign="Top">Email<br>
               </td>
               <td valign="Top" bgcolor="#606080"><input type="text" name="EMAIL" size="40"><br>
               </td>
               <td valign="Top">The email address you wish to be contacted at. HOWTOs
        are long lived documents, make sure your email address is equally durable.
        If needed the Linux Documentation Project can provide an email address,
        inquire for more information.<br>
               </td>
			</tr>
			<tr>
               <td valign="Top">Version<br>
               </td>
               <td valign="Top" bgcolor="#606080"><input type="text" name="VERSION" value="V0.01"><br>
               </td>
               <td valign="Top">Input a version number and date, for
        instance "<font size="+1"><tt>V0.01</tt></font>". Version number is free format.<br>
			</td>
			</tr>
			<tr>
               <td valign="Top">Date<br>
               </td>
               <td valign="Top" bgcolor="#606080"><input type="text" name="DATE" 
	       py-attr="hoy()" value=""><br>
               </td>
               <td valign="Top">Input a date, for instance "<font size="+1"><tt>2000-05-11</tt></font>".
        Recommended date format is ISO standard for dates:"<font size="+1"><tt>YYYY-MM-DD</tt></font>".<br>
		</td>
             </tr>
        
		<!-- Aquí incluyo el resto del formulario original de Stein Gjoen-->
		<div py-include="original.html">cuerpo</div>
		
		<!-- Resto del formulario: llamada a mi función sin los script javascript -->
		<br/>
	
			
		