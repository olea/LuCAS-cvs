%    Introducción al uso de GNU/Linux - Manual para el dictado de cursos 
%    Copyright (C) 2000 Lucas Di Pentima <ldipenti@ciudad.com.ar> 
%			Nicolás César <ncesar@ciudad.com.ar> 
% 
%    This program is free software; you can redistribute it and/or modify 
%    it under the terms of the GNU General Public License as published by 
%    the Free Software Foundation; either version 2 of the License, or 
%    (at your option) any later version. 
% 
%    This program is distributed in the hope that it will be useful, 
%    but WITHOUT ANY WARRANTY; without even the implied warranty of 
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
%    GNU General Public License for more details. 
% 
%    You should have received a copy of the GNU General Public License 
%    along with this program; if not, write to the Free Software 
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 
%%%%%%%%%%%%%%%%%%%%% 
% Sección: StarCalc % 
%%%%%%%%%%%%%%%%%%%%% 
 
 
\section{StarCalc: Hoja de Cálculo} 
 
% La verdad que no sé que meter acá :-( 
 
%Carlos Pérez Pérez {\\tt cperezperez@terra.es} 
 
%*****************************************************
%                           Introducción             *
%*****************************************************

\subsection{Introducción} 
 
Una hoja de cálculo\footnote{También denominada Planilla de Cálculo}
es una herramienta puesta al alcance del usuario para solucionar una
cierta clase de problemas.  Estos problemas van desde llevar el
cálculo de la contabilidad del hogar hasta el ánalisis de datos
estadísticos pasando por un sinfín de posibilidades.  El uso de una
hoja de cálculo queda supeditada a lo que el usuario quiera, pero, hay
situaciones en las que se hace imprescindible el uso de una hoja de
cálculo. Desde llevar la contabilidad de pequeñas empresas, en las que
se requieran sumar grandes cantidades de cifras que la hoja de cálculo
puede hacer automáticamente, utilizarlo para hacer regresiones
estadísticas no excesivamente complejas, llevar el control de pedidos,
de ventas, de \ldots{} .Un largo etcétera cuyo principal punto en
común es el de evitar cálculos manuales tediosos que puedan inducir a
errores.  Definido el problema al que se puede enfrentar el usuario
ahora queda la elección del programa de hoja de cálculo. En el mercado
hay una gran cantidad de paquetes que incorporan hojas de
cálculo. Aquí se expondrá el uso de la StarCalc, la hoja de cálculo
perteneciente al paquete ofimático StarOffice. Pero lo aquí explicado
puede ser aplicado sin esfuerzo al uso de otras hojas de cálculo, como
la Excel.  El lector debe tener en cuenta que aquí no se explican
todas las opciones y características que incorpora StarCalc, sólo se
trata de una introducción al uso de la misma así como una serie de
prácticas en las que se tratará de extender la parte teórica.
 
%**********************************************************
%                    Primeros Pasos                       *
%**********************************************************

\subsection{Primeros Pasos} 
 
\paragraph{Entorno de trabajo.} 
 
El entorno de trabajo de la StarCalc se hace familiar para aquel
usuario que conozca el uso de las hojas de cálculo. Es un entorno
totalmente gráfico e intuitivo desde el principio. En el que podemos
observar una barra de menús donde se encuentran las operaciones que se
pueden hacer con la StarCal. Debajo se hallan una serie de botones que
se usan para acceder más rápida y cómodamente a funciones y acciones
que se encuentran en los menús.

%<Gráfico principal> 
\figura{La hoja de cálculo StarCalc}{StarCalc} 

La zona de menús, allí se posicionan el menú \comando{Archivo},
\comando{Editar}, \comando{Ver}, \comando{Insertar}, \comando{Formato}, 
\comando{Herramientas}, \comando{Datos}, \comando{Ventana} y \comando{Ayuda}.
Dentro decada una de ellas se agrupan las diferentes macros que la
StarCalc tiene predefinidas.

%<Gráfico menu> 
%\figura{Los menús de la StarCalc}{StarCalcMenus}

La siguiente zona está conformada por una serie de botones que permiten el
acceso  rápido a funciones definidas. Este área también se extiende a la parte
izquierda de  la pantalla. 
 
%<Gráfico botones> 
\figura{Barra de botones superiores}{StarCalcBotones}
\figura{Barra de botones laterales}{StarCalcBotonesLaterales}

Luego se nos presenta la zona de trabajo, esto es, la parte destinada a la
introducción,  modificación, cálculo y presentación de datos. 
 
%<Gráfico trabajo> 
\figura{Zona de trabajo}{StarCalcTrabajo}

La última zona está conformada por una línea en la que se presentan una serie
de datos  sobre características generales de la hoja en la que estemos
trabajando.   

%<Gráfico parte baja>
%\figura{Línea inferior}{StarCalcLinea}

%*************************************************************
%                   Creación de Nuevas Hojas                 *
%*************************************************************
 
\paragraph{Creación de nuevas hojas} 
Para crear una nueva hoja se puede recurrir a varias formas de
hacerlo. Por un lado se puede hacer doble click en el icono de
\comando{Nueva Hoja de Cálculo} dentro del escritorio del entorno
StarOffice. También se puede crear en el menú
\comando{Archivo}, submenú \comando{Nuevo}, y elegir \comando{Hoja de 
cálculo}. Otra forma es utilizar las plantillas, para ello se puede
acceder al menú \boton{Archivo}, submenú \comando{Nuevo}, y
\comando{Plantillas}, o también presionar \boton{Ctrl+N}.

%Moverse por la hoja de Cálculo. 
\emph{Selección de celda.} 
Las celdas dentro de la hoja se pueden seleccionar bien usando el
ratón o con el teclado. Con el ratón se presiona en la celda de inicio
y, sin soltar, se extiende la selección moviendo el ratón hasta llegar
a la celda final que se quiere seleccionar. Con el teclado, se
posiciona con las teclas de dirección sobre la celda a selccionar y se
presiona la teclas mayúsculas.  Sin soltar dicha tecla se selccionan
las celdas deseadas con las teclas de dirección.

Para seleccionar celdas que no sean contiguas se utilizará el ratón y
la tecla control. Se selecciona el primer rango de celdas o una sola,
y a continuación se seleccionan las celdas o rangos deseados sin
soltar la tecla control.  Para el caso en el que la selección de
celdas quede fuera de las ventanas, hay que hacer notar que el
movimiento es automático y no se necesita preocuparse hasta dónde
llegar.  Las columnas y filas se pueden selccionar enteras si se
presiona sobre el rótulo de fila o columna.
 
\paragraph{Abrir hoja desde archivo} 
%Las maneras de recuperar el trabajo (de otro o nuestro). 
Para recuperar un trabajo desde el lugar donde esté almacenado
acudiremos al menú \comando{Archivo} y \comando{Abrir} con lo que
aparecerá el cuadro de opciones para recuperar el archivo.

\figura{Recuperar archivo}{StarCalcAbrir}

Se puede acceder al cuadro de diálogo de abrir archivo presionando
\boton{Ctrl+O}.

%*****************************************************************
%                   Introducción de datos                        *
%*****************************************************************

\paragraph{Introducción de datos.} 
 
%Manera adecuada de poner los datos en las celdas :) 
 
