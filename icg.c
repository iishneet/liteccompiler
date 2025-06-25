#include "icg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ICG 100

typedef struct
{
    char result[10];
    char op1[10];
    char operator[3];
    char op2[10];
} ICG;

ICG icg[MAX_ICG];
int icg_index = 0;

// Generate a new intermediate code instruction
void gen(const char *result, const char *op1, const char *operator, const char *op2)
{
    if (icg_index >= MAX_ICG)
    {
        fprintf(stderr, "ICG buffer overflow!\n");
        exit(1);
    }
    strncpy(icg[icg_index].result, result, sizeof(icg[icg_index].result) - 1);
    strncpy(icg[icg_index].op1, op1, sizeof(icg[icg_index].op1) - 1);
    strncpy(icg[icg_index].operator, operator, sizeof(icg[icg_index].operator) - 1);
    strncpy(icg[icg_index].op2, op2, sizeof(icg[icg_index].op2) - 1);
    icg_index++;
}

// Print all generated ICG
void print_icg()
{
    printf("\nGenerated Intermediate Code:\n");
    for (int i = 0; i < icg_index; i++)
    {
        printf("%s = %s %s %s\n", icg[i].result, icg[i].op1, icg[i].operator, icg[i].op2);
    }
}
