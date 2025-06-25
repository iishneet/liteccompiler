#include "symboltable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Symbol *symbolTable = NULL;

void declare(char *name, int value)
{
    Symbol *current = symbolTable;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            printf("redefinition of %s", name);
            printf("previous definition of %s with type ", name);

            exit(1);
        }
        current = current->next;
    }

    Symbol *newSymbol = (Symbol *)malloc(sizeof(Symbol));
    newSymbol->name = strdup(name);
    newSymbol->value = value;
    newSymbol->next = symbolTable;
    symbolTable = newSymbol;
}

void update(char *name, int value)
{
    Symbol *current = symbolTable;
    while (current)
    {
        if (strcmp(current->name, name) == 0)
        {
            current->value = value;
            return;
        }
        current = current->next;
    }

    printf("Error: Variable '%s' is not declared.\n", name);
    exit(1);
}

int lookup(char *name)
{
    Symbol *current = symbolTable;
    while (current)
    {
        if (strcmp(current->name, name) == 0)
            return current->value;
        current = current->next;
    }
    return -1;
}

void printSymbolTable()
{
    Symbol *current = symbolTable;
    while (current)
    {
        printf("%s = %d\n", current->name, current->value);
        current = current->next;
    }
}
