#!/usr/bin/tclsh

#Datos a introducir
set user ""
set pass ""
###################
#Variable general
set correcto "N"
#Variables referentes al producto
set producto ""
set producto2 ""
set descripcion ""
set descripcion2 ""
set cerrado ""
set cerrado2 ""
set max_persona ""
set max_simple_bug ""
set num_confirmado ""
set version ""
set longitud 108
#variables referentes a los componentes
set i 1
set componente ""
set componente2 ""
set descripcion ""
set descripcion2 ""
set propietario ""
set contacto ""

set letra ""
set texto ""




while {$correcto != "correcto"} {
	puts "Version preliminar del script 'Bugzilla'     Autor: T-REX"
	puts ""
	puts "Entrada de datos:"
	puts "-------------------------------------------------------------------------------"
	puts "Nombre del producto:"
	gets stdin producto
	set indice [string length $producto]
#	set longitud [expr $longitud + $indice]
	for {set i 0} {$i <= $indice} {incr i} { 
 
 		 set letra [string index $producto $i]
		  if {[string compare $letra " "] == 0 } { 
		      set letra "+" 
  		  }
		  set texto [ concat $texto$letra ]
		  
	  }
	set producto2 $texto  
	set texto ""  
	puts "Descripcion de $producto:"
	gets stdin descripcion
	set indice [string length $descripcion]
#	set longitud [expr $longitud + indice]
	for {set i 0} {$i <= $indice} {incr i} { 
 
 		 set letra [string index $descripcion $i]
		  if {[string compare $letra " "] == 0 } { 
		      set letra "+" 
  		  }
		  set texto [ concat $texto$letra ]
		  
	  }
	set descripcion2 $texto   
	set texto ""   
	puts "Producto cerrado? (closed for bug entry) (0 abierto, 1 cerrado):"
	gets stdin cerrado2
		if {$cerrado2 == "0"} {set cerrado "ABIERTO"}
		if {$cerrado2 == "1"} {set cerrado "CERRADO"}

	puts "Maximo de votos por persona:"
	gets stdin max_persona
	puts "Maximo numero de votos que una misma persona puede poner en un solo bug:"
	gets stdin max_simple_bug
	puts "Numero de votos necesarios para dejar de ser NO-Confirmado:"
	gets stdin num_confirmado
	puts "Version de $producto"
	gets stdin version

	set indice [string length $version]
	for {set i 0} {$i <= $indice} {incr i} { 
 
 		 set letra [string index $version $i]
		  if {[string compare $letra " "] == 0 } { 
		      set letra "+" 
  		  }
		  set texto [ concat $texto$letra ]
		  
	  }
	set version2 $texto    
	set texto ""  
	puts ""
	puts ""
	puts "RESUMEN DE DATOS"
	puts "Producto: $producto"
	puts ""
	puts "Descripcion: $descripcion"
	puts ""
	puts "Estado del producto: $cerrado"
	puts ""
	puts "Maximo de votos por persona: $max_persona"  
	puts ""
	puts "Max. de votos de una persona sobre 1 solo bug: $max_simple_bug"
	puts ""
	puts "Votos para dejar de ser NO-Confirmado: $num_confirmado"
	puts ""
	puts "Version: $version"
	puts ""
	puts "¿Todo correcto? (Si esta correcto pulsa intro, si no, pulsa lo que sea e intro)"
	gets stdin correcto
		if {$correcto == ""} {
			set correcto "correcto"
			break	}
		if {$correcto != ""} {set correcto "N"}
}


#set correcto "N"

set sockp [socket 193.127.103.90 80]
puts "Haciendo login en la web...."

puts $sockp "GET /cgi-bin/bugzilla/relogin.cgi HTTP/1.1"
puts $sockp "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"
puts $sockp "Referer: http://bugzilla.hispalinux.es/"
puts $sockp "Accept-Language: es"
puts $sockp "Accept-Encoding: gzip, deflate"
puts $sockp "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)"
puts $sockp "Host: bugzilla.hispalinux.es"
puts $sockp "Connection: Keep-Alive"
puts $sockp "Cookie: BUGLIST=454"

flush $sockp

after 2000

close $sockp
set sockp [socket 193.127.103.90 80]

puts $sockp "POST /cgi-bin/bugzilla/query.cgi HTTP/1.1"
puts $sockp "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"
puts $sockp "Referer: http://bugzilla.hispalinux.es/cgi-bin/bugzilla/query.cgi?GoAheadAndLogIn=1"
puts $sockp "Accept-Language: es"
puts $sockp "Content-Type: application/x-www-form-urlencoded"
puts $sockp "Accept-Encoding: gzip, deflate"
puts $sockp "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)"
puts $sockp "Host: bugzilla.hispalinux.es"
puts $sockp "Content-Length: 98"
puts $sockp "Connection: Keep-Alive"
puts $sockp "Cache-Control: no-cache"
puts $sockp "Cookie: BUGLIST="
puts $sockp ""
puts $sockp "Bugzilla_login=$user&Bugzilla_password=$pass&GoAheadAndLogIn=1&GoAheadAndLogIn=Login"

flush $sockp


puts -nonewline "Obteniendo Cookies..."

