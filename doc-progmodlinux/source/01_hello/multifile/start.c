/* start.c 
 * Copyright (C) 1999 by Ori Pomerantz
 * 
 * "Hola, mundo" - la versión módulo del núcleo.
 * Este fichero incluye justamente la rutina de comienzo
 */

/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */



/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        



/* Inicializa el módulo */
int init_module()
{
  printk("Hola, mundo - este es el núcleo hablando\n");

  /* Si retornamos un valor distinto de cero, significa
   * que init_module falló y el módulo del núcleo
   * no puede ser cargado */
  return 0;
}


