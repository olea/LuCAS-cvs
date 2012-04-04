&lt;!DOCTYPE style-sheet PUBLIC
          "-//James Clark//DTD DSSSL Style Sheet//EN" [
&lt;!ENTITY % html "IGNORE"&gt;
&lt;![%html;[
&lt;!ENTITY % print "IGNORE"&gt;
&lt;!ENTITY docbook.dsl PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN"
	 CDATA dsssl&gt;
]]&gt;
&lt;!ENTITY % print "INCLUDE"&gt;
&lt;![%print;[
&lt;!ENTITY docbook.dsl PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN"
	 CDATA dsssl&gt;
]]&gt;
]&gt;
&lt;style-sheet&gt;
&lt;style-specification id="print" use="docbook"&gt;
&lt;style-specification-body&gt; 

&lt;!-- print stylesheet --&gt;
(define %left-margin% 
  ;; Width of left margin
  4pi)

(define %left-margin% 
  ;; Width of left margin
  4pi)
&lt;/style-specification-body&gt;
&lt;/style-specification&gt;

&lt;style-specification id="html" use="docbook"&gt;
&lt;style-specification-body&gt; 

&lt;!-- html stylesheet--&gt;
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
&lt;/style-specification-body&gt;
&lt;/style-specification&gt;
&lt;external-specification id="docbook" document="docbook.dsl"&gt;
&lt;/style-sheet&gt;
