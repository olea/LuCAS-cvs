<?php
$cursos_dirs=array(
		   array("contenido/Introduccion","Introducción","1",true),

		   array("contenido/TextoVsGrafico","TxtVsGrf","2",true),
		   array("contenido/ServidorX","Servidor X","3",true),
		   array("contenido/MultiusuarioMultitareaQueEs","Multiusuario / Multitarea","4",true),

		   array("contenido/KDE2","KDE 2","5",true),
		   array("contenido/KDE2/Configuracion","KDE2 - Configuracion","6",true),
		   array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio","KDE2 - Escritorio","7",true),
		   array("contenido/KDE2/Configuracion/ConfiguracionDelPanel","KDE2 - Configuracion del Panel","8",true),

		   array("contenido/Login","Login","9",true),
		   array("contenido/PermisosDeUsuario","Permisos de usuario","10",true),



		   array("contenido/Internet","Internet","11",true),
		   array("contenido/CorreoElectronico","Correo Electronico","12",true),
		   
		   array("contenido/Editores","Editores","13",true),
		   array("contenido/Editores/vi","Editores - vi","14",true),
		   array("contenido/Shell","Shell","15",true),
		   array("contenido/Comandos","Comandos","16",true),
		   array("contenido/Administracion","Administracion del sistema","17",true),
		   
		   array("contenido/RPMYPaquetes","RPM y paquetes","18",true),

		   array("contenido/Mandrake","Mandrake","19",false),
		   array("contenido/Mandrake/configura","Mandrake - Configuracion","20",false),
		   array("contenido/Mandrake/instala","Mandrake - Instalación","21",false),

		   array("contenido/CorreoElectronico/Sendmail","Sendmail","22",true),
		   array("contenido/ServidoresDeNoticias","Servidor de Noticias","23",false),		   

		   array("contenido/Apache","Apache","24",true),
		   array("contenido/Samba","Samba","25",true),

		   array("contenido/PersonalizandoElKernel","Personalizando el Kernel","26",false),
		   array("contenido/PersonalizandoElKernel/Modulos","Modulos del Kernel","27",false),

		   array("contenido/KDE1","KDE 1 (obsoleto)","28",false),
		   array("contenido/KDE1/Configuracion"," KDE1 - Configuracion (obsoleto) ","29",false),
		   array("contenido/KDE1/Configuracion/Ventanas","KDE1 - Conf. Ventanas (obsoleto)","30",false),
		   array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio","KDE1 - Escritorio (obsoleto)","31",false),
		   array("contenido/KDE1/Configuracion/ConfiguracionDelPanel","KDE1 - Panel (obsoleto)","32",false),
		   array("contenido/StarOffice","Star Office 5.1 (obsoleto)","33",false),

		   array("contenido/DocumentacionYAyuda","Documentacion y Ayuda","34",true),
		   array("contenido/DocumentacionYAyuda/Enlaces","Documentacion y Ayuda - Enlaces","35",true),
		   array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales","Documentacion y Ayuda - Grupos locales","36",true),
		   array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres","Documentacion y Ayuda - Sitios de interés","37",true),

		   array("contenido/Agradecimientos","Agredecimientos","38",true),
		   array("contenido/Licencia","Licencia","39",true),

);

