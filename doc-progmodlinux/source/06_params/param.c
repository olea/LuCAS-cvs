/* param.c 
 * 
 * Recibe en linea de comandos los parámetros en la instalación del módulo
 */

/* Copyright (C) 1998-99 by Ori Pomerantz */





/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        


#include <stdio.h>  /* Necesito NULL */


/* En 2.2.3 /usr/include/linux/version.h se incluye
 * una macro para esto, pero 2.0.35 no lo hace - por lo
 * tanto lo añado aquí si es necesario */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



/* Emmanuel Papirakis:
 *
 * Los nombres de parámetros son ahora (2.2) 
 * manejados en una macro.
 * El núcleo no resuelve los nombres de los 
 * símbolos como parecía que tenía que hacer.
 *
 * Para pasar parámetros a un módulo, tienes que usar una macro
 * definida en include/linux/modules.h (linea 176).
 * La macro coge dos parámetros. El nombre del parámetro y 
 * su tipo. El tipo es una letra entre comillas. 
 * Por ejemplo, "i" debería de ser un entero y "s" debería
 * de ser una cadena de caracteres.
 */


char *str1, *str2;


#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
MODULE_PARM(str1, "s");
MODULE_PARM(str2, "s");
#endif


/* Inicializa el módulo - muestra los parámetros */
int init_module()
{
  if (str1 == NULL || str2 == NULL) {
    printk("La próxima vez, haz insmod param str1=<algo>");
    printk("str2=<algo>\n");
  } else
    printk("Cadenas de caracteres:%s y %s\n", str1, str2);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  printk("Si intentas hacer insmod a este módulo dos veces,");
  printk("(sin borrar antes (rmmod)\n");
  printk("al primero), quizás obtengas el mensaje"); 
  printk("de error:\n");
  printk("'el símbolo para el parámetro str1 no ha sido encontrado'.\n");
#endif

  return 0;
}


/* Limpieza */
void cleanup_module()
{
}  
