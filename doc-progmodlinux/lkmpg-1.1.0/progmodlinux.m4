% Guía de Programación del Módulos del Núcleo Linux -*- LaTeX -*-
% Copyright (C) 1998-1999 por Ori Pomerantz
%
% Este fichero es libremente distribuible, pero debes mantener este copyright
% en todas las copias, y debe ser distribuido solamente como parte de
% la "Guía de Programación de Módulos del Núcleo Linux". El uso de
% este fichero está cubierto por el Copyright del documento entero, en 
% el fichero "copyright.tex".
%

% m4 Macros para un fichero fuente (uso m4 para poder incluir un fichero con el modo verbatim)

define(`sourcesample', `
\vskip 2ex
\addcontentsline{toc}{section}{$1}
{\large\bf $1}
\index{$1, source file}\index{source}\index{source!$1}

\begin{verbatim}
include(../source/$2/$1)
\end{verbatim}
')

% El estilo del documento
% Versiones viejas
%\documentstyle[times,indentfirst,epsfig,twoside,linuxdoc,lotex]{report}
%\documentclass[times,indentfirst,epsfig,a4paper,linuxdoc,twoside,lotex]{book}
\documentclass[a4paper,spanish]{report}
\usepackage{times,indentfirst,epsfig,linuxdoc,lotex}
% Cabeceras en Español
\usepackage[latin1]{inputenc}
\usepackage{babel}
% Queremos un índice.
\makeindex

% Definiciones Específicas del Documento
\newcommand{\myversion}[0]{1.1.0}
\newcommand{\myyear}[0]{1999}
\newcommand{\mydate}[0]{26 Abril \myyear}
\newcommand{\bookname}[0]{Guía de Programación de Módulos del Núcleo Linux}

%  Definiciones Específicas del Autor

\newcommand{\mycorreoe}{mpg@simple-tech.com}
\newcommand{\myname}{Ori Pomerantz}
\newcommand{\myaddress}{\myname\\
                        Apt. \#1032\\
                        2355 N Hwy 360\\
                        Grand Prairie\\
                        TX 75050\\
                        USA}

\typeout{ * \bookname, \mycorreoe }
\typeout{ * Versión \myversion, \mydate.}


% Banderas Condicionales. Establécelas basándote en cómo estés formateando el libro.
% Para la edición Slackware:
\def\igsslack{1}
% Para la edición ASCII plana:
%\def\igsascii{0}

% Hack de jr, porque latex2html no sabe leer doclinux.sty
\makeatletter
\renewcommand{\lbr}{$\langle$}                  % Signo menor que '<'
\renewcommand{\rbr}{$\rangle$}                  % Signo mayor que '>'
\renewcommand{\tldpes}{{\tt http://www.es.tldp.org}}
\makeatother



% Establece la infomación del título.
\title{\bookname}
\years{\myyear}
\author{\large \myname}
\abstract{Versión \myversion, \mydate. \\
\vskip 1ex
Este libro trata sobre cómo escribir Módulos del Núcleo Linux. Se espera que sea de utilidad
para programadores que saben C y quieren aprender a
escribir módulos del núcleo. Está escrito a la manera de un manual de
instrucciones ``Cómo'' (How-To), con ejemplos de todas las técnicas
importantes.
\\
\vskip 1ex
Aunque este libro toca muchos puntos del diseño del núcleo, no se
supone que venga a cumplir dicho propósito; hay otros libros sobre
el tema, tanto impresos como en el proyecto de documentación de Linux.
\\
\vskip 1ex
Usted puede copiar y redistribuir libremente este libro bajo
ciertas condiciones. Por favor, lea los enunciados del copyright y de la
distribución.
}


% esto es 'especial' para dvips
%\special{papersize=7in,9in}
%\setlength\paperwidth  {7in}
%\setlength\paperheight {9in}

% Tabla de contenidos
\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{2}

% Inicialmente, númeración romana sin números.
\pagenumbering{roman}
\pagestyle{empty}  
\sloppy

%%
%% fin del preámbulo
%%


\begin{document}
\raggedbottom{}
\setlength{\parskip}{0pt}      %quita los espacios entre párrafos

\maketitle

include(copyright.m4)
include(copyright-es.m4)

\setcounter{page}{0}
\pagestyle{headings}
\tableofcontents

% Me gusta que mis introducciones empiecen en el capítulo 0.
\setcounter{chapter}{-1}

% ¡No más numeración Romana!
\setcounter{page}{0}
\pagenumbering{arabic}
% Por fin, el principio REAL
\chapter{Introducción}\label{introduction}

Así que quieres escribir un módulo del núcleo. Sabes C, has
escrito algunos programas corrientes que se ejecutan  como procesos, y
ahora quieres ir donde está la verdadera acción, donde un simple
puntero salvaje puede destruir tu sistema de ficheros y  donde un volcado
de memoria (core dump) significa un reinicio de la máquina.

Bueno, pues bienvenido al club. A mí, en una ocasión un puntero salvaje me hizo un estropicio en
un directorio importante bajo DOS (gracias que ahora significa {\bf
D}ead {\bf O}perating {\bf S}ystem; Sistema Operativo Muerto), y no veo por qué vivir bajo
Linux debería ser algo más seguro que esto\index{DOS}.


{\bf Advertencia:} He escrito esto y verificado el programa bajo versiones
2.0.35 y 2.2.3 del núcleo funcionando en un Pentium. Para la mayor
parte, debería funcionar en otras CPUs y en otras versiones del
núcleo siempre que sean 2.0.x o 2.2.x, pero no puedo 
prometer nada. Una excepción es el capítulo~\ref{int-handler}, que
no debería funcionar en ninguna arquitectura excepto x86.



\section{Quién debería leer esto}\label{who-should-read}

Este documento es para personas que quieran escribir módulos del
núcleo. Aunque trataré en varios sitios sobre cómo se hacen las cosas
en el núcleo, éste no es mi propósito. Hay fuentes bastante buenas
que hacen un trabajo mejor que el que yo pudiera haber
hecho.

Este documento también es para personas que saben escribir
módulos del núcleo pero que no se han adaptado a la versión 2.2 de
éste. Si eres una de estas personas, te sugiero que mires en el
apéndice~\ref{ver-changes} todas las diferencias que he
encontrado mientras actualizaba los ejemplos. La lista está lejos de
ser amplia, pero creo que cubre la mayoría de las funcionalidades
básicas y te bastará para empezar.

El núcleo es un magnífico trabajo de programación, y creo que todo
programador debería leer al menos algunos ficheros fuente del
núcleo y entenderlos. Dicho esto, también creo en el valor de jugar
primero con el sistema y hacer las preguntas después. Cuando aprendo un
nuevo lenguaje de programación, no empiezo leyendo el código de la
biblioteca, sino escribiendo un pequeño programa ``hola, mundo''. No
veo por qué el jugar con el núcleo tendría que ser diferente.


\section{Un apunte sobre el estilo}\label{style-note}

Me gusta poner tantas bromas como sea posible en la documentación.
Estoy escribiendo esto porque me gusta, y asumo que la mayoría de vosotros
estáis leyendo esto por el mismo motivo. Si quieres saltarte este punto, %fuzzy. FVD
ignora todo el texto normal y lee el código fuente. Prometo poner todos
los detalles importantes en destacado.


\section{Cambios}\label{changes}

\subsection{Nuevo en la versión 1.0.1}

\begin{enumerate}
\item{\bf Sección de cambios}, \ref{changes}.
\item{\bf Cómo encontrar el número menor del dispositivo}, \ref{char-dev-file}.
\item{\bf Arreglada la explicación de la diferencia entre
        caracteres y ficheros de dispositivo}, \ref{char-dev-file}
\item{\bf Makefiles para los módulos del núcleo}, \ref{makefile}.
\item{\bf Multiproceso simétrico}, \ref{smp}.
\item{\bf Un Capítulo de ``Malas Ideas'' }, \ref{bad-ideas}.
\end{enumerate}


\subsection{Nuevo en la versión 1.1.0}

\begin{enumerate}
\item{\bf Soporte para la versión 2.2 del núcleo}, todo sobre el sitio.
\item{\bf Ficheros fuente para varias versiones del núcleo}, \ref{kernel-ver}.
\item{\bf Cambios entre 2.0 y 2.2}, \ref{ver-changes}.
\item{\bf Módulos del núcleo en varios ficheros fuente}, \ref{multi-file}.
\item{\bf Sugerencia de no dejar módulos que implementan 
        llamadas al sistema que pueden ser quitadas}, \ref{sys-call}.
\end{enumerate}


\section{Agradecimientos}\label{acknowledgments}

Quisiera agradecer a Yoav Weiss por tantas discusiones e ideas 
útiles, así como por encontrar fallos en este documento antes de su
publicación. Por supuesto, cualquier error remanente es sólo 
culpa mía.

El esqueleto \TeX{} para este libro fue descaradamente robado de la guía
``Linux Installation and Getting Started'', donde el trabajo de \TeX{} fue
realizado por Matt Welsh.

Mi gratitud a Linus Torvalds, Richard Stallman y al resto de las personas que
me dieron la posibilidad de ejecutar un sistema operativo de  calidad en mi
ordenador y obtener el código fuente sin decirlo (vale, de acuerdo:          %fuzzy.FVD
entonces ¿por qué lo dije?).

\subsection{Para la versión 1.0.1}

No he podido relacionar aquí a todo el mundo que me escribió un correo-e, y si te he
dejado fuera lo siento por adelantado. Las siguientes personas fueron
especialmente útiles:

\begin{itemize}

\item{\bf Frodo Looijaard, de Holanda} Por un montón de sugerencias
        útiles, y sobre información sobre los núcleos 2.1.x.
\item{\bf Stephen Judd, de Nueva Zelanda} Correcciones tipográficas.
\item{\bf Magnus Ahltorp, de Suiza} Corrigiendo un fallo mío
	 sobre la diferencia entre dispositivos de bloque y de carácter.

\end{itemize}


\subsection{Para la versión 1.1.0}

\begin{itemize}

\item{\bf Emmanuel Papirakis, de Québec, Canadá} Por portar todos los
        ejemplos a la versión 2.2 del núcleo.
\item{\bf Frodo Looijaard, de Holanda} Por decirme cómo crear un módulo
        del núcleo con varios ficheros (\ref{multi-file}).


\end{itemize}

Por supuesto, cualesquiera errores remanentes son míos, y si piensas que
éstos hacen el libro inutilizable eres bienvenido a apuntarte a recibir
un reintegro total del dinero que me has pagado por él.


\chapter{Hola, mundo}\label{hello-world}

Cuando el primer programador de las cavernas cinceló el primer programa en las
paredes de la primera computadora de las cavernas, era un programa para
imprimir la cadena de caracteres ``Hola, mundo'' en las pinturas de los
Antílopes. Los libros de texto de los romanos sobre programación empezaban con el programa
``Salut, Mundi''. No sé qué puede ocurrirle al que rompa esta tradición, 
y creo que es más seguro no averiguarlo\index{hola mundo}\index{salut mundi}.

Un módulo del núcleo tiene que tener por lo menos dos funciones: {\tt init\_module}
que se llama cuando el módulo se inserta en el núcleo, y {\tt cleanup\_module}
que se llama justo antes de ser quitado.
Típicamente, {\tt init\_module} o bien registra un manejador para algo que tiene que ver con el núcleo, o 
reemplaza una de las funciones del núcleo con su propio código (normalmente código para
hacer algo y luego llamar a la función original). La función {\tt cleanup\_module} 
se supone que deshace lo que {\tt init\_module} ha hecho, de forma que el módulo pueda
ser descargado de una forma segura\index{init\_module}\index{cleanup\_module}.


sourcesample(hello.c, 01_hello)

\section{Makefiles para los módulos del núcleo}\label{makefile}\index{makefile}

Un módulo del núcleo no es un ejecutable independiente, sino un fichero objeto 
que será enlazado dentro del núcleo en tiempo de ejecución. En consecuencia,
deberían ser compilados con la bandera {\tt -c}. También, todos los módulos del
núcleo deberían ser compilados con ciertos símbolos 
definidos\index{compilando}.

\begin{itemize}

\item{\tt \_\_KERNEL\_\_} : Esto le dice a los ficheros de cabeceras que este código
        se ejecutará en modo kernel (núcleo), y no como parte de un proceso de usuario (modo
        usuario\index{\_\_KERNEL\_\_}).

\item{\tt MODULE} : Esto le dice a los ficheros de cabeceras que le den las definiciones
        apropiadas para un módulo del núcleo\index{MODULE}.

\item{\tt LINUX} : Técnicamente hablando, esto no es necesario. Sin embargo, 
        si quisieras escribir un módulo serio que se compile
        en más de un sistema operativo, serás feliz si lo haces. Esto te
        permitirá hacer compilación condicional en las partes que son
        dependientes del S. O.\index{LINUX}.
\end{itemize}


Hay otros símbolos que tienen que ser incluidos, o no, dependiendo de las
banderas con las que se haya compilado el núcleo. Si no estás seguro de cómo
fue compilado el núcleo, mira en 
{\tt /usr/include/linux/config.h}\index{config.h}%
\index{configuración del núcleo}\index{configuración}%
\index{configuración!núcleo}


\begin{itemize}

\item{\tt \_\_SMP\_\_} : Multiproceso simétrico. Esto tiene que estar definido si
        el núcleo fue compilado para soportar multiproceso simétrico (incluso
        si sólo se está ejecutando en una CPU). Si usas Multiproceso simétrico,
        hay otras cosas que tienes que hacer (ver capítulo~\ref{smp}%
\index{\_\_SMP\_\_}).

\item{\tt CONFIG\_MODVERSIONS} : Si CONFIG\_MODVERSIONS estaba habilitado,
        necesitas tenerlo definido cuando compiles el módulo del núcleo e 
        incluir {\tt /usr/include/linux/modversions.h}. Esto también puede
        ser realizado por el propio código\index{CONFIG\_MODVERSIONS}%
\index{modversions.h}.

\end{itemize}


sourcesample(Makefile, 01_hello)

Así que ahora sólo falta hacer {\tt su} a root (no compilaste
como root, ¿a que no? Viviendo en el límite\footnote{El motivo por el que prefiero no
compilar como root es que cuanto menos cosas se hagan como root más seguro estará el 
equipo. Trabajo en seguridad informática, así que soy un paranoico}\ldots), y
entonces haz {\tt insmod hello} y {\tt rmmod hello} para la satisfacción de tu alma. Mientras
lo haces, observa la presencia de tu nuevo módulo del núcleo en 
{\tt /proc/modules}\index{insmod}\index{rmmod}\index{/proc/modules}%
\index{root}.

Por cierto: el motivo por el que Makefile recomienda no hacer {\tt insmod}
desde X es porque cuando el núcleo tiene que imprimir un mensaje con {\tt printk},
lo envía a la consola. Cuando no utilizas X, va al terminal virtual que estás
usando (el que escogiste con Alt-F$<$n$>$) y lo ves. Si utilizas X, en cambio, hay
dos posibilidades:  que tengas una consola abierta con {\tt xterm -C}, en cuyo caso la salida
será enviada allí, o que no, en cuyo caso la salida irá al terminal virtual 7 (el que está
``cubierto'' por X)\index{X}\index{X!porqué las deberías evitar}%
\index{xterm -C}\index{consola}\index{terminal virtual}%
\index{virtual}\index{virtual!terminal}\index{printk}.

Si tu núcleo se vuelve inestable será más probable que cojas los
mensajes de depuración sin las X. Fuera de X, {\tt printk} va
directamente desde el núcleo a la consola. En X, en cambio, 
los {\tt printk}s van a un proceso de modo usuario ({\tt xterm -C}).
Cuando este proceso recibe tiempo de CPU, se supone que lo envía al proceso
servidor de X. Entonces, cuando el servidor X recibe la CPU, se supone que
lo muestra; pero un núcleo inestable normalmente significa que el sistema
se va a estrellar o a reiniciar, por lo tanto no quieres que se retrasen los 
mensajes de error, los que podrían explicarte qué es lo que fue mal,
durante mucho más tiempo del que necesitas. 



\section{Módulos del núcleo de varios ficheros}\label{multi-file}%
\index{varios ficheros fuente}%
\index{ficheros fuente}\index{ficheros fuente!varios}

A veces tiene sentido dividir el módulo del núcleo en varios
ficheros de código. En este caso, tienes que hacer lo siguiente:

\begin{enumerate}

\item{En todos lo ficheros fuente menos en uno, añade la línea
        {\tt \#define \_\_NO\_VERSION\_\_}. Esto es importante porque
        {\tt module.h} normalmente incluye la definición de
        {\tt kernel\_version}, una variable global con la
        versión del núcleo para la que se compila el módulo. Si 
        necesitas {\tt version.h}, tienes que incluirla, porque
        {\tt module.h} no lo hará por ti con {\tt \_\_NO\_VERSION\_\_}%
\index{\_\_NO\_VERSION\_\_}\index{module.h}\index{version.h}%
\index{kernel\_version}.}

\item{Compila todos los ficheros fuente de la forma normal.}

\item{Combina todos los ficheros objeto en uno solo. Bajo x86, hazlo con
        {\tt ld -m elf\_i386 -r -o $<$nombre del módulo$>$.o 
        $<$primer fichero fuente$>$.o $<$segundo fichero fuente$>$.o}\index{ld}%
\index{elf\_i386}.}

\end{enumerate}

He aquí un ejemplo de módulo de este tipo.

sourcesample(start.c, 01_hello/multifile)
sourcesample(stop.c, 01_hello/multifile)
sourcesample(Makefile, 01_hello/multifile)


\chapter{Ficheros de dispositivos de carácter}\label{char-dev-file}%
\index{ficheros de dispositivos de carácter}%
\index{carácter}\index{carácter!ficheros de dispositivos}

Así que ahora somos unos valientes programadores del núcleo y sabemos 
escribir módulos que no hacen nada. Estamos orgullosos
de nosotros mismos y llevamos la cabeza bien alta. Pero
de algún modo sentimos que falta algo. Los módulos catatónicos no son muy
divertidos. 

Hay dos formas principales de que un módulo del núcleo se comunique con
los procesos. Una es a través de los ficheros de dispositivos (como los
que están en el directorio {\tt /dev}) y la otra es usar el sistema de ficheros 
proc. Ya que uno de los principales motivos para escribir algo en el núcleo
es soportar algún tipo de dispositivo de hardware, empezaremos con los
ficheros de dispositivos\index{/dev}.

El propósito original de los ficheros de dispositivo es permitir a los
procesos comunicarse con los controladores de dispositivos en el núcleo, 
y a través de ellos con los dispositivos físicos (módems, terminales, etc.).
La forma en la que esto se implementa  es la 
siguiente\index{físicos}%
\index{físicos!dispositivos}\index{dispositivos físicos}%
\index{modem}\index{terminal}.

A cada controlador de dispositivo, que es responsable de algún tipo
de hardware, se le asigna su propio número mayor. La lista de los controladores 
y de sus números mayores está disponible en {\tt /proc/devices}. A cada dispositivo
físico administrado por un controlador de dispositivo se le asigna un número menor. 
El directorio {\tt /dev} se supone que incluye un fichero especial, llamado
fichero de dispositivo, para cada uno de estos dispositivos, tanto si está  
realmente instalado en el sistema como si no\index{mayor}\index{mayor!número}%
\index{número}\index{número!mayor (del controlador de dispositivo)}%
\index{menor}\index{menor!número}%
\index{número}\index{número!mayor (del dispositivo físico)}.

Por ejemplo, si haces {\tt ls -l /dev/hd[ab]*}, verás todas las particiones
de discos duros IDE que posiblemente estén conectadas a una máquina. Date cuenta de que
todos ellos usan el mismo número mayor, 3, pero el número menor cambia de uno
a otro {\em Nota: Esto es así suponiendo que estás usando una arquitectura PC. No sé
nada sobre dispositivos en Linux ejecutándose en otras arquitecturas}.%
\index{IDE}\index{IDE!discos duros}%
\index{partición}\index{partición!de un disco duro}%
\index{disco duro}\index{disco duro!particiones de}

Cuando el sistema se instaló, todos esos ficheros de dispositivos se
crearon mediante la orden {\tt mknod}. No existe un motivo técnico por el que
tienen que estar en el directorio {\tt /dev}, es sólo una convención útil.
Cuando creamos un fichero de dispositivo con el propósito de prueba, como aquí %fuzzy.FVD
para un ejercicio, probablemente tenga más sentido colocarlo en el directorio
en donde compilas el módulo del núcleo\index{mknod}\index{/dev}.

Los dispositivos están divididos en dos tipos: los dispositivos de carácter
y los dispositivos de bloque. La diferencia es que los dispositivos de
bloque tienen un búfer para las peticiones, por lo tanto
pueden escoger en qué orden las van a responder. Esto es importante
en el caso de los dispositivos de almacenamiento, donde es más rápido leer
o escribir sectores que están cerca entre sí, que aquellos
que están más desperdigados. Otra diferencia es que los dispositivos de
bloque sólo pueden aceptar bloques de entrada y de salida (cuyo tamaño
puede variar según el dispositivo), en cambio los dispositivos
de carácter pueden usar muchos o unos pocos bytes como ellos quieran. %fuzzy. FVD
La mayoría de los dispositivos del mundo son de carácter, porque
no necesitan este tipo de \emph{buffering}, y no operan con un tamaño de
bloque fijo. Se puede saber cuándo un fichero de dispositivo es para un
dispositivo de carácter o de bloque mirando el primer carácter de
la salida de {\tt ls -l}. Si es ``b''  entonces es un dispositivo de bloque,
y si es ``c'' es un dispositivo de carácter.%
\index{ficheros de dispositivo}%
\index{ficheros de dispositivo!carácter}%
\index{ficheros de dispositivo!bloque}%
\index{acceso secuencial}%
\index{secuencial}\index{secuencial!acceso}

Este módulo está dividido en dos partes separadas: la parte del módulo
que registra el dispositivo y la parte del controlador del dispositivo. La
función {\tt init\_module} llama a {\tt module\_register\_chrdev} para
añadir el controlador de dispositivo a la tabla de controladores de 
dispositivos de carácter del núcleo. También devuelve el número mayor
que usará el controlador. La función {\tt cleanup\_module}
libera el dispositivo\index{module\_register\_chrdev}%
\index{número mayor del dispositivo}%
\index{número del dispositivo}\index{número del dispositivo!mayor}.

Esto (registrar y liberar algo) es la funcionalidad general
de estas dos funciones. Las cosas en el núcleo no funcionan por %fuzzy.FVD
su propia iniciativa, como los procesos, sino que son llamados por
procesos a través de las llamadas al sistema, o por los dispositivos
hardware a través de las interrupciones, o por otras partes
del núcleo (simplemente llamando a funciones específicas). Como 
resultado, cuando añades código al núcleo, se supone que es
para registrarlo como parte de un manejador o para un cierto tipo
de evento y cuando lo quitas, se supone que lo liberas.%
\index{init\_module}\index{init\_module!propósito general}%
\index{cleanup\_module}\index{cleanup\_module!propósito general}.

El controlador del dispositivo se compone de cuatro funciones
device\_$<$acción$>$, que se llaman cuando alguien intenta
hacer algo con un fichero de dispositivo con nuestro número mayor. La
forma en que el núcleo sabe cómo llamarlas es a través de la estructura
{\tt file\_operations}, {\tt Fops}, que se dio cuando el
dispositivo fue registrado, e incluye punteros a esas
cuatro funciones\index{file\_operations structure}%
\index{struct file\_operations}.

Otro punto que hemos de recordar aquí es que podemos permitir que 
el módulo del núcleo sea borrado cuando \emph{root quiera}. El motivo es que %fuzzy.FVD
si el fichero del dispositivo es abierto por un proceso y entonces quitamos
el módulo del núcleo, el uso del fichero causaría una llamada a la posición
de memoria donde la función apropiada (read/write) usada debería estar. 
Si tenemos suerte, ningún otro código fue cargado allí, y obtendremos
un feo mensaje. Si no tenemos suerte, otro módulo del núcleo fue cargado 
en la misma posición, lo que significará un salto en mitad de
otra función del núcleo. El resultado sería imposible de predecir, pero
no sería positivo\index{rmmod!previniendo}.

Normalmente, cuando no quieres permitir algo, devuelves un código 
de error (un número negativo) desde la función que se supone que
lo tendría que hacer. Con  {\tt cleanup\_module} esto es imposible porque
es una función void. Una vez que se llama a {\tt cleanup\_module}, el módulo
está muerto. En todo caso, hay un contador que cuenta cuántos otros módulos
del núcleo están usando el módulo, llamado contador de referencia (que es 
el último número de la línea en {\tt /proc/modules}). Si este número es distinto de cero, 
{\tt rmmod} fallará. La cuenta de referencia del módulo está disponible en la
variable {\tt mod\_use\_count\_}. Como hay macros definidas para manejar esta
variable ({\tt MOD\_INC\_USE\_COUNT} y {\tt MOD\_DEC\_USE\_COUNT}), 
preferimos usarlas, mejor que utilizar {\tt mod\_use\_count\_} directamente, por
lo tanto será más seguro si la implementación cambia en el futuro.%
\index{/proc/modules}%
\index{cuenta de referencia}%
\index{mod\_use\_count\_}%
\index{cleanup\_module}%
\index{MOD\_INC\_USE\_COUNT}%
\index{MOD\_DEC\_USE\_COUNT}



sourcesample(chardev.c, 02_chardev)


\section{Ficheros fuente para varias versiones del núcleo}\label{kernel-ver}%
\index{versiones del núcleo}

Las llamadas al sistema, que son el principal interfaz que el núcleo
muestra a los procesos, generalmente permanecen igual de versión
a versión. Se puede añadir una nueva llamada al sistema, pero 
normalmente las antiguas se comportarán igual que de costumbre. 
Esto es necesario para la compatibilidad regresiva; una versión 
nueva del núcleo se supone que {\bf no} romperá con los procesos regulares. En 
la mayoría de los casos, los ficheros de dispositivo también permanecerán igual. En
cambio, las interfaces internas dentro del núcleo pueden y de hecho sufren
cambios entre las versiones.  

Las versiones del núcleo Linux están divididas entre las versiones estables
(n.$<$número par$>$.m) y las versiones en desarrollo (n.$<$número impar$>$.m).
Las versiones en desarrollo incluyen todas las ideas nuevas,  incluyendo aquellas
que serán consideradas un error, o reimplementadas, en la siguiente versión. Como
resultado, no puedes confiar en que la interfaz permanecerá igual en estas
versiones (es por lo que no las tratamos en este libro, es mucho trabajo
y caducarán rápidamente). En las versiones estables, por otro lado, podemos 
esperar que el interfaz permanezca sin cambios sin importar la versión
de corrección de fallos (el número m)%
\index{versión en desarrollo}\index{versión en desarrollo!núcleo}%
\index{versión estable}\index{versión estable!núcleo}.

Esta versión de la GPMNL incluye soporte para la versión 2.0.x y la versión
2.2.x del núcleo Linux. Como hay diferencias entre las dos, esto requiere
compilación condicional dependiendo de la versión del núcleo. La forma con
la que hacemos esto es usando la macro {\tt LINUX\_VERSION\_CODE}. En la versión
a.b.c. del núcleo, el valor de esta macro debería ser $2^{16}a+2^{8}b+c$. 
Para obtener el valor específico de una versión específica del núcleo, podemos
usar la macro {\tt KERNEL\_VERSION}. Como no está definida en 2.0.35, la 
definiremos nosotros mismos si es necesario.%
\index{núcleo 2.0.x}\index{núcleo 2.2.x}\index{versiones soportadas}%
\index{compilación condicionada}%
\index{condicionada}\index{condicionada!compilación}%
\index{LINUX\_VERSION\_CODE}\index{KERNEL\_VERSION}



\chapter{El sistema de ficheros /proc}\label{proc-fs}%
\index{sistema de ficheros proc}%
\index{sistema de ficheros /proc}%
\index{sistema de ficheros}\index{sistema de ficheros!/proc}

En Linux hay un mecanismo adicional para que el núcleo y los módulos del núcleo
envíen información a los procesos: el sistema de ficheros {\tt /proc}.
Originalmente diseñado para permitir un fácil acceso a la información 
sobre los procesos (de aquí el nombre), ahora lo utiliza cualquier elemento del núcleo
que tiene algo interesante que informar, como {\tt /proc/modules} que tiene
la lista de los módulos y {\tt /proc/meminfo} que tiene las estadísticas
de uso de la memoria\index{/proc/modules}%
\index{/proc/meminfo}.

El método para usar el sistema de ficheros proc es muy similar al usado
con los controladores de dispositivos: creas una estructura con toda
la información que necesita el fichero {\tt /proc}, incluyendo punteros 
a cualquier función manejadora (en nuestro caso sólo hay una, la que se
llama cuando alguien intenta leer del fichero {\tt /proc}). Entonces, 
{\tt init\_module} registra la estructura con el núcleo y {\tt cleanup\_module}
la libera.

El motivo por el que usamos {\tt proc\_register\_dynamic}\footnote{En la versión
2.0, en la versión 2.2 esto es realizado automáticamente para nosotros si
establecemos el inodo a cero.} es porque no queremos determinar el número
de inodo usado para nuestro fichero por adelantado, sino permitir al
núcleo que lo determine para prevenir colisiones. Los sistemas de ficheros normales
están localizados en un disco, en vez de en memoria (que es donde está
{\tt /proc}), y en ese caso el número de inodo es un puntero a una posición
de disco donde el nodo índice del fichero (abreviadamente inodo) está localizado. 
El inodo contiene información sobre el fichero, por ejemplo los permisos del
fichero, junto con un puntero a la posición o posiciones del disco donde
se pueden encontrar los datos del fichero\index{proc\_register\_dynamic}%
\index{proc\_register}%
\index{inode}.

Como a nosotros no se nos llama cuando el fichero se abre o 
se cierra, no podemos poner {\tt MOD\_INC\_USE\_COUNT} y {\tt MOD\_DEC\_USE\_COUNT}
en este módulo, ya que si el fichero es abierto y después el módulo es borrado, 
no hay forma de evitar las consecuencias. En el siguiente capítulo veremos
una forma más difícil de implementar, pero más flexible, de tratar con los
ficheros {\tt /proc} que nos permitirá protegernos también de este problema.


sourcesample(procfs.c, 03_procfs)



\chapter{Usando /proc para la entrada}\label{proc-input}%  %yo cambiaría este título. FVD
\index{Entrada}\index{Entrada!usando /proc para}%
\index{/proc}\index{/proc!usando para entrada}%
\index{proc!usando para entrada}

Hasta ahora tenemos dos formas de producir una salida a partir de los módulos del núcleo: podemos
registrar un controlador de dispositivo y {\tt mknod} el fichero de dispositivo, 
o podemos crear un fichero {\tt /proc}. Esto permite al módulo del núcleo 
decirnos cualquier cosa que quiera. El único problema es que no tenemos ninguna forma
de responderle. La primera forma en que enviaremos entrada a los
módulos del núcleo será volviendo a escribir en el fichero {\tt /proc}.

Como el sistema de ficheros proc se escribió principalmente para
permitir al núcleo informar de su situación a los procesos, no hay medidas
especiales para la entrada. La estructura {\tt proc\_dir\_entry} no incluye
un puntero a una función de entrada, de la misma forma que incluye un puntero
a una función de salida. En vez de esto, para escribir en un fichero {\tt /proc}, 
necesitamos usar el mecanismo estándar del sistema de ficheros%
\index{proc\_dir\_entry structure}%
\index{struct proc\_dir\_entry}.

En Linux hay un mecanismo estándar para el registro de sistemas de ficheros. 
Como cada sistema de ficheros tiene que tener sus propias funciones para
manejar las operaciones de inodos y ficheros\footnote{La diferencia entre ellas
es que las operaciones de ficheros tratan con el propio fichero, y las operaciones
de inodo tratan con las formas de referenciar el fichero, tales como crear
enlaces a él.}, hay una estructura especial para mantener los punteros a todas
estas funciones, {\tt struct inode\_operations}, que incluye un puntero
a {\tt struct file\_operations}. En /proc, cuando registramos un nuevo fichero, 
se nos permite especificar qué {\tt struct inode\_operations} se usará para 
acceder a él. Éste es el mecanismo que usaremos, una {\tt struct inode\_operations}
que incluya punteros a nuestras funciones {\tt module\_input} y
{\tt module\_output}%
\index{registro de sistema de ficheros}%
\index{sistema de ficheros!registro}%
\index{struct inode\_operations}%
\index{inode\_operations structure}%
\index{struct file\_operations}%
\index{file\_operations structure}.

Es importante destacar que los papeles estándar de lectura y escritura
están invertidos en el núcleo. Las funciones de lectura se usan para
la salida, mientras que las funciones de escritura se usan para la entrada.
El motivo de esto es que la lectura y escritura se refieren al punto de
vista del usuario: si un proceso lee algo del núcleo, entonces el 
núcleo necesita sacarlo, y si un proceso escribe algo en el núcleo, 
entonces el núcleo lo recibe como entrada\index{lectura}%
\index{lectura!en el núcleo}%
\index{escritura}\index{escritura!en el núcleo}.

Otro punto interesante aquí es la función {\tt module\_permission}. Esta 
función se llama cuando un proceso intenta hacer algo con el fichero
{\tt /proc}, y puede decidir si permitir el acceso o no. Ahora mismo
está solamente basado en la operación y el uid del usuario actual (tal
como está disponible en {\tt current}, un puntero a una estructura
que incluye información del proceso actualmente en ejecución), pero puede
estar basado en cualquier cosa que queramos, como lo que otros
procesos están haciendo con el mismo fichero, la hora del día, o la última
entrada recibida\index{module\_permissions}%
\index{permisos}%
\index{puntero actual}%
\index{actual}\index{actual!puntero}


El motivo para {\tt put\_user} y {\tt get\_user} es que la memoria de Linux
(bajo la arquitectura Intel, quizás sea diferente bajo otros procesadores) 
está segmentada. Esto significa que un puntero, por sí mismo, no referencia
una única posición en memoria, sólo una posición en un segmento
de memoria, y necesitas saber qué segmento es para poder
usarlo. Hay un segmento de memoria para el núcleo, y uno
para cada proceso\index{put\_user}%
\index{get\_user}%
\index{segmentos de memoria}%
\index{memoria}\index{memoria!segmento}.


El único segmento de memoria accesible a un proceso es el suyo, por lo
tanto cuando escribimos programas normales para ejecutarse como procesos no
hay necesidad de preocuparse por los segmentos. Cuando escribes un módulo
del núcleo, normalmente quieres acceder al segmento de memoria del núcleo, 
que es manejado automáticamente por el sistema. Sin embargo, cuando el
contenido de un búfer de memoria necesita passarse entre el proceso
actualmente en ejecución y el núcleo, la función del núcleo recibe un puntero 
al búfer de memoria que está en el segmento del proceso. Las macros
{\tt put\_user} y {\tt get\_user} nos permiten acceder a esa memoria.



sourcesample(procfs.c, 04_procfs2)



\chapter{Hablando con los ficheros de dispositivo (escrituras y IOCTLs)}\label{dev-input}%
\index{ficheros de dispositivo!entrada a}%
\index{entrada a ficheros de dispositivos}%
\index{ioctl}%
\index{escritura!a ficheros de dispositivos}

Los ficheros de dispositivos se supone que representan dispositivos
físicos. La mayoría de los dispositivos físicos se utilizan para
salida y para entrada, por lo tanto tiene que haber algún mecanismo
para que los controladores de dispositivos que están en el núcleo obtengan la salida
a enviar al dispositivo desde los procesos. Esto se hace abriendo
el fichero del dispositivo para salida y escribiendo en él, igual que se
escribe en un fichero. En el siguiente ejemplo, esto se implementa
mediante {\tt device\_write}.

Esto no es siempre suficiente. Imagínate que tienes un puerto serie conectado
a un módem (incluso si tienen un módem interno, todavía se implementa desde
la perspectiva de la CPU como un puerto serie conectado a un módem, por lo
tanto no tienes que hacer que tu imaginación trabaje mucho). Lo natural sería
usar el fichero del dispositivo para escribir cosas al módem (tanto comandos del módem
como datos que se enviarán a través de la línea telefónica) y leer cosas desde el módem
(respuestas a órdenes o datos recibidos a través de la línea telefónica).
De todos modos esto deja abierta la pregunta de qué hacer cuando necesitas hablar con
el puerto serie, por ejemplo para enviarle la velocidad a la que los datos
se envían y se reciben\index{puerto serie}\index{módem}.

La respuesta en Unix es usar una función especial llamada {\tt ioctl} (abreviatura
de {\bf i}nput {\bf o}utput {\bf c}on{\bf t}ro{\bf l}). Cada dispositivo tiene
sus propias órdenes {\tt ioctl}, que pueden leer {\tt ioctl}'s (para
enviar información desde un proceso al núcleo), escribir {\tt ioctl}'s (para
devolver información a un proceso),
\footnote{Ten en cuenta que aquí los papeles de leer y escribir se han intercambiado
{\em otra vez}, por lo tanto en las lecturas {\tt ioctl} se envía información
al núcleo y las escrituras reciben información desde el núcleo.} ambas o ninguna.
La función se llama con tres parámetros; el descriptor del fichero del 
dispositivo apropiado, el número de ioctl, y un parámetro, que es 
de tipo long y al que le puedes hacer una conversión (cast) para
usarlo para pasar cualquier cosa.
\footnote{Esto no es exacto. No podrás pasarle una estructura, por
ejemplo, a través de un ioctl; pero podrás  pasarle un puntero
a la estructura.}

El número ioctl codifica el número mayor del dispositivo, el tipo de la ioctl, 
la orden y el tipo del parámetro. Este número ioctl es normalmente
creado por una llamada a una macro ({\tt \_IO}, {\tt \_IOR}, {\tt \_IOW} o
{\tt \_IOWR}, dependiendo del tipo) en el fichero de cabeceras. Este
fichero de cabeceras debería  ser incluido ({\tt \#include}) tanto en 
los programas que van a usar {\tt ioctl} (para que puedan generar los {\tt ioctl}s
apropiados) como por el módulo del núcleo (para que lo entienda). En el 
ejemplo siguiente, el fichero de cabeceras es {\tt chardev.h} y el 
programa que lo usa es {\tt ioctl.c}\index{\_IO}%
\index{\_IOR}%
\index{\_IOW}%
\index{\_IOWR}

Si quieres usar {\tt ioctl}s en tus propios módulos del núcleo, es mejor
recibir un asignación {\tt ioctl} oficial, por que si accidentalmente coges
los {\tt ioctl}s de alguien, o alguien coge los tuyos, sabrás que algo está mal.
Para más información, consulta el árbol del código fuente del núcleo en
``{\tt Documentation/ioctl-number.txt}''\index{asignación oficial ioctl}%
\index{ioctl!asignación oficial}.


sourcesample(chardev.c, 05_devrw)
sourcesample(chardev.h, 05_devrw)%
\index{ioctl!definiendo}%
\index{definiendo ioctls}%
\index{ioctl!fichero de cabeceras para}%
\index{fichero de cabeceras para ioctls}

sourcesample(ioctl.c, 05_devrw)%
\index{ioctl!usándolo en un proceso}


\chapter{Parámetros de inicio}\label{startup-param}% %este capítulo se cae en la versión 2.4
\index{parámetros de inicio}%
\index{inicio}\index{inicio!parámetros de}


En muchos ejemplos previos, tuvimos que codificar algo en el módulo
del núcleo, tal como el nombre del fichero para los ficheros {\tt /proc}
o el número mayor del dispositivo para el dispositivo para que pudiéramos
hacer ioctls en él. Esto va en contra de la filosofía de Unix, y Linux, 
que es escribir un programa flexible que el usuario pueda configurar%
\index{codificar}.

La forma de decirle a un programa, o a un módulo del núcleo, algo que
necesitan antes de empezar a trabajar es mediante los parámetros de la línea de
órdenes. En el caso de los módulos del núcleo, no disponemos de {\tt argc} 
y {\tt argv}; en cambio tenemos algo mejor. Podemos definir
variables globales en el módulo del núcleo e {\tt insmod} las rellenará por
nosotros\index{argc}\index{argv}.

En este módulo del núcleo definimos dos de ellas: {\tt str1} y {\tt str2}.
Todo lo que necesitas hacer es compilar el módulo del núcleo y entonces
ejecutar {\tt insmod str1=xxx str2=yyy}.
Cuando  se llama a {\tt init\_module}, {\tt str1} apuntará a la cadena de caracteres 
``{\tt xxx}'' y {\tt str2} a la cadena de caracteres ``{\tt yyy}''%
\index{insmod}.

En la versión 2.0 no hay comprobación de tipos de estos argumentos\footnote{No puede
haberlos, ya que bajo C el fichero objeto sólo tiene la localización de
las variables globales, no de su tipo. Esto es por lo que los ficheros
de cabeceras son necesarios}. Si el primer carácter de {\tt str1} o {\tt str2}
es un dígito, el núcleo rellenará la variable con el valor del entero, en vez de
con un puntero a la cadena de caracteres. En una situación de la vida real
tienes que verificar esto\index{comprobación de tipos}.

En cambio, en la versión 2.2 usas la macro {\tt MACRO\_PARM} para decir
a {\tt insmod} lo que esperas como parámetros, su nombre {\em y su tipo}.
Esto resuelve el problema de los tipos y permite a los módulos del núcleo 
recibir cadenas de caracteres que empiezan con un dígito, por ejemplo%
\index{MACRO\_PARM}%
\index{insmod}.

sourcesample(param.c, 06_params)



\chapter{Llamadas al sistema}\label{sys-call}%
\index{llamadas al sistema}%
\index{sistema}\index{sistema!llamadas al}

Hasta ahora lo único que hemos hecho ha sido usar mecanismos bien
definidos del núcleo para registrar ficheros {\tt proc} y manejadores de 
dispositivos. Esto está muy bien si quieres hacer algo que los
programadores del núcleo pensaron que querrías hacer, como escribir un 
controlador de dispositivo. Pero ¿y si quieres escribir algo inusual, 
cambiar el comportamiento del sistema de alguna forma? Entonces, te
encuentras solo.

Aquí es dónde la programación del núcleo se vuelve peligrosa. 
Al escribir el ejemplo siguiente eliminé la llamada al sistema {\tt open}.
Esto significa que no podría abrir ningún fichero, no podría ejecutar
ningún programa, y no podría {\tt apagar} la computadora. Tuve que pulsar
el interruptor. Afortunadamente, no se murió ningún fichero. Para asegurate
de que tú tampoco pierdas ningún fichero, por favor ejecuta {\tt sync} justo
antes de hacer el {\tt insmod} y el {\tt rmmod}%
\index{sync}%
\index{insmod}%
\index{rmmod}%
\index{shutdown}.

Olvídate de los ficheros {\tt /proc}, olvídate de los ficheros de los dispositivos.
Son sólo detalles menores. El mecanismo {\em real} de comunicación entre
los procesos y el núcleo, el que usan todos los procesos, son las
llamadas al sistema. Cuando un proceso pide un servicio al núcleo (tal como
abrir un fichero, ramificarse en un nuevo proceso o pedir más memoria), éste es
el mecanismo que se usa. Si quieres cambiar el comportamiento del núcleo de
formas interesantes, éste es el sitio para hacerlo.  Por cierto, si quieres
ver las llamadas al sistema que usa un programa, ejecuta 
{\tt strace {\lbr}orden{\rbr} {\lbr}argumentos{\rbr}}%
\index{strace}.

En general, un proceso se supone que no puede acceder al núcleo. No
puede acceder a la memoria del núcleo y no puede llamar a las funciones del
núcleo. El hardware de la CPU fuerza esto (por eso
se le llama ``modo protegido'').
Las llamadas al sistema son una excepción a esta regla general. Lo que sucede
es que el proceso rellena los registros con los valores apropiados y entonces
llama a una instrucción especial, que salta a una posición previamente
definida dentro del núcleo (por supuesto, la posición es legible por los procesos
de usuario, pero no pueden escribir en ella). Bajo las CPUs de Intel, esto se hace por
medio de la interrupción 0x80.
El hardware sabe que una vez que saltas a esta localización, ya no te estarás 
ejecutando en el modo restringido de usuario, sino como el núcleo del sistema
operativo. Y entonces se te permite hacer todo lo que quieras%
\index{interrupción 0x80}.

A la posición en el núcleo a la que un proceso puede saltar se le llama {\tt system\_call}.
El procedimiento en esa posición verifica el número de la llamada al sistema, 
que le dice al núcleo qué servicio ha pedido el proceso. Después mira
en la tabla de llamadas al sistema ({\tt sys\_call\_table}) para ver la dirección
de la función del núcleo a llamar. A continuación llama a la función, y después
de retornar hace unas pocas comprobaciones del sistema y luego regresa al proceso (o a un
proceso diferente, si el tiempo del proceso ha finalizado). Si quieres leer
este código, está en el fichero fuente {\tt arch/$<$architecture$>$/kernel/entry.S}, 
después de la línea {\tt ENTRY(system\_call)}%
\index{system\_call}%
\index{ENTRY(system\_call)}%
\index{sys\_call\_table}%
\index{entry.S}.

Por lo tanto, si queremos cambiar la forma en que funciona una cierta
llamada al sistema, lo que tenemos que hacer es escribir nuestra
propia función para implementarla (normalmente añadiendo un poco de
nuestro código y después llamando a la función original) y entonces
cambiar el puntero que está en {\tt sys\_call\_table} para que apunte
a nuestra función. Como es posible que seamos eliminados más tarde y
no queremos dejar el sistema en un estado inestable, es importante que
{\tt cleanup\_module} restaure la tabla a su estado original.

El presente código fuente es un ejemplo de módulo del núcleo. Queremos
``espiar'' a un cierto usuario e imprimir un mensaje (con printk) cuando el
usuario abra un fichero. Para conseguir dicha meta, reemplazamos la llamada
al sistema que abre un fichero con nuestra propia función, llamada {\tt our\_sys\_open}.
Esta función verifica el uid (identificación del usuario) del proceso actual, y
si es igual al uid que queremos espiar, llama a {\tt printk} para mostrar el nombre
del fichero que se va a abrir. Luego llama a la función original {\tt open} 
con los mismos parámetros, para realmente abrir el fichero\index{abrir}\index{abrir!llamada al sistema}.

La función {\tt init\_module} sustituye la localización apropiada que está en
{\tt sys\_call\_table} y mantiene el puntero original en una variable. La función {\tt cleanup\_module}
utiliza dicha variable para devolver todo a su estado normal. Esta aproximación
es peligrosa, por la posibilidad de que dos módulos del núcleo
cambien la misma llamada al sistema. Imagínate que tenemos dos módulos
del núcleo, A y B. La llamada al sistema de A será A\_open y la de
B será B\_open. Ahora, cuando A se inserta en el núcleo, la
llamada al sistema es reemplazada con A\_open, la cual llamará a la 
sys\_open original cuando haya acabado. A continuación, B es insertado en 
el núcleo, que reemplaza la llamada al sistema con B\_open, que a su vez ejecutará
la llamada al sistema que él piensa que es la original, A\_open, cuando haya terminado. 

Ahora, si B se quita primero, todo estará bien: simplemente
restaurará la llamada al sistema a A\_open, la cual llama a la
original. En cambio, si se quita A  y  después se quita B, el
sistema se caerá. El borrado de A restaurará la llamada original al sistema,
sys\_open, sacando a B fuera del bucle. Entonces, cuando B es borrado, restaurará
la llamada al sistema a la que {\bf él} piensa que es la original, A\_open, que ya
no está en memoria. A primera vista, parece que podríamos resolver
este problema particular verificando si la llamada al sistema es igual
a nuestra función open y si lo es no cambiándola (de forma que
B no cambie la llamada al sistema cuando se borre), lo
que causará un problema peor aún. Cuando se borra A, a él le parece que la
llamada al sistema fue cambiada a B\_open y así que ya no apunta a
A\_open, y por lo tanto no la restaurará a sys\_open antes de ser
borrado de memoria. Desgraciadamente B\_open aún intentará llamar a
A\_open, que ya no está allí, por lo que incluso sin quitar B 
el sistema se caerá.
 
Se me ocurren dos formas de prevenir este problema. La primera es restaurar
la llamada al valor original, sys\_open. Desgraciadamente, sys\_open no es
parte de la tabla del sistema del núcleo que está en {\tt /proc/ksyms}, por tanto
no podemos acceder a ella. La otra solución es usar el contador de referencias
para evitar que root pueda borrar el módulo una vez cargado. Esto es
bueno para de módulos de producción, pero malo para un ejemplo
de aprendizaje (que es por lo que no lo hice aquí%
\index{rmmod}\index{MOD\_INC\_USE\_COUNT}%
\index{sys\_open}).

sourcesample(syscall.c, 07_syscall)


\chapter{Procesos bloqueantes}\label{blocks}%
\index{procesos bloqueantes}%
\index{bloqueantes}\index{bloqueantes!procesos}

¿Qué puedes hacer cuando alguien te pregunta por algo que no puedes hacer en el acto?
Si eres un humano y estás te está molestando un humano, lo único
que puedes decir es: ``Ahora no. Estoy ocupado. {\em !`Vete!}''. Pero si eres
un módulo del núcleo y un proceso te está molestando, tienes otra
posibilidad. Puedes poner el proceso a dormir hasta que lo puedas atender.
Después de todo, los procesos son puestos a dormir por el núcleo y todos son 
despertados al mismo tiempo (esta es la forma en la que varios procesos
aparentan ejecutarse a la vez en una sola CPU)%
\index{multi tarea}%
\index{ocupado}.

Este módulo del núcleo es un ejemplo de esto. El fichero (llamado {\tt /proc/sleep})
sólo puede ser abierto por un solo proceso a la vez. Si el fichero ya está
abierto, el módulo del núcleo llama a {\tt module\_interruptible\_sleep\_on}\footnote{
La forma más fácil de mantener un fichero abierto es con {\tt tail -f}.}. Esta
función cambia el estado de la tarea (una tarea es la estructura de datos del
núcleo que mantiene información sobre un proceso y la llamada al sistema en
la que está, si es que está en alguna) a {\tt TASK\_INTERRUPTIBLE}, lo que
significa que la tarea no se ejecutará hasta que sea despertada de alguna forma,
y se añade a {\tt WaitQ}, la cola de tareas esperando acceder al fichero.
Entonces, la función llama al planificador para hacer un cambio de contexto
a un proceso diferente, uno que tenga alguna utilidad para la CPU%
\index{interruptible\_sleep\_on}%
\index{TASK\_INTERRUPTIBLE}%
\index{dormir}\index{dormir!poniendo lo procesos a}%
\index{procesos}\index{procesos!poniendo a dormir}%
\index{poniendo procesos a dormir}%
\index{task structure}%
\index{estructura}\index{estructura!task}.

Cuando un proceso ha acabado con el fichero, lo cierra, y se llama a {\tt module\_close}.
Esta función despierta a todos los procesos en la cola (no hay un
mecanismo para despertar sólo a uno de ellos). Entonces retorna y el
proceso que acaba de cerrar el fichero puede continuar ejecutándose. 
A la vez, el planificador decide que ese proceso ya tuvo suficiente tiempo y le da
el control de la CPU a otro proceso. Eventualmente, a uno de los procesos que
estaba en la cola le será concecido el control de la CPU por parte del planificador.
Éste empieza en el punto justo después de la llamada a {\tt module\_interruptible\_sleep\_on}
\footnote{Esto significa que el proceso aún está en modo núcleo; en lo
que concierne al proceso, éste emitió la llamada al sistema {\tt open}
y la llamada al sistema no ha regresado todavía. El proceso no conoce a nadie
que usara la CPU durante la mayoría del tiempo entre el momento en el que
hizo la llamada y el momento en el que regresó.}. Puede proceder a 
establecer un variable global para decirles a todos los demás procesos que el 
fichero aún está abierto y seguir con su vida. Cuando los otros procesos obtienen
un poco de CPU, verán la variable global y volverán a dormirse%
\index{despertando procesos}%
\index{procesos!despertando}%
\index{multitarea}%
\index{planificador}.

Para hacer nuestra vida más interesante, {\tt module\_close} no tiene el
monopolio de despertar a los procesos que están esperando a
acceder al fichero. Una señal, tal como Ctrl-C ({\tt SIGINT}) también
puede despertar a un proceso\footnote{Esto es porque nosotros
usamos {\tt module\_interruptible\_sleep\_on}. Podíamos haber usado
{\tt module\_sleep\_on} en vez de ella, pero lo que conseguiríamos 
serían usuarios extremadamente enfadados cuyos Ctrl-C's serían ignorados.}
En este caso, queremos regresar inmediatamente con {\tt -EINTR}. Esto es
importante para que los usuarios puedan, por ejemplo, matar el
proceso antes de que reciba el fichero%
\index{module\_wake\_up}%
\index{señal}%
\index{SIGINT}%
\index{ctrl-c}%
\index{EINTR}%
\index{procesos!matando}%
\index{module\_sleep\_on}%
\index{sleep\_on}.

Hay un punto más que recordar. Algunas veces los procesos no quieren dormir, 
quieren o bien coger lo que quieren inmediatamente, o bien que les digan 
que ello no es posible. Tales procesos usan la bandera {\tt O\_NONBLOCK}
cuando abren el fichero. Se supone que el núcleo responde retornando
con el código de error {\tt -EAGAIN} desde operaciones que en caso
contrario se bloquearían, tales como abrir el fichero en este ejemplo. El programa
cat\_noblock, disponible en el directorio fuente de este capítulo, puede 
utilizarse para abrir el fichero con {\tt O\_NONBLOCK}%
\index{O\_NONBLOCK}%
\index{no bloqueante}%
\index{bloqueo, cómo evitarlo}%
\index{EAGAIN}.



sourcesample(sleep.c, 08_sleep)



\chapter{Reemplazando printk's}\label{printk}%
\index{printk!reemplazando}%
\index{reemplazando printk's}

Al principio (capítulo~\ref{hello-world}), dije que X y la programación
de módulos del núcleo no se mezclaban. Esto es verdad para el desarrollo
de módulos del núcleo, pero en el uso real quieres poder
enviar mensajes a cualquiera que sea el tty\footnote{{\bf T}ele{\bf ty}pe,
originalmente una combinación de teclado e impresora usada para comunicarse
con un sistema Unix, y hoy una abstracción para el flujo de texto
usado para un programa Unix, ya sea un terminal físico, un xterm, una
pantalla X, una conexión de red usada con telnet, etc.} de donde vino la orden que
cargó el módulo.

%% Esto es importante para identificar errores después de   % esto se ha caído de la versión final. FVD
%% que el módulo del núcleo es liberado, porque será usado por todos ellos.

La forma de hacer esto es usando {\tt current}, un puntero a la
tarea actualmente en ejecución, para obtener la estructura tty de la
tarea actual. Después miramos dentro de la estructura tty para encontrar
un puntero a una función de escritura de cadenas de caracteres, que usamos
para escribir una cadena de caracteres a la tty%
\index{tarea actual}\index{tarea}\index{tarea!actual}%
\index{tty\_struct}\index{estructura!tty}.


sourcesample(printk.c, 09_printk)



\chapter{Planificando tareas}\label{sched}%
\index{planificando tareas}\index{tareas!planificando}

Muy frecuentemente tenemos tareas ``de labores domésticas'' que tienen
que ser realizadas en un cierto tiempo, o todas frecuentemente.  % every so often ?? FVD
Si la tarea tiene que ser realizada por un proceso, lo haremos
poniéndolo en el fichero {\tt crontab}. Si la tarea es realizada por
un módulo del núcleo, tenemos dos posibilidades. La primera es poner
un proceso en el fichero {\tt crontab} que despertará al módulo
mediante una llamada al sistema cuando sea necesario, por ejemplo
abriendo un fichero. Sin embargo esto es terriblemente ineficiente:
ejecutamos un proceso a partir de {\tt crontab}, leemos un ejecutable
nuevo hacia la memoria, y todo esto para despertar a un módulo del
núcleo que de todas formas está en memoria%
\index{domésticas}\index{crontab}.

En vez de hacer eso, podemos crear una función que será llamada una vez
en cada interrupción del reloj. La forma en la que hacemos esto es
creando una tarea, mantenida en una {\tt estructura tq\_struct}, que
mantendrá un puntero a la función. Entonces usamos {\tt queue\_task}
para poner esta tarea en una lista de tareas llamada {\tt tq\_timer}, que
es la lista de tareas que han de ejecutarse en la siguiente interrupción
de reloj. Como queremos que la función siga siendo ejecutada, 
necesitamos ponerla otra vez en {\tt tq\_timer} al ser llamada, para
la siguiente interrupción del reloj%
\index{struct tq\_struct}\index{tq\_struct struct}%
\index{queue\_task}%
\index{tarea}%
\index{tq\_timer}.

Hay un punto más que necesitamos recordar aquí. Cuando un módulo es quitado
mediante {\tt rmmod}, primero se verifica su contador de referencias. Si es cero, 
se llama a {\tt module\_cleanup}. Entonces se quita el módulo de la memoria
con todas sus funciones. Nadie controla si la lista de tareas del
reloj contiene un puntero a una de estas funciones, que ya no estarán
disponibles. Años después (desde la perspectiva de la computadora; para
la perspectiva de un humano no es nada, menos de una milésima de segundo), el
núcleo tiene una interrupción de reloj e intenta llamar a la función que está en la lista
de tareas. Desgraciadamente, la función ya no está allí. En la mayoría de
los casos, la página de memoria donde residía está sin utilizar, y
obtienes un feo mensaje de error. Pero si algún otro código está ahora
situado en la misma posición de memoria, las cosas podrían ponerse
{\bf muy} feas. Desgraciadamente, no tenemos una forma fácil de eliminar
una tarea de una lista de tareas%
\index{rmmod}%
\index{cuenta de referencia}%
\index{module\_cleanup}.

Como {\tt cleanup\_module} no puede retornar con un código de error (es
una función void), la solución es no dejar que retorne. En vez de ello, 
llama a {\tt sleep\_on} o {\tt module\_sleep\_on}\footnote{Ambas son realmente
lo mismo.} para poner el proceso {\tt rmmod} a dormir. Antes de eso,
informa a la función llamada por la interrupción del reloj para que pare
de apuntarse estableciendo una variable global. Entonces, en la siguiente 
interrupción del reloj, el proceso {\tt rmmod} será despertado, cuando nuestra
función ya no está en la cola y es seguro quitar el módulo%
\index{sleep\_on}\index{module\_sleep\_on}.

sourcesample(sched.c, 10_sched)


\chapter{Manejadores de interrupciones}\label{int-handler}%
\index{manejadores de interrupciones}%
\index{interrupción}\index{interrupción!manejador}

Excepto para el último capítulo, todo lo que hemos hecho hasta ahora en el núcleo ha
sido como respuesta a un proceso que lo pide, ya sea tratando
con un fichero especial, enviando un {\tt ioctl()}, o a través de una llamada
al sistema. Pero el trabajo del núcleo no es sólo responder a las peticiones
de los procesos. Otro trabajo no menos importante es hablar
con el hardware conectado a la máquina.

Hay dos tipos de interacción entre la CPU y el resto del hardware de la
computadora. El primer tipo es cuando la CPU da órdenes al hardware, el
el otro es cuando el hardware necesita decirle algo a la CPU.
La segunda, llamada interrupción, es mucho más difícil de implementar
porque hay que tratar con ella cuando le conviene al hardware, no a la CPU. 
Los dispositivos hardware típicamente tienen una pequeña cantidad de RAM, y
si no lees su información cuando está disponible, se pierde.

Bajo Linux, las interrupciones hardware se llaman IRQs (abreviatura de
{\bf I}nterrupt {\bf R}e{\bf q}uests)\footnote{Esta es una nomenclatura
estándar de la arquitectura Intel donde Linux se originó.}.  Hay dos tipos
de IRQs, cortas y largas. Una IRQ corta es la que se espera que dure un
periodo de tiempo {\bf muy} corto, durante el cual el resto de la máquina estará
bloqueado y ninguna otra interrupción será manejada. Una IRQ larga es una que 
puede durar más tiempo, y durante la cual otras interrupciones pueden ocurrir (pero
no interrupciones que vengan del mismo dispositivo). Si es posible, siempre es mejor
declarar un manejador de interrupciones como largo.

Cuando la CPU recibe una interrupción, detiene lo que quiera que esté haciendo
(a menos que se encuentre procesando una interrupción más prioritaria, en cuyo
caso tratará con esta interrupción sólo cuando la más prioritaria se haya
acabado), salva ciertos parámetros en la pila y llama al manejador de interrupciones.
Esto significa que ciertas cosas no se permiten dentro del propio manejador de interrupciones,
porque el sistema se encuentra en un estado desconocido. La solución a este
problema es que el manejador de interrupciones haga lo que necesite
hacer inmediatamente, normalmente leer algo desde el hardware o 
enviar algo al hardware, y después planificar el manejo de la nueva información
en un tiempo posterior (esto se llama ``bottom half'') y retorna. El núcleo
está garantizado que llamará al bottom half tan pronto como sea posible; y 
cuando lo haga, todo lo que está permitido en los módulos del núcleo estará 
permitido\index{bottom half}.

La forma de implementar esto es llamar a {\tt request\_irq()} para que se llame
a tu manejador de interrupciones cuando se reciba la IRQ relevante
(hay 15 de ellas, más una que se utiliza para disponer en cascada
los controladores de interrupción, en las plataformas Intel). %% ya puestos adaptamos esto de la versión 2.4. FVD
Esta función recibe el número 
de IRQ, el nombre de la función, banderas, un nombre para {\tt /proc/interrupts}
y un parámetro para pasarle al manejador de interrupciones. Las banderas pueden
incluir {\tt SA\_SHIRQ} para indicar que estás permitiendo compartir la IRQ con
otro manejador de interrupciones (normalmente porque un número de dispositivos
hardware están en la misma IRQ) y {\tt SA\_INTERRUPT} para indicar que
esta es una interrupción rápida. Esta función sólo tendrá éxito si no hay ya
un manejador para esta IRQ, o si ya la estais compartiendo%
\index{request\_irq}%
\index{/proc/interrupts}%
\index{SA\_SHIRQ}%
\index{SA\_INTERRUPT}.

Entonces, desde dentro del manejador de interrupciones, nos comunicamos con 
el hardware y después usamos {\tt queue\_task\_irq()} con {\tt tq\_immediate()}
y {\tt mark\_bh(BH\_IMMEDIATE)} para planificar el bottom half. El motivo por el que no podemos usar
la {\tt queue\_task} estándar en la versión 2.0 es que la interrupción
podría producirse en el medio de la {\tt queue\_task} de alguien
\footnote{{\tt queue\_task\_irq} está protegida de esto mediante un bloqueo global;
en 2.2 no hay {\tt queue\_task\_irq} y {\tt queue\_task} está protegida por
un bloqueo.}. Necesitamos {\tt mark\_bh} porque las versiones anteriores de 
Linux sólo tenían un array de 32 bottom half's, y ahora uno de ellos 
({\tt BH\_IMMEDIATE}) se usa para la lista enlazada de bottom half's para
los controladores que no tenían una entrada de bottom half asignada%
\index{queue\_task\_irq}%
\index{queue\_task}%
\index{tq\_immediate}%
\index{mark\_bh}%
\index{BH\_IMMEDIATE}.


\section{Teclados en la arquitectura Intel}\label{teclado}%
\index{teclado}\index{arquitectura Intel}\index{arquitectura Intel!teclado}

% \bf Atención:   %  ya no es un warning. FVD
El resto de este capítulo es completamente específico de Intel. Si
no estás trabajando en una plataforma Intel, no funcionará. Ni siquiera intentes
compilar el siguiente código.


Tuve un problema escribiendo el código de ejemplo para este capítulo. Por
una parte, para que un ejemplo sea útil tiene que ejecutarse en las computadoras de todo
el mundo con resultados significativos. Por otra parte, el núcleo ya incluye
controladores de dispositivo para todos los dispositivos comunes, y esos
controladores de dispositivo no coexistirán con lo que voy a escribir. La
solución que encontré fue escribir algo para la interrupción del teclado, y
deshabilitar primero el manejador normal de interrupción del teclado. Como
está definido como un símbolo estático en los ficheros fuente del núcleo
(concretamente {\tt drivers/char/keyboard.c}), no hay forma de restaurarlo.
Antes de instalar este código, haz en otro terminal {\tt sleep 120 ; reboot}  % insmodear? FVD
si es que valoras en algo tu sistema de ficheros.

Este código se registra para la IRQ 1, que es la IRQ controlada por
el teclado bajo las arquitecturas Intel. Entonces, cuando recibe una
interrupción de teclado, lee el estado del teclado (que es el propósito
 de {\tt inb(0x64)}) y el código de barrido (scan code), que es el valor devuelto por el 
teclado. Tan pronto como el núcleo cree que es factible, ejecuta
{\tt got\_char} que da el código de la tecla usada (los siete primeros bits
del código de barrido) y si ha sido presionado (si el octavo bit es cero) 
o soltado (si es uno)\index{inb}.

%jopé, hay más errores que palabras . FVD


sourcesample(intrpt.c, 11_intrp)


\chapter{Multiproceso simétrico}\label{smp}%
\index{SMP}%
\index{multiproceso}%
\index{multiproceso simétrico}%
\index{proceso}\index{proceso!multi}
 
Una de las formas más fáciles y baratas de aumentar el rendimiento del hardware
es poner más de una CPU en la placa. Esto se puede realizar haciendo que
CPUs diferentes tengan trabajos diferentes (multiproceso asimétrico)
o haciendo que todos se ejecuten en paralelo, realizando el mismo trabajo
(multiproceso simétrico o SMP). El hacer multiproceso 
asimétrico requiere un conocimiento especializado sobre las
tareas que la computadora debe ejecutar, lo que no está a nuestro alcance en
un sistema operativo de propósito general como Linux. En cambio el
multiproceso simétrico es relativamente fácil de implementar%
\index{CPU}\index{CPU!varias}.
 
Por relativamente fácil, quiero decir exactamente eso; no que sea {\em realmente}
fácil. En un entorno de multiproceso simétrico, las CPUs comparten
la misma memoria, y como resultado, el código que corre en una CPU puede
afectar a la memoria usada por otra. Ya no puedes estar seguro de que
una variable que has establecido a un cierto valor en la línea anterior todavía
tenga el mismo valor; la otra CPU quizás haya estado jugando con ella mientras no
mirábamos. Obviamente, es imposible programar algo de esta manera.

En el caso de la programación de procesos esto no suele ser un 
problema, porque un proceso normalmente sólo se ejecutará en
una CPU a la vez\footnote{La excepción son los procesos con hilos, que pueden
ejecutarse en varias CPUs a la vez.}. El núcleo, sin embargo, podría ser
llamado por diferentes procesos ejecutándose en CPUs diferentes.

En la versión 2.0.x, esto no es un problema porque el núcleo entero
está en un gran ``spinlock''. Esto significa que si una CPU está dentro del núcleo
y otra CPU quiere entrar en él, por ejemplo por una llamada al sistema, tiene
que esperar hasta que la primera CPU haya acabado. Esto es lo que hace al SMP en
Linux seguro\footnote{En el sentido de que es seguro usarlo con SMP}, pero 
terriblemente ineficiente.

En la versión 2.2.x, varias CPUs pueden estar dentro del núcleo al mismo tiempo. Esto
es algo que los escritores de módulos tienen que tener en cuenta.

% Espero que alguien me dé acceso a un equipo SMP, así que espero  %
% que la siguiente versión de este libro incluya más información.  % Esto se ha caído en ver 2.4. FVD

% Desgraciadamente, no tengo acceso a un equipo SMP para probar cosas, por lo
% tanto no puedo escribir un capítulo sobre cómo hacerlo correctamente. Si 
% alguien tiene acceso a uno y está deseoso de ayudarme, estaré agradecido. Si
% una compañía me suministrara este acceso, les daría un párrafo gratis en
% el comienzo de este capítulo.


\chapter{Problemas comunes}\label{bad-ideas}

Antes de enviarte al mundo exterior y escribir módulos del núcleo, hay algunas
cosas sobre las que te tengo que avisar. Si me equivoco al avisarte
y sucede algo malo, por favor envíame el problema para que te devuelva
íntegramente lo que me pagaron por tu copia del libro%
\index{política de devolución}.

\begin{enumerate}

\item{\bf Usar bibliotecas estándar.} No puedes hacer esto. En un módulo
        del núcleo sólo puedes usar las funciones del núcleo, que
        son las funciones que puedes ver en {\tt /proc/ksyms}%
\index{bibliotecas estándar}\index{estándar}\index{estándar!bibliotecas}%
\index{/proc/ksyms}\index{ksyms}\index{ksyms!fichero proc}.

\item{\bf Deshabilitar las interrupciones.} 
        Podrías necesitar hacerlo por un momento y es
        correcto, pero si no las habilitas posteriormente, tu sistema se quedará
        muerto y tendrás que apagarlo%
\index{interrupción!deshabilitando}.

\item{\bf Meter tu cabeza dentro de la boca de un gran carnívoro.} Es algo que probablemente no
        tendría por qué advertirte pero pensé que debía hacerlo de
        todas formas, por si acaso.

\end{enumerate}

\appendix

\chapter{Cambios entre 2.0 y 2.2}\label{ver-changes}%
\index{versiones!núcleo}\index{2.2 cambios}

No conozco todo el núcleo tan bien como para documentar todos los cambios.
En el transcurso de la conversión de los ejemplos (o más bien adaptando los cambios
de Emmanuel Papirakis) me encontré con las siguientes diferencias. Las
relaciono aquí, todas juntas, para ayudar a los programadores de módulos (especialmente aquellos
que aprendieron de versiones previas de este libro y que están más familiarizados
con las técnicas que utilizo) a convertirse a la nueva versión.

Un recurso adicional para la gente que quiera convertirse a 2.2 está en
{\tt http://www.atnf.csiro.au/\verb'~'rgooch/linux/docs/porting-to-2.2.html}.


\begin{enumerate}

\item{\bf asm/uaccess.h} Si necesitas {\tt put\_user} o {\tt get\_user} 
        tienes que incluir (\#include) sus ficheros de cabeceras%
\index{asm/uaccess.h}\index{uaccess.h!asm}%
\index{get\_user}\index{put\_user}.

\item{\bf get\_user} En la versión 2.2, {\tt get\_user} recibe tanto el
        puntero a la memoria de usuario como la variable en la memoria
        del núcleo para rellenarla con la información. El motivo por el 
        que esto es así es que {\tt get\_user} ahora puede leer
        dos o cuatro bytes al mismo tiempo si la variable que 
        leemos es de una longitud de dos o cuatro bytes.

\item{\bf file\_operations} Esta estructura ahora tiene una función de borrado
        entre las funciones {\tt open} y {\tt close}%
\index{flush}\index{file\_operations}\index{file\_operations!structure}.

\item{\bf close en file\_operations} En la versión 2.2, la función 
        close devuelve un entero, por lo tanto se permite que falle%
\index{close}.

\item{\bf read y write en file\_operations} Las cabeceras de estas funciones
        han cambiado. Ahora devuelven {\tt ssize\_t} en vez de un entero,
        y su lista de parámetros es diferente. El inodo ya no es un parámetro,
        y en cambio sí lo es el desplazamiento dentro del fichero%
\index{read}\index{write}\index{ssize\_t}.

\item{\bf proc\_register\_dynamic} Esta función ya no existe. En vez de ello, 
        llamas al {\tt proc\_register} normal y pones cero en el campo
        de inodo de la estructura%
\index{proc\_register\_dynamic}\index{proc\_register}.

\item{\bf Señales} Las señales en la estructura de tareas ya no son
        un entero de 32 bits, sino un array de enteros {\tt \_NSIG\_WORDS}%
\index{señales}\index{\_NSIG\_WORDS}.

\item{\bf queue\_task\_irq}  Incluso si quieres planificar una tarea para que
        suceda dentro de un manejador de interrupciones, usa {\tt queue\_task},
        no {\tt queue\_task\_irq}%
\index{queue\_task\_irq}\index{queue\_task}\index{interrupts}%
\index{irqs}.

\item{\bf Parámetros del Módulo} Ya no hay que simplemente declarar los parámetros del
        módulo como variables globales. En 2.2 tienes que usar también {\tt MODULE\_PARM}
        para declarar su tipo. Esto es una gran mejora, porque permite que el módulo
        reciba parámetros de cadenas de caracteres que empiezan con un dígito,
        por ejemplo, sin que esto le confunda%
\index{Parámetros}\index{Parámetros!Módulo}\index{Parámetros de Módulo}%
\index{MODULE\_PARM}.

\item{\bf Multiproceso simétrico} El núcleo ya no está dentro de un
        solo ``spinlock'' grande, lo que significa que los módulos del núcleo tienen
        que tener en cuenta el SMP%
\index{SMP}\index{Multiproceso simétrico}.

\end{enumerate}



\chapter{¿Desde aquí hasta dónde?}\label{where-to}

Podría haber introducido fácilmente unos cuantos capítulos más en este
libro. Podría haber añadido un capítulo sobre cómo crear nuevos sistemas de
ficheros, o sobre cómo añadir nuevas pilas de protocolos (como si hubiera
necesidad de esto; tendrías que excavar bajo tierra para
encontrar una pila de protocolos que no estén soportados por Linux). Podría haber
añadido explicaciones sobre los mecanismos del núcleo que no hemos tocado,
tales como el arranque o la interfaz de discos.

Sin embargo, he escogido no hacerlo. Mi propósito al escribir
este libro era dar una iniciación en los misterios de la
programación de módulos del núcleo y enseñar las técnicas más comunes para
ese propósito. Para la gente seriamente interesada en la programación
del núcleo, recomiendo la lista de recursos del núcleo de Juan-Mariano de Goyeneche que está en
{\tt http://jungla.dit.upm.es/\verb'~'jmseyas/linux/kernel/hackers-docs.html}.
También, como dijo Linus, la mejor forma de aprender el núcleo es leer tú 
mismo el código fuente.

Si estás interesado en más ejemplos de módulos cortos del núcleo, te
recomiendo la revista Phrack. Incluso si no estás interesado en 
seguridad, y como programador deberías estarlo, los módulos del núcleo
son buenos ejemplos de lo que puedes hacer dentro del núcleo, y son
lo bastante pequeños como para que su comprensión no requiera demasiado esfuerzo.

Espero haberte ayudado en tu misión de convertirte en un mejor programador, 
o al menos divertirte a través de la tecnología. Y, si escribes módulos
del núcleo útiles, espero que los publiques bajo la GPL, para que yo
también pueda utilizarlos.


\chapter{Beneficios y servicios}\label{ads}

Espero que a nadie le importen las presentes promociones descaradas. Todo son
cosas probablemente útiles para los programadores noveles de
módulos del núcleo Linux.
        
\section{Obteniendo este libro impreso}\label{print-book}

El grupo Coriolis va a imprimir este libro varias veces en el verano del 99. 
Si ya es verano, y quieres este libro impreso, puedes dejar descansar
a tu impresora y comprarlo encuadernado y reluciente.

include(thankme.m4)

include(gpl.m4)

\chapter{Sobre la traducción}

Este documento es la traducción de ``Linux Kernel Module Programing Guide 1.1.0''
y el proceso de traducción ha sido llevado a cabo por:
\begin{itemize}
\item Traductor: Rubén Melcón Fariña \verb'<'melkon@terra.es\verb'>'
\item Revisor: Óscar Sanz Lorenzo \verb'<'gaaldornik@terra.es\verb'>'
\item Encargado de Calidad: Francisco Javier Fernández \verb'<'franciscojavier.fernandez.serrador@hispalinux.es\verb'>'
\item Traducción posterior: Francisco Vila \verb'<'francisco.vila@hispalinux.es\verb'>'
\end{itemize}


Documento publicado por el proyecto de documentación de Linux ({\tldpes}).


Número de revisión: 0.15 (Agosto de 2003)


Si tienes comentarios y/o sugerencias sobre la traducción, ponte en 
contacto con Francisco Javier Fernández \verb'<'franciscojavier.fernandez.serrador@hispalinux.es\verb'>'

\addcontentsline{toc}{chapter}{Índice}
\input{progmodlinux.ind}
\end{document}
