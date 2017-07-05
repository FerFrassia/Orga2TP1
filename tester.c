#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "redcaminera.h"

char *archivoCasoLista  =  "salida.caso.lista.txt";
char *archivoCasoRedChica =  "salida.caso.redchica.txt";
char *archivoCasoRedGrande =  "salida.caso.redgrande.txt";

void casoL();
void casoC();
void casoG();

int main() {
  remove(archivoCasoLista);
  casoL();
  remove(archivoCasoRedChica);
  casoC();
  remove(archivoCasoRedGrande);
  casoG();
  return 0;
}

void imprimirListaTexto(lista* l, FILE *pFile) {
  nodo *n = l->primero;
  while(n) {
    char** c = (char**)n->dato;
    fprintf(pFile, "[%s]\n", *c);
    n = n->siguiente;
  }
}

void imprimirListaCiudad(lista* l, FILE *pFile) {
  nodo *nc = l->primero;
  while(nc) {
    ciudad* c = (ciudad*)nc->dato;
    fprintf(pFile, "[%s,%li]\n", c->nombre, c->poblacion);
    nc = nc->siguiente;
  }
}

void casoL() {
    FILE *pFile;
    pFile = fopen( archivoCasoLista, "a" );
    
    fputs( "Test agregar independiente\n", pFile );

    char* text[12]={"ramon","sracw","jss1f","bamon","cracw","hamon","dss1f","ass1f","eamon","fracw","gss1f","iracw"};
    int  value[12]={ 8145,   6545,   1422,   8145,   6545,   8145,   1422,   1422,   8145,   6545,   1422,   6545  };
    

    lista* ll;
    for(int i=1;i<12;i++) {
        ll = l_crear();
        for(int j=0;j<i;j++)
            l_agregarAdelante(&ll, c_crear(text[j],value[j]), (void (*)(void*))c_borrar);
        imprimirListaCiudad(ll,pFile);
        l_borrarTodo(ll);
    }

    for(int i=1;i<12;i++) {
        ll = l_crear();
        for(int j=0;j<i;j++)
            l_agregarAtras(&ll, c_crear(text[j],value[j]), (void (*)(void*))c_borrar);
        imprimirListaCiudad(ll,pFile);
        l_borrarTodo(ll);   
    }
    
    for(int i=1;i<12;i++) {
        ll = l_crear();
        for(int j=0;j<i;j++)
            l_agregarOrdenado(&ll, c_crear(text[j],value[j]), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
        imprimirListaCiudad(ll,pFile);
        l_borrarTodo(ll);   
    }
    
    fputs( "\nTest agregar repetidos\n", pFile );
    
    ll = l_crear();
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",1), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",2), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    imprimirListaCiudad(ll,pFile);
    l_borrarTodo(ll);

    ll = l_crear();
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",2), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",1), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("ramon",9), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    imprimirListaCiudad(ll,pFile);
    l_borrarTodo(ll);  
    
    fputs( "\nTest agregar junto\n", pFile );
    
    char* textA[12]={"ccfcc","dddsd","a2aaa","bbbdb","lllll","kakkk","jjjjd","hhhah","iiifi","ffmff","eneee","jgggg"};
    char* textB[12]={"cccfc","dsddd","aaa2a","bbbdb","lllll","kkksk","jjjjd","ahhhh","iifii","mffff","eneee","ggjgg"};
    char* textC[12]={"cfccc","ddsdd","a2aaa","bdbbb","lllll","kakkk","jjdjj","hhhah","ifiii","fffmf","eenee","ggjgg"};

    for(int i=1;i<12;i++) {
        ll = l_crear();
        for(int j=0;j<i;j++) {
            l_agregarAdelante(&ll, c_crear(textA[j],value[j]), (void (*)(void*))c_borrar);
            l_agregarAtras(&ll,    c_crear(textB[j],value[j]), (void (*)(void*))c_borrar);
            l_agregarOrdenado(&ll, c_crear(textC[j],value[j]), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
        }
        imprimirListaCiudad(ll,pFile);
        l_borrarTodo(ll);   
    }

    fclose( pFile );
}

