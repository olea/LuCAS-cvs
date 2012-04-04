CC	= 	gcc
CFLAGS	=	-Wall -ansi -pedantic -O2 -c 
LFLAGS	=	-lglib -o main

all: main

avl.o: avl.c avl.h
	$(CC) $(CFLAGS) avl.c


list.o: list.c list.h
	$(CC) $(CFLAGS) list.c


main.o: main.c 
	$(CC) $(CFLAGS) main.c

main: avl.o list.o main.o
	$(CC) $(LFLAGS) main.o avl.o list.o

