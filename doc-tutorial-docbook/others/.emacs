;; The following lines are useful for DocBook Mode
;; They are from Bob DuCharme bob@snee.com

(defun sgml-lt ()
  "Insert ISO entity reference for less-than."
  (interactive)
  (insert "&lt;"))

(defvar sgml-font-lock-keywords  
  
  '(;  Highlight the text between these tags in SGML mode.
    ("<indexterm[^>]*>" . font-lock-comment-face) 
    ("</indexterm>" . font-lock-comment-face) 
    ("<primary[^<]+</primary>" . font-lock-comment-face) 
    ("<secondary[^<]+</secondary>" . font-lock-comment-face) 
    ("<see[^<]+</see>" . font-lock-comment-face) 
    ("<seealso[^<]+</seealso>" . font-lock-comment-face) 
    )
  "Additional expressions to highlight in SGML mode.")
(setq font-lock-defaults '(sgml-font-lock-keywords t))

(defun sgml-para ()
  "Insert para tags and position cursor."
  (interactive)
  (sgml-insert-element 'para))

(defun index-tag ()
  "Copy marked section to a primary index tag for it."
  (interactive)
  (kill-ring-save (point)(mark))
  (sgml-insert-element 'indexterm)
  (yank))

(defun index-tag-sec ()
  "Add secondary index element. Assumes cursor at end of primary element content."
  (interactive)
  (sgml-next-data-field)
  (sgml-insert-element 'secondary))

(defun sgml-comment ()
  "Insert SGML comment and position cursor."
  (interactive)
  (insert "<!--  -->")
  (backward-char 4))

(add-hook 'sgml-mode-hook   ; make all this stuff SGML-specific
(function (lambda()
					; everything in here will only apply in SGML mode
	    
	    (define-key sgml-mode-map "<" 'sgml-lt)
	    (define-key sgml-mode-map "p" 'sgml-para)
	    (define-key sgml-mode-map "x" 'index-tag)
	    (define-key sgml-mode-map "y" 'index-tag-sec)
	    ;;  right-click selected element for edit attributes popup
	    (define-key sgml-mode-map [mouse-3] 'sgml-attrib-menu)
	    (define-key sgml-mode-map "o" 'sgml-comment) ; without this, all SGML text is in same color	    
 	    (setq sgml-markup-faces
 		  '((comment   . font-lock-comment-face)
 		    (start-tag . font-lock-keyword-face)
 		    (end-tag   . font-lock-keyword-face)
 		    (doctype   . font-lock-builtin-face)
 		    (entity    . font-lock-constant-face)))
	    )))

(setq sgml-set-face t)  ; without this, all SGML text is in same color
(setq sgml-markup-faces
      '((comment   . font-lock-comment-face)
	(start-tag . font-lock-keyword-face)
	(end-tag   . font-lock-keyword-face)
	(doctype   . font-lock-builtin-face)
	(entity    . font-lock-constant-face)))
