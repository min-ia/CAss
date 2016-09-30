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
%token COMPARE BIGGER SMALLER BIGGER_THEN SMALLER_THEN DIFFERENT NOT AND OR
%token IF ELSE ELSE_IF
%token PLUS MINUS TIMES DIVIDE LEFT_PARENTHESIS RIGHT_PARENTHESIS
%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_KEY RIGHT_KEY

%type<intValue> Expression INTEGER

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
	IF Conditional {
		fprintf(file, "if\n");
	}
	| ELSE_IF Conditional{
		fprintf(file, "else if\n");
	}
	| ELSE{
		fprintf(file, "else\n");
	}
	| If_statement LEFT_KEY {
		fprintf(file, "{}\n");
	}

Conditional:
	Operand{

	}
	| Operand COMPARE Operand{
		fprintf(file, "	== ");
	}
	| Operand DIFFERENT Operand{
		fprintf(file, "	!= ");
	}
	| Operand SMALLER_THEN Operand{
		fprintf(file, "	< ");
	}
	| Operand BIGGER_THEN Operand{
		fprintf(file, " > ");
	}
	| Operand SMALLER Operand{
		fprintf(file, "	<= ");
	}
	| Operand BIGGER Operand{
		fprintf(file, " >= ");
	}
	| Conditional AND Conditional{
		fprintf(file, " AND ");
	}
	| Conditional OR Conditional{
		fprintf(file, " OR	 ");
	}
	| NOT Conditional {
		fprintf(file, "NOT Conditional ");
	}
	| LEFT_PARENTHESIS Conditional RIGHT_PARENTHESIS{

	}
Operand:
	VARIABLE{
	}
	| Expression{
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
