# -*- coding: iso-8859-1 -*-
# (c) Luis Miguel Morillas. 2003
# GPL
# 
# $Id: tldpDoc.py,v 1.3 2004/03/04 18:45:20 luismiguel.morillas Exp $


# version 0.03 transtated into english
# versión 0.02 Usa DOM para construir el artículo

__version__ = "0.03"

import sys
from cStringIO import StringIO

from Ft.Xml.Domlette import implementation, PrettyPrint, NonvalidatingReader
from Ft.Xml import  EMPTY_NAMESPACE
from xml.sax.saxutils import escape


import libxml2
import libxslt


from Ft.Xml.Xslt import Processor
from Ft.Xml import InputSource
from Ft.Lib import Uri


#####################################
#   sting vars with the licenses text
#
GFDL = """Permission is granted to copy, distribute and/or modify this document under the terms of the GNU Free Documentation License, Version 1.1 or any later version published by the Free Software Foundation with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts."""

OPDL = """This material may be distributed only subject to the terms and conditions set forth in the Open Publication License, vX.Y or later (the latest version is presently available at  <ulink url="http://www.opencontent.org/openpub/">OpenContent</ulink>)."""

SIMPLE = """Use the information in this document at your own risk.
I disavow any potential liability for the contents of this document. Use of the concepts, examples, and/or other content of this document is entirely at your own risk.
All copyrights are owned by their owners, unless specifically noted otherwise. Use of a term in this document should not be regarded as affecting the validity of any trademark or service mark.
Naming of particular products or brands should not be seen as endorsements.
You are strongly recommended to take a backup of your system before major installation and backups at regular intervals."""





class ProcessorLibxml:
    """
    libxml processor class
    The web server can create an instace to process the xml doc
    The run method create html docs

    """
    def __init__ (self, sheet='/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl' ):
        styledoc = libxml2.parseFile(sheet)
        self.processor = libxslt.parseStylesheetDoc(styledoc)
    def run(self, source):
        doc = libxml2.parseDoc(source)
        result = self.processor.applyStylesheet(doc, None)
        return self.processor.saveResultToString(result)
    


class Processor4Suite:
    """
    Processor wrapper specialized in docbook documents.
    Methods for run a node and test his behaviour.

    """
    
    def __init__ (self, sheet='/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl' ):
        """
        By default i use docbook stylesheet.
        I want to create processor and feed stylesheet before client
        connection, so i can save response time
        """
        #instantiate processor
        self.processor=Processor.Processor()

        # configure stylesheet (like domlette object)
        sheet_uri = Uri.OsPathToUri(sheet,1)
        transform = NonvalidatingReader.parseUri(sheet_uri)
        self.processor.appendStylesheetNode(transform, sheet_uri)

        # processor is ready to work :)

    def runNode(self, node):
        """
        Method for run node. The processor needs a domlette object (that one
        i've created from html forms :)
        """
        return self.processor.runNode(node)# perpahs best with outputStream=out)

    def run(self, source):
        return self.processor.run(source)
    
        
    def test(self):
        # I create a test doc
        # TODO
        doc = implementation.createRootNode('file:///article.xml')
        docArtic = doc.createElementNS(EMPTY_NAMESPACE, 'article')
        doc.appendChild(docArtic)
        docelement = doc.createElementNS(EMPTY_NAMESPACE, 'title')
        docelement.appendChild(doc.createTextNode(u'Titulo del articulo'))
        docArtic.appendChild(docelement)

        # Print the doc
        PrettyPrint(doc)

        # run the doc + styleSheet
        #out = StringIO()
        
        return self.processor.runNode(doc) #, outputStream=out)#dom_doc)
        #return out.getvalue()
    

                               


    


