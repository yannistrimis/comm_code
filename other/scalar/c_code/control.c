#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "lattice.h"
#include "utils.h"
#include "action.h"

double* lattice[2];
int nx;
int nt;
int vol;
double lamda;
double kappa;
double action;

int main(void){

    int n_of_lat;
    int traj;
    int my_seed;
    double d_update;


    scanf("seed = %d\n",&my_seed);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("lamda = %lf\n",&lamda);
    scanf("kappa = %lf\n",&kappa);
    scanf("n_of_lat = %d\n",&n_of_lat);
    scanf("trejectories = %d\n",&traj);
    scanf("d_update = %lf\n",&d_update);

    vol = nx*nx*nx*nt;

    initialize(my_seed);
    action_func();
    // for(int ind=0;ind<vol;ind++){
    //     printf("%lf %lf %d\n",lattice[0][ind],lattice[1][ind],ind);
    // }
    return 0;
}