Se aceptan dos grandes tipos: constantes y fórmulas.  Las constantes
se dividen en: valores numéricos, de texto y de fecha y hora.  Para
los valores numéricos y de texto se aceptan: Números del 0 al 9 y
ciertos carácteres especiales, tales como +-E e () . ,
\$ \% y /. Las restantes entradas se considerarán de texto. Si se quiere 
utilizar un valor numérico como texto se antepondrá el signo ' y luego
se introduce el valor.

Para introducir datos nos situaremos en la celda adecuada presionando
en ella y escribiremos aquello que queramos.
 
StarCalc puede ayudarnos a introducir datos, por ejemplo, en series de
números podemos poner el primer número y seleccionar la celda. En la
parte inferior derecha hay un punto negro, al seleecionarlo el puntero
del ratón se convierte en una cruz, arrastrándolo hacia donde
queramosponer los datos se extenderá la selección y la StarCalc sumará
automáticamentelos siguientes datos. En el caso de que los número no
sean correlativos se pueden poner los dos primeros números de la serie
y la StarCalc hará el resto.
 
Se puede hacer lo mismo con los nombres de los meses, si se introduce
enero, y siguiendo el procedimiento anterior se conseguirá que vaya
escribiendo todos los meses. La StarCalc muestra un rótulo al lado
del puntero del ratón, de esta manera sabremos hasta dónde llegar sin
tener que hacer cálculos mentales.

