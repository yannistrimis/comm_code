#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "lattice.h"
#include "utils.h"
#include "action.h"

double* lattice[4];
int nx;
int nt;
int vol;
double beta;
double action;

int main(void){
    nx = 4;
    nt = 4;

    vol = nx*nx*nx*nt;
    int my_seed = 8213;

    double beta_arr[4] = {0.25,0.5,1.0,2.0};

    double d_hot = 1.0;
    initialize(my_seed, d_hot);

    double q_help = 0.0;
    double d_update = 1.0;
    
    for(int i_beta=0;i_beta<4;i_beta++){
        beta = beta_arr[i_beta];


    }
    
    
    
    
    
    
    
    
    
    
    // for(int ind=0;ind<vol;ind++){
    //     for(int i=0;i<4;i++){
    //             printf("%lf\n",lattice[i][ind]);
    //     }
    // }

    for(int i=0;i<4;i++){
        free(lattice[i]);
    }
    return 0;
}