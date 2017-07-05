extern free
extern malloc

; OFFSET LISTA
%define OFF_LONGITUD 0
%define OFF_PRIMERO  4
%define OFF_ULTIMO   12
%define SIZE_LISTA   20

; OFFSET NODO
%define OFF_FUNC_BORRAR 0
%define OFF_DATO 8
%define OFF_SIGUIENTE 16
%define OFF_ANTERIOR 24
%define SIZE_NODO 32

; NULL
%define NULL 0

; OFFSET CIUDAD
%define OFF_NOMBRE_CIUDAD 0
%define OFF_POBLACION 8
%define SIZE_CIUDAD 16

; OFFSET RUTA
%define OFF_CIUDAD_A 0
%define OFF_DISTANCIA 8
%define OFF_CIUDAD_B 16
%define SIZE_RUTA 24

; OFFSET REDCAMINERA
%define OFF_CIUDADES 0
%define OFF_RUTAS 8
%define OFF_NOMBRE_RED 16
%define SIZE_RED 24


; LISTA 

global l_crear
l_crear:
	SUB RSP, 8 ;alineado

	MOV RDI, SIZE_LISTA
	call malloc

	MOV DWORD [RAX+OFF_LONGITUD], 0
	MOV QWORD [RAX+OFF_PRIMERO], NULL
	MOV QWORD [RAX+OFF_ULTIMO], NULL

	ADD RSP, 8 ;desalineado
	RET

global init_nodo
init_nodo:

	;RDI es dato
	;RSI es func borrar

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado

	MOV R12, RDI ;R12 es dato
	MOV R13, RSI ;R13 es func borrar

	MOV RDI, SIZE_NODO
	CALL malloc

	MOV QWORD [RAX+OFF_FUNC_BORRAR], R13
	MOV QWORD [RAX+OFF_DATO], R12
	MOV QWORD [RAX+OFF_SIGUIENTE], NULL
	MOV QWORD [RAX+OFF_ANTERIOR], NULL

	POP R13 ;desalineado
	POP R12 ;alineado
	ADD RSP, 8 ;desalineado
	RET

global borrar_nodo
borrar_nodo:
	
	;RDI es nodo

	PUSH R12 ;alineado

	MOV R12, RDI ;R12 es nodo

	;SI LA FUNCION DE BORRADO NO EXISTE, NO BORRO EL DATO
	CMP QWORD [R12+OFF_FUNC_BORRAR], NULL
	JE .borro_el_nodo

	;BORRO EL DATO
	MOV R9, [R12+OFF_FUNC_BORRAR] ;R9 es func borrar
	MOV RDI, [R12+OFF_DATO] ;RDI es dato
	CALL R9 ;func borrar borra el dato

	.borro_el_nodo:
		MOV RDI, R12 ;RDI es nodo
		CALL free
	
	POP R12 ;desalineado
	RET

global l_agregarAdelante
l_agregarAdelante:

	;RDI tiene el puntero al puntero de lista
	;RSI tiene el puntero al dato
	;RDX tiene el puntero a la funcion borrar

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO LOS PARAMETROS
	MOV R12, RDI ;R12 es puntero a puntero lista
	MOV R13, RSI ;R13 es dato
	MOV R14, RDX ;R14 es func borrar

	;INICIALIZO EL NODO
	MOV RDI, R13 ;RDI es dato
	MOV RSI, R14 ;RSI es func borrar
	CALL init_nodo ;inicializo el nodo N, esta en RAX
	
	MOV R8, [R12] ;R8 es el inicio de la lista

	CMP QWORD [R8+OFF_PRIMERO], NULL
	JNE .lista_con_elemento

	MOV	QWORD [R8+OFF_ULTIMO], RAX ;lista vacia, agrego el elemento al final
	JMP .el_nodo_va_primero_y_aumento_longitud

	.lista_con_elemento:
		MOV R11, [R8+OFF_PRIMERO] ;R11 tiene el primero de la lista
		MOV QWORD [RAX+OFF_SIGUIENTE], R11 ;el siguiente al nodo es el primero de la lista
		MOV QWORD [R11+OFF_ANTERIOR], RAX

	.el_nodo_va_primero_y_aumento_longitud:
		MOV QWORD [R8+OFF_PRIMERO], RAX
		INC DWORD [R8+OFF_LONGITUD]

	POP R14 ;desalineado
	POP R13 ;alineado
	POP R12 ;desalineado
	RET


global l_agregarAtras
l_agregarAtras:

	;RDI es puntero al puntero lista
	;RSI es dato
	;RDX es func borrar

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO PARAMETROS
	MOV R12, RDI ;R12 es puntero puntero lista
	MOV R13, RSI ;R13 es dato
	MOV R14, RDX ;R14 es func borrar

	MOV R8, [R12] ;R8 es lista
	MOV R9, [R8+OFF_PRIMERO] ;R9 es el primero de la lista
	CMP R9, NULL
	JE .lista_vacia
	JMP .lista_llena

	.lista_vacia:
		CALL l_agregarAdelante
		JMP .terminar

	.lista_llena:
		;CREO EL NODO
		MOV RDI, R13 ;RDI es dato
		MOV RSI, R14 ;RSI es func borrar
		CALL init_nodo

		;ENLAZO
		MOV R8, [R12] ;R8 es lista
		MOV R9, [R8+OFF_ULTIMO] ;R9 es viejoUltimo
		MOV QWORD [R9+OFF_SIGUIENTE], RAX ;viejoUltimo->siguiente = n
		MOV QWORD [RAX+OFF_ANTERIOR], R9 ;n->anterior = viejoUltimo
		MOV QWORD [R8+OFF_ULTIMO], RAX ;l->ultimo = n
		INC DWORD [R8+OFF_LONGITUD] ;incremento la lista
		JMP .terminar

	.terminar:
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET

