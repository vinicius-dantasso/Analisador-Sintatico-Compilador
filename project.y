%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token RESERVED_WORD IDCLASS CLASS EQUIVALENTTO SUBCLASSOF DISJOINTCLASSES IDINDIVIDUALS
%token INDIVIDUALS RELOP NUM PROPERTIE_IS PROPERTIE_HAS PROPERTIE DATA_TYPE NOT_VALID

%%

// Classe Primitiva

classes: classPri { cout << "Classe definida\n"; }
		/*| classDef
		|	classAxi
		| classDesc
		| classEnum
		| classCober*/
		;

 
classPri: class subClassOf{ cout << "Classe primitiva definida\n"; }
				| class subClassOf disjointClasses
	 ;

class: CLASS IDCLASS
subClassOf: SUBCLASSOF subClass_list { cout << "Subclasse definida\n"; }
        ;

subClass_list: propertie RESERVED_WORD IDCLASS RELOP subClass_list
             | propertie RESERVED_WORD DATA_TYPE RELOP subClass_list
             | propertie RESERVED_WORD IDCLASS
             | propertie RESERVED_WORD DATA_TYPE
             ;


propertie: PROPERTIE_HAS
         | PROPERTIE_IS
         | PROPERTIE
         ;

disjointClasses: DISJOINTCLASSES disjointClasses_list { cout << "Disjoint definida\n"; }
							 ;

disjointClasses_list: disjointClasses_list RELOP IDCLASS
										| IDCLASS
										;

individuals: INDIVIDUALS individuals_list
						;

individuals_list: individuals_list RELOP IDINDIVIDUALS
								| IDINDIVIDUALS
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
