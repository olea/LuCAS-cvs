secc = $(word 3, $(shell ls ../orig/*.* | sed -e "s/\// /g" -e "s/\./ /g"))
name = $(word 2, $(shell ls ../orig/*.* | sed -e "s/\// /g" -e "s/\./ /g"))

translate:
	-doclifter ../orig/$(name).$(secc) &> report
	make continue

continue:
ifeq ($(shell cat report),)
	mv ../orig/*.xml ../orig-xml/$(secc)-$(name).xml
	xml2po -o ../po/$(secc)-$(name).pot ../orig-xml/$(secc)-$(name).xml
	kbabel ../po/$(secc)-$(name).pot
else
	@echo Falló Doclifter, enviado informe de error.
	@echo Seleccione una nueva página. Fin de la traducción.
	@echo -e"Found this error in lifting the following manpage to XML\n\n"\
	> failreport && cat report \
	| sed -e"s/\// /g" -e"s/\./ /g" -e"s/\orig/ /g" >> failreport
	@cat failreport | mail -s "Syntax Error Report" mtk-manpages@gmx.net
endif

publish:
	xml2po -p ../po/*po ../orig-xml/*xml > ../$(secc)-$(name).xml
	mkdir ../Publish
	xmlto -o ../Publish man ../$(secc)-$(name).xml
	xmlto -o ../Publish pdf ../$(secc)-$(name).xml
	xmlto -o ../Publish html ../$(secc)-$(name).xml
	-cd .. ;\
	cvs add *.* Publish Publish/*.* orig-xml/*.* po/*.*
	cd ..;\
	cvs commit -m "traduccion finalizada y publicada"