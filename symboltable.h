#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

typedef struct Symbol
{
    char *name;
    int value;
    struct Symbol *next;
} Symbol;

void declare(char *name, int value);
void update(char *name, int value);
int lookup(char *name);
void printSymbolTable();

#endif
