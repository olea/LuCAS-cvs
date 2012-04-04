mn2db.cs
 Un programa sencillo para transformar documentos MonoDoc a DocBook
 mediante transformadas XSL

 maintainer: Ricardo Varela - phobeo at ieee dot org
-------------------------------------------------------------------

mn2db es un programa diseñado para ayudar a la gente que necesita trabajar 
con el formato monodoc para transformar fácilmente sus documentos a DocBook,
un formato estándar de documentación muy sencillo de convertir a diferentes 
formatos, como HTML o PDF. Para más información sobre DocBook, puedes visitar
la página http://www.docbook.org

mn2db se creó originariamente como parte del proyecto de traducción del 
estándar ecma334 de la comunidad mono hispano, en colaboración con LuCAS. 
La página del proyecto puede visitarse en:
http://wiki.hispalinux.es/moin/ECMA_5fC_23



  UTILIZACIÓN
-----------------------------------------------------------------

Primero debes compilar mn2db. Simplemente hay que introducir desde el directorio mn2db:

make

Recibirás una advertencia del compilador que puedes ignorar. Tendrás ahora un ejecutable llamado mn2db.exe, que se puede ejecutar como mono mn2db ruta_de_los_archivos_en_monodoc, o si se quiere utilizar en el projyecto de traducción del ECMA C#, ya hay un script preparado para la tarea de traducir todo el monodoc a docbook. Se consige simplemente haciendo

./mn2db

desde el directorio mn2db
