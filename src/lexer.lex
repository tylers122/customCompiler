%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

int curr_line = 1;
int curr_col = 1;

extern char *identToken;
extern int numberToken;
%}

/*
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
COMMA [,]
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
*/

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



[0-9]+    { curr_col += strlen(yytext);  return NUMBER;}
[A-Za-z]+    {
                if(strcmp(yytext, "print") == 0) {
                    curr_col += strlen(yytext);
                    return PRINT;
                } else if(strcmp(yytext, "input") == 0) {
                    curr_col += strlen(yytext);
                    return INPUT;
                } else if(strcmp(yytext, "while") == 0) {
                    curr_col += strlen(yytext);
                    return WHILE;
                } else if(strcmp(yytext, "for") == 0) {
                    curr_col += strlen(yytext);
                    return FOR;
                } else if(strcmp(yytext, "break") == 0) {
                    curr_col += strlen(yytext);
                    return BREAK;
                } else if(strcmp(yytext, "continue") == 0) {
                    curr_col += strlen(yytext);
                    return CONT;
                } else if(strcmp(yytext, "if") == 0) {
                    curr_col += strlen(yytext);
                    return IF;
                } else if(strcmp(yytext, "else") == 0) {
                    curr_col += strlen(yytext);
                    return ELSE;
                } else if(strcmp(yytext, "import") == 0) {
                    curr_col += strlen(yytext);
                    return IMPORT;
                } else if(strcmp(yytext, "export") == 0) {
                    curr_col += strlen(yytext);
                    return EXPORT;
                } else if(strcmp(yytext, "fn") == 0) {
                    curr_col += strlen(yytext);
                    return FUNC;
                } else if(strcmp(yytext, "return") == 0) {
                    curr_col += strlen(yytext);
                    return RETURN;
                } else if(strcmp(yytext, "var") == 0) {
                    curr_col += strlen(yytext);
                    return VAR;
                } else {
                    curr_col += strlen(yytext);
                    return IDENT;
                }
            }
[+]     {curr_col += strlen(yytext); return PLUS;}
[-]     {curr_col += strlen(yytext); return MINUS;}
[*]     {curr_col += strlen(yytext); return MULT;}
[/]     {curr_col += strlen(yytext); return DIV;}
[%]     {curr_col += strlen(yytext); return MOD;}
[=]     {curr_col += strlen(yytext); return ASSIGN;}
(\+=)   {curr_col += strlen(yytext); return PLUS_ASSIGN;}
(-=)    {curr_col += strlen(yytext); return MINUS_ASSIGN;}
(\*=)   {curr_col += strlen(yytext); return MULT_ASSIGN;}
[/][=]  {curr_col += strlen(yytext); return DIV_ASSIGN;}
(%=)    {curr_col += strlen(yytext); return MOD_ASSIGN;}
(\+\+)  {curr_col += strlen(yytext); return INCREMENT;}
(--)    {curr_col += strlen(yytext); return DECREMENT;}
(==)    {curr_col += strlen(yytext); return EQ;}
(!=)    {curr_col += strlen(yytext); return NEQ;}
[<]     {curr_col += strlen(yytext); return LT;}
[>]     {curr_col += strlen(yytext); return GT;}
(<=)    {curr_col += strlen(yytext); return LTE;}
(>=)    {curr_col += strlen(yytext); return GTE;}
(&&)    {curr_col += strlen(yytext); return AND;}
(\|\|)  {curr_col += strlen(yytext); return OR;}
[!]     {curr_col += strlen(yytext); return NOT;}
[(]     {curr_col += strlen(yytext); return LPAREN;}
[)]     {curr_col += strlen(yytext); return RPAREN;}
[{]     {curr_col += strlen(yytext); return LBRACE;}
[}]     {curr_col += strlen(yytext); return RBRACE;}
[\[]    {curr_col += strlen(yytext); return LBRACK;}
[\]]    {curr_col += strlen(yytext); return RBRACK;}
[:]     {curr_col += strlen(yytext); return COLON;}
[;]     {curr_col += strlen(yytext); return SEMICOLON;}
[,]     {curr_col += strlen(yytext); return COMMA;}


[_~@$^]+[A-Za-z]+   {
    curr_col++;
    fprintf(stderr, "Error at line %d, column %d: Token cannot start with underscore: %s\n", yylineno + 1, curr_col, yytext);
    return INVALID_IDENT;
}
.               {
    curr_col++;
    fprintf(stderr, "Error at line %d, column %d: UNRECOGNIZED PATTERN: %s\n", yylineno + 1, curr_col, yytext);
    return INVALID_TOKEN;
}
\n              {
    curr_line++;
    curr_col = 1;
}
         
%%

int yyinput(char *buf, int max_size)
{
    return fread(buf, 1, max_size, stdin);
}

/*
int main(void) {

    printf("Ctrl + D to quit\n");
    yylex();

    return 0;
}
*/
