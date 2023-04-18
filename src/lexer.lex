%{
#include <stdio.h>
#include <string.h>

int curr_line = 1;
int curr_col = 1;
%}

%option yylineno
DIGIT [0-9]
ALPHA [A-Za-z]
INVALID_ALPHA [_]+[A-Za-z]+
PLUS [+]
MINUS [-]
MULT [*]
DIV [/]
MOD [%]
ASSIGN [=]
PLUS_ASSIGN (\+=)
MINUS_ASSIGN (-=)
MULT_ASSIGN (\*=)
DIV_ASSIGN [/][=]
MOD_ASSIGN (%=)
INCREMENT (\+\+)
DECREMENT (--)
EQ (==)
NEQ (!=)
LT [<]
GT [>]
LTE (<=)
GTE (>=)
AND (&&)
OR (\|\|)
NOT [!]
LPAREN [(]
RPAREN [)]
LBRACE [{]
RBRACE [}]
LBRACK [\[]
RBRACK [\]]
COLON [:]
PRINT (print)
INPUT (input)
WHILE (while)
FOR (for)
BREAK (break)
CONT (continue)
IF (if)
ELSE (else)
IMPORT (import)
EXPORT (export)
FUNC (fn)
RETURN (return)
VAR (var)

%%

[ \t\r]+  { curr_col += strlen(yytext); /* ignore whitespaces */ }
"//"(.*)    { /* ignore single-line comments */ yymore(); }
"/*"        { /* ignore multi-line comments */
                  int c;
                  yymore();
                  while ((c = input()) != EOF) {
                      yymore();
                      if (c == '*') {
                          if ((c = input()) == '/') {
                              break;
                          } else {
                              unput(c);
                          }
                      }
                  }
              }



{DIGIT}+    { printf("NUMBER: %s\n", yytext); curr_col += strlen(yytext);}
{ALPHA}+    {
                if(strcmp(yytext, "print") == 0) {
                    printf("PRINT: %s\n", yytext); 
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "input") == 0) {
                    printf("INPUT: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "while") == 0) {
                    printf("WHILE: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "for") == 0) {
                    printf("FOR: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "break") == 0) {
                    printf("BREAK: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "continue") == 0) {
                    printf("CONT: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "if") == 0) {
                    printf("IF: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "else") == 0) {
                    printf("ELSE: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "import") == 0) {
                    printf("IMPORT: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "export") == 0) {
                    printf("EXPORT: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "fn") == 0) {
                    printf("FUNC: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "return") == 0) {
                    printf("RETURN: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else if(strcmp(yytext, "var") == 0) {
                    printf("VAR: %s\n", yytext);
                    curr_col += strlen(yytext);
                } else {
                    printf("TOKEN: %s\n", yytext);
                    curr_col += strlen(yytext);
                }
            }
{PLUS}      { printf("PLUS: %s\n", yytext); curr_col += strlen(yytext);}
{MINUS}     { printf("MINUS: %s\n", yytext); curr_col += strlen(yytext);}
{MULT}      { printf("MULT: %s\n", yytext); curr_col += strlen(yytext);}
{DIV}       { printf("DIV: %s\n", yytext); curr_col += strlen(yytext);}
{MOD}       { printf("MOD: %s\n", yytext); curr_col += strlen(yytext);}
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{PLUS_ASSIGN} { printf("PLUS_ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{MINUS_ASSIGN} { printf("MINUS_ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{MULT_ASSIGN} { printf("MULT_ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{DIV_ASSIGN} { printf("DIV_ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{MOD_ASSIGN} { printf("MOD_ASSIGN: %s\n", yytext); curr_col += strlen(yytext);}
{INCREMENT} { printf("INCREMENT: %s\n", yytext); curr_col += strlen(yytext);}
{DECREMENT} { printf("DECREMENT: %s\n", yytext); curr_col += strlen(yytext);}
{EQ} { printf("EQ: %s\n", yytext); curr_col += strlen(yytext);}
{NEQ} { printf("NEQ: %s\n", yytext); curr_col += strlen(yytext);}
{LT} { printf("LT: %s\n", yytext); curr_col += strlen(yytext);}
{GT} { printf("GT: %s\n", yytext); curr_col += strlen(yytext);}
{LTE} { printf("LTE: %s\n", yytext); curr_col += strlen(yytext);}
{GTE} { printf("GTE: %s\n", yytext); curr_col += strlen(yytext);}
{AND} { printf("AND: %s\n", yytext); curr_col += strlen(yytext);}
{OR} { printf("OR: %s\n", yytext); curr_col += strlen(yytext);}
{NOT} { printf("NOT: %s\n", yytext); curr_col += strlen(yytext);}
{LPAREN} { printf("LPAREN: %s\n", yytext); curr_col += strlen(yytext);}
{RPAREN} { printf("RPAREN: %s\n", yytext); curr_col += strlen(yytext);}
{LBRACE} { printf("LBRACE: %s\n", yytext); curr_col += strlen(yytext);}
{RBRACE} { printf("RBRACE: %s\n", yytext); curr_col += strlen(yytext);}
{LBRACK} { printf("LBRACK: %s\n", yytext); curr_col += strlen(yytext);}
{RBRACK} { printf("RBRACK: %s\n", yytext); curr_col += strlen(yytext);}
{COLON} { printf("COLON: %s\n", yytext); curr_col += strlen(yytext);}
{INVALID_ALPHA} {printf("Error at line %d, column %d: Token cannot start with underscore: %s\n", yylineno, curr_col, yytext); curr_col++;}


.       { printf("Error at line %d, column %d: UNRECOGNIZED PATTERN: %s\n", yylineno, curr_col, yytext); curr_col++;}
\n      { curr_line++; curr_col = 1;}
         
%%

int yyinput(char *buf, int max_size)
{
    return fread(buf, 1, max_size, stdin);
}

int main(void) {

    printf("Ctrl + D to quit\n");
    yylex();

    return 0;
}
