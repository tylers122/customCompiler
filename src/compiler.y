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
        | arr_call {printf("statement -> arr_call\n");}
        | assign_statement {printf("statement -> assign_statement\n");}
        | inc_dec_statement {printf("statement -> inc_dec_statement\n");}
        | print_statement {printf("statement -> print_statement\n");}
        | input_statement {printf("statement -> input_statement\n");}
        | if_statement {printf("statement -> if_statement\n");}
        | while_statement {printf("statement -> while_statement\n");}
        | for_statement {printf("statement -> for_statement\n");}
        | break_statement {printf("statement -> break_statement\n");}
        | continue_statement {printf("statement -> continue_statement\n");}
        | function_call {printf("statement -> function_call\n");}
        | return_statement {printf("statement -> return_statement\n");}
        ;

var_declaration: VAR IDENT  {printf("var_declaration -> VAR IDENT \n");}
                | VAR IDENT ASSIGN NUMBER  {printf("var_declaration -> VAR IDENT ASSIGN NUMBER \n");}
	        ;

arr_declaration: VAR IDENT LBRACK NUMBER RBRACK {printf("arr_declaration -> VAR IDENT LBRACK NUMBER RBRACK\n");}

arr_call: IDENT LBRACK NUMBER RBRACK {printf("arr_call -> IDENT LBRACK NUMBER RBRACK\n");}

assign_statement: IDENT ASSIGN expression  {printf("assign_statement -> IDENT ASSIGN expression \n");}
                | IDENT PLUS_ASSIGN expression  {printf("assign_statement -> IDENT PLUS_ASSIGN expression \n");}
                | IDENT MINUS_ASSIGN expression  {printf("assign_statement -> IDENT MINUS_ASSIGN expression \n");}
                | IDENT MULT_ASSIGN expression  {printf("assign_statement -> IDENT MULT_ASSIGN expression \n");}
                | IDENT DIV_ASSIGN expression  {printf("assign_statement -> IDENT DIV_ASSIGN expression \n");}
                | IDENT MOD_ASSIGN expression  {printf("assign_statement -> IDENT MOD_ASSIGN expression \n");}
                | arr_call ASSIGN expression  {printf("assign_statement -> arr_call ASSIGN expression \n");}
                | arr_call PLUS_ASSIGN expression  {printf("assign_statement -> arr_call PLUS_ASSIGN expression \n");}
                | arr_call MINUS_ASSIGN expression  {printf("assign_statement -> arr_call MINUS_ASSIGN expression \n");}
                | arr_call MULT_ASSIGN expression  {printf("assign_statement -> arr_call MULT_ASSIGN expression \n");}
                | arr_call DIV_ASSIGN expression  {printf("assign_statement -> arr_call DIV_ASSIGN expression \n");}
                | arr_call MOD_ASSIGN expression  {printf("assign_statement -> arr_call MOD_ASSIGN expression \n");}

inc_dec_statement: IDENT INCREMENT  {printf("inc_dec_statement -> IDENT INCREMENT \n");}
                | IDENT DECREMENT  {printf("inc_dec_statement -> IDENT DECREMENT \n");}

print_statement: PRINT LPAREN IDENT RPAREN  {printf("print_statement -> PRINT LPAREN IDENT RPAREN \n");}
                | PRINT LPAREN NUMBER RPAREN  {printf("print_statement -> PRINT LPAREN NUMBER RPAREN \n");}
                | PRINT LPAREN expression RPAREN {printf("print_statement -> PRINT LPAREN expression RPAREN \n");}
                | PRINT LPAREN arr_call RPAREN {printf("print_statement -> PRINT LPAREN arr_call RPAREN \n");}

input_statement: INPUT LPAREN RPAREN {printf("input_statement -> INPUT LPAREN RPAREN\n");}

if_statement: IF LPAREN expression RPAREN LBRACE statements RBRACE {printf("if_statement -> IF LPAREN expression RPAREN LBRACE statement RBRACE\n");}
        | IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE {printf("if_statement -> IF LPAREN expression RPAREN LBRACE statement RBRACE ELSE LBRACE statement RBRACE\n");}
        ;

while_statement: WHILE LPAREN expression RPAREN LBRACE statements RBRACE {printf("while_statement -> WHILE LPAREN expression RPAREN LBRACE statements RBRACE\n");}

for_statement: FOR LPAREN var_declaration expression  inc_dec_statement RPAREN LBRACE statements RBRACE {printf("for_statement -> FOR LPAREN var_declaration expression  expression RPAREN LBRACE statements RBRACE\n");}
        | FOR LPAREN assign_statement expression  inc_dec_statement RPAREN LBRACE statements RBRACE {printf("for_statement -> FOR LPAREN assign_statement expression  expression RPAREN LBRACE statements RBRACE\n");}
        | FOR LPAREN IDENT  expression  inc_dec_statement RPAREN LBRACE statements RBRACE {printf("for_statement -> FOR LPAREN IDENT  expression  expression RPAREN LBRACE statements RBRACE\n");}

break_statement: BREAK  {printf("break_statement -> BREAK \n");}

continue_statement: CONT  {printf("continue_statement -> CONT \n");}



expression: IDENT {printf("expression -> IDENT\n");}
        | NUMBER {printf("expression -> NUMBER\n");}
        | LPAREN expression RPAREN {printf("expression -> LPAREN expression RPAREN\n");}
        | input_statement {printf("expression -> input_statement\n");}
        | arr_call {printf("expression -> arr_call\n");}
        | function_call {printf("expression -> function_call\n");}
        | binary_expression {printf("expression -> binary_expression\n");}

binary_expression: expression PLUS expression {printf("binary_expression -> expression PLUS expression\n");}
                | expression MINUS expression {printf("binary_expression -> expression MINUS expression\n");}
                | expression MULT expression {printf("binary_expression -> expression MULT expression\n");}
                | expression DIV expression {printf("binary_expression -> expression DIV expression\n");}
                | expression MOD expression {printf("binary_expression -> expression MOD expression\n");}
                | expression EQ expression {printf("binary_expression -> expression EQ expression\n");}
                | expression NEQ expression {printf("binary_expression -> expression NEQ expression\n");}
                | expression LT expression {printf("binary_expression -> expression LT expression\n");}
                | expression LTE expression {printf("binary_expression -> expression LTE expression\n");}
                | expression GT expression {printf("binary_expression -> expression GT expression\n");}
                | expression GTE expression {printf("binary_expression -> expression GTE expression\n");}
                | expression AND expression {printf("binary_expression -> expression AND expression\n");}
                | expression OR expression {printf("binary_expression -> expression OR expression\n");}
                ;

/* FUNCTION CALL ASSIGNMENT NEEDS DOUBLE ; */
function_call: IDENT LPAREN args RPAREN  {printf("function_call -> IDENT LPAREN args RPAREN \n");}

args: %empty {printf("args -> epsilon\n");}
    | arg repeat_args {printf("args -> arg repeat_args\n");}

repeat_args: %empty {printf("repeat_args -> epsilon\n");}
        | COMMA arg repeat_args {printf("repeat_args -> COMMA arg repeat_args\n");}

arg: expression {printf("arg -> expression\n");}

return_statement: RETURN expression {printf("return_statement -> RETURN expression \n");}



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