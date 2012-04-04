#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

/* * * * * * * * * * * * * * * * */
/*    Á R B O L    A V L         */
/* * * * * * * * * * * * * * * * */

AVLTree *
AVL_vacio (void)
{
  return NULL;
}

AVLTree *
AVL_hacer (AVL_TipoDato x, AVLTree * izq, AVLTree * der)
{

  AVLTree *aux = (AVLTree *) malloc (sizeof (AVLTree));  
  aux->altura = AVL_max (AVL_altura (izq), AVL_altura (der)) + 1;
  aux->dato = x;
  aux->izq = izq;
  aux->der = der;
  return aux;
}

bool
AVL_es_vacio (AVLTree * t)
{
  return t == NULL;
}

AVLTree *
AVL_izquierdo (AVLTree * t)
{
  return t->izq;
}

AVLTree *
AVL_derecho (AVLTree * t)
{
  return t->der;
}

AVL_TipoDato
AVL_raiz (AVLTree * t)
{
  return t->dato;
}

int
AVL_altura (AVLTree * t)
{
  if (AVL_es_vacio (t))
    return -1;
  else
    return t->altura;
}

void
AVL_destruir (AVLTree * t, AVL_TipoDatoDestroyFunc free_dato)
{
  if (!AVL_es_vacio (t))
    {
      if (AVL_es_vacio (AVL_izquierdo (t)) && AVL_es_vacio (AVL_derecho (t)))
	{
	  if (free_dato)
	    free_dato (AVL_raiz (t));
	  free (t);
	}
      else
	{
	  AVL_destruir (AVL_izquierdo (t), free_dato);
	  AVL_destruir (AVL_derecho (t), free_dato);
	  if (free_dato)
	    free_dato (AVL_raiz (t));
	  free (t);
	}
    }
}




void
AVL_rotar_s (AVLTree ** t, bool izq)
{
  AVLTree *t1;
  if (izq)			/* rotación izquierda */
    {
      t1 = AVL_izquierdo (*t);
      (*t)->izq = AVL_derecho (t1);
      t1->der = *t;
    }
  else				/* rotación derecha */
    {
      t1 = AVL_derecho (*t);
      (*t)->der = AVL_izquierdo (t1);
      t1->izq = *t;
    }

  /* actualizamos las AVL_alturas de ambos nodos modificados */
  AVL_actualizar_altura (*t);
  AVL_actualizar_altura (t1);

  /* asignamos nueva raíz */
  *t = t1;
}






void
AVL_rotar_d (AVLTree ** t, bool izq)
{
  if (izq)			/* rotación izquierda */
    {
      AVL_rotar_s (&(*t)->izq, false);
      AVL_rotar_s (t, true);
    }
  else				/* rotación derecha */
    {
      AVL_rotar_s (&(*t)->der, true);
      AVL_rotar_s (t, false);
    }

  /* la actualización de las AVL_alturas se realiza en las rotaciones
     simples */
}









void
AVL_insertar (AVLTree ** t, AVL_TipoDato x, AVL_TipoDatoCompareFunc comp)
{
  if (AVL_es_vacio (*t))
    *t = AVL_hacer (x, AVL_vacio (), AVL_vacio ());	/* AVL_altura actualizada
							   automáticamente */
  else
    {
      if (comp (x, AVL_raiz (*t)) < 0)
	AVL_insertar (&(*t)->izq, x, comp);

      else
	AVL_insertar (&(*t)->der, x, comp);

      AVL_balancear (t);
      AVL_actualizar_altura (*t);
    }
}










