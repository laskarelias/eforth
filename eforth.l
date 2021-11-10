%option noyywrap
%option yylineno

%{
#include <string.h>
#include "eforth.tab.h"
%}

bye         bye
enter       [\n]
number      [0-9]{10}


%%

{bye}       { printf("ok "); return BYE; }
{enter}     { printf("enter "); return ENTER; }
{number}    { yylval.no = atoi(yytext); return NUMBER; }
