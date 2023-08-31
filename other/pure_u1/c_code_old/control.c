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

double d_update;

int main(void){

    int to_print;
    int n_of_lat;
    int traj;
    int my_seed;
    double d_hot;
    scanf("to_print = %d\n",&to_print);
    scanf("seed = %d\n",&my_seed);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("beta = %lf\n",&beta);
    scanf("n_of_lat = %d\n",&n_of_lat);
    scanf("trajectories = %d\n",&traj);
    scanf("d_hot = %lf\n",&d_hot);
    scanf("d_update = %lf\n",&d_update);

    if( to_print == 1 ){
        printf("to_print = %d\n",to_print);
        printf("seed = %d\n",my_seed);
        printf("nx = %d\n",nx);
        printf("nt = %d\n",nt);
        printf("beta = %lf\n",beta);
        printf("n_of_lat = %d\n",n_of_lat);
        printf("trajectories = %d\n",traj);
        printf("d_hot = %lf\n",d_hot);
        printf("d_update = %lf\n",d_update);
    }

    vol = nx*nx*nx*nt;

    initialize(my_seed, d_hot);
    action_func();

    // THE FOLLOWING WRITES DOWN TAGS FOR THE QUANTITIES
    // TO BE RECORDED. NUMBER OF LATTICE AND PLAQUETTE ARE
    // ALWAYS RECORDED.

    printf("#no");

    #ifdef show_acceptance
    printf(" #accept");
    #endif

    printf(" #plaq");

    #ifdef show_wilson_loop
    printf(" #wl_re #wl_im");
    #endif

    printf("\n");

    // FOLLOWS THE OUTER-MOST LOOP

    for(int i_lat=1;i_lat<=n_of_lat;i_lat++){
        update(traj); // ALSO PRINTS NUMBER OF LATTICE AND ACCEPTANCE (IF SELECTED)
        measurements(); // PRINTS PLAQUETTE AND WILSON LOOP
    }

    for(int i=0;i<4;i++){
        free(lattice[i]);
    }
    return 0;
}