global l_agregarOrdenado
l_agregarOrdenado:

	;RDI tiene puntero a puntero lista
	;RSI tiene puntero a dato
	;RDX tiene puntero a func borrar
	;RCX tiene puntero a func cmp

	PUSH RBX ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	;GUARDO LOS PARAMETROS
	MOV R12, RDI ;R12 es puntero puntero lista
	MOV R13, RSI ;R13 es dato
	MOV R14, RDX ;R14 es func borrar
	MOV R15, RCX ;R15 es func cmp
	MOV RBX, [R12] ;RBX es lista
	MOV RBX, [RBX+OFF_PRIMERO] ;RBX es primer nodo

	.ciclo:
		;SI LLEGO AL FINAL DE LA LISTA, AGREGO ATRAS
		CMP RBX, NULL
		JE .agrego_atras

		;SI EL DATO ES IGUAL O MENOR QUE EL DATO ACTUAL, LO AGREGO ADELANTE DE EL
		MOV RDI, R13 ;RDI es dato a agregar
		MOV RSI, [RBX+OFF_DATO] ;RSI es dato actual
		CALL R15
		CMP EAX, -1
		JNE .agrego_adelante_de

		;SIGO
		MOV RBX, [RBX+OFF_SIGUIENTE]
		JMP .ciclo


	.agrego_atras:
		MOV RDI, R12 ;RDI es puntero puntero lista
		MOV RSI, R13 ;RSI es dato
		MOV RDX, R14 ;RDX es func borrar
		CALL l_agregarAtras
		JMP .terminar

	.agrego_adelante_de:
		MOV RDI, R12 ;RDI es puntero puntero lista
		MOV RSI, R13 ;RSI es dato
		MOV RDX, R14 ;RDX es func borrar
		MOV RCX, RBX ;RCX es nodo actual
		CALL l_agregarAdelanteDe
		JMP .terminar

	.terminar:
		POP R15 ;desalineado
		POP R14 ;alineado
		POP R13 ;desalineado
		POP R12 ;alineado
		POP RBX ;desalineado
		RET

global l_agregarAdelanteDe
l_agregarAdelanteDe:
	
	;RDI es puntero puntero lista
	;RSI es dato
	;RDX es func borrar
	;RCX es nodo actual

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	;GUARDO PARAMETROS
	MOV R12, [RDI] ;R12 es lista
	MOV R13, RSI ;R13 es dato
	MOV R14, RDX ;R14 es func borrar
	MOV R15, RCX ;R15 es actual

	;AUMENTO LA LONGITUD DE LA LISTA
	INC DWORD [R12+OFF_LONGITUD]

	;CREO EL NODO
	MOV RDI, R13 ;RDI es dato
	MOV RSI, R14 ;RSI es func borrar
	CALL init_nodo
	MOV R13, RAX ;R13 es nodo nuevo

	;CHEQUEO SI EL NUEVO NODO ES EL NUEVO PRIMERO
	MOV R9, [R12+OFF_PRIMERO] ;R9 es primero
	CMP R9, R15
	JE .agrego_como_primero
	JMP .agrego_como_no_primero

	.agrego_como_primero:
		MOV QWORD [R15+OFF_ANTERIOR], R13 ;actual->anterior = nuevo
		MOV QWORD [R13+OFF_SIGUIENTE], R15 ;nuevo->siguiente = actual
		MOV QWORD [R12+OFF_PRIMERO], R13 ;l->primero = nuevo
		JMP .terminar

	.agrego_como_no_primero:
		MOV R10, [R15+OFF_ANTERIOR] ;R10 es ant
		MOV QWORD [R10+OFF_SIGUIENTE], R13 ;ant->siguiente = nuevo
		MOV QWORD [R15+OFF_ANTERIOR], R13 ;actual->anterior = nuevo
		MOV QWORD [R13+OFF_ANTERIOR], R10 ;nuevo->anterior = ant
		MOV QWORD [R13+OFF_SIGUIENTE], R15 ;nuevo->siguiente = actual
		JMP .terminar

	.terminar:
		POP R15 ;desalineado
		POP R14 ;alineado
		POP R13 ;desalineado
		POP R12 ;alineado
		ADD RSP, 8 ;desalineado
		RET


global l_borrarTodo
l_borrarTodo:
	
	;RDI es lista
	
	PUSH R12 ;alineado

	;GUARDO LISTA
	MOV R12, RDI ;R12 es lista

	.ciclo:
		CMP QWORD [R12+OFF_PRIMERO], NULL
		JE .liberar_lista

		MOV R9, [R12+OFF_PRIMERO] ;R9 es n1
		MOV R10, [R9+OFF_SIGUIENTE] ;R10 es n2
		MOV QWORD [R12+OFF_PRIMERO], R10 ;el primero de la lista es n2

		;BORRO n1
		MOV RDI, R9
		CALL borrar_nodo
		JMP .ciclo

	.liberar_lista:
		MOV RDI, R12 ;RDI es lista
		CALL free

	POP R12 ;desalineado
	RET

