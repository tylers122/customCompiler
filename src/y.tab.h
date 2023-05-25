/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INVALID_IDENT = 258,
    INVALID_TOKEN = 259,
    PRINT = 260,
    INPUT = 261,
    WHILE = 262,
    FOR = 263,
    BREAK = 264,
    CONT = 265,
    IF = 266,
    ELSE = 267,
    IMPORT = 268,
    EXPORT = 269,
    FUNC = 270,
    RETURN = 271,
    VAR = 272,
    PLUS = 273,
    MINUS = 274,
    MULT = 275,
    DIV = 276,
    MOD = 277,
    ASSIGN = 278,
    PLUS_ASSIGN = 279,
    MINUS_ASSIGN = 280,
    MULT_ASSIGN = 281,
    DIV_ASSIGN = 282,
    MOD_ASSIGN = 283,
    INCREMENT = 284,
    DECREMENT = 285,
    EQ = 286,
    NEQ = 287,
    LT = 288,
    GT = 289,
    LTE = 290,
    GTE = 291,
    AND = 292,
    OR = 293,
    NOT = 294,
    LPAREN = 295,
    RPAREN = 296,
    LBRACE = 297,
    RBRACE = 298,
    LBRACK = 299,
    RBRACK = 300,
    COLON = 301,
    SEMICOLON = 302,
    COMMA = 303,
    NUMBER = 304,
    IDENT = 305
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 115 "compiler.y" /* yacc.c:1909  */

  char *op_val;
  struct CodeNode *node;

#line 110 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
