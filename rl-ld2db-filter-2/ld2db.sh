#!/bin/sh
# Convert LinuxDoc to DocBook using Cygnus DocBook tools
# Reuben Thomas (rrt@sc3d.org)   16/12/99-11/1/00

# Usage: ld2db.sh from to

LD2DB=./ # path to contents of ld2db archive

if [ $# -eq 2 ]; then
	sgmlnorm $LD2DB/docbook.dcl $1 > expanded.sgml
	jade -t sgml -c $LD2DB/catalog -d $LD2DB/ld2db.dsl#db expanded.sgml > $2
	rm expanded.sgml

	# Added by me - In order to get DB4x (ricardo.cervera)
	./parse.sh $2
else
	echo "Usage: $0 from to"
fi
