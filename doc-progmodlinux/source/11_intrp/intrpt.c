/* intrpt.c - Un manejador de interrupciones. */


/* Copyright (C) 1998 por Ori Pomerantz */



/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        

#include <linux/sched.h>
#include <linux/tqueue.h>

/* Queremos una interrupción */
#include <linux/interrupt.h>

#include <asm/io.h>


/* En 2.2.3 /usr/include/linux/version.h se incluye una
 * macro para esto, pero 2.0.35 no lo hace - por lo tanto
 * lo añado aquí si es necesario. */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



/* Bottom Half - esto será llamado por el núcleo
 * tan pronto como sea seguro hacer todo lo normalmente 
 * permitido por los módulos del núcleo. */ 
static void got_char(void *scancode)
{
  printk("Código leído %x %s.\n",
    (int) *((char *) scancode) & 0x7F,
    *((char *) scancode) & 0x80 ? "Liberado" : "Presionado");
}


/* Esta función sirve para las interrupciones de teclado. Lee 
 * la información relevante desde el teclado y entonces
 * planifica el bottom half para ejecutarse cuando el núcleo
 * lo considere seguro. */
void irq_handler(int irq, 
                 void *dev_id, 
                 struct pt_regs *regs)
{
  /* Estas variables son estáticas porque necesitan ser
   * accesibles (a través de punteros) por la rutina bottom
   * half. */
  static unsigned char scancode;
  static struct tq_struct task = 
        {NULL, 0, got_char, &scancode};
  unsigned char status;

  /* Lee el estado del teclado */
  status = inb(0x64);
  scancode = inb(0x60);
  
  /* Planifica el bottom half para ejecutarse */
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,2,0)
  queue_task(&task, &tq_immediate);
#else
  queue_task_irq(&task, &tq_immediate);
#endif
  mark_bh(IMMEDIATE_BH);
}



/* Inicializa el módulo - registra el manejador de IRQs */
int init_module()
{
  /* Como el manejador de teclado no coexistirá con
   * otro manejador, tal como nosotros, tenemos que deshabilitarlo
   * (liberar su IRQ) antes de hacer algo. Ya que nosotros
   * no conocemos dónde está, no hay forma de reinstalarlo 
   * después - por lo tanto la computadora tendrá que ser reiniciada
   * cuando halla sido realizado.
   */
  free_irq(1, NULL);

  /* Petición IRQ 1, la IRQ del teclado, para nuestro 
   * irq_handler. */
  return request_irq(
    1,  /* El número de la IRQ del teclado en PCs */ 
    irq_handler,  /* nuestro manejador */
    SA_SHIRQ, 
    /* SA_SHIRQ significa que queremos tener otro
     * manejador en este IRQ.
     *
     * SA_INTERRUPT puede ser usado para
     * manejarla en una interrupción rápida. 
     */
    "test_keyboard_irq_handler", NULL);
}


/* Limpieza */
void cleanup_module()
{
  /* Esto está aquí sólo para completar. Es totalmente
   * irrelevante, ya que no tenemos forma de restaurar 
   * la interrupción normal de teclado, por lo tanto
   * la computadora está totalmente inservible y tiene que
   * ser reiniciada. */
  free_irq(1, NULL);
}  






















