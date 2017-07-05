#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "redcaminera.h"

int main (void) {
	FILE *pFile = fopen("PepeGuapo.txt", "a" );

	redCaminera* rc = rc_crear("kukamonga");

	rc_agregarCiudad(rc, "montebello", 12041);
	rc_agregarCiudad(rc, "north haverbrook", 1244);
	rc_agregarCiudad(rc, "cocula", 342);

	rc_agregarRuta(rc, "montebello", "north haverbrook", 232);
	rc_agregarRuta(rc, "montebello", "cocula", 233);
	rc_agregarRuta(rc, "north haverbrook", "cocula", 236);

	ciudad* c = ciudadMasPoblada(rc);
	ruta* r = rutaMasLarga(rc);

	rc_imprimirTodo(rc, pFile);
	fprintf(pFile, "Ciudad mas poblada: %s%s%s%lu%s\n", "[", c->nombre, ",", c->poblacion, "]");
	fprintf(pFile, "Ruta mas larga: %s%s%s%s%s%.1f%s\n", "[", r->ciudadA->nombre, ",", r->ciudadB->nombre, ",", r->distancia, "]");

	fclose(pFile);

    return 0;    
}