\paragraph{Protección de datos.} Se pueden proteger libros enteros u hojas
individuales, de manera que se permita acceso de sólo lectura o sin
acceso. A través del menú \comando{Herramientas} y \comando{Proteger}.
También se pueden proteger y desproteger celdas individuales.
 
%*************************************************************************
%                            Construcción de Fórmulas                    *
%*************************************************************************

\paragraph{Construcción de fórmulas.}
 
Creación de fórmulas para la transformación de los datos.
 
Se selecciona una celda vacía y se introduce el signo igual precedido
de la expresión aritmética a utilizar. Por ejemplo, para sumar 3 y 6
pondremos:
\[=3+6\]
 
\emph{Precedencia de los operadores:}
\begin{itemize} 
\item Se procesan primero las expresiones entre paréntesis. 
\item Se ejecutan la multiplicación y la división antes de la suma y la resta. 
\item Los operadores del mismo nivel se calculan de izquierda a derecha. 
\end{itemize}

\emph{Los paréntesis.} 
Hay que incluir un paréntesis cerrado por cada uno que se abra.

\emph{Referencias a las celdas.}
Dentro de una fórmula nos podemos referir a una celda de diferentes
maneras.  Escribiendo A1 haremos referencia a la celda de la fila 1
columna A, que también puede ser seleccionada con el ratón.  En este
punto hay que diferenciar el tipo de referencia que se va a utilizar.

\emph{Referencias relativas.} 
Se refieren a las celdas por sus posiciones en relacción a la celda
que contiene la fórmula. De esta manera la celda A1 se convertirá en
B2 si la fórmula se mueve una fila hacia debajo y una columna hacia la
derecha.

\emph{Referencias absolutas.} 
Se identifica a la celda por su posición fija, la fórmula hará
referencia siempre a la misma celda aunque se mueva la fórmula. La
manera de hacer esto es utilizando el signo \$. Esto es, \$A\$1 hace
referencia a la fila 1 columna A en todo momento. A\$1 hará referncia
a la fila 1 simpre y a la columna se calculará de forma relativa a la
fórmula. El caso contrario sería \$A que mantendría fija la columna.
Nótese que se puede hacer referencia a cualquier celda dentro del
libro de trabajo.
 
%<Ver si se puede en otros libros>. 

\emph{Uso de funciones.}  Las funciones tal y como las hemos visto pude que
no tengan demasiado sentido si se trata, por ejemplo, de sumar una
gran cantidad de celdas:
\[=A1+A2+A3+A4+A5+A6+A7+A8+A9+A10+A11+A12\]
por eso se pueden utilizar las fórmulas que provee la StarCalc
\[=SUMA(A1:A12)\]
 
Se puede utilizar cualquier función definida dentro de la StarCalc
pasándole los parámetros adecuados. Sin embargo, no se pueden conocer
o retener todas las funciones que tiene la hoja, por eso se puede
utilizar insertar función que presentará un cuadro con las distintas
funciones existentes, una pequeña explicación y los parámetros que se
necesitan.

%****************************************************************
%                        Formateo de la Hoja                    *
%****************************************************************

\paragraph{Formateo de la hoja.} 
%Utilización de los formatos de datos correctos y adecuados. 

%****************************************************************
%                     Impresión y Presentación			*
%****************************************************************

\paragraph{Impresión y presentación.}
%Imprimir documentos y presentación en pantalla
%(eso de los colores y las líneas).
El uso de la impresión dentro de la StarCalc sigue el mismo esquema que en el
resto de la suite StarOffice. Seleccionaremos el menú \comando{Archivo} e
\comando{Imprimir}, también podemos presionar las teclas \boton{Ctrl+P}. En
ambos casos se mostrará un cuadro de diálogo. En el caso de que no necesitemos
ajustar las propiedades presionaremos \boton{Aceptar} y StarCalc mandará el
trabajo a la cola de impresión.
 
%****************************************************************
%                        Salvando nuestro esfuerzo              *
%****************************************************************

\paragraph{Salvando nuestro esfuerzo.} 
%Formas de grabar en un archivo lo que hayamos hecho. 
Para guardar los datos con los que estamos trabajando acudiremos a
\comando{Archivo} y \comando{Guardar} o \comando{Guardar como} si
queremos guardarlo bajo otro nombre. En el caso de que el archivo
sea nuevo se nos presentará el diálogo de guardar como para indicar
a la StarCalc bajo que nombre y tipo de archivo deseamos que sea
salvado nuestro trabajo.

