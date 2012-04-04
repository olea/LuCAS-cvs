# Makefile para un módulo básico del núcleo

CC=gcc
MODCFLAGS := -O6 -Wall -DCONFIG_KERNELD -DMODULE -D__KERNEL__ -DLINUX

intrpt.o:	intrpt.c /usr/include/linux/version.h
		$(CC) $(MODCFLAGS) -c intrpt.c
                echo Este módulo matará tu máquina, y no tendrás
                echo forma de reiniciarla de una manera agradable. ¡Antes
                echo de hacer insmod, haz un "sleep 120 ; reboot" en
                echo otro terminal!          
