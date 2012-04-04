<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!entity docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA DSSSL>
]>

<!-- 

Documento: desenvolvimento-html.dsl
Versão: 0.3

Autor: Jorge Godoy <godoy@conectiva.com.br>
Atual mantenedor: Jorge Godoy <godoy@conectiva.com.br>

Alterações no DocBook DTD. Essas alterações são implementadas como um
estilo. Acho que assim tenho um maior controle - e isso não confunde
o psgml.


Changelog:
 
20000620 - Colocadas duas colunas. 
20000621 - Colocado índice para artigos em HTML.

-->

<style-sheet>
<style-specification id="html" use="docbook">
<style-specification-body>


;; =========================
;; Índices.

;; Duas colunas para índice remissivo.
(define %page-n-columns%
  ;; Sets the number of columns on each page
  2)

;; Gerar Índice no HTML
(define %generate-article-toc% 
  #t)


;; =========================
;; Cabeçalhos de navegação

;; Cabeçalhos de navegação com o assunto anterior e o próximo... 
(define %header-navigation%
  #t)

(define %footer-navigation%
  #t)

;; Tabelas para os cabeçalhos de navegação.
(define %gentext-nav-use-tables%
  #t)

;; Largura da tabela que é definida para os cabeçalhos de navegação 
(define %gentext-nav-tblwidth% 
  "100%")


;; =========================
;; Indentação

;; Indentação para listagens de programas
(define %indent-programlisting-lines%
  "    ") ;; 4 espaços. Pode ser #f para suprimir a indentação.

;; Indentação para telas
(define %indent-screen-lines%
  "    ") ;; 4 espaços. Pode ser #f para suprimir a indentação.

;; =========================
;; Verbatim

;; Sombreamento em ambientes verbatim
(define %shade-verbatim%  
  #t)

;; Tabela de atributos usados no sombreamento
(define ($shade-verbatim-attr$)
  (list
   (list "BORDER" "0")
   (list "BGCOLOR" "#E0E0E0")
   (list "WIDTH" ($table-width$))))

;; ========================
;; Callouts

;; Coluna padrão para callouts.
(define %callout-default-col% 
  70)

;; ========================
;; Bibliografia

(define biblio-number
  #t)

;; ========================
;; Imagens

(define %graphic-default-extension% 
  "jpg")

;; Arquivos terminados com essa extensão não terão acrescidos o valor
;; acima. 
(define %graphic-extensions% 
  '("gif" "jpg" "jpeg" "png" "tif" "tiff" "eps" "epsf"))

;; ========================
;; Estilos CSS

;; Nome do estilo
(define %stylesheet%
    "desenvolvimento-2.0.css")

;; Tipo do estilo
(define %stylesheet-type%
  "text/css")


;; ========================
;; Arquivos gerados

;; Usar ID como nome de arquivo
(define %use-id-as-filename%
  #t)

;; Diretórios de saída devem ser usados?
(define use-output-dir
  #t)

;; Diretório de saída
;;(define %output-dir%
;;  "html/") ;; Diretório em relação ao diretório atual.

;; Extensão padrão
(define %html-ext% 
  ".html")

;; Nome do arquivo principal padrão.
(define %root-filename%
  "index") ;; Pode ser #f também. A extensão é adicionada
           ;; automaticamente, de acordo com o valor definido
           ;; acima. Isso vale para todos os arquivos cujos nomes
           ;; foram gerados a partir do ID.

;; Adicionar o atributo de idioma no nome do arquivo?
(define %html-use-lang-in-filename% 
  #f)

;; Gerar HTML 4.0?
(define %html40%
  #t)

;; Identificador público do HTML
(define %html-pubid%
  "-//W3C//DTD HTML 4.01//EN") ;; Pode ser #f.

;; ====================
;; Satisfazendo os DTDs...

;; Elementos de bloco podem existir dentro do para do DocBook, mas
;; não no p do HTML. Isso acrescenta p e /p adicionais para
;; tentar resolver esse problema.
(define %fix-para-wrappers%
  #t)

;; ====================
;; Seções

;; Mostra o número das seções.
(define %section-autolabel%
  #t)

;; Não deve haver nenhuma seção com o índice.
(define (chunk-skip-first-element-list)
  '())

</style-specification-body>
</style-specification>
<external-specification id="docbook" document="docbook.dsl">
</style-sheet>
