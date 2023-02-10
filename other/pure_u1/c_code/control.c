#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "lattice.h"
#include "utils.h"

double* lattice[4];
int nx;
int nt;
int vol;
double beta;

int main(void){
    nx = 4;
    nt = 4;
    vol = (int)pow(nx,3)*nt;
    int my_seed = 8213;
    beta = 1.0;

    double d_hot = 1.0;
    initialize(my_seed, d_hot);

    for(int ind=0;ind<vol;ind++){
        for(int i=0;i<4;i++){
                printf("%lf\n",lattice[i][ind]);
        }
    }

    for(int i=0;i<4;i++){
        free(lattice[i]);
    }
    return 0;
}