; CIUDAD

global c_crear
c_crear:
	
	;RDI es nombre, char*
	;RSI es poblacion, int64

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	MOV R12, RDI ;R12 es nombre
	MOV R13, RSI ;R13 es poblacion

	MOV RDI, SIZE_CIUDAD
	CALL malloc
	MOV R14, RAX ;R14 es ciudad

	MOV RDI, R12 ;RDI es nombre
	CALL str_copy ;RAX tiene la copia
	MOV R12, RAX ;R12 tiene nombre copiado

	MOV QWORD [R14+OFF_NOMBRE_CIUDAD], R12 ;inicializo nombre copiado
	MOV QWORD [R14+OFF_POBLACION], R13 ;inicializo poblacion

	MOV RAX, R14 ;RAX tiene la ciudad

	POP R14 ;desalineado
	POP R13 ;alineado
	POP R12 ;desalineado
	RET

global c_cmp
c_cmp:

	;RDI es c1
	;RSI es c2

	SUB RSP, 8 ;alineado

	MOV RDI, [RDI+OFF_NOMBRE_CIUDAD] ;RDI es nombre ciudad 1
	MOV RSI, [RSI+OFF_NOMBRE_CIUDAD] ;RSI es nombre ciudad 2
	CALL str_cmp

	ADD RSP, 8 ;desalineado
	RET

global c_borrar
c_borrar:
	
	;RDI es ciudad

	PUSH R12 ;alineado	

	;BORRO CIUDAD
	MOV R12, [RDI+OFF_NOMBRE_CIUDAD] ;R12 es nombre ciudad
	CALL free

	;BORRO NOMBRE
	MOV RDI, R12 ;RDI es nombre ciudad
	CALL free 

	POP R12 ;desalineado
	RET

global string_borrar
string_borrar:

	SUB RSP, 8 ;alineado

	call free

	ADD RSP, 8 ;desalineado
	RET

; RUTA

global r_crear
r_crear:
	
	;RDI es c1
	;RSI es c2
	;XMM0 es distancia

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	MOV R12, RDI ;R12 es c1
	MOV R13, RSI ;R13 es c2
	MOVQ R14, XMM0 ;R14 es distancia


	;ORDENO LOS NOMBRES
	MOV RDI, [RDI+OFF_NOMBRE_CIUDAD] ;RDI es nombre c1
	MOV RSI, [RSI+OFF_NOMBRE_CIUDAD] ;RSI es nombre c2

	CALL str_cmp
	CMP EAX, 0
	JE .terminar
	JG .c1_es_menor
	JL .c1_es_mayor

	.c1_es_menor:
		MOV RDI, SIZE_RUTA
		CALL malloc

		MOV QWORD [RAX+OFF_CIUDAD_A], R12 ;inicializo ciudadA
		MOV QWORD [RAX+OFF_DISTANCIA], R14 ;inicializo distancia
		MOV QWORD [RAX+OFF_CIUDAD_B], R13 ;inicializo ciudadB

		JMP .terminar

	.c1_es_mayor:
		MOV RDI, SIZE_RUTA
		CALL malloc

		MOV QWORD [RAX+OFF_CIUDAD_A], R13 ;inicializo ciudadA
		MOV QWORD [RAX+OFF_DISTANCIA], R14 ;inicializo distancia
		MOV QWORD [RAX+OFF_CIUDAD_B], R12 ;inicializo ciudadB

	.terminar:
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET

global r_cmp
r_cmp:

	;RDI es r1
	;RSI es r2

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	MOV R12, RDI ;R12 es r1
	MOV R13, RSI ;R13 es r2

	MOV R14, QWORD [R12+OFF_CIUDAD_A] ;R14 es c1A
	MOV R15, QWORD [R13+OFF_CIUDAD_A] ;R15 es c2A

	MOV RDI, QWORD [R14+OFF_NOMBRE_CIUDAD] ;RDI es c1A nombre
	MOV RSI, QWORD [R15+OFF_NOMBRE_CIUDAD] ;RSI es c2A nombre
	CALL str_cmp
	CMP EAX, 0
	JNE .terminar

	MOV R14, QWORD [R12+OFF_CIUDAD_B] ;R14 es c1B
	MOV R15, QWORD [R13+OFF_CIUDAD_B] ;R15 es c2B

	MOV RDI, QWORD [R14+OFF_NOMBRE_CIUDAD] ;RDI es c1B nombre
	MOV RSI, QWORD [R15+OFF_NOMBRE_CIUDAD] ;RSI es c2B nombre
	CALL str_cmp


	.terminar:
	POP R15 ;desalineado
	POP R14 ;alineado
	POP R13 ;desalineado
	POP R12 ;alineado
	ADD RSP, 8 ;desalineado

	RET

global r_borrar
r_borrar:
	
	;RDI es r

	SUB RSP, 8 ;alineado
	CALL free
	ADD RSP, 8 ;desalineado
	RET

; RED CAMINERA

