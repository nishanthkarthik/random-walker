#include "stdio.h"

void noop(long n)
{
    // printf("Completed nop - %ld times\n", n);
    while (--n > 0)
        __asm__("nop");
}