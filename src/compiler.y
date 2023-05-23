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
%type  <node>   var_declaration
%type  <node>   arr_declaration
%type  <node>   arr_call
%type  <node>   assign_statement
%type  <node>   inc_dec_statement
%type  <node>   print_statement
%type  <node>   input_statement
%type  <node>   if_statement
%type  <node>   while_statement
%type  <node>   for_statement
%type  <node>   break_statement
%type  <node>   continue_statement
%type  <node>   function_call
%type  <node>   return_statement
%type  <node>   binary_expression


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
        | arr_call 
                {
                        CodeNode *arrCall = $1;

                        CodeNode *node = new CodeNode;
                        node->code = arrCall->code;
                        $$ = node;
                }
        | assign_statement 
                {
                        CodeNode *assign = $1;

                        CodeNode *node = new CodeNode;
                        node->code = assign->code;
                        $$ = node;
                }
        | inc_dec_statement 
                {
                        CodeNode *incDec = $1;

                        CodeNode *node = new CodeNode;
                        node->code = incDec->code;
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
                        CodeNode *ifState = $1;

                        CodeNode *node = new CodeNode;
                        node->code = ifState->code;
                        $$ = node;
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
                        std::string ident = $2;
                        Type t = Integer;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(". ") + ident + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

        | VAR IDENT ASSIGN NUMBER  
                {
                        std::string ident = $2;
                        Type t = Integer;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(". ") + ident + std::string("\n");

                        std::string value = $4;

                        code += std::string("= ") + ident + std::string(", ") + value + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        ;

arr_declaration: 
        VAR IDENT LBRACK NUMBER RBRACK 
                {
                        std::string ident = $2;
                        std::string value = $4;
                        Type t = Array;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(".[] ") + ident + std::string(", ") + value + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

arr_call:       
        IDENT LBRACK NUMBER RBRACK 
                {
                        std::string ident = $1;
                        std::string index = $3;

                        std::string code = std::string("[]= ") + ident + std::string(", ") + index + std::string(", ");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

//CALL ARRAY DOESN'T WORK, MAKE ANOTHER STATE VAR THAT SPLITS TO IDENT OR ARR
assign_statement: 
        IDENT ASSIGN expression         
                {
                        std::string ident = $1;
                        CodeNode *exp = $3;
                        
                        std::string code = exp->code;
                        
                        code += std::string("= ") + ident + std::string(", ") + exp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                        
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
                        CodeNode *arrCall = $1;
                        CodeNode *exp = $3;
                        
                        
                        std::string code = exp->code;

                        code += arrCall->code;
                        
                        code += exp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
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
                        std::string ident = $3;

                        std::string code = std::string(".> ") + ident + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        | PRINT LPAREN NUMBER RPAREN  
                {
                        std::string value = $3;

                        std::string code = std::string(".> ") + value + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        | PRINT LPAREN expression RPAREN 
                {
                        CodeNode *exp = $3;

                        std::string code = exp->code;

                        code += std::string(".> ") + exp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        | PRINT LPAREN arr_call RPAREN 
                {
                        //fix this
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
                        std::string ident = $1;

                        std::string name = ident;

                        CodeNode *node = new CodeNode;
                        node->name = name;
                        $$ = node;

                }
        | NUMBER 
                {
                        std::string value = $1;

                        std::string name = value;

                        CodeNode *node = new CodeNode;
                        node->name = name;
                        $$ = node;
                }
        | LPAREN expression RPAREN 
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
        | arr_call 
                {
                
                }
        | function_call 
                {
                
                }
        | binary_expression 
                {
                        CodeNode *binExp = $1;

                        CodeNode *node = new CodeNode;
                        node->code = binExp->code;
                        node->name = binExp->name;
                        $$ = node;
                }

binary_expression: 
        expression PLUS expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("+ ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression MINUS expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("- ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression MULT expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("* ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression DIV expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("/ ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression MOD expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("% ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression EQ expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("== ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression NEQ expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("!= ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression LT expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("< ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression LTE expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("<= ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression GT expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("> ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression GTE expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string(">= ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression AND expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("&& ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }
        | expression OR expression 
                {
                        CodeNode *exp1 = $1;
                        CodeNode *exp2 = $3;
                        std::string temp = create_temp();

                        std::string code = decl_temp(temp); 
                        
                        code += std::string("|| ") + temp + std::string(", ") + exp1->name + std::string(", ") + exp2->name + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
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