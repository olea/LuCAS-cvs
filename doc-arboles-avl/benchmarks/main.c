#include <glib.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "avl.h"
#include "list.h"

int int_comp(int x, int y)
{
  if (x<y) return -1;
  else if(x>y) return 1;
  else return 0;
}

int int_makecopy(int x)
{
  return x;
}



#define RAND_SUP 500.0
#define INSERCIONES   2500000
#define ELIMINACIONES 2500000



int main(void)
{
  long unsigned int t_avl, t_list; /* en microsegundos */
  GTimer *T=g_timer_new();
  srand(time(0));


  g_timer_start(T);  
  /* árbol AVL */
  {
    int i;
    AVLTree *t=AVL_hacer(44, AVL_vacio(), AVL_vacio());
    for(i=0; i<INSERCIONES; i++)
      AVL_insertar(&t, (int) (RAND_SUP*rand()/(RAND_MAX+1.0)), int_comp);
    for(i=0; i<ELIMINACIONES; i++)
      AVL_eliminar(&t, (int) (RAND_SUP*rand()/(RAND_MAX+1.0)), int_comp, 0,int_makecopy);
    AVL_destruir(t, 0);
  }
  g_timer_stop(T);
  g_timer_elapsed(T, &t_avl);

  g_timer_reset(T);

  g_timer_start(T);
  /* lista enlazada */
  {
    int i;
    list *l=NULL;
    for(i=0; i<INSERCIONES; i++)
      list_append((int) (RAND_SUP*rand()/(RAND_MAX+1.0)),l);
    for(i=0; i<ELIMINACIONES; i++)
      list_borrar((int) (RAND_SUP*rand()/(RAND_MAX+1.0)), l, int_comp, 0);
    list_destruir(l,0);
  }
  g_timer_stop(T);
  g_timer_elapsed(T, &t_list);

  g_timer_destroy(T);

  printf ("Tiempo del avl: %d\nTiempo de la lista: %d\n", t_avl, t_list);
  return 0;
}
