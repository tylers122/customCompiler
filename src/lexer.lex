%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap
%option yylineno

DIGIT [0-9]
ALPHA [A-Za-z]
PLUS [+]
MINUS [-]
MULT [*]
DIV [/]
MOD [%]
ASSIGN [=]
PLUS_ASSIGN (\\+=)
MINUS_ASSIGN (-=)
MULT_ASSIGN (\*=)
DIV_ASSIGN (\\/=)
MOD_ASSIGN (%=)
INCREMENT (\\+\\+)
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

[ \t\r\n]+  { /* ignore whitespaces */ }
"//"(.*)    { /* ignore single-line comments */ }
"/*"        { /* ignore multi-line comments */ int c = yyinput(); \
                                              while (c != '*' || yyinput() != '/') c = yyinput(); }



{DIGIT}+    { printf("NUMBER: %s\n", yytext); }
{ALPHA}+    {
                if(strcmp(yytext, "print") == 0)
                    printf("PRINT: %s\n", yytext);
                else if(strcmp(yytext, "input") == 0)
                    printf("INPUT: %s\n", yytext);
                else if(strcmp(yytext, "while") == 0)
                    printf("WHILE: %s\n", yytext);
                else if(strcmp(yytext, "for") == 0)
                    printf("FOR: %s\n", yytext);
                else if(strcmp(yytext, "break") == 0)
                    printf("BREAK: %s\n", yytext);
                else if(strcmp(yytext, "continue") == 0)
                    printf("CONT: %s\n", yytext);
                else if(strcmp(yytext, "if") == 0)
                    printf("IF: %s\n", yytext);
                else if(strcmp(yytext, "else") == 0)
                    printf("ELSE: %s\n", yytext);
                else if(strcmp(yytext, "import") == 0)
                    printf("IMPORT: %s\n", yytext);
                else if(strcmp(yytext, "export") == 0)
                    printf("EXPORT: %s\n", yytext);
                else if(strcmp(yytext, "fn") == 0)
                    printf("FUNC: %s\n", yytext);
                else if(strcmp(yytext, "return") == 0)
                    printf("RETURN: %s\n", yytext);
                else if(strcmp(yytext, "var") == 0)
                    printf("VAR: %s\n", yytext);
                else
                    printf("TOKEN: %s\n", yytext);
            }
{PLUS}      { printf("PLUS: %s\n", yytext); }
{MINUS}     { printf("MINUS: %s\n", yytext); }
{MULT}      { printf("MULT: %s\n", yytext); }
{DIV}       { printf("DIV: %s\n", yytext); }
{MOD}       { printf("MOD: %s\n", yytext); }
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); }
{PLUS_ASSIGN} { printf("PLUS_ASSIGN: %s\n", yytext); }
{MINUS_ASSIGN} { printf("MINUS_ASSIGN: %s\n", yytext); }
{MULT_ASSIGN} { printf("MULT_ASSIGN: %s\n", yytext); }
{DIV_ASSIGN} { printf("DIV_ASSIGN: %s\n", yytext); }
{MOD_ASSIGN} { printf("MOD_ASSIGN: %s\n", yytext); }
{INCREMENT} { printf("INCREMENT: %s\n", yytext); }
{DECREMENT} { printf("DECREMENT: %s\n", yytext); }
{EQ} { printf("EQ: %s\n", yytext); }
{NEQ} { printf("NEQ: %s\n", yytext); }
{LT} { printf("LT: %s\n", yytext); }
{GT} { printf("GT: %s\n", yytext); }
{LTE} { printf("LTE: %s\n", yytext); }
{GTE} { printf("GTE: %s\n", yytext); }
{AND} { printf("AND: %s\n", yytext); }
{OR} { printf("OR: %s\n", yytext); }
{NOT} { printf("NOT: %s\n", yytext); }
{LPAREN} { printf("LPAREN: %s\n", yytext); }
{RPAREN} { printf("RPAREN: %s\n", yytext); }
{LBRACE} { printf("LBRACE: %s\n", yytext); }
{RBRACE} { printf("RBRACE: %s\n", yytext); }
{LBRACK} { printf("LBRACK: %s\n", yytext); }
{RBRACK} { printf("RBRACK: %s\n", yytext); }
{COLON} { printf("COLON: %s\n", yytext); }

.       { printf("UNRECOGNIZED PATTERN: %s\n", yytext); }

%%

int main(void) {

    printf("Ctrl + D to quit\n");
    yylex();

    return 0;
}
