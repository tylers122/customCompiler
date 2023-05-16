%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#inclulde <vector>
#include <string>

extern FILE* yyin;
extern int yylex();
extern int yylineno;
extern int curr_col;
void yyerror(const char* s);

char *identToken;
int numberToken;
int  count_names = 0;

enum Type { Integer, Array };

struct Symbol {
  std::string name;
  Type type;
};

struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

// remember that Bison is a bottom up parser: that it parses leaf nodes first before
// parsing the parent nodes. So control flow begins at the leaf grammar nodes
// and propagates up to the parents.
Function *get_function() {
  int last = symbol_table.size()-1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    exit(1);
  }
  return &symbol_table[last];
}

// find a particular variable using the symbol table.
// grab the most recent function, and linear search to
// find the symbol you are looking for.
// you may want to extend "find" to handle different types of "Integer" vs "Array"
bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

// when you see a function declaration inside the grammar, add
// the function name to the symbol table
void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

// when you see a symbol declaration inside the grammar, add
// the symbol name as well as some type information to the symbol table
void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

// a function to print out the symbol table to the screen
// largely for debugging purposes.
void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

struct CodeNode {
    std::string code; // generated code as a string.
    std::string name;
};
%}


%union {
  char *op_val;
  struct CodeNode *node;
}



%error-verbose
%start prog_start
%token INVALID_IDENT INVALID_TOKEN
%token PRINT INPUT WHILE FOR BREAK CONT IF ELSE IMPORT EXPORT FUNC RETURN VAR
%token IDENT NUMBER
%token PLUS MINUS MULT DIV MOD ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN
%token MOD_ASSIGN INCREMENT DECREMENT EQ NEQ LT GT LTE GTE AND OR NOT LPAREN
%token RPAREN LBRACE RBRACE LBRACK RBRACK COLON SEMICOLON COMMA

%%
prog_start: 
functions
{
        CodeNode *node = $1;
        std::string code = node->code;
        printf("Generated code:\n");
        printf("%s\n", code.c_str());
}

functions: 
        %empty
        {
                CodeNode *node = new CodeNode;
                $$ = node;
        }
        | function 
        {
                CodeNode *func = $1;
                std::string code = func->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        }        
        | function functions 
        {
                CodeNode *func  = $1;
                CodeNode *funcs = $2;
                std::string code = func->code + funcs->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        }
        

function: 
        FUNC IDENT LPAREN arguments RPAREN LBRACE 
        statements RBRACE 
        {
                
        }
	

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