%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>
#include <sstream>

extern FILE* yyin;
extern int yylex(void);
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
  std::vector<Symbol> arguments;
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
  for(int i=0; i < f->arguments.size(); i++) {
    Symbol *s = &f->arguments[i];
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
  f->arguments.push_back(s);
}

// a function to print out the symbol table to the screen
// largely for debugging purposes.
void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].arguments.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].arguments[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

struct CodeNode {
    std::string code; // generated code as a string.
    std::string name;
};


std::string create_temp() {
        static int num = 0;
        std::ostringstream ss;
        ss << num;
        std::string value = "_temp" + ss.str();
        num += 1;
        return value;
}

std::string decl_temp(std::string &temp){
        return std::string(". ") + temp + std::string("\n");
}
%}


%union {
  char *op_val;
  struct CodeNode *node;
}



%define parse.error verbose
%start prog_start
%token INVALID_IDENT INVALID_TOKEN
%token PRINT INPUT WHILE FOR BREAK CONT IF ELSE IMPORT EXPORT FUNC RETURN VAR
%token PLUS MINUS MULT DIV MOD ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN
%token MOD_ASSIGN INCREMENT DECREMENT EQ NEQ LT GT LTE GTE AND OR NOT LPAREN
%token RPAREN LBRACE RBRACE LBRACK RBRACK COLON SEMICOLON COMMA
%token  <op_val> NUMBER
%token  <op_val> IDENT
%type   <op_val> func_ident
%type   <node>  functions
%type   <node>  function
%type   <node>  arguments
%type   <node>  argument
%type   <node>  repeat_arguments
%type   <node>  statement
%type   <node>  statements
%type   <node>  var_declaration
%type   <node>  arr_declaration
%type   <node>  assign_statement
%type   <node>  print_statement
%type   <node>  input_statement
%type   <node>  if_statement
%type   <node>  else_statement
%type   <node>  while_statement
%type   <node>  break_statement
%type   <node>  continue_statement
%type   <node>  expression
%type   <node>  binary_expression
%type   <node>  add_expression
%type   <node>  mult_expression
%type   <node>  base_expression
%type   <node>  assign_var
%type   <node>  assign_arr
%type   <node>  function_call
%type   <node>  param
%type   <node>  params
%type   <node>  return_statement



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
        %empty {
                CodeNode *node = new CodeNode;
                $$ = node;
        }
        | function functions {
                CodeNode *func = $1;
                CodeNode *funcs = $2;
                std::string code = func->code + funcs->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        };
        

