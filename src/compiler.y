%{
#include <stdio.h>
#include "y.tab.h"

extern FILE* yyin;
extern int yylex();
extern int yylineno;
extern int curr_col;
void yyerror(const char* s);
%}

%error-verbose
%start prog_start
%token INVALID_IDENT INVALID_TOKEN
%token PRINT INPUT WHILE FOR BREAK CONT IF ELSE IMPORT EXPORT FUNC RETURN VAR
%token IDENT NUMBER
%token PLUS MINUS MULT DIV MOD ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN
%token MOD_ASSIGN INCREMENT DECREMENT EQ NEQ LT GT LTE GTE AND OR NOT LPAREN
%token RPAREN LBRACE RBRACE LBRACK RBRACK COLON SEMICOLON COMMA

%%
prog_start: %empty /* epsilon */ {printf("prog_start->epsilon\n");} 
        | functions {printf("prog_start -> functions\n");}
        ;

functions: function {printf("functions -> function\n");}
        | function functions {printf("functions -> function functions\n");}
        ;

function: FUNC IDENT LPAREN arguments RPAREN LBRACE statements RBRACE {printf("function -> VAR IDENT LPAREN arguments RPAREN LBRACE statements RBRACE\n");}
	;

arguments: %empty {printf("arguments -> epsilon\n");}
        | argument repeat_arguments {printf("arguments -> argument repeat_arguments\n");}

repeat_arguments: %empty {printf("repeat_arguments -> epsilon\n");}
                | COMMA argument repeat_arguments {printf("repeat_arguments -> COMMA argument repeat_arguments\n");}

argument: VAR IDENT {printf("argument -> VAR IDENT\n");}
	;

statements: %empty /* epsilon */ {printf("statements -> epsilon\n");}
        | statement statements {printf("statements -> statement statements\n");}
        ;

statement: var_declaration {printf("statement -> var_declaration\n");}
        | arr_declaration {printf("statement -> arr_declaration\n");}
        | print_statement {printf("statement -> print_statement\n");}
        | input_statement {printf("statement -> input_statement\n");}
        | if_statement {printf("statement -> if_statement\n");}
        | while_statement {printf("statement -> while_statement\n");}
        | break_statement {printf("statement -> break_statement\n");}
        | continue_statement {printf("statement -> continue_statement\n");}
        | function_call {printf("statement -> function_call\n");}
        | return_statement {printf("statement -> return_statement\n");}
        | assign_var {printf("statement -> assign_var\n");}
        | assign_arr {printf("statement -> assign_arr\n");}
        ;

var_declaration: VAR IDENT assign_statement {printf("var_declaration -> VAR IDENT assign_statement \n");}

arr_declaration: VAR IDENT LBRACK add_expression RBRACK assign_statement {printf("arr_declaration -> VAR IDENT LBRACK add_expression RBRACK assign_statement\n");}

assign_statement: %empty {printf("assign_statement -> epsilon\n");}
                | ASSIGN add_expression {printf("assign_statement -> ASSIGN add_expression\n");}
                ;

print_statement: PRINT LPAREN binary_expression RPAREN {printf("print_statement -> PRINT LPAREN binary_expression RPAREN \n");}

input_statement: INPUT LPAREN NUMBER RPAREN {printf("input_statement -> INPUT LPAREN NUMBER RPAREN\n");}

if_statement: IF expression LBRACE statements RBRACE else_statement {printf("if_statement -> IF expression LBRACE statement RBRACE else_statement\n");}

else_statement: %empty {printf("else_statement -> epsilon\n");}
        | ELSE LBRACE statements RBRACE {printf("else_statement -> ELSE LBRACE statements RBRACE\n");}

while_statement: WHILE LPAREN binary_expression RPAREN LBRACE statements RBRACE {printf("while_statement -> WHILE LPAREN binary_expression RPAREN LBRACE statements RBRACE\n");}

break_statement: BREAK {printf("break_statement -> BREAK \n");}

continue_statement: CONT {printf("continue_statement -> CONT \n");}

expression: IDENT {printf("expression -> IDENT\n");}
        | NUMBER {printf("expression -> NUMBER\n");}
        | input_statement {printf("expression -> input_statement\n");}
        | function_call {printf("expression -> function_call\n");}
        | LPAREN binary_expression RPAREN {printf("expression -> LPAREN binary_expression RPAREN\n");}
        | IDENT LBRACK add_expression RBRACK {printf("expression -> IDENT LBRACK add_expression RBRACK\n");}
        ;

binary_expression: add_expression {printf("binary_expression -> add_expression\n");}
                | binary_expression EQ add_expression {printf("binary_expression -> binary_expression EQ add_expression\n");}
                | binary_expression NEQ add_expression {printf("binary_expression -> binary_expression NEQ add_expression\n");}
                | binary_expression LT add_expression {printf("binary_expression -> binary_expression LT add_expression\n");}
                | binary_expression LTE add_expression {printf("binary_expression -> binary_expression LTE add_expression\n");}
                | binary_expression GT add_expression {printf("binary_expression -> binary_expression GT add_expression\n");}
                | binary_expression GTE add_expression {printf("binary_expression -> binary_expression GTE add_expression\n");}
                | binary_expression AND add_expression {printf("binary_expression -> binary_expression AND add_expression\n");}
                | binary_expression OR add_expression {printf("binary_expression -> binary_expression OR add_expression\n");}
                ;

add_expression: mult_expression {printf("add_expression -> mult_expression\n");}
                | add_expression PLUS mult_expression {printf("add_expression -> add_expression PLUS mult_expression\n");}
                | add_expression MINUS mult_expression {printf("add_expression -> add_expression MINUS mult_expression\n");}
                ;

mult_expression: base_expression {printf("mult_expression -> base_expression\n");}
                | mult_expression MULT base_expression {printf("mult_expression -> mult_expression MULT base_expression\n");}
                | mult_expression DIV base_expression {printf("mult_expression -> mult_expression DIV base_expression\n");}
                | mult_expression MOD base_expression {printf("mult_expression -> mult_expression MOD base_expression\n");}
                ;

base_expression: expression {printf("base_expression -> expression\n");}

assign_var: IDENT ASSIGN add_expression {printf("assign_var -> IDENT ASSIGN add_expression\n");}

assign_arr: IDENT LBRACK add_expression RBRACK ASSIGN add_expression {printf("assign_arr -> IDENT LBRACK add_expression RBRACK ASSIGN add_expression\n");}

function_call: IDENT LPAREN param RPAREN {printf("function_call -> IDENT LPAREN param RPAREN \n");}

param: %empty {printf("param -> epsilon \n");}
        | binary_expression params {printf("param -> binary_expression params \n");}
        ;

params: %empty {printf("params -> epsilon \n");}
        | COMMA binary_expression params {printf("params -> COMMA binary_expression params \n");}
        ;

return_statement: RETURN add_expression {printf("return_expression -> add_expression \n");}



%%


void yyerror(const char* s) {
	fprintf(stderr, "Error %s at line %d, column %d\n", s, yylineno, curr_col);
} 

void main(int argc, char** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL)
			yyin = stdin;
	}
	else {
		yyin = stdin;
	}
	yyparse();
}