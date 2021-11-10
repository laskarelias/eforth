compile:
	@bison -Wconflicts-sr -d -t -v eforth.y
	@flex -o eforth.lex.c eforth.l
	@gcc -Wall -o eforth *.c -lfl -lm

run:
	./eforth


clean:
	rm eforth eforth.lex.c eforth.tab.* eforth.output
