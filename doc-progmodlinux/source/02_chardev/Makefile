# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -O6 -Wall -DCONFIG_KERNELD -DMODULE -D__KERNEL__ -DLINUX 

chardev.o:	chardev.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c chardev.c
                                                     
