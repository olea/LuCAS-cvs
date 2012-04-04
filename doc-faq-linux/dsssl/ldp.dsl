<!DOCTYPE style-sheet PUBLIC
          "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % html "IGNORE">
<![%html;[
<!ENTITY % print "IGNORE">
<!ENTITY docbook.dsl PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN"
	 CDATA dsssl>
]]>
<!ENTITY % print "INCLUDE">
<![%print;[
<!ENTITY docbook.dsl PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN"
	 CDATA dsssl>
]]>
]>



<style-sheet>
<style-specification id="print" use="docbook">
<style-specification-body> <!-- print stylesheet -->
(define %left-margin% 
  ;; Width of left margin
  4pi)
</style-specification-body>
</style-specification>




<style-specification id="html" use="docbook">
<style-specification-body> <!-- html stylesheet-->
(define ($generate-book-lot-list$)
  ;; Which Lists of Titles should be produced for Books?
  (list (normalize "equation")))

(define %gentext-nav-use-ff%
  ;; Add "fast-forward" to the navigation links?
  #t)
(define %html-ext%
  ;; when producing HTML files, use this extension
  ".html")
(define %use-id-as-filename%
  ;; Use ID attributes as name for component HTML files?
  #t)


</style-specification-body>
</style-specification>






<external-specification id="docbook" document="docbook.dsl">
</style-sheet>
