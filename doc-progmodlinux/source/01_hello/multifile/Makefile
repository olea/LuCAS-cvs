# Makefile para un módulo multiarchivo del núcleo

CC=gcc
MODCFLAGS := -Wall -DMODULE -D__KERNEL__ -DLINUX

hello.o:	start.o stop.o
		ld -m elf_i386 -r -o hello.o start.o stop.o

start.o:	start.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c start.c

stop.o:		stop.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c stop.c
