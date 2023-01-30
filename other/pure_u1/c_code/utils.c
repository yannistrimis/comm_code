#include "utils.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>

void hot(int nx,int my_seed){
    lattice = malloc( sizeof( double ) * 4 );
    srand(my_seed);
    for(int i=0;i<nx;i++){
        double r = (double)rand()/(double)RAND_MAX;
        lattice[i] = r;
    }
}
void ran_test(int nx){
    for(int i=0;i<nx;i++){
        double r = (double)rand()/(double)RAND_MAX;
        lattice[i] = r;
    }
}
void print_lat(){
    for(int i=0;i<nx;i++){
        printf("%lf ",lattice[i]);
    }
    printf("\n");
}