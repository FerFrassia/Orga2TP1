#include "redcaminera.h"


void rc_imprimirTodo(redCaminera* rc, FILE *pFile) {

	//print nombre
   fprintf(pFile, "%s\n%s\n", "Nombre:", rc->nombre);

   //print ciudades
   fprintf(pFile, "%s\n", "Ciudades:");

    lista* ciudades = rc->ciudades;
  	nodo* actualCiudad = ciudades->primero;
  	while (actualCiudad != NULL) {
  		ciudad* c = actualCiudad->dato;
  		fprintf(pFile, "%s%s%s%lu%s\n", "[", c->nombre, ",", c->poblacion, "]");
  		actualCiudad = actualCiudad->siguiente;
  	}

  	//print rutas
  	   fprintf(pFile, "%s\n", "Rutas:");

    lista* rutas = rc->rutas;
  	nodo* actualRuta = rutas->primero;
  	while (actualRuta != NULL) {
  		ruta* r = actualRuta->dato;
  		ciudad* a = r->ciudadA;
  		ciudad* b = r->ciudadB;
  		fprintf(pFile, "%s%s%s%s%s%.1f%s\n", "[", a->nombre, ",", b->nombre, ",", r->distancia, "]");
  		actualRuta = actualRuta->siguiente;
  	}
}

void rc_mergearCiudades(redCaminera* r, redCaminera* rc1, redCaminera* rc2) {
	nodo* nActual1 = rc1->ciudades->primero;
	nodo* nActual2 = rc2->ciudades->primero;

	while(nActual1 != NULL || nActual2 != NULL) {
		if (nActual1 != NULL) {
			if (nActual2 != NULL) {
				//AMBAS LISTAS TIENEN ELEMENTOS
				char* nombreC1 = ((ciudad*)nActual1->dato)->nombre;
				char* nombreC2 = ((ciudad*)nActual2->dato)->nombre;
				int32_t comparacion = str_cmp(nombreC1, nombreC2);
				
				if (comparacion == 1) {
					rc_agregarCiudad(r, nombreC1, ((ciudad*)nActual1->dato)->poblacion);
					nActual1 = nActual1->siguiente;
				}

				if (comparacion == -1) {
					rc_agregarCiudad(r, nombreC2, ((ciudad*)nActual2->dato)->poblacion);
					nActual2 = nActual2->siguiente;
				}

				if (comparacion == 0) {
					rc_agregarCiudad(r, nombreC1, ((ciudad*)nActual1->dato)->poblacion);
					nActual1 = nActual1->siguiente;
					nActual2 = nActual2->siguiente;
				}
			} else {
				//AGREGO DE LISTA 1
				rc_agregarCiudad(r, ((ciudad*)nActual1->dato)->nombre, ((ciudad*)nActual1->dato)->poblacion);
				nActual1 = nActual1->siguiente;
			}
		} else {
			//AGREGO DE LISTA 2
			rc_agregarCiudad(r, ((ciudad*)nActual2->dato)->nombre, ((ciudad*)nActual2->dato)->poblacion);
			nActual2 = nActual2->siguiente;	
		}
	}
}

void rc_mergearRutas(redCaminera* r, redCaminera* rc1, redCaminera* rc2) {
	nodo* rActual1 = rc1->rutas->primero;
	nodo* rActual2 = rc2->rutas->primero;

	while (rActual1 != NULL || rActual2 != NULL) {
		if (rActual1 != NULL) {
			if (rActual2 != NULL) {
				//AMBAS LISTAS TIENEN ELEMENTOS
				char* nombreA1 = ((ruta*)rActual1->dato)->ciudadA->nombre;
				char* nombreA2 = ((ruta*)rActual2->dato)->ciudadA->nombre;
				int32_t compA = str_cmp(nombreA1, nombreA2);

				if (compA == 1) {
					rc_agregarRuta(r, nombreA1, ((ruta*)rActual1->dato)->ciudadB->nombre, ((ruta*)rActual1->dato)->distancia);
					rActual1 = rActual1->siguiente;
				}

				if (compA == -1) {
					rc_agregarRuta(r, nombreA2, ((ruta*)rActual2->dato)->ciudadB->nombre, ((ruta*)rActual2->dato)->distancia);
					rActual2 = rActual2->siguiente;
				}

				if (compA == 0) {
					char* nombreB1 = ((ruta*)rActual1->dato)->ciudadB->nombre;
					char* nombreB2 = ((ruta*)rActual2->dato)->ciudadB->nombre;
					int32_t compB = str_cmp(nombreB1, nombreB2);

					if (compB == 1) {
						rc_agregarRuta(r, nombreA1, nombreB1, ((ruta*)rActual1->dato)->distancia);
						rActual1 = rActual1->siguiente;
					}

					if (compB == -1) {
						rc_agregarRuta(r, nombreA2, nombreB2, ((ruta*)rActual2->dato)->distancia);
						rActual2 = rActual2->siguiente;
					}

					if (compB == 0) {
						rc_agregarRuta(r, nombreA1, nombreB1, ((ruta*)rActual1->dato)->distancia);
						rActual1 = rActual1->siguiente;
						rActual2 = rActual2->siguiente;
					}
				}
			} else {
				//AGREGO DE LISTA 1
				rc_agregarRuta(r, ((ruta*)rActual1->dato)->ciudadA->nombre, ((ruta*)rActual1->dato)->ciudadB->nombre, ((ruta*)rActual1->dato)->distancia);
				rActual1 = rActual1->siguiente;
			}
		} else {
			//AGREGO DE LISTA 2
			rc_agregarRuta(r, ((ruta*)rActual2->dato)->ciudadA->nombre, ((ruta*)rActual2->dato)->ciudadB->nombre, ((ruta*)rActual2->dato)->distancia);
			rActual2  =rActual2->siguiente;
		}
	}
}

redCaminera* rc_combinarRedes(char* nombre, redCaminera* rc1, redCaminera* rc2) {
	redCaminera* r = rc_crear(nombre);
	rc_mergearCiudades(r, rc1, rc2);
	rc_mergearRutas(r, rc1, rc2);
    return r;
}

void rc_agregarSubCiudades(redCaminera* r, redCaminera* rc, lista* ciudades) {
	nodo* actual = ciudades->primero;
	while (actual != NULL) {
		ciudad* ciudadABuscar = (ciudad*)actual->dato;
		ciudad* ciudadObtenida = obtenerCiudad(rc, ciudadABuscar->nombre);
		if (ciudadObtenida != NULL) {
			rc_agregarCiudad(r, ciudadObtenida->nombre, ciudadObtenida->poblacion);
		}
		actual = actual->siguiente;
	}
}

void rc_agregarSubRutas(redCaminera* r, redCaminera* rc) {
	lista* rutasABuscar = rc->rutas;
	nodo* actual = rutasABuscar->primero;
	while (actual != NULL) {
		ruta* rutaActual = (ruta*)actual->dato;
		char* nombreA = rutaActual->ciudadA->nombre;
		char* nombreB = rutaActual->ciudadB->nombre;
		if (obtenerCiudad(r, nombreA) != NULL && obtenerCiudad(r, nombreB) != NULL) {
			rc_agregarRuta(r, nombreA, nombreB, rutaActual->distancia);
		}
		actual = actual->siguiente;
	}
}

redCaminera* rc_obtenerSubRed(char* nombre, redCaminera* rc, lista* ciudades) {
	redCaminera* r = rc_crear(nombre);
	rc_agregarSubCiudades(r, rc, ciudades);
	rc_agregarSubRutas(r, rc);
    return r;
}