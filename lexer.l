%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

"int"           { return INT; }
"printf"        { return PRINTF; }
"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }

\"[^\"]*\"      { yylval.sval = strdup(yytext); return STRING; }

[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.sval = strdup(yytext); return ID; }

"<="            { return LE; }
">="            { return GE; }
"=="            { return EQ; }
"!="            { return NE; }

"<"             { return '<'; }
">"             { return '>'; }
"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
";"             { return ';'; }
","             { return ','; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }

[ \t\r\n]+      {  }

.               { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
