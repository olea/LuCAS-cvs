# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -O6 -Wall -DCONFIG_KERNELD -DMODULE -D__KERNEL__ -DLINUX

syscall.o:	syscall.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c syscall.c
		echo Soy peligroso. Una persona inteligente debería sincronizar
		echo (sync) correctamente antes de ejecutar insmod.
                                                     
