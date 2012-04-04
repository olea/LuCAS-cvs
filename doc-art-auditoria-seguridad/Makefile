PACKAGE=audit
OUTPUT=$(PACKAGE).text $(PACKAGE).html $(PACKAGE).pdf

tar: $(PACKAGE).sgml  $(OUTPUT)
	cd .. ; tar -zcf $(PACKAGE).tgz  $(PACKAGE)/

%.text: %.sgml
	debiandoc2text $<

%.ps: %.sgml
	debiandoc2ps $<

%.html: %.sgml
	debiandoc2html $<

clean:
	-rm -rf *~  $(OUTPUT)
