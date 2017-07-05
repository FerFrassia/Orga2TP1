CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main tester

main: main.c redcaminera_c.o redcaminera_asm.o
	$(CC) $(CFLAGS) $^ -o $@

tester: tester.c redcaminera_c.o redcaminera_asm.o
	$(CC) $(CFLAGS) $^ -o $@

redcaminera_asm.o: redcaminera.asm
	$(NASM) $(NASMFLAGS) $< -o $@

redcaminera_c.o: redcaminera.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.caso.*