set i 0
set cookie ""

while {$i == 0 } {
   gets $sockp trafico
#   puts $trafico
   set posicion [string first "Bugzilla_logincookie=" $trafico]
   if {$posicion != -1} {
	   for {set i 0} {$i < 120} {incr i} {
		   set letra [string index $trafico $posicion]
		   if {$letra == ";"} {set i 121 }
		   if {$i != 121} {
			if {$letra != ";"} {	
				set cookie [concat $cookie$letra]
				}
			}
		   incr posicion
	   }
	set i 1
	}
#   puts $trafico
}

puts "Cookie encontrada: $cookie"
puts ""


### CREANDO EL PRODUCTO

puts "Creando el producto"
after 2000
set envio "product=$producto2&description=$descripcion2&defaultmilestone=---&disallownew=$cerrado2&votesperuser=$max_persona&maxvotesperbug=$max_simple_bug&votestoconfirm=$num_confirmado&version=$version2&action=new"
set longitud [string length $envio]

close $sockp
set sockp [socket 193.127.103.90 80]


puts $sockp "POST /cgi-bin/bugzilla/editproducts.cgi HTTP/1.1"
puts $sockp "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"
puts $sockp "Referer: http://bugzilla.hispalinux.es/cgi-bin/bugzilla/editproducts.cgi?action=add"
puts $sockp "Accept-Language: es"
puts $sockp "Content-Type: application/x-www-form-urlencoded"
puts $sockp "Accept-Encoding: gzip, deflate"
puts $sockp "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)"
puts $sockp "Host: bugzilla.hispalinux.es"
puts $sockp "Content-Length: $longitud"
puts $sockp "Connection: Keep-Alive"
puts $sockp "Cache-Control: no-cache"
puts $sockp "Cookie: BUGLIST=; Bugzilla_login=$user; $cookie"
puts $sockp ""
puts $sockp "product=$producto2&description=$descripcion2&defaultmilestone=---&disallownew=$cerrado2&votesperuser=$max_persona&maxvotesperbug=$max_simple_bug&votestoconfirm=$num_confirmado&version=$version2&action=new"

flush $sockp



## CREACION DE LOS COMPONENTES
after 2000
close $sockp
puts "Producto Añadido a la web :)"
puts ""
puts "**********************************************"
puts "Añadamos los componentes de $producto"
puts "**********************************************"
puts ""
set ind 1
while {$ind < 6} {

puts "Componente número $ind de $producto:"
puts "--------------------------------------------------------------------------"

puts "Nombre del Componente:"
gets stdin componente

	set indice [string length $componente]
	for {set i 0} {$i <= $indice} {incr i} { 
 
 		 set letra [string index $componente $i]
		  if {[string compare $letra " "] == 0 } { 
		      set letra "+" 
  		  }
		  set texto [ concat $texto$letra ]
		  
	  }
	set componente2 $texto    
	set texto ""  

puts "Descripcion de $componente :"
gets stdin descripcion

	set indice [string length $descripcion]
	for {set i 0} {$i <= $indice} {incr i} { 
 
 		 set letra [string index $descripcion $i]
		  if {[string compare $letra " "] == 0 } { 
		      set letra "+" 
  		  }
		  set texto [ concat $texto$letra ]
		  
	  }
	set descripcion2 $texto    
	set texto ""  

puts "Propietario inicial:"
gets stdin propietario
puts "Initial QA contact:"
gets stdin contacto

puts "Siguiente componente? (INTRO para el siguiente, cualquier otra cosa e intro para repetir este)"
gets stdin correcto
if {$correcto == ""} {

	puts "Creando el componente...esto depende de la velocidad de la conexion, se paciente"
	set envio ""
	set longitud 0
	set envio "component=$componente2&product=$producto2&description=$descripcion2&initialowner=$propietario&initialqacontact=$contacto&action=new"
          set longitud [string length $envio]
	after 2000

	set sockp [socket 193.127.103.90 80]

	puts $sockp "POST /cgi-bin/bugzilla/editcomponents.cgi HTTP/1.1"
	puts $sockp "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"
	puts $sockp "Referer: http://bugzilla.hispalinux.es/cgi-bin/bugzilla/editcomponents.cgi?action=add&product=prueba%20de%20script"
	puts $sockp "Accept-Language: es"
	puts $sockp "Content-Type: application/x-www-form-urlencoded"
	puts $sockp "Accept-Encoding: gzip, deflate"
	puts $sockp "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)"
	puts $sockp "Host: bugzilla.hispalinux.es"
	puts $sockp "Content-Length: $longitud "
	puts $sockp "Connection: Keep-Alive"
	puts $sockp "Cache-Control: no-cache"
	puts $sockp "Cookie: BUGLIST=; Bugzilla_login=$user; $cookie"
	puts $sockp ""
	puts $sockp "component=$componente2&product=$producto2&description=$descripcion2&initialowner=$propietario&initialqacontact=$contacto&action=new"

	after 2000
	if {$ind != 5} {puts "Componente $ind creado, seguimos para bingo ;)"}
	if {$ind == 5} {puts "Producto y componentes creados :)"}
	puts ""
	close $sockp

	incr ind
	
	}

}












