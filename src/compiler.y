%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <string>

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
%token <op_val> NUMBER
%token <op_val> IDENT
%type  <op_val> func_ident
%type  <node>   functions
%type  <node>   function
%type  <node>   statements
%type  <node>   statement
%type  <node>   arguments
%type  <node>   argument
%type  <node>   repeat_arguments
%type  <node>   expression


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
                }

repeat_arguments: 
        %empty 
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;                        
                }
        | COMMA argument repeat_arguments 
                {
                        
                }

argument: 
        VAR IDENT 
                {
                        
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
                        
                }
        ;

statement: 
        var_declaration 
                {
                        
                }
        | arr_declaration 
                {
                        
                }
        | arr_call 
                {
                        
                }
        | assign_statement 
                {
                        
                }
        | inc_dec_statement 
                {
                        
                }
        | print_statement 
                {
                        
                }
        | input_statement 
                {
                        
                }
        | if_statement 
                {
                        
                }
        | while_statement 
                {
                        
                }
        | for_statement 
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
        ;

var_declaration: 
        VAR IDENT  
                {
                        
                }
        | VAR IDENT ASSIGN NUMBER  
                {
                        //std::string value = $1;
                        //Type t = Integer;
                        //add_variable_to_symbol_table(value, t);
                }
        ;

arr_declaration: 
        VAR IDENT LBRACK NUMBER RBRACK 
                {
                        
                }

arr_call:       
        IDENT LBRACK NUMBER RBRACK 
                {
                        
                }

assign_statement: 
        IDENT ASSIGN expression         
                {
                        
                }
        | IDENT PLUS_ASSIGN expression  
                {
                        
                }
        | IDENT MINUS_ASSIGN expression  
                {
                        
                }
        | IDENT MULT_ASSIGN expression  
                {
                        
                }
        | IDENT DIV_ASSIGN expression  
                {
                        
                }
        | IDENT MOD_ASSIGN expression  
                {
                        
                }
        | arr_call ASSIGN expression  
                {
                
                }
        | arr_call PLUS_ASSIGN expression  
                {
                        
                }
        | arr_call MINUS_ASSIGN expression  
                {
                        
                }
        | arr_call MULT_ASSIGN expression  
                {
                        
                }
        | arr_call DIV_ASSIGN expression  
                {
                        
                }
        | arr_call MOD_ASSIGN expression  
                {
                        
                }

inc_dec_statement: 
        IDENT INCREMENT  
                {
                        
                }
        | IDENT DECREMENT  
                {
                        
                }

print_statement: 
        PRINT LPAREN IDENT RPAREN  
                {
                        
                }
        | PRINT LPAREN NUMBER RPAREN  
                {
                        
                }
        | PRINT LPAREN expression RPAREN 
                {
                        
                }
        | PRINT LPAREN arr_call RPAREN 
                {
                        
                }

input_statement: 
        INPUT LPAREN RPAREN 
                {

                }

if_statement: 
        IF LPAREN expression RPAREN LBRACE statements RBRACE 
                {
                
                }
        | IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE 
                {
                
                }
        ;

while_statement: 
        WHILE LPAREN expression RPAREN LBRACE statements RBRACE 
                {
                
                }

for_statement: 
        FOR LPAREN var_declaration expression  inc_dec_statement RPAREN LBRACE statements RBRACE 
                {

                }
        | FOR LPAREN assign_statement expression  inc_dec_statement RPAREN LBRACE statements RBRACE 
                {

                }
        | FOR LPAREN IDENT  expression  inc_dec_statement RPAREN LBRACE statements RBRACE 
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
                
                }
        | NUMBER 
                {
                
                }
        | LPAREN expression RPAREN 
                {
                
                }
        | input_statement 
                {

                }
        | arr_call 
                {
                
                }
        | function_call 
                {
                
                }
        | binary_expression 
                {
                
                }

binary_expression: 
        expression PLUS expression 
                {
                
                }
        | expression MINUS expression 
                {
                
                }
        | expression MULT expression 
                {
                
                }
        | expression DIV expression 
                {
                
                }
        | expression MOD expression 
                {
                
                }
        | expression EQ expression 
                {
                
                }
        | expression NEQ expression 
                {
                
                }
        | expression LT expression 
                {
                
                }
        | expression LTE expression 
                {
                
                }
        | expression GT expression 
                {
                
                }
        | expression GTE expression 
                {
                
                }
        | expression AND expression 
                {
                
                }
        | expression OR expression 
                {
                
                }
        ;

/* FUNCTION CALL ASSIGNMENT NEEDS DOUBLE ; */
function_call: 
        IDENT LPAREN args RPAREN  
                {
                
                }

args: 
        %empty 
                {
                              
                }
        | arg repeat_args 
                {
                
                }

repeat_args: 
        %empty 
                {
                            
                }
        | COMMA arg repeat_args 
                {
                
                }

arg: 
        expression 
                {
                
                }

return_statement: 
        RETURN expression 
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