

all: mn2db.exe


mn2db.exe : mn2html.cs 
	mcs mn2html.cs

run: mn2html.exe
	mono mn2html.exe -f -d ../traducido/

clean: 
	rm *.exe
