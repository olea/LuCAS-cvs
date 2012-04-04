#include "list.h"
#include <stdlib.h>

list *
list_append (list_TipoDato x, list * l)
{
  list *aux = (list *) malloc (sizeof (list));
  aux->data = x;
  aux->next = l;
  return aux;
}

list *
list_borrar (list_TipoDato x, list * l, list_TipoDatoCompareFunc comp,
	     list_TipoDatoDestroyFunc destroy)
{
  if(l){
  list *m = l, *aux;
  if (comp (x, m->data) == 0)
    {
      if (destroy)
	destroy (m->data);
      l = m->next;
      free (m);
    }
  else
    while (m->next)
      {
	if (comp (x, m->next->data) == 0)
	  {
	    if (destroy)
	      destroy (m->next->data);
	    aux = m->next->next;
	    free (m->next);
	    m->next = aux;
	    break;
	  }
	m = m->next;
      }
  return l;
  }
}

void
list_destruir (list * l, list_TipoDatoDestroyFunc destroy)
{
  list *aux;
  while ((aux = l))
    {
      if (destroy)
	destroy (l->data);
      l = l->next;
      free (aux);
    }
}

bool
list_pertenece (list * l, list_TipoDato x, list_TipoDatoCompareFunc comp)
{
  while (l)
    {
      if (comp (x, l->data) == 0)
	return true;
      l = l->next;
    }
  return false;
}