void casoC() {
    FILE *pFile;
    pFile = fopen( archivoCasoRedChica, "a" );
    
    redCaminera *rc, *rc1, *rc2, *rcc;
    ciudad* c;
    ciudad* c1;
    ciudad* c2;
    ruta* r;
    uint32_t a;
    double totald;
    uint64_t totalp;
    ciudad* cMas;
    lista* ll;
    
    fputs( "Test casos chicos\n", pFile );
    
    rc = rc_crear("sarasa");
    rc_imprimirTodo(rc, pFile);
    rc_borrarTodo(rc);
    rc = rc_crear("sarasa");
    rc_agregarCiudad(rc, "sarasas", 1000);
    rc_imprimirTodo(rc, pFile);
    rc_borrarTodo(rc);    
    rc = rc_crear("sarasa");
    rc_agregarCiudad(rc, "sarasas", 1000);
    rc_agregarRuta(rc, "no", "no", 30.234);
    rc_agregarRuta(rc, "sh345hs", "no", 30.234);
    rc_agregarRuta(rc, "sh345hs", "sarasas", 30.234);
    rc_imprimirTodo(rc, pFile);
    rc_borrarTodo(rc);
    rc = rc_crear("sarasa");
    rc_agregarCiudad(rc, "sarasas", 1000);
    rc_agregarCiudad(rc, "7nhewrs", 1003);
    rc_agregarCiudad(rc, "no", 1003);
    rc_agregarRuta(rc, "sarasas", "7nhewrs", 10);
    rc_agregarRuta(rc, "no", "no", 30.234);
    c = ciudadMasPoblada(rc);
    fprintf(pFile,"%s\n",c->nombre);
    r = rutaMasLarga(rc);
    fprintf(pFile,"%f\n",r->distancia);
    ciudadesMasLejanas(rc, &c1, &c2);
    fprintf(pFile,"%s %s\n",c1->nombre,c2->nombre);
    a = cantidadDeCaminos(rc, "sh345hs");
    fprintf(pFile,"%i\n",a);
    totald = totalDeDistancia(rc);
    fprintf(pFile,"%f\n",totald);
    totalp = totalDePoblacion(rc);
    fprintf(pFile,"%li\n",totalp);
    cMas = ciudadMasComunicada(rc);
    fprintf(pFile,"%s\n",cMas->nombre);
    rc_imprimirTodo(rc, pFile);
    rc_borrarTodo(rc);
    
    fputs( "\nTest caso duplicado\n", pFile );
    
    rc = rc_crear("sarasa");
    rc_agregarCiudad(rc, "sarasas", 1000);
    rc_agregarCiudad(rc, "sh345hs", 9999);
    rc_agregarCiudad(rc, "8324sas", 4443);
    rc_agregarCiudad(rc, "7nhewrs", 1003);
    rc_agregarCiudad(rc, "avsdv4s", 1004);
    rc_agregarRuta(rc, "sh345hs", "sarasas", 30.234);
    rc_agregarRuta(rc, "sh345hs", "avsdv4s", 31.234);
    rc_agregarRuta(rc, "sh345hs", "7nhewrs", 54.234);
    rc_agregarRuta(rc, "sarasas", "7nhewrs", 33.234);
    rc_agregarRuta(rc, "sarasas", "avsdv4s", 34.234);
    rc_agregarRuta(rc, "8324sas", "sh345hs", 3545);
    c = ciudadMasPoblada(rc);
    fprintf(pFile,"%s\n",c->nombre);
    r = rutaMasLarga(rc);
    fprintf(pFile,"%f\n",r->distancia);
    ciudadesMasLejanas(rc, &c1, &c2);
    fprintf(pFile,"%s %s\n",c1->nombre,c2->nombre);
    a = cantidadDeCaminos(rc, "sh345hs");
    fprintf(pFile,"%i\n",a);
    totald = totalDeDistancia(rc);
    fprintf(pFile,"%f\n",totald);
    totalp = totalDePoblacion(rc);
    fprintf(pFile,"%li\n",totalp);
    cMas = ciudadMasComunicada(rc);
    fprintf(pFile,"%s\n",cMas->nombre);
    rc_imprimirTodo(rc, pFile);
    rc_agregarCiudad(rc, "sarasas", 1000);
    rc_agregarCiudad(rc, "sh345hs", 9999);
    rc_agregarCiudad(rc, "8324sas", 4443);
    rc_agregarCiudad(rc, "7nhewrs", 1003);
    rc_agregarCiudad(rc, "avsdv4s", 1004);
    rc_agregarRuta(rc, "sh345hs", "sarasas", 30.234);
    rc_agregarRuta(rc, "sh345hs", "avsdv4s", 31.234);
    rc_agregarRuta(rc, "sh345hs", "7nhewrs", 54.234);
    rc_agregarRuta(rc, "sarasas", "7nhewrs", 33.234);
    rc_agregarRuta(rc, "sarasas", "avsdv4s", 34.234);
    rc_agregarRuta(rc, "8324sas", "sh345hs", 3545);
    rc_agregarCiudad(rc, "weegwq1", 1);
    rc_agregarCiudad(rc, "weegwq2", 2);
    rc_agregarCiudad(rc, "weegwq3", 3);
    rc_agregarCiudad(rc, "weegwq4", 4);
    rc_agregarCiudad(rc, "weegwq5", 5);
    rc_agregarRuta(rc, "weegwq1", "weegwq4", 0);
    rc_agregarRuta(rc, "weegwq2", "weegwq3", 10);
    rc_agregarRuta(rc, "weegwq2", "weegwq5", 100);
    rc_agregarRuta(rc, "weegwq2", "weegwq5", 1000);
    rc_agregarRuta(rc, "weegwq2", "weegwq2", 10000);
    rc_agregarRuta(rc, "weegwq2", "weegwq2", 100000);
    c = ciudadMasPoblada(rc);
    fprintf(pFile,"%s\n",c->nombre);
    r = rutaMasLarga(rc);
    fprintf(pFile,"%f\n",r->distancia);
    ciudadesMasLejanas(rc, &c1, &c2);
    fprintf(pFile,"%s %s\n",c1->nombre,c2->nombre);
    a = cantidadDeCaminos(rc, "sh345hs");
    fprintf(pFile,"%i\n",a);
    totald = totalDeDistancia(rc);
    fprintf(pFile,"%f\n",totald);
    totalp = totalDePoblacion(rc);
    fprintf(pFile,"%li\n",totalp);
    cMas = ciudadMasComunicada(rc);
    fprintf(pFile,"%s\n",cMas->nombre);
    rc_imprimirTodo(rc, pFile);
    rc_borrarTodo(rc);

    fputs( "\nTest caso combinar\n", pFile );
    
    rc1 = rc_crear("r1");
    rc2 = rc_crear("r2");
    rc_imprimirTodo(rc1, pFile);
    rc_imprimirTodo(rc2, pFile);
    rcc = rc_combinarRedes("tasss",rc1,rc2);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc);
    rc_agregarCiudad(rc1, "sarasa1", 10 );
    rc_agregarCiudad(rc2, "sarasa2", 10 );
    rc_imprimirTodo(rc1, pFile);
    rc_imprimirTodo(rc2, pFile);
    rcc = rc_combinarRedes("tasss",rc1,rc2);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc);
    rc_agregarCiudad(rc1, "sarasa1", 101 );
    rc_agregarCiudad(rc1, "sarasa2", 102 );
    rc_agregarCiudad(rc1, "sarasa3", 103 );
    rc_agregarCiudad(rc1, "sarasa4", 104 );
    rc_agregarCiudad(rc1, "sar1", 1011 );
    rc_agregarRuta(rc1, "sarasa1", "sarasa2", 100.11);
    rc_agregarRuta(rc1, "sarasa3", "sarasa4", 100.12);
    rc_agregarCiudad(rc2, "sarasa4", 104 );
    rc_agregarCiudad(rc2, "sar1", 1011 );
    rc_agregarCiudad(rc2, "sar2", 1021 );
    rc_agregarCiudad(rc2, "sar3", 1031 );
    rc_agregarCiudad(rc2, "sar4", 1041 );
    rc_agregarRuta(rc1, "sar1", "sar2", 100.112);
    rc_agregarRuta(rc1, "sar3", "sar4", 100.122);
    rc_imprimirTodo(rc1, pFile);
    rc_imprimirTodo(rc2, pFile);
    rcc = rc_combinarRedes("tasss",rc1,rc2);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc);    
    rc_borrarTodo(rc1);
    rc_borrarTodo(rc2);
    
    fputs( "\nTest caso subred\n", pFile );
    
    rc1 = rc_crear("r1");
    rc_imprimirTodo(rc1, pFile);
    ll = l_crear();
    imprimirListaCiudad(ll,pFile);
    rcc = rc_obtenerSubRed("ufa", rc1, ll);
    rc_imprimirTodo(rcc, pFile);
    l_borrarTodo(ll);
    rc_borrarTodo(rcc);    
    rc_borrarTodo(rc1);
    rc1 = rc_crear("r1");
    rc_agregarCiudad(rc1, "sarasa1", 10 );
    rc_imprimirTodo(rc1, pFile);
    ll = l_crear();
    imprimirListaCiudad(ll,pFile);
    rcc = rc_obtenerSubRed("ufa", rc1, ll);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc);
    l_borrarTodo(ll);
    rc_borrarTodo(rc1);
    rc1 = rc_crear("r1");
    rc_imprimirTodo(rc1, pFile);
    ll = l_crear();
    l_agregarOrdenado(&ll, c_crear("asdgwg",130), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    imprimirListaCiudad(ll,pFile);
    rcc = rc_obtenerSubRed("ufa", rc1, ll);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc); 
    l_borrarTodo(ll);
    rc_borrarTodo(rc1);
    rc1 = rc_crear("r1");
    rc_agregarCiudad(rc1, "sarasa1", 101 );
    rc_agregarCiudad(rc1, "sarasa2", 102 );
    rc_agregarCiudad(rc1, "sarasa3", 103 );
    rc_agregarCiudad(rc1, "sarasa4", 104 );
    rc_agregarCiudad(rc1, "sar1", 1011 );
    rc_agregarCiudad(rc1, "sar2", 1021 );
    rc_agregarCiudad(rc1, "sar3", 1031 );
    rc_agregarCiudad(rc1, "sar4", 1041 );
    rc_agregarRuta(rc1, "sarasa1", "sarasa2", 100.11);
    rc_agregarRuta(rc1, "sarasa3", "sarasa4", 100.12);
    rc_agregarRuta(rc1, "sar1", "sar2", 100.112);
    rc_agregarRuta(rc1, "sar3", "sar4", 100.122);
    rc_imprimirTodo(rc1, pFile);
    ll = l_crear();
    l_agregarOrdenado(&ll, c_crear("sarasa1",999), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("sarasa2",999), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    l_agregarOrdenado(&ll, c_crear("sar3",999999), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
    imprimirListaCiudad(ll,pFile);
    rcc = rc_obtenerSubRed("ufa", rc1, ll);
    rc_imprimirTodo(rcc, pFile);
    rc_borrarTodo(rcc);
    l_borrarTodo(ll);
    rc_borrarTodo(rc1);
    
    fclose( pFile );
}

void casoG() {
    FILE *pFile;
    pFile = fopen( archivoCasoRedGrande, "a" );
    
    redCaminera *rc, *rc1, *rc2;
    ciudad* c;
    ciudad* c1;
    ciudad* c2;
    ruta* r;
    uint32_t a;
    double totald;
    uint64_t totalp;
    ciudad* cMas;
    char text1[100];
    char text2[100];
    
    fputs( "Test\n", pFile );
    
    srand(70);
    for(int size=0;size<100;size=size+10)
    {
        rc = rc_crear("nombre");
        for(int i=0;i<size;i++) {
            sprintf(text1, "name%i", rand()%1000);
            sprintf(text2, "name%i", rand()%1000);
            rc_agregarCiudad(rc, text1, rand()%1000 );
            rc_agregarCiudad(rc, text2, rand()%1000 );
            rc_agregarRuta(rc, text1, text2, rand()%10000 / 100 );
        }
        rc_imprimirTodo(rc, pFile);
        for(int i=0;i<10*(size+1);i++) {
            sprintf(text1, "name%i", rand()%1000);
            rc_agregarCiudad(rc, text1, rand()%1000 );
        }
        rc_imprimirTodo(rc, pFile);
        for(int i=0;i<10*(size+1);i++) {
            sprintf(text1, "name%i", rand()%1000);
            sprintf(text2, "name%i", rand()%1000);
            rc_agregarRuta(rc, text1, text2, rand()%10000 / 100 );
        }
        rc_imprimirTodo(rc, pFile);
        rc_borrarTodo(rc);
    }

    fputs( "\nTest caso combinar\n", pFile );
    
    srand(70);
    for(int scale=1;scale<5;scale++) {
        rc1 = rc_crear("nombre1");
        for(int i=0;i<100*scale;i++) {
            sprintf(text1, "name%i", i);
            rc_agregarCiudad(rc1, text1, rand()%1000 );
        }
        for(int i=0;i<100*scale;i++) {
            sprintf(text1, "name%i", (rand()%100)*scale);
            sprintf(text2, "name%i", (rand()%100)*scale);
            rc_agregarRuta(rc1, text1, text2, rand()%10000 / 100 );
        }
        rc_imprimirTodo(rc1, pFile);
        
        rc2 = rc_crear("nombre2");
        for(int i=50*scale;i<150*scale;i++) {
            sprintf(text1, "name%i", i);
            rc_agregarCiudad(rc2, text1, rand()%1000 );
        }
        for(int i=0;i<100*scale;i++) {
            sprintf(text1, "name%i", (rand()%100+50)*scale);
            sprintf(text2, "name%i", (rand()%100+50)*scale);
            rc_agregarRuta(rc2, text1, text2, rand()%10000 / 100 );
        }
        rc_imprimirTodo(rc2, pFile);
        
        redCaminera* rcc = rc_combinarRedes("chatanoga",rc1,rc2);
        rc_imprimirTodo(rcc, pFile);
        rc_borrarTodo(rcc);
        rc_borrarTodo(rc1);
        rc_borrarTodo(rc2);
    }
    
    fputs( "\nTest caso subred\n", pFile );
    
    srand(10);
    rc1 = rc_crear("nombreRAN!");
    for(int i=0;i<100;i++) {
        sprintf(text1, "name%i", i);
        rc_agregarCiudad(rc1, text1, rand()%1000 );
    }
    for(int i=0;i<100;i++) {
        sprintf(text1, "name%i", rand()%100);
        sprintf(text2, "name%i", rand()%100);
        rc_agregarRuta(rc1, text1, text2, rand()%10000 / 100 );
    }
    rc_imprimirTodo(rc1, pFile);
    for(int i=0;i<10;i++) {
        lista* ll = l_crear();
        for(int i=0;i<15;i++) {
            sprintf(text1, "name%i", rand()%100);
            l_agregarOrdenado(&ll, c_crear(text1,rand()%1000), (void (*)(void*))c_borrar, (int32_t (*)(void*,void*))c_cmp);
        }
        imprimirListaCiudad(ll,pFile);
        redCaminera* rcc = rc_obtenerSubRed("YJRKTYJ", rc1, ll);
        rc_imprimirTodo(rcc, pFile);
        rc_borrarTodo(rcc);
        l_borrarTodo(ll);
    }
    rc_borrarTodo(rc1);

    fclose( pFile );
}
