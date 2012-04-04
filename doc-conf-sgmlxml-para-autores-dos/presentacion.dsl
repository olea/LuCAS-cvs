<!-- $Id: presentacion.dsl,v 1.1.1.1 2002/06/07 18:30:09 olea Exp $ -->

<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % html "IGNORE">
<![%html;[
<!ENTITY % print "IGNORE">
<!ENTITY docbook.dsl SYSTEM "/usr/share/sgml/docbook/dsssl-stylesheets/html/docbook.dsl" CDATA dsssl>
]]>
<!ENTITY % print "INCLUDE">
<![%print;[
<!ENTITY docbook.dsl SYSTEM "/usr/share/sgml/docbook/dsssl-stylesheets/print/docbook.dsl" CDATA dsssl>
]]>
]>

<!--
;;#######################################################################
;;#									#
;;#									#
;;#	Hojas de estilo de Hispafuentes. Basadas en gdp-both.dsl	#
;;#	del proyecto Gnome y modificadas por olea@hispafuentes.com	#
;;#									#
;;#######################################################################
;;#									#
;;#                                                                     #
;;#    Dave's Custom DocBook Stylesheet by Dave Mason dcm@redhat.com    #
;;#            Based on Norman Walsh's Modular Stylesheets              #
;;#                                                                     #
;;#            This is intended as a drop-in replacement for            #
;;#            the cygnus-both.dsl file in DocBook Tools.               #
;;#           Just copy it to the location dbtools created              #
;;#                   and rename it cygnus-both.dsl                     #
;;#                                                                     #
;;#######################################################################
-->

<style-sheet>


<style-specification id="print" use="docbook">
<style-specification-body> 

;;==========================================================================
;;                               PRINT
;;==========================================================================

;;======================================
;; Pies de página
;;======================================

(define %footnote-size-factor% 
  ;; When printing footnotes, the current font size is multiplied by the
  ;; '%footnote-size-factor%'. 
  0.7)

