# -*- coding iso-8859-1 -*-
# $Id: TldpData.py,v 1.2 2004/03/04 10:00:46 luismiguel.morillas Exp $
""" Some varss and functions to use at tldp howto maker
"""

formulario="""
		<FORM NAME="theLinuxDocform" action="creaDoc" method="POST"> 
		<!-- need a form to address content of output field -->
		<p>
		<br>
		<textarea name="OUTPUT" READONLY rows="35" cols="120">
		%s 
		</textarea><br>
		<p>
		</FORM>"""
                

def fechaVersion():
    fVer="$Date: 2004/03/04 10:00:46 $"
    return fVer.split()[1]
	
def hoy():
    import time
    today_date=time.localtime()
    return "%d-%d-%d" % (today_date[:3])

def idioma():
    """Selecciona el idioma del navegador: inglés o availableLanguages
    """
    defaultLanguage = 'en'
    if request.headerMap.has_key('accept-language'):
        if request.headerMap['accept-language'].find('es') >= 0:
            return 'es'
    return 'en'


