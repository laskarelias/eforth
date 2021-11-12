%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern int yylex();
extern int yyparse();

extern void yyerror(const char *s);

%}

%union {
    int no;
}

%token BYE;
%token ENTER;
%token <no> NUMBER

%%

base: BYE ENTER {
      printf("bye!\n");
      exit(0);
    }

;

number: NUMBER {
        push($1, num);
      }
;

%%


void yyerror(const char *s){
    printf(" not ok \n");
}
