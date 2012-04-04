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
<!ENTITY htmlmath.dsl SYSTEM "HTMLMath.dsl">
<!ENTITY texmath.dsl SYSTEM "TeXMath.dsl">
]>

<!-- customizations by Allin Cottrell for dbtexmath package -->

<style-sheet>

<style-specification id="print" use="docbook">
<style-specification-body> 

;; customize the print stylesheet

(define tex-backend 
  ;; Are we using the TeX backend?
  #t)

;; if we're using TeX, might as well have justification...
(define %default-quadding%   
  ;; The default quadding
  'justify)

;; ...and hyphenation
(define %hyphenation%
  ;; Allow automatic hyphenation?
  #t)

;; By default the math will come out in Computer Modern, so I'll
;; choose that family for text too.  YMMV.

(define %body-font-family% 
 "Computer Modern")
 
(define %title-font-family% 
 "Computer Modern")
 
(define %mono-font-family% 
 "Computer Modern Typewriter")

&texmath.dsl;

;; end of print stylesheet customization

</style-specification-body>
</style-specification>

<style-specification id="html" use="docbook">
<style-specification-body> 

;; customize the html stylesheet

(define ($section-separator$)
  (empty-sosofo)) 

&htmlmath.dsl;

;; end of html stylesheet customization

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>

