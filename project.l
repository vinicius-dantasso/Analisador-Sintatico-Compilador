%{
// Reconhecedor de uma linguagem simplificada
#include <iostream>
using namespace std;

#include "project.tab.h"

%}

%option yylineno
%option noyywrap

delim	[ \t\n]
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
propertie {letterMi}{letter}
dataType {letterMi}({colon})({letter})


%%
{brancos}	        ; // nenhuma ação e nenhum retorno
some                return RESERVED_WORD;     
all                 return RESERVED_WORD;     
value               return RESERVED_WORD;     
min                 return RESERVED_WORD;     
max                 return RESERVED_WORD;     
exactly             return RESERVED_WORD;     
that                return RESERVED_WORD;     
not                 return RESERVED_WORD;     
and                 return RESERVED_WORD;     
or                  return RESERVED_WORD;     
only                return RESERVED_WORD;     
Class:              return CLASS;             
EquivalentTo:       return EQUIVALENTTO;      
Individuals:        return INDIVIDUALS;       
SubClassOf:         return SUBCLASSOF;        
DisjointClasses:    return DISJOINTCLASSES;   
DisjointWith:       return DISJOINTCLASSES;
{digito}	        return NUM;                
"<"		            return RELOP;              
"<="		        return RELOP;              
"="		            return RELOP;              
"<>"		        return RELOP;              
">"		            return RELOP;             
">="		        return RELOP;             
"["                 return RELOP;             
"]"                 return RELOP;             
"{"                 return RELOP;             
"}"                 return RELOP;             
"("                 return RELOP;             
")"                 return RELOP;             
","                 return RELOP;             
{propIs}            return PROPERTIE_IS;      
{propHas}           return PROPERTIE_HAS;         
{propertie}         return PROPERTIE;         
{dataType}          return DATA_TYPE;         
{idClasse}          return IDCLASS;            
{idIndividual}      return IDINDIVIDUALS;     
%%

// nenhuma função auxiliar é necessária
