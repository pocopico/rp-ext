/**
 * C program to convert decimal to binary number system
 */

#include <stdio.h>
#define INT_SIZE sizeof(int) * 8 /* Size of int in bits */

int main()
{
    int num, index, i;
    int bin[INT_SIZE];

    /* Input number from user */
   /* printf("Enter any number: ");*/
    scanf("%d", &num);


    index = INT_SIZE - 1;

    while(index >= 0)
    {
        /* Store LSB of num to bin */
        bin[index] = num & 1;

        /* Decrement index */
        index--;

        /* Right Shift num by 1 */
        num >>= 1;
    }

    /* Print converted binary */
    /*printf("Converted binary: ");*/
    for(i=0; i<INT_SIZE; i++)
    {
        printf("%d", bin[i]);
    }

    return 0;
}
