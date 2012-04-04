#
#  Makefile for cool.ps
#
.SUFFIXES: .fig .latex .eps

CHAPTERS = 	intro/preface.tex \
		basics/hw.tex basics/sw.tex \
		mm/memory.tex \
		kernel/processes.tex \
		ipc/ipc.tex \
		dd/drivers.tex dd/interrupts.tex dd/pci.tex \
		fs/filesystem.tex \
		net/net.tex \
		kernel/kernel.tex \
		sources/sources.tex \
		modules/modules.tex

MISC = 		tlk2e.sty \
		misc/copyright.tex \
		misc/dedication.tex  \
		misc/definitions.tex \
		misc/macros.tex 

PICTURES_EPS = 	basics/board.eps \
		mm/vm.eps mm/pte.eps mm/vm_area.eps \
		mm/free-area.eps mm/vm-axp.eps \
		mm/page-tables.eps mm/mm.eps \
		mm/shm.eps mm/page-cache.eps \
		dd/pci-structures.eps \
		dd/pci-system.eps dd/pci-bars.eps dd/pci-config-header.eps \
		dd/pci-pci-config-eg-1.eps dd/pci-pci-config-eg-2.eps \
		dd/pci-pci-config-eg-3.eps dd/pci-pci-config-eg-4.eps \
		dd/pci-cycle-0.eps dd/pci-cycle-1.eps \
		dd/interrupts.eps dd/interrupt-handling.eps \
		dd/blk_dev.eps dd/gendisk.eps \
		dd/scsi.eps dd/chrdevs.eps \
		fs/ext2_inode.eps fs/ext2.eps fs/ext2_dir.eps \
		fs/file-systems.eps fs/vfs.eps fs/mounted.eps \
		fs/buffer-cache.eps \
		modules/modules.eps \
		kernel/bh.eps kernel/tqueue.eps kernel/timers.eps \
		kernel/binfmt.eps kernel/files.eps ipc/pipes.eps \
		kernel/process-vm.eps kernel/elf.eps \
		ipc/msg.eps ipc/shm.eps ipc/sem.eps \
		net/protocols.eps net/fib.eps net/sk_buff.eps \
		net/layers.eps net/sockets.eps

APPENDICES = \
		appendices/glossary.tex \
		appendices/www.tex \
		appendices/axp.tex \
		appendices/bibliography.tex \
		appendices/gpl.tex \
		ds/ds.tex ds/sk_buff.tex ds/device.tex ds/mem_map_t.tex \
		ds/mm_struct.tex ds/vm_area_struct.tex ds/task_struct.tex \
		ds/files_struct.tex ds/fs_struct.tex ds/file.tex \
		ds/ipc_perm.tex ds/timer_list.tex ds/linux_binfmt.tex \
		ds/pci_dev.tex ds/pci_bus.tex ds/irqaction.tex ds/device_struct.tex \
		ds/blk_dev_struct.tex ds/device.tex ds/request.tex ds/gendisk.tex ds/inode.tex \
		ds/buffer_head.tex ds/socket.tex ds/sock.tex \
		ds/rtable.tex ds/tq_struct.tex ds/semaphore.tex 

tlk.dvi:	tlk.tex $(MISC) $(CHAPTERS) $(PICTURES_EPS) $(APPENDICES) version.tex
		latex tlk.tex
		latex tlk.tex
		latex tlk.tex

tlk.ps:	tlk.dvi
	dvips -o tlk.ps tlk.dvi

tlk-html.html:	index
	tth -e2 -Ltlk < tlk-html.tex > tlk-html.html 2>html.err

tlk.html:	index
	tth -e2 -Ltlk < tlk.tex > tlk.html 2>html.err

all:		tlk.ps \
		tlk.html
	echo	'done'

figures:	$(PICTURES_EPS)
	echo	'done'


#
# Version
#
version.tex:	version.pl .version
	./version.pl

newversion:	version.pl
	./version.pl -i

.version:	version.pl
	./version.pl

#
# Index
#
index:		tlk.dvi
	makeindex -o tlk.ind tlk.idx
	latex tlk.tex

#
# Pictures.
#
.fig.latex:
	fig2dev -L latex $< > $@

#
# Pictures.
#
.fig.eps:
	fig2dev -L ps -c $< > $@

#
# Index
#
tlk.ind:		tlk.idx $(CHAPTERS)
	makeindex -o tlk.ind tlk.idx

#
# Always clean up...
#
clean:		
	rm -f *.log *.toc *.aux *~
	rm -f ./*/*.latex ./*/*.aux ./*/*~
	rm -f *.idx *.ind
	rm -f *.ilg *.lof
	rm -f ./*/*.bak
	rm -f ./*/*.eps
	rm -f version.tex
	rcsclean

really_clean:	clean 
	rm -f ./*/*.gif
	rm -f *.ps *.dvi
	rm -f *.html html.err

