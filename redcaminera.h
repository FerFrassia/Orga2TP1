#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

//* testing include *//
#include <stdbool.h>

/** Estructuras de LISTA **/

typedef struct lista_t {
  uint32_t longitud;
  struct nodo_t* primero;
  struct nodo_t* ultimo;
} __attribute__((__packed__)) lista;

typedef struct nodo_t {
  void (*func_borrar)(void*);
  void* dato;
  struct nodo_t* siguiente;
  struct nodo_t* anterior;
} __attribute__((__packed__)) nodo;

/** Estructuras de RED CAMINERA **/

typedef struct redCaminera_t {
  struct lista_t* ciudades;
  struct lista_t* rutas;
  char* nombre;
} __attribute__((__packed__)) redCaminera;

typedef struct ciudad_t {
  char* nombre;
  uint64_t poblacion;
} __attribute__((__packed__)) ciudad;

typedef struct ruta_t {
  struct ciudad_t* ciudadA;
  double distancia;
  struct ciudad_t* ciudadB;
} __attribute__((__packed__)) ruta;

/** Funciones de LISTA **/

lista* l_crear();
void l_agregarAdelante(lista** l, void* dato, void (*func_borrar)(void*));
void l_agregarAtras(lista** l, void* dato, void (*func_borrar)(void*));
void l_agregarOrdenado(lista** l, void* dato, void (*func_borrar)(void*), int (*func_cmp)(void*,void*));
void l_borrarTodo(lista* l);

/** Funciones de testing de LISTA **/
bool l_listaEsNull(lista* l);
bool l_listaEsVacia(lista* l);
void l_print(lista* l);
bool l_existeDato(lista* l, void* dato);

/** Funciones de CIUDAD y RUTA **/

ciudad* c_crear(char* nombre, uint64_t poblacion);
int32_t c_cmp(ciudad* c1, ciudad* c2);
void c_borrar(ciudad* c);

/**funciones testing ciudad **/
bool c_ciudadEsNull(ciudad* c);
uint64_t c_ciudadPoblacion(ciudad* c);
char* c_ciudadNombre(ciudad* c);

ruta* r_crear(ciudad* c1, ciudad* c2, double distancia);
int32_t r_cmp(ruta* r1, ruta* r2);
void r_borrar(ruta* r);

/** Funciones testing ruta **/
ciudad* r_ciudad_A(ruta* r);
ciudad* r_ciudad_B(ruta* r);
double r_distancia(ruta* r);

/** Funciones de RED CAMINERA **/

redCaminera* rc_crear(char* nombre);
void rc_borrarTodo(redCaminera* rc);
void rc_agregarCiudad(redCaminera* rc, char* nombre, uint64_t poblacion);
void rc_agregarRuta(redCaminera* rc, char* ciudad1, char* ciudad2, double distancia);
void rc_imprimirTodo(redCaminera* rc, FILE *pFile);
redCaminera* rc_combinarRedes(char* nombre, redCaminera* rc1, redCaminera* rc2);
redCaminera* rc_obtenerSubRed(char* nombre, redCaminera* rc, lista* ciudades);

/** testing red caminera **/


/** Funciones de consulta de RED CAMINERA **/

ciudad* obtenerCiudad(redCaminera* rc, char* c);
ruta* obtenerRuta(redCaminera* rc, char* c1, char* c2);
ciudad* ciudadMasPoblada(redCaminera* rc);
ruta* rutaMasLarga(redCaminera* rc);
void ciudadesMasLejanas(redCaminera* rc, ciudad** c1, ciudad** c2);
uint32_t cantidadDeCaminos(redCaminera *rc, char* ci);
double totalDeDistancia(redCaminera *rc);
uint64_t totalDePoblacion(redCaminera *rc);
ciudad* ciudadMasComunicada(redCaminera *rc);

/** Funciones auxiliares **/

char* str_copy(char* a);
int32_t str_cmp(char* a, char* b);
