%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token RESERVED_WORD IDCLASS CLASS EQUIVALENTTO SUBCLASSOF DISJOINTCLASSES IDINDIVIDUALS
%token INDIVIDUALS RELOP NUM PROPERTIE_IS PROPERTIE_HAS PROPERTIE DATA_TYPE

%%

classes: classPri 	{ cout << "Classe Primitiva válida\n"; }
	   | classDef 	{ cout << "Classe Definida válida\n"; }
	   | classAxi 	{ cout << "Classe com Axioma válida\n"; }
	   //| classDesc
	   | classEnum 	{ cout << "Classe Enumerada válida\n"; }
       | classCober { cout << "Classe Coberta válida\n"; }
	   ;


// Classe Primitiva
classPri: class subClassOf
		| class subClassOf disjointClasses 
		| class subClassOf individuals
		| class subClassOf disjointClasses individuals 
	 	;

// Classe Definida
classDef: class equivalentTo individuals
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
class: CLASS IDCLASS
	 ;

// SubClassOf para requisitos gerais
subClassOf: SUBCLASSOF subClass_list
          ;

// Diferentes formas que uma subClassOf geral pode se organizar
subClass_list: propertie RESERVED_WORD IDCLASS RELOP subClass_list
             | propertie RESERVED_WORD DATA_TYPE RELOP subClass_list
             | propertie RESERVED_WORD IDCLASS
             | propertie RESERVED_WORD DATA_TYPE
             ;

// SubClassOf especifica para determinar uma classe com axioma fechado
subClassOf_Axi: SUBCLASSOF subClass_AxiList
			  ;

// Diferentes formas que uma subClassOf para o Axioma Fechado pode se organizar
subClass_AxiList: IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD RELOP IDCLASS RESERVED_WORD IDCLASS RELOP
				| IDCLASS RELOP propertie RESERVED_WORD IDCLASS RELOP propertie RESERVED_WORD RELOP IDCLASS RELOP
				;

// EquivalentTo para requisitos gerais
equivalentTo: EQUIVALENTTO IDCLASS RESERVED_WORD RELOP PROPERTIE_HAS RESERVED_WORD IDCLASS RELOP
			| EQUIVALENTTO IDCLASS RESERVED_WORD RELOP PROPERTIE_HAS RESERVED_WORD DATA_TYPE RELOP RELOP NUM RELOP RELOP
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
enum_list: IDCLASS RELOP enum_list
		 | IDCLASS RELOP
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
	extern char * yytext;   

	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}