%***************************************************************
%                     Análisis de Datos                        *
%***************************************************************

\subsection{Análisis de Datos} 
%Análisis de datos. 
%3.1. Funciones Comunes. 
 
\paragraph{Funciones comunes.} 
%Las funciones que ofrece la StarCalc 
Sintaxis de las funciones: 
Las funciones presentas dos partes diferenciadas, por un lado, el nombre de la 
función, por el otro, sus argumentos. Los argumentos de una función deben estar 
entre paréntesis inmediatamente después del nombre de la fucnión y su cantidad 
dependerá del tipo de función que se use. También hay que destacar el hecho que 
dentro de los argumentos se pueden incluir tanto otras funciones, con sus propios 
argumentos, como valores numéricos, valores de texto o valores lógicos, así como 
matrices y valores de error. 
La forma más sencilla de insertar funciones es usándo el autopiloto de funciones que 
se encuentra en el menú insertar, función, presionando las teclas
\boton{Ctrl+F2} o usándo el  botón que se encuentra en las barras de botones,
dónde se introducen las fórmulas.  Aquí no se van a exponer todas las
funciones que existen e la StarCalc, para ver  todas las funciones que la hoja
puede ofrecer puede consultar el Autopiloto de Funciones,  allí las encontrará
agrupadas según el uso que se les quiera dar.

\figura{Autopiloto de funciones.}{StarCalcFunciones}

\paragraph{Fechas y horas.} 
%Manipulación de fechas para presentación y utilización en cálculos. 
Fechas y horas. 
Las fechas se introducen directamente en las celdas siguiendo alguno de los siguientes 
formatos que son perfectamente legibles por StarCalc: d/mm/aa; d-mmm-aa, d--mmm o mmm-aa. 
Paraconseguir 5 de Noviembre el año 2000, teclearemos \comando{5-nov-2000} y se
nos mostrará tal cual  la hemos introducido. En aquellos formatos en los que se
omita alguna parte de la  fecha se tratarán de distinta manera, así si falta
el día se introduce automáticamente  el día primero, si es el año se introduce
el año en curso. Nótese que no puede faltar  el mes en los formatos
presentados.  Para introducir series de fechas utilizaremos lo aprendido en la
sección de introducción  de datos, esto es, podemos extender la selección
automáticamente con el ratón.  Para la introducción de horas se pueden seguir
los siguientes formatos: h:mm AM/PM; h:mm;ss AM/PM;  h:mm; h:mm:ss; mm:ss.0;
[h]:mm:ss.  El lector interesado puede mirar el Autopiloto de funciones donde
se encuentran algunas funciones  para utilizar y transformar fechas. 
 
\paragraph{Análisis financiero.} 
%Cálculo de TAE, VAN, TIR, rentabilidades, intereses, etc. 
Análisis financiero. 
En una hoja de cálculo no podían faltar las funciones referidas a operaciones financieras, tales 
como el valor actual neto o la tasa interna de retorno. Estas funciones son muy utilizadas en 
entornos empresariales y para el usuario doméstico que de esta forma puede calcular el rendimiento 
de sus ahorros o si la inversión en la compra de una casa es factible. 
en esta sección también se debe hacer referencia a las funciones de depreciación, cálculo de la 
tasa de retorno y análisis de valores bursátiles. En este último caso, desarrollaremos un método 
de análisis de acciones y opciones en la parte teórica que no hace uso de las funciones que 
propone la StarCalc. 
 
\paragraph{Análisis estadístico.} 
%Cálculos de medias, modas, varianzas, regresiones, etc. 
Análisis estadístico. 
StarCalc utiliza funciones estadísticas predefinidas con las que puede calcular multitud de aspectos 
sobre poblaciones. Así tenemos funciones como media, modas, medianas, rango, histogramas, frecuencias 
covarianzas, coeficiente de correalción, desviación típica, distribuciones estándar, binomial, exponencial, 
normal, ji, poisson, regresiones lineales, entre otras. Cuya utilización será de utilidad 
para aquellas personas que requieran el uso de cálculos estadísticos. 
 
%*********************************************************************
%                              Gráficos                              *
%*********************************************************************