global rc_crear
rc_crear:

	;RDI es nombre red caminera

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado

	;GUARDO NOMBRE RED
	MOV R12, RDI ;R12 es nombre red

	;CREO LA RED
	MOV RDI, SIZE_RED 
	CALL malloc
	MOV R13, RAX ;R13 es red

	;INICIALIZO CIUDADES
	CALL l_crear
	MOV QWORD [R13+OFF_CIUDADES], RAX

	;INICIALIZO RUTAS
	CALL l_crear
	MOV QWORD [R13+OFF_RUTAS], RAX

	;COPIO NOMBRE RED Y INICIALIZO NOMBRE
	;MOV RDI, R12 ;RDI es nombre red
	;CALL str_copy
	MOV QWORD [R13+OFF_NOMBRE_RED], R12

	;DEVUELVO EN RAX LA RED
	MOV RAX, R13 ;RAX es red

	POP R13 ;desalineado
	POP R12 ;alineado
	ADD RSP, 8 ;desalineado
	RET

global rc_borrarTodo
rc_borrarTodo:

	;RDI es red

	PUSH R12 ;alineado

	;GUARDO PARAMETROS
	MOV R12, RDI ;R12 es red

	;BORRO CIUDADES
	MOV RDI, [R12+OFF_CIUDADES]
	CALL l_borrarTodo

	;BORRO RUTAS
	MOV RDI, [R12+OFF_RUTAS]
	CALL l_borrarTodo

	;BORRO RED
	MOV RDI, R12
	CALL free

	POP R12 ;desalineado
	RET

global rc_existeCiudad
rc_existeCiudad:

	;RDI es red
	;RSI es char* nombre ciudad

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	MOV R12, [RDI+OFF_CIUDADES] ;R12 es ciudades
	MOV R12, [R12+OFF_PRIMERO] ;R12 es primer nodo
	MOV R13, RSI ;R13 es nombre a comparar

	.ciclo:
		CMP R12, NULL
		JE .devolver_0_y_terminar

		MOV R15, [R12+OFF_DATO] ;R15 es ciudad actual

		;COMPARO NOMBRES
		MOV RDI, R13 ;RDI es nombre a comparar
		MOV RSI, [R15+OFF_NOMBRE_CIUDAD] ;RSI es nombre actual
		CALL str_cmp
		CMP EAX, 0
		JE .devolver_1_y_terminar

		;SIGO
		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE]
			JMP .ciclo

	.devolver_1_y_terminar:
		MOV EAX, 1
		JMP .terminar

	.devolver_0_y_terminar:
		MOV EAX, 0

	.terminar:
		POP R15 ;desalineado
		POP R14 ;alineado
		POP R13 ;desalineado
		POP R12 ;alineado
		ADD RSP, 8 ;desalineado
		RET

global rc_agregarCiudad
rc_agregarCiudad:
	
	;RDI es red
	;RSI es char* nombre ciudad
	;RDX es int64 poblacion

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO LOS PARAMETROS
	MOV R12, RDI ;R12 es red
	MOV R13, RSI ;R13 es nombre ciudad
	MOV R14, RDX ;R14 es poblacion

	;VERIFICO QUE NO EXISTA LA CIUDAD
	CALL rc_existeCiudad
	CMP EAX, 1
	JE .terminar

	;CREO LA CIUDAD
	MOV RDI, R13 ;RDI es nombre ciudad
	MOV RSI, R14 ;RSI es poblacion
	CALL c_crear
	MOV R13, RAX ;R13 es ciudad nueva
	MOV R8, [R13+OFF_NOMBRE_CIUDAD] ;TESTING

	;AGREGO LA CIUDAD
	MOV R14, [R12+OFF_CIUDADES] ;R14 es ciudades
	SUB RSP, 8 ;desalineado
	PUSH R14 ;R14 está en el tope de la pila y RSP apunta ahí. Alineado

	MOV RDI, RSP ;RDI tiene lista** ciudades
	MOV RSI, R13 ;RSI tiene la nueva ciudad, osea el dato
	MOV RDX, c_borrar ;RDX tiene la funcion de borrado
	MOV RCX, c_cmp ;RCX tiene la funcion de comparacion
	CALL l_agregarOrdenado
	
	POP R14 ;desalineado
	ADD RSP, 8 ;alineado
	
	.terminar:
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET


global rc_existeRuta
rc_existeRuta:

	;RDI es red
	;RSI es nombre ciudadA
	;RDX es nombre ciudadB

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO DATOS
	MOV R12, [RDI+OFF_RUTAS] ;R12 es rutas
	MOV R12, [R12+OFF_PRIMERO] ;R12 es primer nodo
	MOV R13, RSI ;R13 es nombre A param
	MOV R14, RDX ;R14 es nombre B param

	.ciclo:
		CMP R12, NULL 
		JE .devolver_0_y_terminar

		;COMPARO NOMBRE CIUDAD A
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_A] ;R8 es ciudad A actual
		MOV R8, [R8+OFF_NOMBRE_CIUDAD] ;R8 es nombre A actual
		MOV RDI, R8 ;RDI es nombre A actual
		MOV RSI, R13 ;RSI es nombre A param
		CALL str_cmp
		
		;COMPARO NOMBRE CIUDAD B
		CMP EAX, 0
		JE .comparo_nombre_ciudadB

		;SIGO
		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE] ;R12 es siguiente
			JMP .ciclo

	.comparo_nombre_ciudadB:
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_B] ;R8 es ciudad B actual
		MOV R8, [R8+OFF_NOMBRE_CIUDAD] ;R8 es nombre B actual
		MOV RDI, R8 ;RDI es nombre B actual
		MOV RSI, R14; RSI es nombre B param
		CALL str_cmp

		CMP EAX, 0
		JE .devolver_1_y_terminar
		JMP .sigo

	.devolver_1_y_terminar:
		MOV EAX, 1
		JMP .terminar

	.devolver_0_y_terminar:
		MOV EAX, 0
		JMP .terminar

	.terminar:
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET


