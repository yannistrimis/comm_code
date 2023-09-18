#include "utils.h"
#include "measurements.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>



void measurements(){
    double plaq;

    plaq = plaquette();
    printf(" %lf",plaq); // I LEAVE GAP FIRST BECAUSE COUNTER IS PRINTED BY update() FUNCTION

    #ifdef show_wilson_loop

    wl_struct wl;
    // SIZES OF WILSON LOOPS ARE DEFINED HERE:
    int r_wl[1] = {2};
    int t_wl[2] = {2,3};

    int r_size = sizeof(r_wl)/sizeof(int);
    int t_size = sizeof(t_wl)/sizeof(int);
    for(int ir=0;ir<r_size;ir++){
        for(int it=0;it<t_size;it++){
            wl = wilson_loop(r_wl[ir],t_wl[it]);
            printf(" %lf %lf",wl.re,wl.im);
        }
    }

    #endif

    printf("\n");
}


wl_struct wilson_loop(int r, int t){

// THIS FUNCTION FIRST MEASURES THE LINE THAT
// GOES FORWARD IN THE TIME DIRECTION. THEN IT CLOSES
// THE LOOP IN ALL 3 SPATIAL WAYS. IT DOES THAT FOR EVERY POINT
// AND IN THE END DIVIDES BY 3*VOLUME.

    wl_struct wl;

    double tf;
    double tb;
    double sf;
    double sb;
    double loop;

    int cursor;
    int milestone;

    wl.re = 0.0;
    wl.im = 0.0;

    for(int ind=0;ind<vol;ind++){
        tf = 0.0;

        cursor = ind;
        for(int it=0;it<t;it++){
            tf = tf + lattice[3][cursor];
            cursor = nn(cursor,3);
        }

        milestone = cursor;
        for(int a=0;a<3;a++){
            tb = 0.0;
            sf = 0.0;
            sb = 0.0;
            loop = 0.0;
            cursor = milestone;
            for(int ix=0;ix<r;ix++){
                sf = sf + lattice[a][cursor];
                cursor = nn(cursor,a);
            }

            for(int it=0;it<t;it++){
                cursor = pnn(cursor,3);
                tb = tb - lattice[3][cursor];
            }

            for(int ix=0;ix<r;ix++){
                cursor = pnn(cursor,a);
                sb = sb - lattice[a][cursor];
            }

            loop = tf + sf + tb + sb;
            wl.re = wl.re + cos(loop);
            wl.im = wl.im + sin(loop);
        }
    }

    wl.re = (double)wl.re/(3.0*vol);
    wl.im = (double)wl.im/(3.0*vol);

    
}