$cursos_array=array( 


/*
 *		--- Introducción --- (capítulo)
 */



array("contenido/Introduccion/Presentacion.tex","Presentación","1"), // (No se adapta a lo que es actualmente el curso)
array("contenido/Introduccion/Descripcion.tex","¿Qué es GNU/Linux?","1"),
array("contenido/Introduccion/Historia.tex","Historia","no"),
array("contenido/Introduccion/OrigenLinuxYQuienEsLinusTorvalds.tex","¿De dónde salió Linux?, ?'Quién es Linus Torvalds?","no"),
array("contenido/Introduccion/UnixYLinuxTienenAlgoQueVer.tex","UNIX y GNU/Linux... ¿tienen algo que ver?","1"),
array("contenido/Introduccion/Distribuciones.tex","Distribuciones","no"),
array("contenido/Introduccion/DiferenciasWindowsLinux.tex","Diferencias entre Windows y Linux","1"),
array("contenido/Introduccion/CompetenciaLinuxVsWindows.tex","Competencia de GNU/Linux vs Windows","1"),



/*
 *		--- TextoVsGrafico --- (capítulo)
 */



array("contenido/TextoVsGrafico/Introduccion.tex","Introducción","1"),
array("contenido/TextoVsGrafico/VentajasYDesventajas.tex","Ventajas y desventajas","1"),
array("contenido/TextoVsGrafico/Requerimientos.tex","Requerimientos","1"),
array("contenido/TextoVsGrafico/UsoDeTerminalesDeTextoEnEntornoGrafico.tex","Texto en entornos gráficos","1"),



/*
 *		---	Instalación de GNU/Linux --- (capítulo)
 */



//	-- Mandrake -- (sección)


array("contenido/Mandrake/iniciando.tex","Iniciando la instalación","no"),
array("contenido/Mandrake/lista_paquetes_mdk.tex","Lista de paquetes","no"),

//	- Instalación - (subsección)

array("contenido/Mandrake/instala/pasos_a_seguir.tex","Pasos a seguir","no"),
array("contenido/Mandrake/instala/particiones.tex","Creando las particiones para Linux","no"),
array("contenido/Mandrake/instala/paquetes.tex","Selección de paquetes","no"),
array("contenido/Mandrake/instala/usuarios.tex","Establecer la clave del root y otros ususarios","no"),
array("contenido/Mandrake/instala/redes.tex","Configuración de la Red ","no"),
array("contenido/Mandrake/instala/ConexionAInternet.tex","Configuración de la conexión a Internet","no"),
array("contenido/Mandrake/instala/zona_horaria.tex","Zona Horaria","no"),
array("contenido/Mandrake/instala/impresora.tex","Configuración de la impresora","no"),
array("contenido/Mandrake/instala/servicios.tex","Servicios en el Arranque","no"),
array("contenido/Mandrake/instala/disco_inicio.tex","Disco de inicio","no"),
array("contenido/Mandrake/instala/lilo.tex","Instalando LILO","no"),
array("contenido/Mandrake/instala/xwindows.tex","Configuración de X-window","no"),

//	- Post-instalación y administración - (subsección)

array("contenido/Mandrake/configura/ingreso.tex","Configuración y Control de acceso","no"),
array("contenido/Mandrake/configura/lilo.tex","Configuración de LILO","no"),
array("contenido/Mandrake/configura/impresora.tex","Printerdrake","no"),
array("contenido/Mandrake/configura/printerdrake.tex","PrinterDrake","no"),
array("contenido/Mandrake/configura/redes.tex","Configuración de la Red","no"),
array("contenido/Mandrake/configura/modemconf.tex","Configuracion de modem","no"),
array("contenido/Mandrake/configura/recursos.tex","Compartir Recursos","no"),
array("contenido/Mandrake/configura/paquetes.tex","Herramientas de administración","no"),
array("contenido/Mandrake/configura/newhardw.tex","Configuración de hardware","no"),
array("contenido/Mandrake/configura/xfdrake.tex","Xconfigurator","no"),

// - (sección) -

array("contenido/Mandrake/biblio_mdk.tex","Bibliografía","no"),




/*
 *		---	Trabajando en modo texto --- (capítulo)
 */



//	-- Multiusuario y multitarea -- (sección)


array("contenido/MultiusuarioMultitareaQueEs/Introduccion.tex","Introducción","1"),
array("contenido/MultiusuarioMultitareaQueEs/Multiusuario.tex","Multiusuario","2"),
array("contenido/MultiusuarioMultitareaQueEs/AutenticacionAutorizacion.tex","Conceptos de autentificación y autorización","2"),


//	-- Entrar en el sistema -- (sección)


array("contenido/Login/Introduccion.tex","Introducción","1"),
array("contenido/Login/IniciandoUnaSesion.tex","Iniciando una sesión","2"),
array("contenido/Login/LaBaseDeUsuarios.tex","La base de datos de los usuarios","2"),


//	-- Comandos básicos -- (sección)


array("contenido/Comandos/Introduccion.tex","Introducción","1"),


//	- Listado de comandos - (subsección)


array("contenido/Comandos/cp.tex","El comando cp","2"),
array("contenido/Comandos/mv.tex","El comando mv","2"),
array("contenido/Comandos/ls.tex","El comando ls","2"),
array("contenido/Comandos/cd.tex","El comando cd","2"),
array("contenido/Comandos/touch.tex","El comando touch","2"),
array("contenido/Comandos/sort.tex","El comando sort","2"),
array("contenido/Comandos/less.tex","El comando less","2"),
array("contenido/Comandos/cat.tex","El comando cat","2"),
array("contenido/Comandos/head.tex","El comando head","2"),
array("contenido/Comandos/echo.tex","El comando echo","2"),
array("contenido/Comandos/tail.tex","El comando tail","2"),
array("contenido/Comandos/grep.tex","El comando grep","2"),
array("contenido/Comandos/find.tex","El comando find","2"),
array("contenido/Comandos/rm.tex","El comando rm","2"),
array("contenido/Comandos/mkdir.tex","El comando mkdir","2"),
array("contenido/Comandos/ln.tex","El comando ln","2"),
array("contenido/Comandos/pwd.tex","El comando pwd","2"),
array("contenido/Comandos/df.tex","El comando df","2"),
array("contenido/Comandos/du.tex","El comando du","2"),
array("contenido/Comandos/man.tex","El comando man","2"),
array("contenido/Comandos/apropos.tex","El comando apropos","2"),
array("contenido/Comandos/passwd.tex","El comando passwd","2"),
array("contenido/Comandos/whoami.tex","El comando whoami","2"),
array("contenido/Comandos/whereis.tex","El comando whereis","2"),
array("contenido/Comandos/locate.tex","El comando locate","2"),
array("contenido/Comandos/cal.tex","El comando cal","2"),
array("contenido/Comandos/wc.tex","El comando wc","2"),
array("contenido/Comandos/date.tex","El comando date","2"),
array("contenido/Comandos/mail.tex","El comando mail","2"),


//	-- Permisos de usuario -- (sección)


array("contenido/PermisosDeUsuario/Introduccion.tex","Introducción","1"),
array("contenido/PermisosDeUsuario/ConceptosBasicos.tex","Conceptos básicos","2"),
array("contenido/PermisosDeUsuario/Directorios.tex","Un caso especial, los directorios","2"),
array("contenido/PermisosDeUsuario/chmod.tex","Cambio de permisos: el comando chmod","2"),
array("contenido/PermisosDeUsuario/RepresentacionOctal.tex","Representación octal","3"),


//	-- La shell -- (sección)


array("contenido/Shell/VariablesDeEntorno.tex","Variables de entorno","1"),


//	- Redirección de entradas y salidas - (subsección)


array("contenido/Shell/EntradaSalida.tex","Entrada, salida y error estándar","2"),
array("contenido/Shell/Tuberias.tex","Tuberías (pipes)","2"),
array("contenido/Shell/Redireccion.tex","Redirección","2"),

// - (subsubsubsecciones) -

array("contenido/Shell/Redireccion-Escritura.tex","Escritura","3"),
array("contenido/Shell/Redireccion-Lectura.tex","Lectura","3"),		
array("contenido/Shell/RedireccionIO-practica.tex","Práctica","3"),

// - (subsección) -

array("contenido/Shell/ConfiguracionBash.tex","Archivos de configuración del intérprete de comandos bash","2"),

// - (subsubsecciones) -

array("contenido/Shell/bashrc.tex",".bashrc","3"),
array("contenido/Shell/bash_profile.tex",".bash_profile","3"),

// - (subsección) -

array("contenido/Shell/ProgramacionEnShell.tex","Programación en shell","2"),

// - (subsubsecciones) -

array("contenido/Shell/CodigosDeSalida.tex","Códigos de salida","3"),
array("contenido/Shell/if.tex","El comando if","3"),
array("contenido/Shell/while.tex","El comando while","3"),
array("contenido/Shell/for.tex","El comando for","3"),
array("contenido/Shell/ProgramacionEnShell-practica.tex","Práctica","3"),


//	-- Correo electrónio -- (sección)


array("contenido/CorreoElectronico/Introduccion.tex","Introducción","1"),

// - (subsección) -

array("contenido/CorreoElectronico/ClientesDeCorreo/Introduccion.tex","Uso de clientes de correo","no"),

// - (subsubsecciones) -

array("contenido/CorreoElectronico/ClientesDeCorreo/Pine/Introduccion.tex","Pine","no"),

// - (subsubsubsecciones) -

array("contenido/CorreoElectronico/ClientesDeCorreo/Pine/ConfiguracionBasica.tex","Configuración Básica","no"),
array("contenido/CorreoElectronico/ClientesDeCorreo/Pine/Carpetas.tex","Carpetas","no"),
array("contenido/CorreoElectronico/ClientesDeCorreo/Pine/LeyendoYEnviandoCorreo.tex","Leyendo y enviando correo","no"),
array("contenido/CorreoElectronico/ClientesDeCorreo/Pine/HaciendoRespaldoConfiguraciones.tex","Haciendo respaldo de las configuraciones","no"),

// - (subsubsecciones) -

array("contenido/CorreoElectronico/ClientesDeCorreo/Mutt/Introduccion.tex","Mutt","no"),

// - (subsección) -

array("contenido/CorreoElectronico/EncriptandoElCorreo/Introduccion.tex","La seguridad del correo electrónico","no"),

// - (subsubsecciones) -

array("contenido/CorreoElectronico/EncriptandoElCorreo/QueEsGnuPG.tex","¿Qué es GnuPG?","no"),
array("contenido/CorreoElectronico/EncriptandoElCorreo/ConfigurandoGPG.tex","Configurando GnuPG","no"),
array("contenido/CorreoElectronico/EncriptandoElCorreo/UsoDiarioDeGPG.tex","Uso diario de GnuPG","no"),
array("contenido/CorreoElectronico/EncriptandoElCorreo/CifrandoInformacion.tex","Cifrando información","no"),
array("contenido/CorreoElectronico/EncriptandoElCorreo/DescifrandoInformacion.tex","Descifrando información","no"),
array("contenido/CorreoElectronico/EncriptandoElCorreo/Conclusion.tex","Conclusión","no"),


// - (subsecciones) -


array("contenido/CorreoElectronico/EncriptandoDesdeClientesDeCorreo.tex","Encriptando desde el cliente de correo","no"),
array("contenido/CorreoElectronico/AutomatizandoCorreo.tex","Envío de correo automatizado con el comando mail","no"),
array("contenido/CorreoElectronico/Codificacion.tex","Herramientas de tratamiento de codificación MIME, UUE, ROT13, etc.","no"),
array("contenido/CorreoElectronico/fetchmail.tex","Configuración y uso de fetchmail","no"),
array("contenido/CorreoElectronico/procmail.tex","Configuración de filtros con procmail","no"),


//	-- Edición de archivos -- (sección)


array("contenido/Editores/vi/introduccion-a-vi.tex","Introducción al editor de textos vi","1"),



/*
 *	--- Tareas administrativas básicas --- (capítulo)
 */



//	-- Personalización y compilación del núcleo -- (sección)


array("contenido/PersonalizandoElKernel/Introduccion.tex","Introducción","1"),
array("contenido/PersonalizandoElKernel/SoporteDeHardware.tex","Soporte de hardware","2"),
array("contenido/PersonalizandoElKernel/ActualizacionDelNucleo.tex","Actualización del núcleo","2"),
array("contenido/PersonalizandoElKernel/CompilacionDelNucleo.tex","Compilación del núcleo","2"),

// - (subsección) -

array("contenido/PersonalizandoElKernel/LILO.tex","LILO","2"),

// - (subsubsecciónes) -

array("contenido/PersonalizandoElKernel/ConfiguracionDeLILO.tex","Configurando LILO","3"),
array("contenido/PersonalizandoElKernel/IntalandoLILO.tex","Instalando LILO","3"),

// - (sección) -

array("contenido/PersonalizandoElKernel/Modulos/Introduccion.tex","Introduccion a los módulos","1"),

// - (subsecciones) -

array("contenido/PersonalizandoElKernel/Modulos/GenerandoModulos.tex","Cómo generar un módulo","2"),
array("contenido/PersonalizandoElKernel/Modulos/MostrandoModulos.tex","Mostrando los módulos cargados","2"),
array("contenido/PersonalizandoElKernel/Modulos/AgregandoModulos.tex","Agregando módulos","2"),
array("contenido/PersonalizandoElKernel/Modulos/RetirandoModulos.tex","Retirando módulos de memoria","2"),
array("contenido/PersonalizandoElKernel/Modulos/AutomatizandoModulos.tex","Automatizando un poco mas los módulos","2"),

// - (subsección) -

array("contenido/PersonalizandoElKernel/PersonalizandoElKernel-practica.tex","Práctica","no"),


//	-- Instalación y actualización de paquetes utilizando RPM/DEB -- (sección)

 
//	- Paquetes RPM - (subsección)

array("contenido/RPMYPaquetes/Instalacion.tex","Instalación","1"),
array("contenido/RPMYPaquetes/Eliminacion.tex","Eliminación","1"),
array("contenido/RPMYPaquetes/Verificacion.tex","Verificación","1"),
array("contenido/RPMYPaquetes/BajadaDeInternet.tex","Consiguiendo paquetes nuevos","1"),
//	- (subsubsección) -
array("contenido/RPMYPaquetes/NombresDePaquetes.tex","Saber sobre nombres de paquetes","2"),
array("contenido/RPMYPaquetes/Busqueda.tex","Buscando paquetes","2"),


//	-- Programación de tareas con cron y at -- (sección)


array("contenido/Administracion/ProgramandoTareasConCron.tex","Programación de tareas con cron","1"),


//	-- Configuración básica de Samba -- (sección)


array("contenido/Samba/Introduccion.tex","Introducción","1"),
array("contenido/Samba/Funcionamiento.tex","Funcionamiento de Samba","2"),
array("contenido/Samba/Instalacion.tex","Obtención e instalación","2"),
array("contenido/Samba/Configuracion.tex","Configuración de un servidor Samba como un servidor NT/2000","2"),


//	-- Configuración básica de Apache -- (sección)


array("contenido/Apache/Introduccion.tex","Introducción a Apache","1"),
array("contenido/Apache/httpdconf.tex","El archivo httpd.conf","2"),
array("contenido/Apache/VirtualHost.tex","La directiva VirtualHost","2"),


//	-- Servidores de noticias -- (sección)


array("contenido/ServidoresDeNoticias/Introduccion.tex","Introducción","no"),
array("contenido/ServidoresDeNoticias/Leafnode/Introduccion.tex","Leafnode","no"),

// - (subsecciones) -

array("contenido/ServidoresDeNoticias/Leafnode/ObtencionEInstalacion.tex","Obtención e Instalación","no"),
array("contenido/ServidoresDeNoticias/Leafnode/ConfiguracionYUtilizacion.tex","Configuración y utilización","no"),
array("contenido/ServidoresDeNoticias/Leafnode/LosFiltros.tex","Los filtros","no"),
array("contenido/ServidoresDeNoticias/Leafnode/Documentacion.tex","Documentación","no"),

// - (sección) -

array("contenido/ServidoresDeNoticias/INN/Introduccion.tex","INN","no"),

// - (subsecciones) -

array("contenido/ServidoresDeNoticias/INN/ObtencionEInstalacion.tex","Inn+Suck: Obtención e instalación","no"),




//	-- Configuración básica de Sendmail -- (sección)


array("contenido/CorreoElectronico/Sendmail/QueEsUnMTA.tex","¿Qué es un MTA?","1"),
array("contenido/CorreoElectronico/Sendmail/Smarthost.tex","Smarthost con sendmail","1"),
array("contenido/CorreoElectronico/Sendmail/UsuariosVirtuales.tex","Usuarios Virtuales","1"),
array("contenido/CorreoElectronico/Sendmail/DominiosVirtuales.tex","Dominios Virtuales con sendmail","1"),
array("contenido/CorreoElectronico/Sendmail/Aliases.tex","Alias de correo con sendmail","1"),
array("contenido/CorreoElectronico/Sendmail/Pasarela.tex","Pasarela de correos con sendmail","no"),
array("contenido/CorreoElectronico/Sendmail/AdmDeColaDeMensajes.tex","Administración de Cola de Mensajes","1"),



/*
 *    --- Trabajando en modo gráfico --- (capítulo)
 */



//	-- Servidor X -- (sección)


array("contenido/ServidorX/ModeloDeCapas.tex","Modelo de capas del protocolo X11","1"),
array("contenido/ServidorX/BibliotecasGraficas.tex","Bibliotecas gráficas","1"),



//	-- KDE1 -- (sección)

array("contenido/KDE1/Introduccion.tex","Introducción","1"),

// - Configuración - (subsección)

array("contenido/KDE1/Configuracion/Introduccion.tex","Introducción","2"),
array("contenido/KDE1/Configuracion/PersonalizacionDelIdioma.tex","Personalización del idioma","3"),
array("contenido/KDE1/Configuracion/ConfiguracionDelTipoDeTeclado.tex","Configuración del tipo de teclado","3"),

//	- Personalización del escritorio - (subsección)

array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/PersonalizacionDelEscritorio.tex","Personalización del escritorio","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/Bordes.tex","Bordes","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/Colores.tex","Colores","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/Estilo.tex","Estilo","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/FondoDePantalla.tex","Fondo de pantalla","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/Fuentes.tex","Fuentes","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/GestorDeTemas.tex","Gestor de Temas","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/IconosDelEscritorio.tex","Iconos de escritorio","3"),
array("contenido/KDE1/Configuracion/PersonalizacionDelEscritorio/Salvapantalla.tex","Salvapantallas","3"),

//	- Personalización de las ventanas - (subsección)

array("contenido/KDE1/Configuracion/Ventanas/Ventanas.tex","Personalización del comportamiento de las ventanas","3"),
array("contenido/KDE1/Configuracion/Ventanas/BarraDeTitulo.tex","Barra de título","3"),
array("contenido/KDE1/Configuracion/Ventanas/Botones.tex","Botones","3"),
array("contenido/KDE1/Configuracion/Ventanas/Propiedades.tex","Propiedades","3"),
array("contenido/KDE1/Configuracion/Ventanas/Avanzado.tex","Avanzado","3"),

//	- Configuración del panel - (subsección)

array("contenido/KDE1/Configuracion/ConfiguracionDelPanel/ConfiguracionDelPanel.tex","Configuración de la Barra o Panel","3"),
array("contenido/KDE1/Configuracion/ConfiguracionDelPanel/Escritorios.tex","Escritorios","3"),
array("contenido/KDE1/Configuracion/ConfiguracionDelPanel/NavegadorDeDisco.tex","Navegador de disco","3"),
array("contenido/KDE1/Configuracion/ConfiguracionDelPanel/Opciones.tex","Opciones","3"),
array("contenido/KDE1/Configuracion/ConfiguracionDelPanel/Panel.tex","Panel","3"),



//	-- KDE2 -- (sección)


array("contenido/KDE2/Configuracion/Introduccion.tex","Introducción","1"),
array("contenido/KDE2/Configuracion/PersonalizacionDelIdioma.tex","Personalización del idioma y país","2"),
array("contenido/KDE2/Configuracion/ConfiguracionDelTipoDeTeclado.tex","Configuración del tipo de teclado","2"),
array("contenido/KDE2/Configuracion/PersonalizacionDeLasVentanas.tex","Personalización del comportamiento de las ventanas","2"),

//	- PersonalizacionDelEscritorio - (subsección)

array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/ConfiguracionDelEscritorio.tex","Configuración del escritorio","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/Colores.tex","Colores del entorno","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/Estilo.tex","Estilo del entorno","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/FondoDePantalla.tex","Fondo de pantalla","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/Fuentes.tex","Tipografías del entorno","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/GestorDeTemas.tex","Gestor de Temas","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/IconosDelEscritorio.tex","Iconos del Entorno","3"),
array("contenido/KDE2/Configuracion/PersonalizacionDelEscritorio/Salvapantalla.tex","Salvapantalla","3"),

//	- ConfiguracionDelPanel - (subsección)

array("contenido/KDE2/Configuracion/ConfiguracionDelPanel/ConfiguracionDelPanel.tex","Configuración de la Barra ó Panel","3"),
array("contenido/KDE2/Configuracion/ConfiguracionDelPanel/Panel.tex","Panel","3"),
array("contenido/KDE2/Configuracion/ConfiguracionDelPanel/Opciones.tex","Opciones","3"),
array("contenido/KDE2/Configuracion/ConfiguracionDelPanel/NavegadorDeDisco.tex","Navegador de disco","3"),
array("contenido/KDE2/Configuracion/ConfiguracionDelPanel/Escritorios.tex","Escritorios","3"),




/*
 *		--- StarOffice --- (capítulo)
 */



array("contenido/StarOffice/Introduccion.tex","Introducción","no"),
array("contenido/StarOffice/StarDesktop.tex","StarDesktop: El Entorno de StarOffice","no"),
array("contenido/StarOffice/StarWriter.tex","StarWriter: Procesador de textos","no"),
array("contenido/StarOffice/StarCalc.tex","StarCalc: Hoja de Cálculo","no"),
array("contenido/StarOffice/StarImpress.tex","StarImpress: Creador y Visualizador de Presentaciones","no"),
array("contenido/StarOffice/StarDraw.tex","StarDraw: Creador de dibujos","no"),
array("contenido/StarOffice/StarSchedule.tex","StarSchedule: Agenda","no"),
array("contenido/StarOffice/StarChart.tex","StarChart: Generador de gráficas","no"),
array("contenido/StarOffice/StarImage.tex","StarImage: Editor de Imágenes","no"),
array("contenido/StarOffice/CompatibilidadConElMSOffice.tex","Compatibilidad con el MS Office","no"),



/*
 *		--- Internet --- (capítulo)
 */



array("contenido/Internet/Conectarse.tex","Conectarse","1"),
array("contenido/Internet/ProblemasConElModem.tex","Problemas con el modem","2"),
array("contenido/Internet/ProblemasConPPPD.tex","Problemas con el pppd","2"),
array("contenido/Internet/ProblemasConElServidor.tex","Problemas relativos al provedor","2"),
array("contenido/Internet/Navegacion.tex","Navegación","1"),
array("contenido/Internet/CorreoElectronico.tex","Correo electrónico","1"),
array("contenido/Internet/UtilidadesVarias.tex","Utilidades varias","1"),
array("contenido/Internet/pingEnKnu.tex","Ping","2"),
array("contenido/Internet/Chat.tex","Chat","1"),
array("contenido/Internet/BusquedaDeArchivos.tex","Búsqueda de archivos","1"),



/*
 *		--- DocumentacionYAyuda --- (capítulo)
 */



array("contenido/DocumentacionYAyuda/Introduccion.tex","Introducción","1"),
array("contenido/DocumentacionYAyuda/FilosofiaRTFM.tex","Filosofía RTFM","1"),
array("contenido/DocumentacionYAyuda/PaginasMan.tex","Páginas del Manual","1"),
array("contenido/DocumentacionYAyuda/SeccionesPaginaMan.tex","Secciones de una Página del Manual","no"),
array("contenido/DocumentacionYAyuda/PaginasInfo.tex","Páginas Info","1"),
array("contenido/DocumentacionYAyuda/COMOs.tex","COMOs","1"),
array("contenido/DocumentacionYAyuda/Manuales.tex","Manuales","1"),
array("contenido/DocumentacionYAyuda/LinuxEnSantaFe-Argentina.tex","Linux en Santa Fe, Argentina","no"),


//	-- Enlaces -- (sección)


array("contenido/DocumentacionYAyuda/Enlaces/Introduccion.tex","Introducción","2"),
array("contenido/DocumentacionYAyuda/Enlaces/ListasDeCorreo.tex","Listas de correo","2"),


//	- GruposLocales - (subsección)


array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Introduccion.tex","Introducción","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Argentina.tex","Argentina","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Bolivia.tex","Bolivia","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Chile.tex","Chile","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Colombia.tex","Colombia","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/CostaRica.tex","Costa Rica","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Cuba.tex","Cuba","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Ecuador.tex","Ecuador","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/ElSalvador.tex","El Salvador","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Espania.tex","España","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Guatemala.tex","Guatemala","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Mexico.tex","México","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Peru.tex","Perú","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/PuertoRico.tex","Puerto Rico","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Uruguay.tex","Uruguay","3"),
array("contenido/DocumentacionYAyuda/Enlaces/GruposLocales/Venezuela.tex","Venezuela","3"),


//	- SitiosDeInteres - (subsección)


array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres/Introduccion.tex","Introducción","3"),
array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres/Informacion.tex","Información","3"),
array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres/Documentacion.tex","Documentación","3"),
array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres/Noticias.tex","Noticias","3"),
array("contenido/DocumentacionYAyuda/Enlaces/SitiosDeInteres/ProgramasYAplicaciones.tex","Programas y aplicaciones","3"),



/*
 *		--- Para el profesor --- (capítulo)
 */



array("contenido/ParaElProfesor/DinamicaDeClase.tex","Dinámica de clase","no"),
array("contenido/ParaElProfesor/GuiaDeTemas.tex","Guía de temas","no"),
array("contenido/ParaElProfesor/Transparencias.tex","Transparencias","no"),
array("contenido/ParaElProfesor/ejercitacion.tex","Ejercicios para proponer en clase","no"),
array("contenido/ParaElProfesor/Examenes.tex","Guía de preguntas para examenes","no"),
array("contenido/ParaElProfesor/Examen1.tex","Examen del curso I","no"),



/*
 *		--- Agradecimientos --- (capítulo)
 */



array("contenido/Agradecimientos/Agradecimientos.tex","Agradecimientos","1"),



/*
 *		--- Licencia --- (capítulo)
 */


// - (secciones) -

array("contenido/Licencia/Licencia.tex","Introducción","1"),
array("contenido/Licencia/fdl/fdl.tex","GNU Free Documentation License","1"), 

// - (subsecciones) -

array("contenido/Licencia/fdl/Preamble.tex","Preamble","2"), 
array("contenido/Licencia/fdl/ApplicabilityAndDefinitions.tex","Applicability and definitions","2"), 
array("contenido/Licencia/fdl/VerbatimCopying.tex","Verbatim Copying","2"), 
array("contenido/Licencia/fdl/CopyingInQuantity.tex","Copying in Quantity","2"), 
array("contenido/Licencia/fdl/Modifications.tex","Modifications","2"), 
array("contenido/Licencia/fdl/CombiningDocuments.tex","Combining Documents","2"), 
array("contenido/Licencia/fdl/CollectionsOfDocuments","Collections of Documents","2"), 
array("contenido/Licencia/fdl/AggregationWithIndependentWorks.tex","Aggregation With Independent Works","2"), 
array("contenido/Licencia/fdl/Translation.tex","Translation","2"), 
array("contenido/Licencia/fdl/Termination.tex","Termination","2"), 
array("contenido/Licencia/fdl/FutureRevisionsOfThisLicense.tex","Future Revisions of This License","2"), 
array("contenido/Licencia/fdl/ADDENDUM.tex","ADDENDUM: How to use this License for your documents","2"), 

);
?>
