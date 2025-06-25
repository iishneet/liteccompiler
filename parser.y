%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboltable.h"  // must define declare, update, and lookup
#include "icg.h"          // optional for later

int yylex();
void yyerror(const char *s);
extern FILE *yyin;

char temp[10];
int tempCount = 0;

char* newTemp() {
    sprintf(temp, "t%d", tempCount++);
    return strdup(temp);
}
%}

%union {
    int ival;
    char* sval;
}

%token <sval> ID STRING
%token <ival> NUMBER
%token INT PRINTF IF ELSE FOR
%token LE GE EQ NE
%type <ival> expr

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%left '<' '>' LE GE EQ NE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
    stmts
    ;

stmts:
    stmts stmt
    | /* empty */
    ;

stmt:
    INT ID '=' expr ';' {
        declare($2, $4);
        printf("int %s = %d\n", $2, $4);
    }
    | ID '=' expr ';' {
        update($1, $3);
        printf("%s = %d\n", $1, $3);
    }
    | PRINTF '(' STRING ')' ';' {
        char *str = $3;
        for (int i = 1; i < strlen(str) - 1; i++) {
            if (str[i] == '\\' && str[i+1] == 'n') {
                putchar('\n');
                i++;
            } else {
                putchar(str[i]);
            }
        }
        putchar('\n');
    }
    | PRINTF '(' STRING ',' ID ')' ';' {
        char *str = $3;
        int val = lookup($5);
        if (val != -1) {
            for (int i = 1; i < strlen(str) - 1; i++) {
                if (str[i] == '\\' && str[i+1] == 'n') {
                    putchar('\n');
                    i++;
                } else if (str[i] == '%' && str[i+1] == 'd') {
                    printf("%d", val);
                    i++;
                } else {
                    putchar(str[i]);
                }
            }
            putchar('\n');
        } else {
            printf("Error: Undefined variable %s\n", $5);
        }
    }
    | IF '(' expr ')' stmt %prec LOWER_THAN_ELSE {
        if ($3) {
            // parse-time execution: do nothing because stmt already executed
        }
    }
    | IF '(' expr ')' stmt ELSE stmt {
        if ($3) {
            // stmt already executed
        } else {
            // stmt already executed
        }
    }
    | block
    ;

block:
    '{' stmts '}'
    ;

expr:
    expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr {
        if ($3 == 0) {
            yyerror("Division by zero");
            exit(1);
        }
        $$ = $1 / $3;
    }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | expr '<' expr { $$ = $1 < $3; }
    | expr '>' expr { $$ = $1 > $3; }
    | expr LE expr { $$ = $1 <= $3; }
    | expr GE expr { $$ = $1 >= $3; }
    | expr EQ expr { $$ = $1 == $3; }
    | expr NE expr { $$ = $1 != $3; }
    | '(' expr ')' { $$ = $2; }
    | NUMBER { $$ = $1; }
    | ID {
        int val = lookup($1);
        if (val == -1) {
            yyerror("Undefined variable");
            exit(1);
        }
        $$ = val;
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("Error opening file");
        return 1;
    }

    yyin = f;
    yyparse();
    fclose(f);
    return 0;
}
