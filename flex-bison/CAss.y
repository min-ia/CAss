%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "symbol_table.h"

	extern FILE *yyin;
	FILE *file;
	char *variable;

	#define true 1
	#define false 0

%}

%union
{
	int bool;
    int intValue;
    char *stringValue;
}


%token INTEGER
%token <stringValue> VARIABLE
%token INT ASSIGN SEMICOLON END
%token COMPARE BIGGER SMALLER BIGGER_THEN SMALLER_THEN
%token IF ELSE ELSE_IF
%token PLUS MINUS TIMES DIVIDE LEFT_PARENTHESIS RIGHT_PARENTHESIS
%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right LEFT_PARENTHESIS RIGHT_PARENTHESIS

%type<intValue> Expression INTEGER
%type<bool> Conditional

%start Input

%%

Input:
	/*    */
	| Input Line
	;
Line:
	END
	| Assignment END {
		//printf("Resultado: %d\n",$1); 
	}
	| If_statement END{

	}
	;
Assignment:
	INT VARIABLE SEMICOLON {
		fprintf(file, "%s;\n", $2);
	}
	| INT VARIABLE ASSIGN INTEGER SEMICOLON {
		fprintf(file, "%s DQ %d\n", $2, $4);
	}
	| INT VARIABLE ASSIGN Expression SEMICOLON {
		fprintf(file, "%s DQ %d\n", $2, $4);
	}
	;
Expression:
	INTEGER {
		$$ = $1;
	}
	| Expression PLUS Expression{
		$$ = $1 + $3;

	}
	| Expression MINUS Expression{
		$$ = $1 - $3;
	}
	| Expression TIMES Expression{
		$$ = $1 * $3;
	}
	| Expression DIVIDE Expression{
		$$ = $1 / $3;
	}
	| MINUS Expression %prec NEG{
		$$ = -$2;
	}
	| LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS {
		$$ = $2;
	}
   	;
If_statement:
	IF LEFT_PARENTHESIS Conditional RIGHT_PARENTHESIS{
		fprintf(file, "if(%d)\n", $3);
	}
	| ELSE_IF LEFT_PARENTHESIS Conditional RIGHT_PARENTHESIS{
		fprintf(file, "else if(%d)\n", $3);
	}
	| ELSE{
		fprintf(file, "else\n");
	}
Conditional:
	INTEGER COMPARE INTEGER{
		$$ = true;
	}
	| INTEGER SMALLER INTEGER{
		$$ = true;
	}
	| INTEGER BIGGER INTEGER{
		$$ = true;
	}
	| INTEGER SMALLER_THEN INTEGER{
		$$ = true;
	}
	| INTEGER BIGGER_THEN INTEGER{
		$$ = true;
	}
%%

int yyerror() {
	printf("ERROR\n");
}

int main(void) {

	node *symbol = create_list();
	file = fopen("compilado.txt", "r");

	if(file != NULL){
		fclose(file);
		remove("compilado.txt");
	}

	file = fopen("compilado.txt", "a");

	yyparse();

	fclose(file);
}
