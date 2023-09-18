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
    int r_ext;
    int t_ext;

    scanf("lat_name = %s\n",&lat_name);
    scanf("nx = %d\n",&nx);
    scanf("nt = %d\n",&nt);
    scanf("r_ext = %d\n",&r_ext);
    scanf("t_ext = %d\n",&t_ext);

    printf("lat_name = %s\n",lat_name);
    printf("nx = %d\n",nx);
    printf("nt = %d\n",nt);
    printf("r_ext = %d\n",r_ext);
    printf("t_ext = %d\n\n",t_ext);

    vol = nx*nx*nx*nt;

    read_lattice(lat_name);
    printf("READ FROM BINARY FILE %s\n\n",lat_name);    

    wilson_loop(r_ext,t_ext);

    for(int i=0;i<4;i++){
        free(lattice[i]);
    }

    t = time(NULL);
    tm = *localtime(&t);
    printf("\n\nEND: %d-%02d-%02d %02d:%02d:%02d\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);


    return 0;
}
