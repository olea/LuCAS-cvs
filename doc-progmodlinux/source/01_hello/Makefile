# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -Wall -DMODULE -D__KERNEL__ -DLINUX

hello.o:	hello.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c hello.c
		echo insmod hello.o para conectarlo
		echo rmmod hello para desconectarlo
		echo
		echo X y la programación del núcleo no se mezclan.
		echo Haz insmod y rmmod desde fuera de X.