function: 
        FUNC func_ident LPAREN arguments RPAREN LBRACE statements RBRACE 
                {
                        std::string func_name = $2;
                        CodeNode *args = $4;
                        CodeNode *stmts = $7;

                        std::string code = std::string("fn ") + func_name + std::string("\n");
                        code += args->code;
                        code += stmts->code;
                        code += std::string("endfunc\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                };
	
func_ident: 
        IDENT 
                {
                        std::string name = $1;
                        add_function_to_symbol_table(name);
                        $$ = $1;
                }

arguments: 
        %empty 
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;
                }
        | argument repeat_arguments 
                {
                        CodeNode *arg = $1;
                        CodeNode *args = $2;
                        std::string code = arg->code + args->code;
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

repeat_arguments: 
        %empty 
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;                        
                }
        | COMMA argument repeat_arguments 
                {
                        CodeNode *arg = $2;
                        CodeNode *args = $3;
                        std::string code = arg->code + args->code;

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

argument: 
        VAR IDENT 
                {
                        std::string value = $2;
                        Type t = Integer;
                        add_variable_to_symbol_table(value, t);

                        std::string code = std::string(". ") + value + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
	;

statements: 
        %empty /* epsilon */ 
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;                        
                }
        | statement statements 
                {
                        CodeNode *stmt = $1;
                        CodeNode *stmts = $2;
                        
                        CodeNode *node = new CodeNode;
                        node->code = stmt->code + stmts->code;
                        $$ = node;
                }
        ;

statement: 
        var_declaration 
                {
                        CodeNode *varDec = $1;

                        CodeNode *node = new CodeNode;
                        node->code = varDec->code;
                        $$ = node;
                }
        | arr_declaration 
                {
                        CodeNode *arrDec = $1;

                        CodeNode *node = new CodeNode;
                        node->code = arrDec->code;
                        $$ = node;
                }
        | print_statement 
                {
                        CodeNode *print = $1;

                        CodeNode *node = new CodeNode;
                        node->code = print->code;
                        $$ = node;
                }
        | input_statement 
                {
                        CodeNode *input = $1;

                        CodeNode *node = new CodeNode;
                        node->code = input->code;
                        $$ = node;
                }
        | if_statement 
                {

                }
        | while_statement 
                {
                        
                }
        | break_statement 
                {
                        
                }
        | continue_statement 
                {
                        
                }
        | function_call 
                {
                        
                }
        | return_statement 
                {
                        
                }
        | assign_var
                {

                }
        | assign_arr
                {

                }
        ;

var_declaration: 
        VAR IDENT assign_statement
                {
                        std::string ident = $2;
                        CodeNode *assignState = $3;
                        Type t = Integer;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(". ") + ident + std::string("\n");
                        if (assignState->code != "") {
                                code += std::string("= ") + ident + std::string(", ") + assignState->code;
                        }
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        
                        $$ = node;
                }
        ;

arr_declaration: 
        VAR IDENT LBRACK add_expression RBRACK assign_statement
                {
                        
                }

assign_statement:
        %empty
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;                        
                }
        | ASSIGN add_expression
                {
                        CodeNode *addexp = $2;

                        std::string code = addexp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

print_statement: 
        PRINT LPAREN binary_expression RPAREN  
                {
                        
                }

input_statement: 
        INPUT LPAREN NUMBER RPAREN 
                {
                        std::string value = $3;

                        std::string code = std::string(".< ") + value + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = value;
                        $$ = node;
                }

if_statement: 
        IF expression LBRACE statements RBRACE else_statement
                {

                }

else_statement:
        %empty
                {

                }
        | ELSE LBRACE statements RBRACE
                {

                }
        ;

while_statement: 
        WHILE LPAREN binary_expression RPAREN LBRACE statements RBRACE 
                {
                
                }

break_statement: 
        BREAK  
                {

                }

continue_statement: 
        CONT  
                {

                }

expression: 
        IDENT 
                {
                        std::string ident = $1;

                        CodeNode *node = new CodeNode;
                        node->name = ident;
                        $$ = node;

                }
        | NUMBER 
                {
                        std::string value = $1;

                        CodeNode *node = new CodeNode;
                        node->name = value;
                        $$ = node;
                }
        | LPAREN binary_expression RPAREN 
                {
                        CodeNode *exp = $2;


                        CodeNode *node = new CodeNode;
                        node->code = exp->code;
                        node->name = exp->name;
                        $$ = node;
                }
        | input_statement 
                {
                        CodeNode *inState = $1;

                        CodeNode *node = new CodeNode;
                        node->code = inState->code;
                        node->name = inState->name;
                        $$ = node;
                }
        | function_call 
                {
                
                }
        | IDENT LBRACK add_expression RBRACK
                {

                }

binary_expression: 
        add_expression
                {

                }
        | binary_expression EQ add_expression
                {

                }
        | binary_expression NEQ add_expression
                {

                }
        | binary_expression LT add_expression 
                {

                }
        | binary_expression LTE add_expression 
                {

                }
        | binary_expression GT add_expression 
                {

                }
        | binary_expression GTE add_expression 
                {

                }
        | binary_expression AND add_expression
                {

                }
        | binary_expression OR add_expression
                {

                }
        ;

add_expression:
        mult_expression
                {
                        CodeNode *multexp = $1;

                        CodeNode *node = new CodeNode;
                        node->code = multexp->code;
                        node->name = multexp->name;
                        $$ = node;
                }
        | add_expression PLUS mult_expression
                {
                        std::string temp = create_temp();

                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code;
                        node->code += decl_temp(temp) + std::string("+ ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | add_expression MINUS mult_expression
                {

                }
        ;

mult_expression:
        base_expression
                {
                        CodeNode *baseexp = $1;

                        CodeNode *node = new CodeNode;
                        node->code = baseexp->code;
                        node->name = baseexp->name;
                        $$ = node;
                }
        | mult_expression MULT base_expression 
                {

                }
        | mult_expression DIV base_expression 
                {

                }
        | mult_expression MOD base_expression
                {

                }
        ;

base_expression:
        expression
                {
                        CodeNode *exp = $1;
                        
                        CodeNode *node = new CodeNode;
                        node->code = exp->code;
                        node->name = exp->name;
                        $$ = node;
                }

assign_var:
        IDENT ASSIGN add_expression
                {
                        std::string ident = $1;
                        CodeNode *addexp = $3;

                        std::string code = addexp->code + std::string("= ") + ident + std::string(", ") + addexp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

assign_arr: 
        IDENT LBRACK add_expression RBRACK ASSIGN add_expression
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;           
                }

function_call: 
        IDENT LPAREN param RPAREN  
                {
                
                }

param: 
        %empty 
                {
                              
                }
        | binary_expression params
                {
                
                }

params:
        %empty
                {

                }
        | COMMA binary_expression params
                {

                }

return_statement: 
        RETURN add_expression
                {
                        
                }



%%


void yyerror(const char* s) {
	fprintf(stderr, "Error %s at line %d, column %d\n", s, yylineno, curr_col);
} 

int main(int argc, char** argv) {
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