all: project

# Compiladores
CPP=g++
FLEX=flex 
BISON=bison

project: lex.yy.c project.tab.c
	$(CPP) lex.yy.c project.tab.c -std=c++17 -o project

lex.yy.c: project.l
	$(FLEX) project.l

project.tab.c: project.y
	$(BISON) -d -Wcounterexamples project.y

clean:
	rm project lex.yy.c project.tab.c project.tab.h