void
AVL_balancear (AVLTree ** t)
{
  if (!AVL_es_vacio (*t))
    {
      if (AVL_altura (AVL_izquierdo (*t)) - AVL_altura (AVL_derecho (*t)) ==
	  2)
	{			/* desequilibrio hacia la izquierda! */
	  if (AVL_altura ((*t)->izq->izq) >= AVL_altura ((*t)->izq->der))
	    /* desequilibrio simple hacia la izquierda */
	    AVL_rotar_s (t, true);
	  else
	    /* desequilibrio doble hacia la izquierda */
	    AVL_rotar_d (t, true);
	}

      else if (AVL_altura (AVL_derecho (*t)) -
	       AVL_altura (AVL_izquierdo (*t)) == 2)
	{			/* desequilibrio hacia la derecha! */
	  if (AVL_altura ((*t)->der->der) >= AVL_altura ((*t)->der->izq))
	    /* desequilibrio simple hacia la izquierda */
	    AVL_rotar_s (t, false);
	  else
	    /* desequilibrio doble hacia la izquierda */
	    AVL_rotar_d (t, false);
	}
    }
}









AVL_TipoDato
AVL_eliminar_min (AVLTree ** t, AVL_TipoDatoDestroyFunc destroy, AVL_TipoDatoMakeCpy makecpy)
{
  if (AVL_es_vacio (*t))
    {
      fprintf (stderr, "No se respeta precondición de AVL_eliminar_min()\n");
      return 0;
    }
  else
    {
      if (!AVL_es_vacio (AVL_izquierdo (*t)))
	{
	  AVL_TipoDato x = AVL_eliminar_min (&(*t)->izq, destroy, makecpy);
	  AVL_balancear (t);
	  AVL_actualizar_altura (*t);
	  return x;
	}
      else
	{
	  AVLTree *aux = (*t);
          AVL_TipoDato x;
          if(makecpy) 
            x=makecpy(AVL_raiz (aux));
          else
            x = AVL_raiz (aux);
	  *t = AVL_derecho (*t);
	  if (destroy)
	    destroy (AVL_raiz (aux));
	  free (aux);
	  AVL_balancear (t);
	  AVL_actualizar_altura (*t);
	  return x;
	}
    }
}



void
AVL_eliminar (AVLTree ** t, AVL_TipoDato x, AVL_TipoDatoCompareFunc comp,
	      AVL_TipoDatoDestroyFunc destroy, AVL_TipoDatoMakeCpy makecpy)
{
  if(!AVL_es_vacio(*t)){
  AVLTree *aux;

  if (comp (x, AVL_raiz (*t)) < 0)
    AVL_eliminar (&(*t)->izq, x, comp, destroy, makecpy);

  else if (comp (x, AVL_raiz (*t)) > 0)
    AVL_eliminar (&(*t)->der, x, comp, destroy, makecpy);

  else				/* coincidencia! */
    {
      if (AVL_es_vacio (AVL_izquierdo (*t))
	  && AVL_es_vacio (AVL_derecho (*t)))
	{			/* es una hoja */
	  if (destroy)
	    destroy (AVL_raiz (*t));
	  free (*t);
	  (*t) = AVL_vacio ();
	}
      else if (AVL_es_vacio (AVL_izquierdo (*t)))
	{			/* subárbol AVL_izquierdo AVL_vacio */
	  aux = (*t);
	  (*t) = (*t)->der;
	  if (destroy)
	    destroy (AVL_raiz (aux));
	  free (aux);
	}
      else if (AVL_es_vacio (AVL_derecho (*t)))
	{			/* subárbol AVL_derecho AVL_vacio */
	  aux = (*t);
	  (*t) = (*t)->izq;
	  if (destroy)
	    destroy (AVL_raiz (aux));
	  free (aux);
	}
      else			/* caso más complicado */
	{
	  (*t)->dato = AVL_eliminar_min (&(*t)->der, destroy, makecpy);
	}
    }

  AVL_balancear (t);
  AVL_actualizar_altura (*t);
  }
}


void
AVL_actualizar_altura (AVLTree * t)
{
  if (!AVL_es_vacio (t))
    t->altura = AVL_max (AVL_altura ((t)->izq), AVL_altura ((t)->der)) + 1;
}
