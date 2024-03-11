%{

// Reconhecedor de uma linguagem simplificada
#include <iostream>
#include <string>
#include <unordered_map>
using namespace std;

#include "project.tab.h"
#define CONSULTA 0;

unordered_map<string,int> tabela;
int estado;

int inserir(int tipo, string palavra);
int buscar(string palavra);
int podeInserir(string palavra);

%}

%option yylineno
%option noyywrap

delim	[ \t]
brancos {delim}+
letterMa [A-Z]+
letterMi [a-z]+
letter [A-Za-z]+
digito	[0-9]+
underline [_]
has (has)
is (is)
of (Of)
colon (:)
propHas ({has})({letter})
propIs {is}({letterMa}({letter})){of}
idClasse {letterMa}({letter}|{underline})*
idIndividual {letterMa}({letter})({digito})
propertie (({letterMi})({letterMa})({letter})|({letterMi}))
dataType {letterMi}({colon})({letter})


%%
\n estado = 0;

{brancos}	; // nenhuma ação e nenhum retorno
some                estado = RESERVED_WORD;     {podeInserir(yytext);};
all                 estado = RESERVED_WORD;     {podeInserir(yytext);};
value               estado = RESERVED_WORD;     {podeInserir(yytext);};
min                 estado = RESERVED_WORD;     {podeInserir(yytext);};
max                 estado = RESERVED_WORD;     {podeInserir(yytext);};
exactly             estado = RESERVED_WORD;     {podeInserir(yytext);};
that                estado = RESERVED_WORD;     {podeInserir(yytext);};
not                 estado = RESERVED_WORD;     {podeInserir(yytext);};
and                 estado = RESERVED_WORD;     {podeInserir(yytext);};
or                  estado = RESERVED_WORD;     {podeInserir(yytext);};
only                estado = RESERVED_WORD;     {podeInserir(yytext);};
Class:              estado = CLASS;             {podeInserir(yytext);};
EquivalentTo:       estado = EQUIVALENTTO;      {podeInserir(yytext);};
Individuals:        estado = INDIVIDUALS;       {podeInserir(yytext);};
SubClassOf:         estado = SUBCLASSOF;        {podeInserir(yytext);};
DisjointClasses:    estado = DISJOINTCLASSES;   {podeInserir(yytext);};
{digito}	        estado = NUM;               {podeInserir(yytext);}; 
"<"		            estado = RELOP;             {podeInserir(yytext);}; 
"<="		        estado = RELOP;             {podeInserir(yytext);}; 
"="		            estado = RELOP;             {podeInserir(yytext);}; 
"<>"		        estado = RELOP;             {podeInserir(yytext);}; 
">"		            estado = RELOP;             {podeInserir(yytext);};
">="		        estado = RELOP;             {podeInserir(yytext);};
 "["                estado = RELOP;             {podeInserir(yytext);};
 "]"                estado = RELOP;             {podeInserir(yytext);};
 "{"                estado = RELOP;             {podeInserir(yytext);};
 "}"                estado = RELOP;             {podeInserir(yytext);};
 "("                estado = RELOP;             {podeInserir(yytext);};
 ")"                estado = RELOP;             {podeInserir(yytext);};
 ","                estado = RELOP;             {podeInserir(yytext);};
{propIs}            estado = PROPERTIE;         {podeInserir(yytext);};
{propHas}           estado = PROPERTIE;         {podeInserir(yytext);};
{propertie}         estado = PROPERTIE;         {podeInserir(yytext);};
{dataType}          estado = DATA_TYPE;         {podeInserir(yytext);};
{idClasse}          estado = IDCLASS;           {podeInserir(yytext);}; 
{idIndividual}      estado = IDINDIVIDUALS;     {podeInserir(yytext);};
%%

int inserir(int tipo, string palavra) {

    if(buscar(palavra) != 0) {
        cout << "atenção: " << palavra << " já definido\n";
        return 0;
    }

    tabela.insert({palavra, tipo});

    return 1;

}

int buscar(string palavra) {

    auto pos = tabela.find(palavra);

    if(pos == tabela.end()) {
        return 0;
    }

    return pos->second;

}

int podeInserir(string palavra) {

    if(estado != 0) {
        inserir(estado, palavra);
    }
    else {

        switch(buscar(palavra)) {

            case RESERVED_WORD:     return RESERVED_WORD;
            case RELOP:             return RELOP;
            case PROPERTIE:         return PROPERTIE;
            case IDCLASS:           return IDCLASS;
            case CLASS:             return CLASS;
            case EQUIVALENTTO:      return EQUIVALENTTO;
            case SUBCLASSOF:        return SUBCLASSOF;
            case DISJOINTCLASSES:   return DISJOINTCLASSES;
            case IDINDIVIDUALS:     return IDINDIVIDUALS;
            case INDIVIDUALS:       return INDIVIDUALS;
            case DATA_TYPE:         return DATA_TYPE;
            case NUM:               return NUM;
            default: cout << "Erro léxico: \"" << palavra << "\" não reconhecido\n";

        }

    }

}

// nenhuma função auxiliar é necessária
