%option noyywrap
%option yylineno
%option nounput

%{
#include <string.h>
#include "eforth.tab.h"
%}

bye         bye
enter       [\n]
number      [0-9]{9}
plus        +
minus       -
times       *
cr          cr


%%

{bye}       { return BYE; }
{enter}     { return ENTER; }
{number}    { yylval.no = atoi(yytext); return NUMBER; }
