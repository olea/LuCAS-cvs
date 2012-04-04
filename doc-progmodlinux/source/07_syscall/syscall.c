/* syscall.c 
 * 
 * Ejemplo de llamada al sistema "robando" 
 */


/* Copyright (C) 1998-99 por Ori Pomerantz */


/* Los ficheros de cabeceras necesarios */

/* Estándar en los módulos del núcleo */
#include <linux/kernel.h>   /* Estamos haciendo trabajo del núcleo */
#include <linux/module.h>   /* Específicamente, un módulo */

/* Distribuido con CONFIG_MODVERSIONS */
#if CONFIG_MODVERSIONS==1
#define MODVERSIONS
#include <linux/modversions.h>
#endif        

#include <sys/syscall.h>  /* La lista de llamadas al sistema */

/* Para el actual estructura (proceso), necesitamos esto
 * para conocer quién es el usuario actual. */
#include <linux/sched.h>  




/* En 2.2.3 /usr/include/linux/version.h se incluye
 * una macro para esto, pero 2.0.35 no lo hace - por lo
 * tanto lo añado aquí si es necesario */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) ((a)*65536+(b)*256+(c))
#endif



#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
#include <asm/uaccess.h>
#endif



/* La tabla de llamadas al sistema (una tabla de funciones).
 * Nosotros justamente definimos esto como externo, y el
 * núcleo lo rellenerá para nosotros cuando instalemos el módulo
 */
extern void *sys_call_table[];


/* UID que queremos espiar - será rellenado desde la
 * linea de comandos */
int uid;  

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
MODULE_PARM(uid, "i");
#endif

/* Un puntero a la llamada al sistema original. El motivo para
 * mantener esto, mejor que llamar a la función original
 * (sys_open), es que alguien quizás haya reemplazado la 
 * llamada al sistema antes que nosotros. Destacar que esto
 * no es seguro al 100%, porque si otro módulo reemplaza sys_open
 * antes que nosotros, entonces cuando insertemos llamaremos 
 * a la función en ese módulo - y quizás sea borrado
 * antes que nosotros.
 *
 * Otro motivo para esto es que no podemos tener sys_open.
 * Es una variable estática, por lo tanto no es exportada. */
asmlinkage int (*original_call)(const char *, int, int);



/* Por algún motivo, en 2.2.3 current-uid me da cero, en vez de
 * la ID real del usuario. He intentado encontrar dónde viene mal,
 * pero no lo he podido hacer en un breve periodo de tiempo, y 
 * soy vago - por lo tanto usaremos la llamada al sistema para 
 * obtener el uid, de la forma que un proceso lo haría.
 *
 * Por algún motivo, después de que recompilara el núcleo este
 * problema se ha ido.
 */
asmlinkage int (*getuid_call)();



/* La función con la que reemplazaremos sys_open (la
 * función llamada cuando llamas a la llamada al sistema open).
 * Para encontrar el prototipo exacto, con el número y tipo de
 * argumentos, encontramos primero la función original (es en
 * fs/open.c).
 *
 * En teoría, esto significa que estamos enlazados a la versión
 * actual del núcleo. En la práctica, las llamadas al sistema nunca
 * cambian (se destruirían naufragando y requerirían que los programas
 * fuesen recompilados, ya que las llamadas al sistema son las 
 * interfaces entre el núcleo y los procesos).
 */
asmlinkage int our_sys_open(const char *filename, 
                            int flags, 
                            int mode)
{
  int i = 0;
  char ch;

  /* Checkea si este es el usuario que estamos espiando */
  if (uid == getuid_call()) {  
   /* getuid_call es la llamada al sistema getuid,
    * la cual nos da el uid del usuario que ejecutó
    * el proceso que llamó a la llamada al sistema
    * que tenemos. */

    /* Indica el fichero, si es relevante */
    printk("Fichero abierto por %d: ", uid); 
    do {
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
      get_user(ch, filename+i);
#else
      ch = get_user(filename+i);
#endif
      i++;
      printk("%c", ch);
    } while (ch != 0);
    printk("\n");
  }

  /* Llamamos a la sys_open original - en otro caso, perdemos
   * la habilidad para abrir ficheros */
  return original_call(filename, flags, mode);
}



/* Inicializa el módulo - reemplaza la llamada al sistema */
int init_module()
{
  /* Peligro - muy tarde para él ahora, pero quizás 
   * la próxima vez... */
  printk("Soy peligroso. Espero que hayas hecho un ");
  printk("sync antes de insertarme.\n");
  printk("Mi duplicado, cleanup_module(), es todavía"); 
  printk("más peligroso. Si\n");
  printk("valoras tu sistema de ficheros, será mejor ");
  printk("que hagas \"sync; rmmod\" \n");
  printk("cuando borres este módulo.\n");

  /* Mantiene un puntero a la función original en
   * original_call, y entonces reemplaza la llamada al sistema
   * en la tabla de llamadas al sistema con our_sys_open */
  original_call = sys_call_table[__NR_open];
  sys_call_table[__NR_open] = our_sys_open;

  /* Para obtener la dirección de la función para la
   * llamada al sistema foo, va a sys_call_table[__NR_foo]. */

  printk("Espiando el UID:%d\n", uid);

  /* Coje la llamada al sistema para getuid */
  getuid_call = sys_call_table[__NR_getuid];

  return 0;
}


/* Limpieza - libera el fichero apropiado de /proc */
void cleanup_module()
{
  /* Retorna la llamada al sistema a la normalidad */
  if (sys_call_table[__NR_open] != our_sys_open) {
    printk("Alguien más jugó con la llamada al sistema ");
    printk("open\n");
    printk("El sistema quizás haya sido dejado ");
    printk("en un estado iniestable.\n");
  }

  sys_call_table[__NR_open] = original_call;
}  










