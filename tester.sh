#!/bin/bash
clear

echo " "
echo "**Compilando"

make tester
if [ $? -ne 0 ]; then
  echo "  **Error de compilacion"
  exit 1
fi

echo " "
echo "**Corriendo Valgrind"

valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./tester
if [ $? -ne 0 ]; then
  echo "  **Error de memoria"
  exit 1
fi

echo " "
echo "**Corriendo diferencias con la catedra"

DIFFER="diff -d"
ERRORDIFF=0

$DIFFER salida.caso.lista.txt Catedra.salida.caso.lista.txt > /dev/null
if [ $? -ne 0 ]; then
  echo "  **Discrepancia en el caso RED GRANDE: salida.caso.lista.txt vs Catedra.salida.caso.lista.txt"
  ERRORDIFF=1
fi

$DIFFER salida.caso.redchica.txt Catedra.salida.caso.redchica.txt > /dev/null
if [ $? -ne 0 ]; then
  echo "  **Discrepancia en el caso RED CHICA: salida.caso.redchica.txt vs Catedra.salida.caso.redchica.txt"
  ERRORDIFF=1
fi

$DIFFER salida.caso.redgrande.txt Catedra.salida.caso.redgrande.txt > /dev/null
if [ $? -ne 0 ]; then
  echo "  **Discrepancia en el caso RED GRANDE: salida.caso.redgrande.txt vs Catedra.salida.caso.redgrande.txt"
  ERRORDIFF=1
fi

echo " "
if [ $ERRORDIFF -eq 0 ]; then
  echo "**Todos los tests pasan"
fi
echo " "
