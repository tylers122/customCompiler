all:
	flex lexer.lex
	bison -v -d --file-prefix=y compiler.y
	g++ -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f lexer parser lex.yy.c y.tab.c y.tab.h y.output
