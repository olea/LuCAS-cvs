/* stop.c 
 * Copyright (C) 1999 by Ori Pomerantz
 * 
 * "Hola, mundo" - la versión módulo del núcleo. Este 
 * fichero incluye justamente la rutina de parada.
 */

/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */

#define __NO_VERSION__      /* Este no es "el" fichero 
                             * del módulo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

#include <linux/version.h>   /* No incluido por 
                              * module.h debido  
                              * a __NO_VERSION__ */



/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        




/* Limpieza - deshacemos todo aquello que hizo init_module */
void cleanup_module()
{
  printk("La vida de un módulo del núcleo es corta\n");
}  


