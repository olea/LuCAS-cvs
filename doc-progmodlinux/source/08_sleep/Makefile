# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -O6 -Wall -DCONFIG_KERNELD -DMODULE -D__KERNEL__ -DLINUX

all: sleep.o cat_noblock

sleep.o:	sleep.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c sleep.c

cat_noblock:	cat_noblock.c
		$(CC) -o cat_noblock cat_noblock.c
                                                     
