%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
#include <cstring>
using std::cout;
char vet[200];
int isClass = 0;
extern char * yytext; 

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token RESERVED_WORD IDCLASS CLASS EQUIVALENTTO SUBCLASSOF DISJOINTCLASSES IDINDIVIDUALS
%token INDIVIDUALS RELOP NUM PROPERTIE_IS PROPERTIE_HAS PROPERTIE DATA_TYPE

%%

classes: classPri classes 	{std::cout << "Classe primitiva válida"}	
	   | classDefAnin classes
	   | classAxi classes 		{std::cout << "Classe com axioma de fechamento válida"}
	   | classEnum classes 		{std::cout << "Classe enumerada válida"}
       | classCober classes 	{std::cout << "Classe coberta válida"}
	   | 
	   ;


// Classe Primitiva
classPri: class subClassOf
		| class subClassOf disjointClasses
		| class subClassOf individuals
		| class subClassOf disjointClasses individuals
	 	;

// Classe Definida/Aninhada
classDefAnin: class equivalentTo individuals
			| class equivalentTo
			;

// Classe com Axioma Fechado
classAxi: class subClassOf_Axi
		;
	
// Classe Enumerada
classEnum: class equivalentToEnum
		 ;

// Classe Coberta
classCober: class equivalentToCober
		  ;

// Define uma Class: Pizza
class: CLASS IDCLASS { isClass = 1; strcpy(vet,yytext); }
	 ;

// SubClassOf para requisitos gerais
subClassOf: SUBCLASSOF subClass_list
		  | SUBCLASSOF IDCLASS
          ;

// Diferentes formas que uma subClassOf geral pode se organizar
subClass_list: propertie RESERVED_WORD IDCLASS RELOP subClass_list
             | propertie RESERVED_WORD DATA_TYPE RELOP subClass_list
			 | propertie RESERVED_WORD NUM RELOP IDCLASS subClass_list
			 | propertie RESERVED_WORD NUM IDCLASS
			 | propertie RESERVED_WORD NUM IDCLASS RELOP subClass_list
			 | propertie propertie RESERVED_WORD NUM IDCLASS
			 | propertie propertie RESERVED_WORD NUM IDCLASS RELOP subClass_list
             | propertie RESERVED_WORD IDCLASS
			 | propertie RESERVED_WORD IDCLASS RELOP subClass_list
			 | propertie propertie RESERVED_WORD IDCLASS
			 | propertie propertie RESERVED_WORD IDCLASS RELOP subClass_list
             | propertie RESERVED_WORD DATA_TYPE
			 | IDCLASS RELOP subClass_list
			 | IDCLASS RELOP subClass_list2 subClass_list
			 | IDCLASS RELOP composedBySubClass subClass_list
             ;
composedBySubClass: RELOP propertie RESERVED_WORD NUM IDCLASS RELOP RELOP
				  |	RELOP propertie RESERVED_WORD NUM IDCLASS RELOP RESERVED_WORD composedBySubClass
				  ;

subClass_list2: RELOP propertie RESERVED_WORD IDCLASS RELOP
			  | RELOP propertie RESERVED_WORD IDCLASS RELOP RELOP
			  | RELOP propertie RESERVED_WORD IDCLASS RELOP RESERVED_WORD subClass_list2
			  ;

// SubClassOf especifica para determinar uma classe com axioma fechado
subClassOf_Axi: SUBCLASSOF subClass_AxiList
			  ;

// Diferentes formas que uma subClassOf para o Axioma Fechado pode se organizar
subClass_AxiList: IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD RELOP IDCLASS RESERVED_WORD IDCLASS RELOP
				| IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD RELOP IDCLASS RELOP
				;

// EquivalentTo para requisitos gerais
equivalentTo: equivalent DATA_TYPE RELOP RELOP NUM RELOP RELOP
			| equivalent descAnin
			;

equivalent: EQUIVALENTTO IDCLASS RESERVED_WORD RELOP propertie RESERVED_WORD
		  | EQUIVALENTTO IDCLASS RESERVED_WORD RELOP RELOP propertie RESERVED_WORD
		  | EQUIVALENTTO IDCLASS RESERVED_WORD propertie RESERVED_WORD
		  ;

descAnin: RELOP propertie RESERVED_WORD IDCLASS RELOP RELOP descAnin2
		| RELOP cober_list RELOP RELOP descAnin2
		| RELOP cober_list RELOP descAnin2
		| IDCLASS descAnin2
		| IDCLASS RELOP descAnin2
		;

descAnin2: RESERVED_WORD RELOP propertie RESERVED_WORD RELOP propertie RESERVED_WORD IDCLASS RELOP RELOP descAnin2
		 | RESERVED_WORD RELOP propertie RESERVED_WORD RELOP cober_list RELOP RELOP descAnin2
		 | RESERVED_WORD RELOP propertie RESERVED_WORD NUM IDCLASS RELOP descAnin2
		 | RESERVED_WORD RELOP propertie RESERVED_WORD IDCLASS RELOP descAnin2
		 | RESERVED_WORD RELOP propertie RESERVED_WORD IDCLASS RELOP RELOP descAnin2
		 | RESERVED_WORD propertie RESERVED_WORD IDCLASS descAnin2
		 | RESERVED_WORD propertie RESERVED_WORD NUM IDCLASS descAnin2
		 |
		 ;

// EquivalentTo especifico para determinar uma classe coberta
equivalentToCober: EQUIVALENTTO cober_list
				 ;

// Diferentes formas que um equivalentTo para a Classe Coberta pode se organizar
cober_list: IDCLASS RESERVED_WORD cober_list
		  | IDCLASS
		  ;

// EquivalentTo especifico para determinar uma classe enumerada
equivalentToEnum: EQUIVALENTTO RELOP enum_list
				;

// Diferentes formas que um equivalentTo para a Classe Enumerada pode se organizar
enum_list: IDINDIVIDUALS RELOP enum_list
		 | IDINDIVIDUALS RELOP
		 ;

// Define uma DisjointClass
disjointClasses: DISJOINTCLASSES disjointClasses_list
			   ;

// Diferentes formas que um DisjointClass pode se organizar
disjointClasses_list: disjointClasses_list RELOP IDCLASS
					| IDCLASS
					;

// Define um Individuals
individuals: INDIVIDUALS individuals_list
		   ;

// Diferentes formas que um Individuals pode se organizar/
individuals_list: individuals_list RELOP IDINDIVIDUALS
				| IDINDIVIDUALS
				;

// Define as properties em um geral
propertie: PROPERTIE_HAS
         | PROPERTIE_IS
         | PROPERTIE
         ;

%%

/* definido pelo analisador léxico */
extern FILE * yyin;  

int main(int argc, char ** argv)
{
	/* se foi passado um nome de arquivo */
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " não encontrado!\n";
			exit(1);
		}
		
		/* entrada ajustada para ler do arquivo */
		yyin = file;
	}

	yyparse();
}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
  

	if(isClass == 1) {
		/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    	cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ") Na classe " << vet << "\n";
		isClass = 2;
	}
	yyparse();
}