global rc_agregarRuta
rc_agregarRuta:

	;RDI es red
	;RSI es nombre ciudad 1
	;RDX es nombre ciudad 2
	;XMM0 es distancia

	PUSH RBX ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	;GUARDO LOS PARAMETROS
	MOV R12, RDI ;R12 es red
	MOV R13, RSI ;R13 es nombre ciudad 1
	MOV R14, RDX ;R14 es nombre ciudad 2
	MOVQ R15, XMM0 ;R15 es distancia

	;CHEQUEO QUE LAS CIUDADES EXISTAN
	MOV RDI, R12 ;RDI es red
	MOV RSI, R13 ;RSI es nombre ciudad 1
	CALL rc_existeCiudad
	CMP EAX, 0
	JE .terminar

	MOV RDI, R12 ;RDI es red
	MOV RSI, R14 ;RSI es nombre ciudad 2
	CALL rc_existeCiudad
	CMP EAX, 0
	JE .terminar

	;CHEQUEO QUE LOS NOMBRES SEAN DIFERENTES
		MOV RDI, R13 ;RDI es nombre ciudad 1
		MOV RSI, R14 ;RSI es nombre ciudad 2
		CALL str_cmp
		CMP EAX, 0
		JE .terminar

	;ORDENO LOS NOMBRES Y CHEQUEO QUE LA RUTA NO EXISTA
		JG .ciudad_1_es_A
		JL .ciudad_1_es_B

		.ciudad_1_es_A:
			;R13 Y R14 ESTAN BIEN
			JMP .chequeo_que_no_exista

		.ciudad_1_es_B:
			;SWAPEO R13 Y R14, PARA QUE SEAN A Y B RESPECTIVAMENTE.
			MOV R8, R13
			MOV R13, R14
			MOV R14, R8
			JMP .chequeo_que_no_exista

		.chequeo_que_no_exista:
			MOV RDI, R12 ;RDI es red 
			MOV RSI, R13; RSI es nombre ciudad A
			MOV RDX, R14 ;RDX es nombre ciudad B
			CALL rc_existeRuta
			CMP EAX, 1
			JE .terminar

	;OBTENGO CIUDAD A
	MOV RDI, R12 ;RDI es red
	MOV RSI, R13 ;RSI es nombre ciudad A
	CALL obtenerCiudad
	MOV RBX, RAX ;RBX es ciudad A

	;OBTENGO CIUDAD B
	MOV RDI, R12 ;RDI es red
	MOV RSI, R14 ;RSI es nombre ciudad B
	CALL obtenerCiudad
	MOV R9, RAX ;R9 es ciudad B
	MOV R8, QWORD [R9+OFF_NOMBRE_CIUDAD] ;TESTING

	;CREO LA RUTA
	MOV RDI, RBX ;RDI es ciudad A
	MOV RSI, R9 ;RSI es ciudad B
	MOVQ XMM0, R15 ;XMM0 es distancia
	CALL r_crear
	MOV R8, RAX ;R8 es nueva ruta

	;AGREGO LA RUTA
	MOV R9, [R12+OFF_RUTAS] ;R9 es rutas
	SUB RSP, 8 ;desalineado
	PUSH R9 ;alineado
	
	MOV RDI, RSP ;RDI es lista** rutas
	MOV RSI, R8 ;RSI es nueva ruta
	MOV RDX, r_borrar ;RDX es funcion de borrado
	MOV RCX, r_cmp ;RCX es funcion de comparacion
	CALL l_agregarOrdenado
	
	POP R9  ;desalineado
	ADD RSP, 8 ;alineado


	.terminar:
		POP R15 ;desalineado
		POP R14 ;alineado
		POP R13 ;desalineado
		POP R12 ;alineado
		POP RBX ;desalineado
		RET

; OTRAS DE RED CAMINERA

global obtenerCiudad
obtenerCiudad:
	
	;RDI es red
	;RSI es nombre a buscar

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	MOV R12, [RDI+OFF_CIUDADES] ;R12 es ciudades
	MOV R12, [R12+OFF_PRIMERO] ;R12 es primer nodo
	MOV R13, RSI ;R13 es nombre a comparar

	.ciclo:
		CMP R12, NULL
		JE .devolver_null_y_terminar

		MOV R14, [R12+OFF_DATO] ;R14 es ciudad actual

		;COMPARO NOMBRES
		MOV RDI, R13 ;RDI es nombre a comparar
		MOV RSI, [R14+OFF_NOMBRE_CIUDAD] ;RSI es nombre actual
		CALL str_cmp
		CMP EAX, 0
		JE .devolver_ciudad_y_terminar

		;SIGO
		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE]
			JMP .ciclo

	.devolver_ciudad_y_terminar:
		MOV RAX, R14
		JMP .terminar

	.devolver_null_y_terminar:
		MOV RAX, NULL

	.terminar:
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET


