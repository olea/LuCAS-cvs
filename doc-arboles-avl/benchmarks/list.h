/* lista (simple) enlazada */


#ifndef bool
#ifndef false
#define false 0
#define true 1
#endif
#define bool int
#endif

typedef int list_TipoDato;

typedef int (*list_TipoDatoCompareFunc) (list_TipoDato a, list_TipoDato b);
/* Las funciones de este tipo deben cumplir con: (comp(a,b)<0
   sii. a<b), (comp(a,b)==0 sii. a==b), (comp(a,b)>0 sii. a>b).*/

typedef void (*list_TipoDatoDestroyFunc) (list_TipoDato a);
/* Las funciones de este tipo deben liberar la memoria ocupada
   por un objeto del tipo AVL_list_TipoDato. */



typedef struct _list list;

struct _list
{
  list_TipoDato data;
  list *next;
};



/* Acceso a los nodos (listas enlazadas) de la tabla */

list *list_append (list_TipoDato x, list * l);
/* inserta el elemento x al principio de la lista l */

list *list_borrar (list_TipoDato x, list * l, list_TipoDatoCompareFunc comp,
		   list_TipoDatoDestroyFunc destroy);
/* borra (si existe) el elemento de valor x de la lista l. El
   tercer parámetro debe ser una función de comparación entre los
   elementos list_TipoDato de la lista. Si los objetos list_TipoDato
   requieren ser eliminados dinámicamente de memoria o algo por
   el estilo, puede pasarse como 4to parámetro una función para
   tal propósito. De otro modo, pasar NULL. */

void list_destruir (list * l, list_TipoDatoDestroyFunc destroy);
/* Libera la memoria ocupada por la lista. Si los objetos
   list_TipoDato requieren ser eliminados dinámicamente de memoria o
   algo por el estilo, puede pasarse como 4to parámetro una
   función para tal propósito. De otro modo, pasar NULL. */

bool list_pertenece (list * l, list_TipoDato x,
		     list_TipoDatoCompareFunc comp);
/* devuelve true si x pertenece a la lista l. De otro modo
   devuelve false. */