class Documento:
    """Objeto documento xml
    Se construye el objeto DOM con los datos que recibe del formulario
    Creación del documento: tipo de documento: docbook y nodo raíz: artículo
    """
   
    def __init__(self, dicDatos):
        self.salida = StringIO()
        #self.doc = implementation.createDocument(EMPTY_NAMESPACE,'article', None,'articulo')
        #self.doc.publicId="-//OASIS//DTD DocBook XML V4.2//EN"
        #self.doc.systemId="http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
        self.raiz = implementation.createRootNode('file:///article.xml')
        self.articulo = self.raiz.createElementNS(EMPTY_NAMESPACE,  'article')
        self.raiz.appendChild(self.articulo)
        self.articulo.setAttributeNS(None, 'lang', "es")
        self.raiz.publicId="-//OASIS//DTD DocBook XML V4.2//EN"
        #self.raiz.systemId="http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
        self.raiz.systemId="/usr/share/sgml/docbook/dtd/xml/4.2/docbookx.dtd"
        self.convertir(dicDatos)
        self.articleinfo(dicDatos)
        self.cuerpo(dicDatos)
        print dicDatos
        
    def nameSpace(self):
        self.articulo.setAttributeNS(None, 'xmlns', "http://docbook.org/docbook/xml/4.2/namespace")
                  
    def convertir(self, diccionario, codigo="latin-1"):
        for k in diccionario.keys():
            diccionario[k]=escape((unicode(diccionario[k], codigo)))
        
    def creaNodo (self, tipo):
        return self.raiz.createElementNS(None, tipo)
    
    def creaTexto (self, texto):
        return self.raiz.createTextNode(u'%s' % texto)
        
    def pon(self, nodo):
        self.appendChild(nodo)
        
    def articleinfo(self, dicDatos):
        info = self.creaNodo('articleinfo')
        self.articulo.appendChild(info)
                      
        if dicDatos.has_key('TITLE') and dicDatos['TITLE']:
            titulo = self.creaNodo('title')
            titulo.appendChild(self.creaTexto( dicDatos['TITLE']))
            info.appendChild(titulo)

        if dicDatos.has_key('SURNAME') and dicDatos['SURNAME']:
            autor = self.creaNodo('author')
            info.appendChild(autor)
            apellido = self.creaNodo('surname')
            apellido.appendChild(self.creaTexto(dicDatos['SURNAME']))
            autor.appendChild(apellido)
            nombre = self.creaNodo('firstname')
            nombre.appendChild(self.creaTexto(dicDatos['FIRSTNAME']))
            autor.appendChild(nombre)
            email = self.creaNodo('email')
            email.appendChild(self.creaTexto(dicDatos['EMAIL']))
            autor.appendChild(email)
            
            
        if dicDatos.has_key('VERSION') and dicDatos['VERSION']:
            revhis = self.creaNodo('revhistory')
            info.appendChild(revhis)
            revision = self.creaNodo('revision')
            revhis.appendChild(revision)
            revnum = self.creaNodo('revnumber')
            revision.appendChild(revnum)
            revnum.appendChild(self.creaTexto(dicDatos["VERSION"]))
            if dicDatos.has_key('DATE'):
                fecha = self.creaNodo('date')
                fecha.appendChild(self.creaTexto(dicDatos["DATE"]))
                revision.appendChild(fecha)
            
        if dicDatos.has_key('KEYWORDS') and dicDatos['KEYWORDS']:
            palabrasClave = self.creaNodo("keywordset")
            info.appendChild(palabrasClave)
            for key in dicDatos['KEYWORDS'].split():
                clave = self.creaNodo("keyword")
                clave.appendChild(self.creaTexto(key))
                palabrasClave.appendChild(clave)

        if dicDatos.has_key('ABSTRACT') and dicDatos['ABSTRACT']:
            abstr = self.creaNodo('abstract')
            info.appendChild(abstr)
                        
            for l in dicDatos["ABSTRACT"].split('\n'):
                abstr.appendChild(self.parrafo(l))
        
        if dicDatos.has_key('COPYRIGHT') and dicDatos['COPYRIGHT']:
            copy = self.creaNodo("copyright")
            info.appendChild(copy)
            year =self.creaNodo("year")
            copy.appendChild(year)
            year.appendChild(self.creaTexto(dicDatos['DATE'][:4]))
            holder=self.creaNodo("holder")
            copy.appendChild(holder)
            holder.appendChild(self.creaTexto("%s" % (dicDatos['FIRSTNAME']+' '+dicDatos['SURNAME'])))
            legal=self.creaNodo("legalnotice")
            info.appendChild(legal)
            if dicDatos['COPYRIGHT']=='OPDL':
                for l in OPDL.split('\n'):
                    legal.appendChild(self.parrafo(l))
            elif dicDatos['COPYRIGHT']=='GFDL':
                for l in GFDL.split('\n'):
                    legal.appendChild(self.parrafo(l))
            else:
                for l in dicDatos['OTHER'].split('\n'):
                    legal.appendChild(self.parrafo(l))
            

        if dicDatos.has_key('DISCLAIMER') and dicDatos['DISCLAIMER'] and dicDatos['DISCLAIMER'] !='NONE':
            disc = self.creaNodo("legalnotice")
            info.appendChild (disc)
            disc.appendChild(self.titulo('Disclaimer'))
            
            if dicDatos['DISCLAIMER']=='SIMPLE':
                for l in SIMPLE.split('\n'):
                    disc.appendChild(self.parrafo(l))
            elif dicDatos['DISCLAIMER']=='OTHER':
                for l in dicDatos['DISCLAIMERother'].split('\n'):
                    disc.appendChild(self.parrafo(l))

        

    def cuerpo(self, dicDatos):
        if dicDatos.has_key('INTRO'):
            self.seccion('Introduction', dicDatos['INTRO'])
        for sec in ['NEWS', 'CREDITS', 'TRANSLATION', 'STRUCTURE', 'TECHNO', 'IMPL', 'MAINT', 'ADVISS', 'TROUBLES', 'FURTHER', 'GETHELP', 'CONCLUDE', 'QNA','BITSNPIECES', 'EXAMPLES', 'TESTS']:
            if dicDatos.has_key('ENABLE'+sec):# and dicDatos['ENABLE'+sec]=='Enable':
                self.seccion(dicDatos[sec+'TITLE'], dicDatos[sec])
                
        
    def seccion(self, titulo, cuerpo):
        sec = self.creaNodo("section")
        self.articulo.appendChild(sec)
        sec.appendChild(self.titulo(titulo))
        for linea in cuerpo.split('\n'):
            sec.appendChild(self.parrafo(linea))
                
    def titulo(self, linea):
        t=self.creaNodo("title")
        t.appendChild(self.creaTexto(linea.strip()))
        return t

            
    def parrafo(self, linea):
        p= self.creaNodo('para')
        p.appendChild(self.creaTexto(linea.rstrip()))
        return p
            
            
    def imprimir (self):
        PrettyPrint(self.raiz, stream=self.salida, encoding='iso-8859-1')
        return self.salida.getvalue()
       

def test():
    dic={'INTRO':'Introducción al proceso de xml',
        'TITLEs':'Prueba de docbook-xml',
         'FIRSTNAME': 'Luis Miguel',
         'SURNAME': 'Morillas',
         'EMAIL': 'luismiguel.morillas@hispalinux.es',
         'VERSION': '1.2',
         'DATE': '2003-11-12',
         'KEYWORDS': 'Estoy hasta las ...',
         'ABSTRACT':'Hola carabola\nQue tal',
         'COPYRIGHT': 'GFDL',
         'DISCLAIMER': 'OTHER',
         'DISCLAIMERother': "blabla\nblabal",
         'ENABLENEWS': 'OK',
         'NEWSTITLE':'Noticias de aqui',
         'NEWS': 'Buenas noticias\nde ayer \nyhoy'}
    
    doc = Documento(dic)
    print '***************** Documento en xml ************************\n'
    print doc.imprimir()
    print '\n\n***************** Documento en html ************************\n'
    p = Processor4Suite('/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/fo/docbook.xsl')
    print p.test() # first test (processor)

    print p.run(doc.raiz) #second processor test
    

if __name__ == '__main__':
    test()
    