global obtenerRuta
obtenerRuta:
	
	;RDI es red
	;RSI es nombre ciudad 1
	;RDX es nombre ciudad 2

	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	;GUARDO PARAMETROS
	MOV R12, [RDI+OFF_RUTAS] ;R12 es rutas
	MOV R12, [R12+OFF_PRIMERO] ;R12 es primer nodo de rutas
	MOV R13, RSI ;R13 es nombre ciudad 1
	MOV R14, RDX ;R14 es nombre ciudad 2

	;CHEQUEO CUAL ES CIUDAD A Y CUAL ES CIUDAD B
	MOV RDI, R13 ;RDI es ciudad 1
	MOV RSI, R14 ;RSI es ciudad 2
	CALL str_cmp
	CMP EAX, 0
	JG .ciudad_1_es_A
	JL .ciudad_2_es_A

	.ciudad_1_es_A:
		;R13 ES CIUDAD A Y R14 ES CIUDAD B
		JMP .ciclo

	.ciudad_2_es_A:
		;SWAPEO R13 CON R14
		MOV R8, R13
		MOV R13, R14
		MOV R14, R8
		JMP .ciclo

	;
	.ciclo:
		CMP R12, NULL
		JE .devolver_null_y_terminar

		;COMPARO NOMBRE CIUDAD A
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_A] ;R8 es ciudad A actual
		MOV R8, [R8+OFF_NOMBRE_CIUDAD] ;R8 es nombre A actual
		MOV RDI, R8 ;RDI es nombre A actual
		MOV RSI, R13 ;RSI es nombre A param
		CALL str_cmp

		;COMPARO NOMBRE CIUDAD B
		CMP EAX, 0
		JE .comparar_nombre_ciudad_B

		;SIGO
		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE] ;adelanto R12
			JMP .ciclo


	.comparar_nombre_ciudad_B:
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_B] ;R8 es ciudad B actual
		MOV R8, [R8+OFF_NOMBRE_CIUDAD] ;R8 es nombre B actual
		MOV RDI, R8 ;RDI es nombre B actual
		MOV RSI, R14 ;RSI es nombre B param
		CALL str_cmp

		CMP EAX, 0
		JE .devolver_ruta_y_terminar
		JMP .sigo

	.devolver_ruta_y_terminar:
		MOV RAX, [R12+OFF_DATO] ;RAX es ruta a devolver
		JMP .terminar

	.devolver_null_y_terminar:
		MOV RAX, NULL
		JMP .terminar

	.terminar:
		POP R15 ;desalineado
		POP R14 ;alineado
		POP R13 ;desalineado
		POP R12 ;alineado
		ADD RSP, 8 ;desalineado
		RET

global ciudadMasPoblada
ciudadMasPoblada:

	;RDI es red

	SUB RSP, 8 ;alineado

	MOV R8, [RDI+OFF_CIUDADES] ;R8 es ciudades
	MOV R8, [R8+OFF_PRIMERO] ;R8 es el primer nodo de ciudades
	MOV R10, 0 ;R10 es poblacion maxima
	MOV R11, NULL ;inicializo R11 por si no hay ciudad

	.ciclo:
		CMP R8, NULL
		JE .terminar

		;COMPARO POBLACIONES
		MOV R9, [R8+OFF_DATO] ;R9 es ciudad actual
		MOV R9, [R9+OFF_POBLACION] ;R9 es poblacion actual
		CMP R9, R10
		JG .nuevo_maximo

		.sigo:
			MOV R8, [R8+OFF_SIGUIENTE] ;avanzo R8
			JMP .ciclo

	.nuevo_maximo:
		MOV R10, R9 ;R10 se actualiza con la poblacion
		MOV R11, [R8+OFF_DATO] ;R11 se actualiza con la ciudad
		JMP .sigo

	.terminar:
		MOV RAX, R11 ;RAX es la ciudad mas poblada
		ADD RSP, 8;desalineado
		RET

global rutaMasLarga
rutaMasLarga:

	;RDI es red

	PUSH R12 ;alineado

	MOV R12, [RDI+OFF_RUTAS] ;R12 es rutas
	MOV R12, [R12+OFF_PRIMERO] ;R12 es el primer nodo de rutas
	MOV R10, 0 ;R10 es distancia maxima
	MOV R11, NULL ;R11 es ruta mas larga, inicializo por si no hay

	.ciclo:
		CMP R12, NULL
		JE .terminar

		;COMPARO DISTANCIAS
		MOV R9, [R12+OFF_DATO] ;R9 es ruta actual
		MOV R9, [R9+OFF_DISTANCIA] ;R9 es distancia actual
		CMP R9, R10
		JG .actualizo_maximo
		JE .comparo_nombres

		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE] ;avanzo R12
			JMP .ciclo

	.comparo_nombres:
		CMP R11, NULL
		JNE .comparo_nombres_A
		JMP .actualizo_maximo

	.comparo_nombres_A:
		MOV RDI, [R12+OFF_DATO] ;RDI es ruta actual
		MOV RDI, [RDI+OFF_CIUDAD_A] ;RDI es ciudad A de ruta actual
		MOV RDI, [RDI+OFF_NOMBRE_CIUDAD] ;RDI es nombre A de ruta actual

		MOV RSI, [R11+OFF_CIUDAD_A] ;RSI es ciudad A de ruta maxima
		MOV RSI, [RSI+OFF_NOMBRE_CIUDAD] ;RSI es nombre A de ruta maxima

		CALL str_cmp
		CMP EAX, 0
		JE .comparo_nombres_B
		JG .actualizo_maximo
		JL .sigo

	.comparo_nombres_B:
		MOV RDI, [R12+OFF_DATO] ;RDI es ruta actual
		MOV RDI, [RDI+OFF_CIUDAD_B] ;RDI es ciudad B de ruta actual
		MOV RDI, [RDI+OFF_NOMBRE_CIUDAD] ;RDI es nombre B de ruta actual

		MOV RSI, [R11+OFF_CIUDAD_B] ;RSI es ciudad B de ruta maxima
		MOV RSI, [RSI+OFF_NOMBRE_CIUDAD] ;RSI es nombre B de ruta maxima

		CALL str_cmp
		CMP EAX, 0
		JG .actualizo_maximo
		JMP .sigo

	.actualizo_maximo:
		MOV R10, R9 ;R10 se actualiza con la distancia maxima
		MOV R11, [R12+OFF_DATO] ;R11 se actualiza con la ruta
		JMP .sigo

	.terminar:
		MOV RAX, R11 ;RAX es la ruta mas larga
		POP R12 ;desalineado
		RET

