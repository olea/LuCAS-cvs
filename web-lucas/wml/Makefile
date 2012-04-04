##
# Código fuente LuCAS V3
# Copyright (C) 1999 Hispalinux / Juan J. Amor / Ismael Olea
# Programa bajo la proteccion de GPL 2.0
##
# $Id: Makefile,v 1.8 2005/01/15 00:39:44 olea Exp $
##
##
# Makefile para las paginas de LuCAS
# (C) 1999 Juan J. Amor / Ismael Olea / Hispalinux
##

DIR_TARGET = ../..
PARAM_DIR_ICONS = -D icondir="../icons/"
INCLUDES= Icabecera.wml Imenu.wml Ipie.wml

#####
##
## Regenerar las dependencias de vez en cuando, ejecutando
## make dep
##
#####

include .dependencias

dep:
	@echo Regenerando dependencias WML-HTML ...
	./haz_dep_wml

# Regla para index.html
$(DIR_TARGET)/index.html: index.wml novedades.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)
	wml -E weblint -D icondir="icons/" -D htmldir="htmls/" -Dtarget=$(@F) $< > $@

# Regla para novedades.html
$(DIR_TARGET)/htmls/novedades.html: novedades.wml novedades.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@
#	./el-avisador-automatico-de-lucas.pl

# Regla para comos.html
$(DIR_TARGET)/htmls/comos.html: comos.wml $(INCLUDES) $(INCL_COMOS)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla predeterminada
$(DIR_TARGET)/htmls/%.html: %.wml $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla para generacion de tutoriales
$(DIR_TARGET)/htmls/tutoriales.html: tutoriales.wml tutoriales.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla para generacion de manuales
$(DIR_TARGET)/htmls/manuales.html: manuales.wml manuales.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla para generacion de los informes
$(DIR_TARGET)/htmls/informes.html: informes.wml informes.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla para generacion del directorio de proyectos
$(DIR_TARGET)/htmls/directorio-proyectos.html: directorio-proyectos.wml proy-* $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla para generacion de los estándares
$(DIR_TARGET)/htmls/estandares.html: estandares.wml rfc-es.conf $(INCLUDES)
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblint $(PARAM_DIR_ICONS) -Dmaindir="../" -Dtarget=$(@F) $< > $@

# Regla especial: regeneracion explicita de presentaciones
regen_presen:
	mkdir -p $(DIR_TARGET)/htmls
	wml -E weblink $(PARAM_DIR_ICONS) -Dmaindir="../" -DTARGET=presentaciones.html presentaciones.wml > $(DIR_TARGET)/htmls/presentaciones.html

clean:
	rm -f $(DIR_TARGET)/index.html
	for var in `ls $(DIR_TARGET)/htmls/*.html`; do rm -f $$var; done

emacsclean:
	rm -f *~
