#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "lattice.h"
#include "utils.h"
#include "action.h"

double* lattice[4];
int nx;
int nt;
int vol;
double beta;
double action;

double d_update; // WILL BE READ FROM BINARY IF reload IS PERFORMED

int main(void){

    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    printf("\nGENERATION OF PURE GAUGE U(1) CONFIGURATIONS\n");
    printf("START: %d-%02d-%02d %02d:%02d:%02d\n\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);


    int traj;
    int my_seed;
    double d_hot;

    char startlat[10]; // "fresh" OR "reload"
    char prevlat_name[100]; // DON'T LEAVE BLANK
    char endlat[10]; // "save" OR "forget"
    char lat_name[100]; // DON'T LEAVE BLANK

    scanf("seed = %d\n",&my_seed);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("beta = %lf\n",&beta);
    scanf("trajectories = %d\n",&traj);
    scanf("startlat = %s\n",&startlat);
    scanf("d_hot = %lf\n",&d_hot);
    scanf("d_update = %lf\n",&d_update);
    scanf("prevlat_name = %s\n",&prevlat_name);
    scanf("endlat = %s\n",&endlat);
    scanf("lat_name = %s\n",&lat_name);


    printf("seed = %d\n",my_seed);
    printf("nx = %d\n",nx);
    printf("nt = %d\n",nt);
    printf("beta = %lf\n",beta);
    printf("trajectories = %d\n",traj);
    printf("startlat = %s\n",startlat);
    if( strcmp(startlat,"fresh")==0 ){
        printf("d_hot = %lf\n",d_hot);
        printf("d_update = %lf\n",d_update);
    }
    if( strcmp(startlat,"reload")==0 ){    
        printf("prevlat_name = %s\n",prevlat_name);
    }
    printf("endlat = %s\n",endlat);
    if( strcmp(endlat,"save")==0 ){
        printf("lat_name = %s\n",lat_name);   
    }
    printf("\n");

    vol = nx*nx*nx*nt;

    if( strcmp(startlat,"fresh")==0 ){
        initialize(my_seed, d_hot);
        printf("HOT START PERFORMED.\n\n");
    }else if(  strcmp(startlat,"reload")==0 ){
        read_lattice(prevlat_name);
        printf("READ FROM BINARY FILE %s\n\n",prevlat_name);    
    }

    action_func(); // ACTION IS CALCULATED ONCE. FOR ALL NEXT STEPS ONLY DIFFERENCES
                   // ARE CALCULATED

    printf("ACCEP PLAQ\n");

    update(traj);

    printf("\n");

    if( strcmp(endlat,"save")==0 ){
        save_lattice(lat_name);
        printf("SAVED TO BINARY FILE %s\n",lat_name);
    }


    for(int i=0;i<4;i++){
        free(lattice[i]);
    }

    t = time(NULL);
    tm = *localtime(&t);
    printf("\n\nEND: %d-%02d-%02d %02d:%02d:%02d\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);


    return 0;
}
