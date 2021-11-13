%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include <string.h>
#include "eforth.tab.h"
%}

%%

[0-9]{1,9}    { yylval.no = atoi(yytext); return NUMBER; }
[-+*\/]        { yylval.sym = yytext[0]; return MATH; }
bye           { return BYE; }
\n            { return ENTER; }
.             { }
<<EOF>>       { printf("Ctrl-D\n bye!\n"); exit(0); }
