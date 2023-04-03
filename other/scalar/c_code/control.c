#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "lattice.h"
#include "utils.h"
#include "action.h"

double* phi[2];
int nx;
int nt;
int vol;
double lamda;
double kappa;
double action;

double d_rho;
double d_theta;

int main(void){

    int n_of_lat;
    int traj;
    int my_seed;


    scanf("seed = %d\n",&my_seed);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("lamda = %lf\n",&lamda);
    scanf("kappa = %lf\n",&kappa);
    scanf("n_of_lat = %d\n",&n_of_lat);
    scanf("trajectories = %d\n",&traj);
    scanf("d_rho = %lf\n",&d_rho);
    scanf("d_theta = %lf\n",&d_theta);

    vol = nx*nx*nx*nt;

    initialize(my_seed);
    action_func();
    // for(int ind=0;ind<vol;ind++){
    //     printf("%lf %lf %d\n",phi[0][ind],phi[1][ind],ind);
    // }

    printf("#no");
    
    #ifdef show_accept_rho
    printf(" accept_rho");
    #endif

    #ifdef show_accept_theta
    printf(" accept_theta");
    #endif

    printf("\n");

    for(int i_lat=1;i_lat<=n_of_lat;i_lat++){
        update(traj);
        measurements();
    }    



    for(int i=0;i<2;i++){
        free(phi[i]);
    }
    return 0;
}