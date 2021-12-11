%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include <string.h>
#include "eforth.tab.h"
%}

%%

[0-9]{1,9}    { yylval.no = atoi(yytext); 
                return NUMBER;
              }
[-+*\/]       { yylval.sym = yytext[0];
                return MATH;
              }
[\.]          { return DOT; }
[:]           { return COLON; }
emit          { return EMIT; }

drop          { return DROP; }
swap          { return SWAP; }
over          { return OVER; }
rot           { return ROT; }

bye           { return BYE; }
forgot        { return FORGOT; }
clear         { return CLEAR; }
\n            { return ENTER; }
[^ \t\n]*     { strncpy(yylval.str, yytext, 31);
                yylval.str[31] = '\0';
                return WORD; 
              }
[ \t]*        { }
<<EOF>>       { printf("Ctrl-D\n bye!\n"); 
                exit(0); 
              }