\subsection{Gráficos} 
%Creación de gráficos para la mejor comprensión de los datos. 
%Gráficos. 
Como dice el refrán, más vale una imagen que mil palabras. Por eso 
la StarCalc provee una serie de herramientas que permiten convertir los datos 
en gráficos para una mejor comprensión. 
 
Creación de un nuevo gráfico. 
Lo primero es seleccionar los datos que se desean representar para luego ir a 
\comando{Diagrama} en el menú \comando{Insertar}. 
Se nos mostrará un cuadro pidiendo los datos, estos serán los que hemos seleccionado 
o cualquier rango que podemos ingresar manualmente.
En este punto podremos seleccionar si queremos nuestro gráfico en la misma hoja o en 
una nueva hoja. Presionaremos \boton{Avanzar} y se nos mostrará el cuadro de
diálogo para seleccionar  el tipo de gráfico que vamos a utilizar.

\figura{Selección del tipo de gráfico}{StarCalcDiagramaSeleccion}
 
Una vez seleccionado el tipo de gráfico y la variante que vayamos a utilizar, se nos presenta 
un cuadro en el que podremos introducir los títulos que van a acompañar el gráfico. 

\figura{Titulos del gráfico}{StarCalcDiagramaTitulos}

Tras lo cual seleccionaremos \boton{Crear} y se nos presentará el gráfico
dentro de la hoja activa,  o en una hoja nueva si es lo que hemos seleccionado
previamente.  Podremos trabajar directamente sobre el gráfico utilizando el
botón derecho del ratón o el menú  de formato que nos permitirá personalizar
el gráfico. 

\emph{Personalización de gráficos.}
Presionando con el botón derecho elegiremos la opción del menú
\comando{Editar}. De esta manera  activaremos el gráfico y podremos utilizar
las funciones de personalización sobre  aquellas zonas del gráfico que
deseemos cambiar. Para ello seleccionaremos la parte  del gráfico a cambiar y
seleccionaremos la opción \comando{Propiedades del Objeto} que se nos  muestra
con el botón derecho del ratón o dentro del menú \comando{Formato}.  Ha de
hacerce notar que se pueden utilizar la hilera de botones verticales que se
encuentran  en la parte izquierda de la pantalla y que nos permiten acceder a
opciones del gráfico  de forma más rápida.

\figura{Personalización de gráficos}{StarCalcDiagramaGraficoCambioPropiedades}

%***********************************************************************
%              Gestión de bases de datos y listas                      *
%***********************************************************************

\subsection{Gestión de bases de datos y listas} 
%Utilizar la StarBase para usar con la StarCalc. Utilización de las 
%listas. 
La utilización de listas es muy común en las hojas de cálculo (clientes, teléfonos, etc.) 
Las lista deben cumplir una serie de características para que su utilización sea lo 
más efectiva posible.

\begin{itemize} 
\item Cada columna debe contener el mismo tipo de información. 
\item La primera fila deben ser rótulos de descripción del contenido. 
\item No debería haber columnas o filas en blanco en la lista. 
\item Para el uso de filtros no debería haber otra información en las filas que ocupe la misma. 
\end{itemize} 

%Gestión de bases de datos y listas. 
%Utilizar la StarBase para usar con la StarCalc. Utilización de las 
%listas. 
 
La utilización de listas es muy común en las hojas de cálculo (clientes, teléfonos, etc.) 
Las lista deben cumplir una serie de características para que su utilización sea lo 
más efectiva posible. 
\begin{itemize} 
\item Cada columna debe contener el mismo tipo de información. 
\item La primera fila deben ser rótulos de descripción del contenido. 
\item No debería haber columnas o filas en blanco en la lista. 
\item Para el uso de filtros no debería haber otra información en las filas
que ocupe la misma.
\end{itemize}

Para crear una lista a partir de los datos de una hoja vamos al \comando{Piloto
de Datos} en el  menú de \comando{Datos}.  Se nos mostrá el cuadro de
seleccionar fuente.

%<Gráfico>

Presionando aceptar se nos mostrará  el cuadro de Pilot de Datos
donde colocaremos por el método arrastar y soltar los datos que  queramos que
se muestren. En el botón de \boton{Opciones} podremos acceder a una serie de
características  para afinar aún más la lista.   
\emph{Ordenación de listas.}
Para ordenar listas sólo tenemos que seleccionar el área a ordenar y elegir
\comando{Ordenar} dentro del menú  de \comando{Datos} e indicar el método de
ordenación y la columna por la que se ordenará, entre otras opciones  de
personalización. Se debe tener en cuenta que hemos de seleccionar la opción de
Área contiene  encabezamientos de columna para que no ordene los encabezados
junto con los datos. Para esto  seleccionaremos la solapa de Opciones dentro
del cuadro \boton{Ordenar} y marcaremos la opción \boton{Área} contiene 
encabezamientos de columna, a continuación aceptaremos y se creará la lista.   