global ciudadesMasLejanas
ciudadesMasLejanas:

	;RDI es red
	;RSI es ** ciudad 1
	;RDX es ** ciudad 2

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO LOS PARAMETROS
	MOV R12, RDI ;R12 es red
	MOV R13, RSI ;R13 es ** ciudad 1
	MOV R14, RDX ;R14 es ** ciudad 2

	;OBTENGO LA RUTA MAS LARGA
	CALL rutaMasLarga ;RAX es ruta mas larga
	
	;ACTUALIZO EL PUNTERO A LA CIUDAD 1
	MOV R8, [RAX+OFF_CIUDAD_A] ;R8 es ciudad A
	MOV QWORD [R13], R8 ;RSI apunta a ciudad A

	;ACTUALIZO EL PUNTERO A LA CIUDAD 2
	MOV R8, [RAX+OFF_CIUDAD_B] ;R8 es ciudad B
	MOV QWORD [R14], R8 ;RDX apunta a ciudad B

	POP R14 ;desalineado
	POP R13 ;alineado
	POP R12 ;desalineado
	RET

global cantidadDeCaminos
cantidadDeCaminos:
	
	;RDI es red
	;RSI es nombre ciudad param

	PUSH R12 ;alineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado

	;GUARDO PARAMETROS
	MOV R12, RDI ;R12 es red
	MOV R12, [R12+OFF_RUTAS] ;R12 es rutas
	MOV R12, [R12+OFF_PRIMERO] ;R12 es el primer nodo de rutas
	MOV R13, RSI ;R13 es nombre ciudad param
	MOV R14, 0 ;R14 es contador de rutas que conectan a nombre ciudad

	.ciclo:
		CMP R12, NULL
		JE .terminar

		;COMPARO CIUDAD A DE RUTA ACTUAL
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_A] ;R8 es ciudad A
		MOV RDI, [R8+OFF_NOMBRE_CIUDAD] ;RDI es nombre ciudad A actual
		MOV RSI, R13 ;RSI es nombre ciudad param
		CALL str_cmp
		CMP EAX, 0
		JE .acumular_y_seguir

		;COMPARO CIUDAD B DE RUTA ACTUAL
		MOV R8, [R12+OFF_DATO] ;R8 es ruta actual
		MOV R8, [R8+OFF_CIUDAD_B] ;R8 es ciudad B
		MOV RDI, [R8+OFF_NOMBRE_CIUDAD] ;RDI es nombre ciudad B actual
		MOV RSI, R13 ;RSI es nombre ciudad param
		CALL str_cmp
		CMP EAX, 0
		JE .acumular_y_seguir

		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE] ;avanzo R12
			JMP .ciclo

	.acumular_y_seguir:
		INC R14 ;sumo una ruta
		JMP .sigo

	.terminar:
		MOV EAX, R14D
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET

global totalDeDistancia
totalDeDistancia:

	;RDI es red

	SUB RSP, 8 ;alineado

	MOV R8, [RDI+OFF_RUTAS] ;R8 es rutas
	MOV R8, [R8+OFF_PRIMERO] ;R8 es el primer nodo de rutas
	PXOR XMM0, XMM0 ;XMM0 es contador de distancia

	.ciclo:
		CMP R8, NULL ;R8 es nodo actual
		JE .terminar

		;SUMO DISTANCIA ACTUAL
		MOV R9, [R8+OFF_DATO] ;R9 es ruta actual
		MOVQ XMM1, [R9+OFF_DISTANCIA] ;XMM1 es distancia actual
		ADDSD XMM0, XMM1 ;sumo distancia actual a distancia acumulada

		;SIGO
		MOV R8, [R8+OFF_SIGUIENTE] ;avanzo R8
		JMP .ciclo

	.terminar:
		ADD RSP, 8 ;desalineado
		RET

global totalDePoblacion
totalDePoblacion:
	
	;RDI es red

	SUB RSP, 8; alineado

	MOV R8, [RDI+OFF_CIUDADES] ;R8 es ciudades
	MOV R8, [R8+OFF_PRIMERO] ;R8 es primer nodo de ciudades
	MOV RAX, 0 ;RAX es contador poblacion

	.ciclo:
		CMP R8, NULL ;R8 es nodo actual
		JE .terminar

		;SUMO LA POBLACION ACTUAL
		MOV R9, [R8+OFF_DATO] ;R9 es ciudad actual
		MOV R9, [R9+OFF_POBLACION] ;R9 es poblacion actual
		ADD RAX, R9 ;RAX se actualiza

		;SIGO
		MOV R8, [R8+OFF_SIGUIENTE]
		JMP .ciclo

	.terminar:
		ADD RSP, 8 ;desalineado
		RET

