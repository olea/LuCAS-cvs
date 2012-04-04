/* * * * * * * * * * * * * * * * */
/*    Á R B O L    A V L         */
/* * * * * * * * * * * * * * * * */


#ifndef bool
#ifndef false
#define false 0
#define true 1
#endif
#define bool int
#endif


/* Declaración del Meta dato almacenado en el AVLTree */
/* Definido por el usuario                            */

typedef int AVL_TipoDato;
typedef int (*AVL_TipoDatoCompareFunc) (AVL_TipoDato a, AVL_TipoDato b);
/* Las funciones de este tipo deben cumplir con: (comp(a,b)<0
   sii. a<b), (comp(a,b)==0 sii. a==b), (comp(a,b)>0 sii. a>b).*/

typedef void (*AVL_TipoDatoDestroyFunc) (AVL_TipoDato a);
/* Las funciones de este tipo deben liberar la memoria ocupada
   por un objeto del tipo AVL_TipoDato. */

typedef AVL_TipoDato (*AVL_TipoDatoMakeCpy) (AVL_TipoDato a);
/* las funciones de este tipo deben encargarse de hacer copias en memoria
   (posiblemente dinámicas) de los objetos AVL_TipoDato */


/* Declaración del TAD AVLTree (árbol AVL) */

typedef struct AVLNode AVLTree;

struct AVLNode
{
  AVL_TipoDato dato;
  AVLTree *izq;
  AVLTree *der;
  int altura;
};



/* Constructores */

AVLTree *AVL_vacio (void);
/* devuelve un árbol AVL vacío */

AVLTree *AVL_hacer (AVL_TipoDato x, AVLTree * izq, AVLTree * der);
/* devuelve un nuevo árbol formado por una raíz con valor x,
   subárbol AVL_izquierdo el árbol izq y subárbol AVL_derecho el árbol
   der. */



/*  Predicados   */

bool AVL_es_vacio (AVLTree * t);
/* devuelve true sii. t es un árbol vacío. */



/*  Selectores   */

AVLTree *AVL_izquierdo (AVLTree * t);
/* devuelve el subárbol AVL_izquierdo de t. */

AVLTree *AVL_derecho (AVLTree * t);
/* devuelve el subárbol AVL_derecho de t. */

AVL_TipoDato AVL_raiz (AVLTree * t);
/* devuelve el valor de la raíz del árbol t. Precondición:
   !AVL_es_vacio(t) */

int AVL_altura (AVLTree * t);
/* devuelve la AVL_altura del nodo t en el árbol */



/*  Destructures */

void AVL_destruir (AVLTree * t, AVL_TipoDatoDestroyFunc free_dato);
/* libera la memoria ocupada por los nodos del árbol. Si los
   datos almacenados en cada nodo están almacenados dinámicamente
   y se los quiere liberar también, debe pasarse como segundo
   parámetro una función de tipo void func(int t) que libere
   la memoria de objetos int. Si los datos no están
   almacenados dinámicamente o simplemente no se los quiere
   AVL_destruir (liberar de memoria), pásese como segundo parámetro
   NULL. Nota: Función Recursiva! */



/*  Rotaciones y balance del árbol  */

void AVL_rotar_s (AVLTree ** t, bool izq);
/* realiza una rotación simple del árbol t el cual se
   pasa por referencia. La rotación será izquierda
   sii. (izq==true) o será derecha
   sii. (izq==false). 

   Nota: las AVL_alturas de t y sus subárboles serán actualizadas
   dentro de esta función!

   Precondición:
   si (izq==true) ==> !AVL_es_vacio(AVL_izquierdo(t)) 
   si (izq==false) ==> !AVL_es_vacio(AVL_derecho(t))
*/

void AVL_rotar_d (AVLTree ** t, bool izq);
/* realiza una rotación doble. Funciona análogamente a
   AVL_rotar_s(). */

void AVL_balancear (AVLTree ** t);
/* Detecta y corrige por medio de un número finito de rotaciones
   un desequilibrio en el árbol *t. Dicho desequilibrio no debe
   tener una diferencia de AVL_alturas de más de 2. */

void AVL_actualizar_altura (AVLTree * t);




/*   Inserción y eliminación   */

void AVL_insertar (AVLTree ** t, AVL_TipoDato x,
		   AVL_TipoDatoCompareFunc comp);
/* inserta x en el árbol en un tiempo O(log(n)) peor caso. */

void AVL_eliminar (AVLTree ** t, AVL_TipoDato x, AVL_TipoDatoCompareFunc comp,
		   AVL_TipoDatoDestroyFunc destroy, AVL_TipoDatoMakeCpy makecpy);
/* elimina x del árbol en un tiempo O(log(n)) peor caso. 
   Precondición: existe un nodo con valor x en el árbol
   t. */




/* Funciones Auxiliares */

#define AVL_max(A,B) ((A>B)?(A):(B))

AVL_TipoDato AVL_eliminar_min (AVLTree ** t, AVL_TipoDatoDestroyFunc destroy, AVL_TipoDatoMakeCpy makecpy);
/* Función auxiliar a AVL_eliminar(). Elimina el menor nodo del árbol
   *t devolviendo su contenido (el cual no se libera de
   memoria). Se actualizan las AVL_alturas de los nodos. precond:
   !AVL_es_vacio(*t) */