\emph{Filtrado de listas.}
Con el uso de filtros dentro de las listas conseguiremos analizar aquellos datos que interesan. 
Por eso, al crear la lista se añade un botón denominado \boton{Filtro} que
permite definir los  datos que se van a mostrar dependiendo de aquellos datos
que se busquen.   
\emph{Bases de datos.}
StarCalc puede trabajar conjuntamente con bases de datos profesionales. Se pueden importar tablas 
desde bases de datos que StarOffice tenga registradas para trabajar directamente con listas. 
En la versión 5.2 de StarOffice se instala por defecto el soporte para Adabas siempre y cuando 
dicha base de datos se encuentre en el sistema. El uso de bases de datos tiene su tratamiento 
en la sección de StarBase. 
 
%*************************************************************************
%                            Tablas dinámicas                            *
%*************************************************************************

\subsection{Tablas dinámicas} 
%Creación de tablas dinámicas para que el cálculo de datos 
%se automático. 
Es un tipo especial de tabla que resume la información de ciertos campos de una lista o 
base de datos. 
Las tablas dinámicas están vinculadas a los datos de los que proceden. Cuando dichos datos 
cambian, la tabla no se recalcula automáticamente, pero se puede actualizar en cualquier momento. 
 
%**************************************************************************
%                              Macros y StarBasic                         *
%**************************************************************************
\subsection{Macros y Starbasic} 
%Creación de Macros y utilización del lenguaje de macros StarBasic. 
%Esto se hará de forma bastante esquemática. :-( 
 
%**************************************************************************
%                            PARTE DE PRÁCTICAS                           *
%**************************************************************************

\subsection{De prácticas} 
En estas prácticas se pretenden enseñar rudimentos de la utilización 
de hojas de cálculo. Así como técnicas que no se enseñan en la parte 
teórica. 
Se presentan de menor a mayor dificultad. Exceptuando las dos últimas 
que son casos aparte. 
 
\paragraph{Control de ingresos y gastos.} 
Objetivo. Llevar la contabilidad doméstica. 
Don Rufino Pensante no sabía por dónde se le escapa el dinero que 
ganaba con su trabajo en una tienda de caramelos así que decidió 
montar un sistema de contabilidad doméstica para llevar un orden y 
control de todo el dinero que pasaba por sus manos. 

\begin{tabular}{|l|r|r|r|r|r}
Mes & Enero & Febrero & Marzo & Abril & Mayo\\
Sueldo & 145.000 & 145.000 & 145.000 & 145.000 & 145.000\\
Vivienda & 30.000 & 31.000 & 30.000 & 29.000 & 32.000\\
Comida & 40.000 & 43.000 & 46.000 & 39.000 & 41.000\\
Coche & 15.000 & 6.000 & 16.000 & 8.000 & 9.000\\
Agua & 7.000 & 8.000 & 6.000 & 4.000 & 9.000\\
Luz & 11.000 & 10.000 & 12.000 & 9.000 & 10.500\\
Varios & 10.000 & 18.000 & 11.000 & 8.000 & 11.000\\
\end{tabular}

\paragraph{Productos de financiación.} 
Objetivo. Calcular las mensualidades del pago de un préstamo o el  
rendimiento de los ahorros. 
 
\paragraph{Análisis de proyectos de inversión.} 
Objetivo. Ayuda a la toma de decisiones en inversiones. 
 
\paragraph{Seguimiento de Acciones y opciones.} 
Objetivo. Ver la evolución de los títulos de acciones y opciones que 
tengamos :-) . Modelo Black-Scholes. 
 
\paragraph{Análisis de tendencia.} 
Objetivo. Calcular las previsiones para años futuros dada una serie de 
datos con un modelo sencillo. 

%*********************************************************************
%                                 El final                           *
%*********************************************************************

%\subsection{Bibliografía}
%De donde he sacado todo lo de arriba.
 
%\subsection{Agradecimientos}
%Lo que proceda. Aunque no sé si corresponde aquí.
