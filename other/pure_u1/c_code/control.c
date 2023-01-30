#include <stdio.h>
#include <stdlib.h>
#include "lattice.h"
#include "utils.h"

double* lattice;
int nx;

int main(void){
    nx = 4; 
    int my_seed = 8213;

    hot(nx,my_seed);
    for(int i=0;i<nx;i++){
        printf("%lf ",lattice[i]);
    }
    printf("\n");
    
    ran_test(nx);
    for(int i=0;i<nx;i++){
        printf("%lf ",lattice[i]);
    }
    printf("\n");

    ran_test(nx);
    for(int i=0;i<nx;i++){
        printf("%lf ",lattice[i]);
    }
    printf("\n");
    
    lattice[0]=lattice[0]+1;
    print_lat();

    free(lattice);
    return 0;
}