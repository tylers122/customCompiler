%{
#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>
#include <sstream>
#include <stack>

extern FILE* yyin;
extern int yylex(void);
extern int yylineno;
extern int curr_col;
extern int curr_line;
void yyerror(const char* s);

char *identToken;
int numberToken;
int  count_names = 0;
bool main_present = false;
int inloop = -1;
std::stack<int> loopstack;

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

bool find(std::string &value, Type t) {
  Function *f = get_function();
  for(int i=0; i < f->arguments.size(); i++) {
    Symbol *s = &f->arguments[i];
    if (s->name == value && s->type == t) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value;
  if(value == "main")
  	main_present = true;
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->arguments.push_back(s);
}

std::string typeToString(Type t) {
  switch (t) {
    case Integer:
      return "Integer";
    case Array:
      return "Array";
  }
  return "Unknown";
}

void print_symbol_table() {
  printf("symbol table:\n");
  printf("--------------------\n");
  for (int i = 0; i < symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for (int j = 0; j < symbol_table[i].arguments.size(); j++) {
      printf("  locals: %s, type: %s\n", symbol_table[i].arguments[j].name.c_str(),
             typeToString(symbol_table[i].arguments[j].type).c_str());
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


std::string create_if() {
        static int if_num = 0;
        std::ostringstream ss;
        ss << if_num;
        std::string t = std::string("if_true") + ss.str();
        if_num++;
        return t;
}

std::string create_else() {
        static int num = 0;
        std::ostringstream ss;
        ss << num;
        std::string t = std::string("else") + ss.str();
        num++;
        return t;
}

std::string decl_label(std::string &temp) {
        return std::string(": ") + temp + std::string("\n");
}

std::string create_loop() {
        static int num = 0;
        std::ostringstream ss;
        ss << num;
        std::string t = std::string("beginloop") + ss.str();
        num++;
        loopstack.push(num);
        return t;
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
                std::string code = func->code + std::string("\n") + funcs->code;

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

                        std::string code = std::string("func ") + func_name + std::string("\n");
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

                        std::string varAssign = "";
                        std::string code = arg->code + args->code;
                        
                        std::stringstream ss(code);
                        std::ostringstream intConvert;
                        std::string currLine;
                        int currPar = 0;

                        while (std::getline(ss, currLine)) {
                                std::string currVar;
                                
                                if (currLine.substr(0, 2) == ". ") {
                                        currVar = currLine.substr(2);
                                }
                                intConvert << currPar++;
                                varAssign += "= " + currVar + ", " + "$" + intConvert.str() + "\n";
                                intConvert.str("");
                                intConvert.clear();
                        }

                        CodeNode *node = new CodeNode;
                        node->code = code + varAssign;
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
                {       CodeNode *ifState = $1;

                        CodeNode *node = new CodeNode;
                        node->code = ifState->code;
                        $$ = node;
                }
        | while_statement 
                {
                        CodeNode *whileState = $1;

                        CodeNode *node = new CodeNode;
                        node->code = whileState->code;
                        $$ = node;
                }
        | BREAK 
                {
                        std::string code = std::string(":= endloop");
                        if(loopstack.empty()) {
                                yyerror("break is not inside loop statement");
                                exit(10);
                        } else {
                                static int num = loopstack.top();
                                std::ostringstream ss;
                                ss << num;
                                code += ss.str() + std::string("\n");
                        }

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        | CONT
                {
                        std::string code = std::string(":= beginloop");
                        if(loopstack.empty()) {
                                yyerror("continue is not inside loop statement");
                                exit(9);
                        } else {
                                static int num = loopstack.top();
                                std::ostringstream ss;
                                ss << num;
                                code += ss.str() + std::string("\n");
                        }

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
        | function_call 
                {
                        CodeNode *funcCall = $1;
                        CodeNode *node = new CodeNode;
                        node->code = funcCall->code;
                        $$ = node;
                }
        | return_statement 
                {
                        CodeNode *returnStmt = $1;
                        
                        CodeNode *node = new CodeNode;
                        node->code = returnStmt->code;
                        $$ = node;
                }
        | assign_var
                {
                        CodeNode *assignVar = $1;
                        
                        CodeNode *node = new CodeNode;
                        node->code = assignVar->code;
                        $$ = node;
                }
        | assign_arr
                {
                        CodeNode *assignArr = $1;
                        
                        CodeNode *node = new CodeNode;
                        node->code = assignArr->code;
                        $$ = node;
                }
        ;

var_declaration: 
        VAR IDENT assign_statement
                {
                        std::string ident = $2;
                        CodeNode *assignState = $3;
                        Type t = Integer;
			if(find(ident)) {
				yyerror(("Variable already defined: " + ident).c_str());
			}
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
        VAR IDENT LBRACK NUMBER RBRACK assign_statement
                {
                        std::string ident = $2;
                        std::string size = $4;
                        CodeNode *assignState = $6;
                        if(find(ident)){
                                yyerror(("Array variable already defined: " + ident).c_str());
                        }
                        int arraySize; 
                        std::stringstream ss(size);
                        if (!(ss >> arraySize) || arraySize <= 0) {
                                yyerror(("Invalid array size: " + ident).c_str());
                        }
                        Type t = Array;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(".[] ") + ident + std::string(", ") + size + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
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
                        CodeNode *binexp = $3;
                        std::string code = binexp->code + std::string(".> ") + binexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
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
                        CodeNode *exp = $2;
                        CodeNode *state = $4;
                        CodeNode *elseState = $6;

                        CodeNode *node = new CodeNode;

                        std::string label = create_if();
                        std::string code = exp->code;
                        code += std::string("?:= ") + label + std::string(", ") + exp->name + std::string("\n");
                        code += elseState->name; 
                        code += std::string(": ") + label + std::string("\n");
                        code += state->code;

                        std::string temp = std::string("endif") + label.substr(label.find("e") + 1, label.at(label.size() - 1));
                        code += std::string(":= ") + temp + std::string("\n");
                        code += elseState->code; 
                        code += std::string(": ") + temp + std::string("\n");
                        
                        node->code = code;
                        $$ = node;
                }

else_statement:
        %empty
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;
                }
        | ELSE LBRACE statements RBRACE
                {
                        CodeNode *node = new CodeNode;
                        std::string n = create_else();
                        node->name = std::string(":= ") + n + std::string("\n");

                        CodeNode *state = $3;
                        node->code = decl_label(n) + state->code;
                        $$ = node;
                }
        ;


while_statement: 
        WHILE LPAREN binary_expression RPAREN LBRACE statements RBRACE 
                {
                        CodeNode *exp = $3;
                        CodeNode *state = $6;
                        CodeNode *node = new CodeNode;

                        std::string loopName = create_loop();
                        std::string integer = loopName.substr(loopName.find("p") + 1, loopName.at(loopName.size() - 1));

                        std::string code = std::string(": ") + loopName + std::string("\n") + exp->code;
                        code += std::string("?:= loopbody") + integer + std::string(", ") + exp->name + std::string("\n");
                        code += std::string(":= endloop") + integer + std::string("\n");
                        code += std::string(": loopbody") + integer + std::string("\n");
                        code += state->code;
                        code += std::string(":= ") + loopName + std::string("\n");
                        code += std::string(": endloop") + integer + std::string("\n");

                        loopstack.pop();
                        node->code = code;
                        $$ = node;
                }

expression: 
        IDENT 
                {
			std::string i = $1;
                	if(!find(i)) {
                		yyerror(("Variable previously not defined" + i).c_str());
                	}
			if(find(i, Array)) {
				yyerror(("Integer variable used as array: " + i).c_str());
			}
                        CodeNode *node = new CodeNode;
                        node->name = i;
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
                        CodeNode *binexp = $2;
                        CodeNode *node = new CodeNode;
                        node->code = binexp->code;
                        node->name = binexp->name;
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
                        CodeNode *func = $1;
                        CodeNode *node = new CodeNode;
                        node->code = func->code;
                        node->name = func->name;
                        $$ = node;
                }
        | IDENT LBRACK add_expression RBRACK
                {
                        std::string temp = create_temp();
                        std::string ident = $1;
			if(!find(ident)) {
				yyerror(("Array not defined: " + ident).c_str());
			}
			if(find(ident, Integer)) {
				yyerror(("Brackets don't apply to Integer variables: " + ident).c_str());			
			}
                        CodeNode *addexp = $3;
                        std::string code = decl_temp(temp) + std::string ("=[] ") + temp + std::string(", ") + ident + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }

binary_expression: 
        add_expression
                {
                        CodeNode *addexp = $1;
                        CodeNode *node = new CodeNode;
                        node->code = addexp->code;
                        node->name = addexp->name;
                        $$ = node;
                }
        | binary_expression EQ add_expression
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("== ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression NEQ add_expression
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("!= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression LT add_expression 
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("< ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression LTE add_expression 
                {
                        std::string temp = create_temp();

                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("<= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression GT add_expression 
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("> ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression GTE add_expression 
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string(">= ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression AND add_expression
                {
                        std::string temp = create_temp();

                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("&& ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | binary_expression OR add_expression
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code + decl_temp(temp);
                        node->code += std::string("|| ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
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
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code;
                        node->code += decl_temp(temp) + std::string("- ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
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
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code;
                        node->code += decl_temp(temp) + std::string("* ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | mult_expression DIV base_expression 
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code;
                        node->code += decl_temp(temp) + std::string("/ ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
                }
        | mult_expression MOD base_expression
                {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = $1->code + $3->code;
                        node->code += decl_temp(temp) + std::string("% ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                        node->name = temp;
                        $$ = node;
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
                        if(!find(ident)) {
                        	yyerror(("Variable was not previously declared: " + ident).c_str());
                        }
                        if(find(ident, Array)){
                                yyerror(("Array variable used as integer variable: " + ident).c_str());
                        }
                        std::string code = addexp->code + std::string("= ") + ident + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

assign_arr: 
        IDENT LBRACK add_expression RBRACK ASSIGN add_expression
                {
                        std::string ident = $1;
                        CodeNode *index = $3;
                        CodeNode *addexp = $6;
                        if(!find(ident)) {
                        	yyerror(("Array was not previously declared:" + ident).c_str());
                        }
                        if(find(ident, Integer)){
                                yyerror(("Integer variable used as array variable: " + ident).c_str());
                        }
                        std::string code = index->code + addexp->code + std::string("[]= ") + ident + std::string(", ") + index->name + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

function_call: 
        IDENT LPAREN param RPAREN  
                {
                        std::string temp = create_temp();
                        std::string ident = $1;
                        CodeNode *param = $3;
                        bool exists = false;
                        for (std::size_t i = 0; i < symbol_table.size(); ++i) {
                                if (symbol_table[i].name == ident) {
                                        exists = true;
                                        break;
                                }
                        }
                        if(!exists){
                                yyerror(("Array was not previously declared:" + ident).c_str());
                        }
                        std::string code = param->code + decl_temp(temp);
                        code += std::string("call ") + ident + std::string(", ") + temp + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        $$ = node;
                }

param: 
        %empty 
                {
                       CodeNode *node = new CodeNode;
                       $$ = node;       
                }
        | add_expression params
                {
                        CodeNode *addexp = $1;
                        CodeNode *params = $2;
                        std::string code = std::string("param ") + addexp->name + std::string("\n");
                        code += params->code;
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

params:
        %empty
                {
                        CodeNode *node = new CodeNode;
                        $$ = node;  
                }
        | COMMA add_expression params
                {
                        CodeNode *addexp = $2;
                        std::string code = addexp->code;
                        code += std::string("param ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }

return_statement: 
        RETURN add_expression
                {
                        CodeNode *ret = $2;
                        std::string code = ret->code + std::string("ret ") + ret->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        $$ = node;
                }
%%
void yyerror(const char* s) {
	fprintf(stderr, "Error at line %d, column %d: %s\n", curr_line, curr_col, s);
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
        
        if (!main_present) {
		yyerror("Main not defined");
	}
}
