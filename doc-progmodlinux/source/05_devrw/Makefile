# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -O6 -Wall -DCONFIG_KERNELD -DMODULE -D__KERNEL__ -DLINUX


all: chardev.o ioctl

chardev.o:	chardev.c chardev.h /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c chardev.c
                                                     
ioctl:		ioctl.c chardev.h
		$(CC) ioctl.c -o ioctl
