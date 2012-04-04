/* hello.c 
 * Copyright (C) 1998 by Ori Pomerantz
 * 
 * "Hello, world" - la versión módulo del núcleo. 
 */

/* Los archivos de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos realizando trabajo del núcleo */
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


/* Limpieza - deshacemos todo aquello que hizo init_module */
void cleanup_module()
{
  printk("La vida de un módulo del núcleo es corta\n");
}  
