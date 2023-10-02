#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "lattice.h"
#include "utils.h"
#include "measurements.h"

double* lattice[4];
int nx;
int nt;
int vol;

int main(void){

    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    printf("\nMEASUREMENT OF WILSON LOOP ON PURE GAUGE U(1) CONFIGURATIONS\n");
    printf("START: %d-%02d-%02d %02d:%02d:%02d\n\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);

    char lat_name[100]; // DON'T LEAVE BLANK
    int r_min, r_step, r_max;
    int t_min, t_step, t_max;

    scanf("lat_name = %s\n",&lat_name);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("r_min = %d\n",&r_min);
    scanf("r_step = %d\n",&r_step);
    scanf("r_max = %d\n",&r_max);
    scanf("t_min = %d\n",&t_min);
    scanf("t_step = %d\n",&t_step);
    scanf("t_max = %d\n",&t_max);

    printf("lat_name = %s\n",lat_name);
    printf("nx = %d\n",nx);
    printf("nt = %d\n",nt);
    printf("r_min = %d\n",r_min);
    printf("r_step = %d\n",r_step);
    printf("r_max = %d\n",r_max);
    printf("t_min = %d\n",t_min);
    printf("t_step = %d\n",t_step);
    printf("t_max = %d\n\n",t_max);

    vol = nx*nx*nx*nt;

    read_lattice(lat_name);
    printf("READ FROM BINARY FILE %s\n\n",lat_name);    
    printf("R T REWLOOP IMWLOOP\n");
    for(int ir=r_min; ir<=r_max; ir=ir+r_step){
        for(int it=t_min; it<=t_max; it=it+t_step){
            wilson_loop(ir,it);
        }
    }
    
    for(int i=0;i<4;i++){
        free(lattice[i]);
    }

    t = time(NULL);
    tm = *localtime(&t);
    printf("\n\nEND: %d-%02d-%02d %02d:%02d:%02d\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);

    return 0;
}