global ciudadMasComunicada
ciudadMasComunicada:

	;RDI es red

	PUSH R12 ;salineado
	PUSH R13 ;desalineado
	PUSH R14 ;alineado
	PUSH R15  ;desalineado
	PUSH RBX  ;alineado

	;GUARDO PARAMETROS Y INICIALIZO VARIABLES
	MOV R12, [RDI+OFF_CIUDADES] ;R12 es ciudades
	MOV R12, [R12+OFF_PRIMERO] ;R12 es el primer nodo de ciudades
	MOV R13D, 0 ;R13 es cantidad de rutas que comunican a ciudad mas comunicada
	MOV R14, 0 ;R14 es ciudad mas comunicada
	MOV R15, RDI ;R15 es red

	.ciclo:
		CMP R12, NULL
		JE .terminar

		;OBTENGO CANTIDAD DE RUTAS DE CIUDAD ACTUAL
		MOV RDI, R15 ;RDI es red
		MOV R8, [R12+OFF_DATO] ;R8 es ciudad actual
		MOV RSI, [R8+OFF_NOMBRE_CIUDAD] ;RSI es nombre ciudad actual
		CALL cantidadDeCaminos

		;DE SER NECESARIO, ACTUALIZO MAXIMOS
		MOV EBX, EAX ;EBX es cantidad caminos ciudad actual
		CMP EBX, R13D ;comparo cantidad actual con cantidad maxima
		JE .desempatar_por_nombres
		JG .actualizo_maximo

		.sigo:
			MOV R12, [R12+OFF_SIGUIENTE]
			JMP .ciclo


	.desempatar_por_nombres:
		;CHEQUEO QUE HAYA CIUDAD MAXIMA GUARDADA
		CMP R14, 0
		JE .actualizo_maximo

		;AHORA DESEMPATO
		MOV R8, [R12+OFF_DATO] ;R8 es ciudad actual
		MOV RDI, [R8+OFF_NOMBRE_CIUDAD] ;RDI es nombre ciudad actual
		MOV RSI, [R14+OFF_NOMBRE_CIUDAD] ;RSI es ciudad maxima
		CALL str_cmp
		CMP EAX, 1
		JE .actualizo_maximo
		JMP .sigo

	.actualizo_maximo:
		MOV R13D, EBX ;R13D es nueva cantidad de rutas maxima
		MOV R14, [R12+OFF_DATO] ;R14 es nueva ciudad maxima
		JMP .sigo

	.terminar:
		MOV RAX, R14 ;RAX es ciudad mas comunicada
		POP RBX ;desalineado
		POP R15 ;alineado
		POP R14 ;desalineado
		POP R13 ;alineado
		POP R12 ;desalineado
		RET

; AUXILIARES

global str_copy
str_copy:
	
	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado
	PUSH R14 ;desalineado
	PUSH R15 ;alineado

	MOV R12, RDI ;R12 es inicio
	MOV R13, 0 ;contador de cantidad de chars

	.ciclo_contador:
		MOV AL, [R12] ;AL <- char actual
		CMP AL, 0
		JE .ciclo_copiador
		INC R12
		INC R13
		JMP .ciclo_contador

	.ciclo_copiador:
		INC R13 ;para terminar en null
		MOV R12, RDI; R12 <- inicio
		MOV RDI, R13 ;RDI <- tamanio string
		CALL malloc
		MOV R15, RAX ;R15 <- puntero nuevo string
		.copiando:
			CMP R13, 0
			JE .fin
			MOV R8B, BYTE [R12] ;R8 <- char actual
			MOV BYTE [R15], R8B
			INC R12
			INC R15
			DEC R13
			JMP .copiando

	.fin:
	POP R15 ;desalineado
	POP R14 ;alineado
	POP R13 ;desalineado
	POP R12 ;alineado
	ADD RSP, 8 ;desalineado
	RET

global str_cmp
str_cmp:
	
	;RDI es string a
	;RSI es string b
	
	SUB RSP, 8 ;alineado
	PUSH R12 ;desalineado
	PUSH R13 ;alineado

	MOV R12, RDI ;R12 es a
	MOV R13, RSI ;R13 es b

	.ciclo:
		MOV R8B, BYTE [R12] ;R8B es actualA
		MOV R9B, BYTE [R13] ;R9B es actualB

		CMP R8B, 0 ;actualA es 0
		JE .a_termino

		CMP R9B, 0 ;actualB es 0
		JE .b_termino_y_a_no

		;actualA y actualB no son 0, los comparo
		CMP R8B, R9B 
		JL .devolver_1_y_terminar
		JG .devolver_menos1_y_terminar

		;son iguales, aumento los punteros y vuelvo a ciclar
		INC R12
		INC R13
		JMP .ciclo

	.a_termino:
		CMP R9B, 0
		JE .devolver_0_y_terminar
		JMP .devolver_1_y_terminar

	.b_termino_y_a_no:
		JMP .devolver_menos1_y_terminar

	.devolver_0_y_terminar:
		MOV EAX, 0
		JMP .terminar

	.devolver_1_y_terminar:
		MOV EAX, 1
		JMP .terminar

	.devolver_menos1_y_terminar:
		MOV EAX, -1
		JMP .terminar

	.terminar:
		POP R13 ;desalineado
		POP R12 ;alineado
		ADD RSP, 8 ;desalineado
		RET
