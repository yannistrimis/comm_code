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

    int n_of_lat;
    int traj;
    int my_seed;
    double d_hot;
    double d_update;


    scanf("seed = %d\n",&my_seed);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("beta = %lf\n",&beta);
    scanf("n_of_lat = %d\n",&n_of_lat);
    scanf("trejectories = %d\n",&traj);
    scanf("d_hot = %lf\n",&d_hot);
    scanf("d_update = %lf\n",&d_update);


    // printf("seed = %d\n",my_seed);
    // printf("nx = %d\n",nx);
    // printf("nt = %d\n",nt);
    // printf("beta = %lf\n",beta);
    // printf("n_of_lat = %d\n",n_of_lat);
    // printf("trejectories = %d\n",traj);
    // printf("d_hot = %lf\n",d_hot);
    // printf("d_update = %lf\n",d_update);

    vol = nx*nx*nx*nt;

    initialize(my_seed, d_hot);
    action_func();

    printf("#plaq");

    #ifdef show_acceptance
    printf(" #accept");
    #endif

    #ifdef show_wilson_loop
    printf(" #wl_re #wl_im");
    #endif

    printf("\n");

    for(int i_lat=1;i_lat<=n_of_lat;i_lat++){
        d_update = update(d_update,traj);
        measurements();
    }   
    
    
    // printf("%d %d %lf\n",nx,nt,beta);
    
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