;; Notas al pie de página, como debe ser.
(define bop-footnotes
  ;; Make "bottom-of-page" footnotes?
  #f)

;Make Ulinks footnotes to stop bleeding in the edges - this increases
;jade time tremendously!
(define %footnote-ulinks%
  #f)


; (define %gentext-es-start-quote% (dingbat "laquo"))
; (define %gentext-es-end-quote% (dingbat "raquo"))


;;======================================
;;General Options
;;======================================

(define (part-titlepage-recto-elements)
  (list (normalize "title")
        (normalize "subtitle") 
        (normalize "corpauthor") 
        (normalize "authorgroup") 
        (normalize "author") 
        (normalize "editor")
        (normalize "edition") 
        (normalize "pubdate") 
        (normalize "copyright")
	(normalize "isbn")
	(normalize "pubsnumber")
        (normalize "publishername") 
        (normalize "abstract") 
        (normalize "publisher") 

	(normalize "contrib")
        (normalize "legalnotice") 
        (normalize "revhistory")
        (normalize "releaseinfo")))




;;Do you want to print on both sides of the paper?
(define %two-side% 
 #f)

;;Do you want enumerated sections? (E.g, 1.1, 1.1.1, 1.2, etc.)
(define %section-autolabel% 
 #f)

;;What is the default extension for graphics?
(define %graphic-default-extension% 
  "png")
;;  "eps")

;;Show URL links? If the text of the link and the URL are identical,
;;the parenthetical URL is suppressed.
(define %show-ulinks%
 #f)

;;Tex Backend on
(define tex-backend 
 #t)

;;Define Line Spacing
(define %line-spacing-factor% 1.1)

;;Define the Paragraph Style
(define para-style
  (style
   font-size: %bf-size%
   font-weight: 'medium
   font-posture: 'upright
   font-family-name: %body-font-family%
   line-spacing: (* %bf-size% %line-spacing-factor%)))

(define ($object-titles-after$)
  (list (normalize "figure")))


;;======================================
;;Book Options
;;======================================

(define (book-titlepage-verso-elements)
  (list (normalize "title") 
        (normalize "subtitle") 
        (normalize "corpauthor") 
        (normalize "authorgroup") 
        (normalize "author") 
        (normalize "editor")
        (normalize "edition") 
        (normalize "pubdate") 
        (normalize "copyright")
        (normalize "publishername") 
	(normalize "isbn")
	(normalize "pubsnumber")
        (normalize "abstract") 
        (normalize "publisher") 

        (normalize "legalnotice") 
        (normalize "revhistory")
        (normalize "releaseinfo")))

;;Do you want a title page for a Book?
(define %generate-book-titlepage%
 #t)

;;Do you want a separate page for the title?
(define %generate-book-titlepage-on-separate-page%
 #t)

;;Generate Book TOC?
(define %generate-book-toc% 
 #t)

;;Do you want a TOC for the element part?
(define %generate-part-toc% 
 #f)

;;Do you want the part toc on the part titlepage or separate?
(define %generate-part-toc-on-titlepage%
 #t)

;;Generate Part Title Page?
(define %generate-part-titlepage% 
  #t)

;;Do you want the Part intro on the part title page?
(define %generate-partintro-on-titlepage%
  #t)

;;What elements should have a LOT?
(define ($generate-book-lot-list$)
  (list (normalize "example")
    (normalize "equation")))

;;Do you want chapters enumerated?
(define %chapter-autolabel% 
 #t)

;;Automatically label chapters if no label is given?
(define %chap-app-running-head-autolabel% 
  #t)

;;======================================
;;Article Options
;;======================================

(define (article-titlepage-verso-elements)
  (list (normalize "abstract")
        (normalize "legalnotice") 
        (normalize "revhistory")
        (normalize "releaseinfo")))


;;Do you want a title page for an Article?
(define %generate-article-titlepage%
 #t)

;;Do you want a separate page for the title?
(define %generate-article-titlepage-on-separate-page%
 #f)

;;Do you want the article toc on the titlepage or separate?
(define %generate-article-toc-on-titlepage%
 #f)

;;Do you want to start new page numbers with each article?
(define %article-page-number-restart%
 #f)

;;======================================
;;Columns
;;======================================

;;How many columns do you want?
(define %page-n-columns%
 1)

;;How much space between columns?
(define %page-column-sep%
 0.2in)

;;======================================
;;Fonts
;;======================================

;;Defines the general size of the text in the document. normal(10),
;;presbyopic(12), and large-type(24). 
(define %visual-acuity%
 "normal")

;;What font would you like for titles?
(define %title-font-family% 
  "Helvetica")

;;What font would you like for the body?
(define %body-font-family% 
 "Helvetica")

;;What font would you like for mono-seq?
(define %mono-font-family% 
 "Courier New")

;;If the base fontsize is 10pt, and '%hsize-bump-factor%' is
;; 1.2, hsize 1 is 12pt, hsize 2 is 14.4pt, hsize 3 is 17.28pt, etc
(define %hsize-bump-factor% 
 1.1)
;;1.2

;;What size do you want the body fonts?
(define %bf-size%
 (case %visual-acuity%
    (("tiny") 8pt)
    (("normal") 10pt)
    (("presbyopic") 12pt)
    (("large-type") 24pt)))

(define-unit em %bf-size%)

;;======================================
;;Margins
;;======================================

(define %left-right-margin% 2pi)

;;How much indentation for the body?
(define %body-start-indent% 
 3pi)

;;How big is the left margin? (relative to physical page)
(define %left-margin% 
 6pi) ;white-paper-column

;;How big is the right margin? (relative to physical page)
(define %right-margin% 
 6pi) ;white-paper-column

;;How big do you want the margin at the top?
(define %top-margin%
(if (equal? %visual-acuity% "large-type")
      7.5pi
      4pi))

;;How big do you want the margin at the bottom?
(define %bottom-margin% 
 (if (equal? %visual-acuity% "large-type")
      7.5pi 
      6pi))

;;Define the text width. (Change the elements in the formula rather
;;than the formula itself)

;(define %text-width% (- %page-width% (* %left-right-margin% 2)))
(define %text-width%  (- %page-width% (+ %left-margin% %right-margin%)))

;;Define the body width. (Change the elements in the formula rather
;;than the formula itself)
(define %body-width% 
 (- %text-width% %body-start-indent%))

;;Define distance between paragraphs
(define %para-sep% 
 (/ %bf-size% 2.0))

;;Define distance between block elements (figures, tables, etc.).
(define %block-sep% 
 (* %para-sep% 2.0))

;;Indent block elements?
(define %block-start-indent% 
  0pt)

;;======================================
;;Admon Graphics
;;======================================

;;Do you want admon graohics on?
(define %admon-graphics%
 #f)

;;======================================
;;Quadding
;;======================================


;; The quadding of division-level titles ('Set', 'Book', and 'Part').
(define division-title-quadding
 'left)

;; The quadding of division-level subtitles ('Set', 'Book', and 'Part').
(define division-subtitle-quadding
 'left)

;;What quadding do you want by default; start, center, justify, or end?
(define %default-quadding%
 'justify)

;;What quadding for component titles(Chapter, Appendix, etc)?
(define %component-title-quadding% 
 'start)

;;What quadding for section titles?
(define %section-title-quadding% 
 'start)

;;What quadding for section sub-titles?
(define %section-subtitle-quadding%
 'start)

;;What quadding for article title?
(define %article-title-quadding% 
 'start)


;;What quadding for component subtitles?
(define %component-subtitle-quadding% 
  'start)

;;What quadding for article sub-titles?
(define %article-subtitle-quadding%
 'start)

;;======================================
;;Paper Options
;;======================================

;;What size paper do you need? A4, USletter, USlandscape, or RedHat?
(define %paper-type%
 "A4")

;;Now define those paper types' width
(define %page-width%
 (case %paper-type%
    (("A4") 210mm)
    (("USletter") 8.5in)
    (("RedHat") 7.0in)
    (("USlandscape") 11in)))

;;Now define those paper types' height
(define %page-height%
 (case %paper-type%
    (("A4") 297mm)
    (("USletter") 11in)
    (("RedHat") 8.5in)
    (("USlandscape") 8.5in)))

;;======================================
;;Functions
;;======================================

(define (OLSTEP)
  (case
   (modulo (length (hierarchical-number-recursive "ORDEREDLIST")) 4)
	((1) 1.2em)
	((2) 1.2em)
	((3) 1.6em)
	((0) 1.4em)))

(define (ILSTEP) 1.0em)

(define (PROCSTEP ilvl)
  (if (> ilvl 1) 1.8em 1.4em))

(define (PROCWID ilvl)
  (if (> ilvl 1) 1.8em 1.4em))

(define ($comptitle$)
  (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-size: (HSIZE 2)
	line-spacing: (* (HSIZE 2) %line-spacing-factor%)
	space-before: (* (HSIZE 2) %head-before-factor%)
	space-after: (* (HSIZE 2) %head-after-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: 'start
	keep-with-next?: #t
	(process-children-trim)))

;;Callouts are confusing in Postscript... fix them.
(define %callout-fancy-bug% 
 #f)

;;======================================
;;Non-printing Elements
;;======================================

(element COMMENT (empty-sosofo))
(element TITLEABBREV (empty-sosofo))
(element SETINFO (empty-sosofo))
(element BIBLIOENTRY (empty-sosofo))
(element BIBLIOMISC (empty-sosofo))
(element BOOKBIBLIO (empty-sosofo))
(element SERIESINFO (empty-sosofo))

;;======================================
;;Inlines
;;======================================

(element application ($mono-seq$))
(element command ($bold-seq$))
(element filename ($mono-seq$))
(element function ($mono-seq$))
(element guibutton ($bold-seq$))
(element guiicon ($bold-seq$))
(element guilabel ($italic-seq$))
(element guimenu ($bold-seq$))
(element guimenuitem ($bold-seq$))
(element hardware ($bold-mono-seq$))
(element keycap ($bold-seq$))
(element literal ($mono-seq$))
(element parameter ($italic-mono-seq$))
(element prompt ($mono-seq$))
(element symbol ($charseq$))
(element emphasis ($italic-seq$))


;;=====================================
;;Title Page Changes
;;=====================================

(mode article-titlepage-recto-mode

  (element authorgroup
    (make display-group
      lines: 'asis
      (literal "by")
      (process-children)))

 (element affiliation
   (make display-group
      use: article-titlepage-recto-style
      quadding: 'start
      (process-children)))

 (element address
   (make display-group
     use: article-titlepage-recto-style
     quadding: 'start
     (process-children)))

 (element email
   (make display-group
     use: article-titlepage-recto-style
     quadding: 'start)))




</style-specification-body>
</style-specification>


<!-- 
;;===========================================================================
;;                                HTML
;;===========================================================================
-->

<style-specification id="html" use="docbook">
<style-specification-body> 

;; this is necessary because right now jadetex does not understand
;; symbolic entities, whereas things work well with numeric entities.
(declare-characteristic preserve-sdata?
          "UNREGISTERED::James Clark//Characteristic::preserve-sdata?"
          #f)

;;======================================
;;Comillas guapas «»
;;======================================

; (define %gentext-es-start-quote% (dingbat "laquo"))
; (define %gentext-es-end-quote% (dingbat "raquo"))

;;=========================
;;Common Stuff
;;=========================

(define (part-titlepage-recto-elements)
  (list (normalize "title")
        (normalize "subtitle") 
	(normalize "graphic")
        (normalize "corpauthor") 
        (normalize "authorgroup") 
        (normalize "author") 
        (normalize "editor")
        (normalize "edition") 
        (normalize "pubdate") 
        (normalize "copyright")
        (normalize "publishername") 
	(normalize "isbn")
	(normalize "pubsnumber")
        (normalize "abstract") 
        (normalize "publisher") 

	(normalize "contrib")
        (normalize "legalnotice") 
        (normalize "revhistory")
        (normalize "releaseinfo")))


;;Should there be a link to the legalnotice?
(define %generate-legalnotice-link%
  #t)

;;What graphics extensions allowed?
(define %graphic-extensions% 
'("gif" "png" "jpg" "jpeg" "tif" "tiff" "eps" "epsf" ))

;;What is the default extension for images?
(define %graphic-default-extension% "png")

;;Use element ids as filenames?
(define %use-id-as-filename%
 #t)


;;=========================
;;Book Stuff
;;=========================

;;Do you want a separate page for the title?
; (define %generate-book-titlepage-on-separate-page%
;  #t)

;;Do you want a TOC for Books?
(define %generate-book-toc% 
  #t)

;;What depth should the TOC generate?
;;Only top level of appendixes
(define (toc-depth nd)
  (if (string=? (gi nd) (normalize "book"))
      3
      (if (string=? (gi nd) (normalize "appendix"))
        0
        1)))

;;What elements should have an LOT?
(define ($generate-book-lot-list$)
  (list (normalize "table")
  (normalize "example")
  (normalize "equation")))

;;Do you want a title page for your Book?
(define %generate-book-titlepage%
#t)

;;=========================
;;Part Stuff
;;=========================

;;Should parts have TOCs?
(define %generate-part-toc% 
  #t)

;;Should part TOCs be on their titlepages?
(define %generate-part-toc-on-titlepage%
  #t)

;;Do you want a title page for your part?
(define %generate-part-titlepage% 
  #t)

;;Should the Part intro be on the part title page?
(define %generate-partintro-on-titlepage%
 #t)

;;========================
;;Chapter Stuff
;;=======================

(define $generate-chapter-toc$
 (lambda ()
    #f))

;;=========================
;;Navigation
;;=========================

;;Should there be navigation at top?
(define %header-navigation%
 #t)

;;Should there be navigation at bottom?
(define %footer-navigation%
  #t)

;;Use tables to create the navigation?
(define %gentext-nav-use-tables%
 #t)

;;If tables are used for navigation, 
;;how wide should they be? 
(define %gentext-nav-tblwidth% 
"100%")

;;Add arrows to navigation
(define (gentext-en-nav-prev prev) 
  (make sequence (literal "<<< Previous")))

(define (gentext-en-nav-next next)
  (make sequence (literal "Next >>>")))


;;=========================
;;Tables and Lists
;;=========================

;;Should Variable lists be tables?
(define %always-format-variablelist-as-table%
 #f)

;;What is the length of the 'Term' in a variablelist?
(define %default-variablelist-termlength%
  20)

;;When true | If the terms are shorter than 
;;the termlength above then the variablelist 
;;will be formatted as a table.
(define %may-format-variablelist-as-table%
#f)

;;This overrides the tgroup definition 
;;(copied from 1.20, dbtable.dsl).
;;It changes the table background color, 
;;cell spacing and cell padding.

(element tgroup
  (let* ((wrapper   (parent (current-node)))
	 (frameattr (attribute-string (normalize "frame") wrapper))
	 (pgwide    (attribute-string (normalize "pgwide") wrapper))
	 (footnotes (select-elements (descendants (current-node)) 
				     (normalize "footnote")))
	 (border (if (equal? frameattr (normalize "none"))
		     '(("BORDER" "0"))
		     '(("BORDER" "1"))))
	 (bgcolor '(("BGCOLOR" "#E0E0E0")))
	 (width (if (equal? pgwide "1")
		    (list (list "WIDTH" ($table-width$)))
		    '()))
	 (head (select-elements (children (current-node)) (normalize "thead")))
	 (body (select-elements (children (current-node)) (normalize "tbody")))
	 (feet (select-elements (children (current-node)) (normalize "tfoot"))))
    (make element gi: "TABLE"
	  attributes: (append
		       border
		       width
		       bgcolor
		       '(("CELLSPACING" "0"))
		       '(("CELLPADDING" "4"))
		       (if %cals-table-class%
			   (list (list "CLASS" %cals-table-class%))
			   '()))
	  (process-node-list head)
	  (process-node-list body)
	  (process-node-list feet)
	  (make-table-endnotes))))

;;===================
;; Admon Graphics
;;===================

;;Should Admon Graphics be used?
(define %admon-graphics%
  #t)

;;Where are those admon graphics?
(define %admon-graphics-path%
  "./stylesheet-images/")

;;Given an admonition node, returns the 
;;name of the graphic that should
;;be used for that admonition.

(define ($admon-graphic$ #!optional (nd (current-node)))
  (cond ((equal? (gi nd) (normalize "tip"))
	 (string-append %admon-graphics-path% "tip.gif"))
	((equal? (gi nd) (normalize "note"))
	 (string-append %admon-graphics-path% "note.gif"))
	((equal? (gi nd) (normalize "important"))
	 (string-append %admon-graphics-path% "important.gif"))
	((equal? (gi nd) (normalize "caution"))
	 (string-append %admon-graphics-path% "caution.gif"))
	((equal? (gi nd) (normalize "warning"))
	 (string-append %admon-graphics-path% "warning.gif"))
	(else (error (string-append (gi nd) " is not an admonition.")))))

;;Given an admonition node, returns 
;;the width of the graphic that will
;;be used for that admonition.
(define ($admon-graphic-width$ #!optional (nd (current-node)))
  "25")

;;=========================
;;Labels
;;=========================

;;Enumerate Chapters?
(define %chapter-autolabel% 
 #f)

;;Enumerate Sections?
(define %section-autolabel%
 #f)

;;=========================
;;    HTML Attributes
;;=========================

;;What attributes should be hung off 
;;of 'body'?
(define %body-attr%
 (list
   (list "BGCOLOR" "#FFFFFF")
   (list "TEXT" "#000000")
   (list "LINK" "#0000FF")
   (list "VLINK" "#840084")
   (list "ALINK" "#0000FF")))

;;Default extension for filenames?
(define %html-ext% 
  ".html")

;;Use a CSS stylesheet?
;;Which one?
;(define %stylesheet% 
;        "./gnome.css")

;;========================
;;Title Pages for Books
;;=======================

(define (book-titlepage-recto-elements)
  (list (normalize "title")
	(normalize "subtitle")
	(normalize "corpauthor")
	(normalize "authorgroup")
	(normalize "author")
	(normalize "orgname")

        (normalize "editor")
        (normalize "edition") 
        (normalize "pubdate") 
        (normalize "copyright")
        (normalize "publishername") 
	(normalize "isbn")
	(normalize "pubsnumber")
        (normalize "publisher") 

        (normalize "legalnotice") 
        (normalize "revhistory")
        (normalize "releaseinfo")))




;;========================
;;Title Pages for Articles
;;========================

;;Should Articles have a TOC?
(define %generate-article-toc% 
  #t)

;;Which elements should appear 
;;on title page?
(define (article-titlepage-recto-elements)
  (list (normalize "title")
	(normalize "subtitle")
        (normalize "authorgroup")
        (normalize "copyright")
        (normalize "revhistory")
        (normalize "legalnotice")
        (normalize "abstract")))

;;How should elements on title page look?
(mode article-titlepage-recto-mode

(element authorgroup
  (make sequence
    (literal "by:")
    (process-children)))

;;Author name is too big - change it!
  (element author
    (let ((author-name  (author-string))
	  (author-affil (select-elements (children (current-node)) 
					 (normalize "affiliation"))))
      (make sequence      
	(make element gi: "H4"
	      attributes: (list (list "CLASS" (gi)))
	      (make element gi: "A"
		    attributes: (list (list "NAME" (element-id)))
		    (literal author-name)))
	(process-node-list author-affil))))

;;Address?
  (element address 
    (make sequence
      (make element gi: "DIV"
            attributes: (list (list "CLASS" (gi)))
            (process-children))))

;;Get rid of spam-producing "mailto" links
;;and get rid of email indentation  
  (element email
    (make sequence
      (make element gi: "DIV"
            attributes: (list (list "CLASS" (gi)))
            (process-children))))

;;Point Abstract to custom table function 
;;(See $dcm-abstract-object$ below. For default
;;use $semiformal-object$
  (element abstract
    (make element gi: "DIV"
          ($dcm-abstract-object$)))

  (element (abstract title) (empty-sosofo))

;;Handle ISBN
(element isbn
  (make sequence
    (make element gi: "SPAN"
	  attributes: (list (list "CLASS" (gi))))
    (literal "ISBN")
    (process-children)
    (make empty-element gi: "BR")))

;;Handle PubsNumber
(element pubsnumber
  (make sequence
    (make element gi: "SPAN"
	  attributes: (list (list "CLASS" (gi))))
    (literal "PUBSNUMBER")
    (process-children)
    (make empty-element gi: "BR")))

;;Handle Publisher
(element publisher
  (make sequence
    (make element gi: "P"
	  attributes: (list (list "CLASS" (gi)))
	  (literal "Published By:")
	  (process-children))))

;;revhistory table is MUCH too wide!
  (element revhistory
    (make element gi: "DIV"
	  attributes: (list (list "CLASS" (gi)))
	  (make element gi: "TABLE"
		attributes: (list
                             (list "WIDTH" "35%")
                             (list "BORDER" "0"))
		(make sequence
		  (make element gi: "TR"
			(make element gi: "TH"
			      attributes: '(("ALIGN" "LEFT") 
					    ("VALIGN" "TOP")
					    ("COLSPAN" "3"))
			      (make element gi: "B"
				    (literal (gentext-element-name 
					      (gi (current-node)))))))
		  (process-children)))))

;;subtitle sizing
(element subtitle 
  (make element gi: "H4"
        attributes: (list (list "CLASS" (gi)))
        (process-children-trim))))

;;=================
;;    INLINES
;;=================

;Define my own series of fonts for various elements
(element application ($mono-seq$))
(element command ($bold-seq$))
(element filename ($mono-seq$))
(element function ($mono-seq$))
(element guibutton ($bold-seq$))
(element guiicon ($bold-seq$))
(element guilabel ($bold-mono-seq$))
(element guimenu ($bold-seq$))
(element guimenuitem ($bold-seq$))
(element guisubmenu ($bold-seq$))
(element hardware ($bold-mono-seq$))
(element keycap ($bold-seq$))
(element literal ($mono-seq$))
(element parameter ($italic-mono-seq$))
(element prompt ($mono-seq$))
(element symbol ($charseq$))
(element emphasis ($italic-seq$))


;;====================
;; General Formatting
;;====================

;;Formal Paras are ugly by default!
;;Make the title run in - otherwise 
;;you should use a sect!

(element formalpara
  (make element gi: "DIV"
	attributes: (list
		     (list "CLASS" (gi)))
  	(make element gi: "P"
	      (process-children))))

;(element (formalpara title) ($lowtitle$ 5))
(element (formalpara title) 
  (make element gi: "B"
	($runinhead$)))

;;make captions come after objects in the list
(define ($object-titles-after$)
  (list (normalize "figure")))


;;Literal Elements

;;Indent Literal layouts?
(define %indent-literallayout-lines% 
  #f)

;;Indent Programlistings?
(define %indent-programlisting-lines%
  #f)

;;Number lines in Programlistings?
(define %number-programlisting-lines%
 #f)

;;Should verbatim items be 'shaded' with a table?
(define %shade-verbatim% 
 #t)

;;Define shade-verbatim attributes
(define ($shade-verbatim-attr$)
 (list
  (list "BORDER" "0")
  (list "BGCOLOR" "#E0E0E0")
  (list "WIDTH" ($table-width$))))

;;===================
;;    Entities
;;===================

;;Netscape doesn't handle trademark 
;;entity right at all!! Get rid of it.

(element trademark
  (make sequence
    (process-children)
    (make element gi: "sup"
    (literal "TM"))))



;;===================
;; New Definitions
;;==================

(define ($dcm-abstract-object$)
   (make element gi: "TABLE"
        attributes: '(("BORDER" "0")
                      ("BGCOLOR" "#E0E0E0")
                      ("WIDTH" "50%")
                      ("CELLSPACING" "0")
                      ("CELLPADDING" "0")
                      ("ALIGN" "CENTER"))
        (make element gi: "TR"
              (make element gi: "TD"
                    attributes: '(("VALIGN" "TOP"))
                    (make element gi: "B"
                    (literal "Abstract"))))
        (make element gi: "TR"
              (make element gi: "TD"
                    attributes: '(("VALIGN" "TOP"))
                    (process-children)))))

;;Redefine Titlepage Separator on Articles

(define (article-titlepage-separator side)
  (make empty-element gi: "HR"
  attributes: '(("WIDTH" "75%")
                 ("ALIGN" "CENTER")
                 ("COLOR" "#000000")
                 ("SIZE" "1"))))


</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>
