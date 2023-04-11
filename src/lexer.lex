%{
#include <stdio.h>

%}

DIGIT [0-9]
ALPHA [A-Za-z]
PLUS [+]
MINUS [-]
MULT [*]
DIV [/]
MOD [%]
ASSIGN [=]
%%
{DIGIT}+    { printf("NUMBER: %s\n", yytext); }
{ALPHA}+    { printf("TOKEN: %s\n", yytext); }
{PLUS}      { printf("PLUS: %s\n", yytext); }
{MINUS}     { printf("MINUS: %s\n", yytext); }
{MULT}      { printf("MULT: %s\n", yytext); }
{DIV}       { printf("DIV: %s\n", yytext); }
{MOD}       { printf("MOD: %s\n", yytext); }
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); }
.
%%

int main(void) {

    //printf(), use %s to print string, use %d to print num
    //print("Hello, my name is %s\n", Tyler)
    //print("%d + %d = %d", 1, 1, 2)

    printf("Ctrl + D to quit\n");
    yylex();

}
