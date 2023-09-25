#include "utils.h"
#include "measurements.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void wilson_loop(int r, int t){

    /* THIS FUNCTION FIRST MEASURES THE LINE THAT
    GOES FORWARD IN THE TIME DIRECTION. THEN IT CLOSES
    THE LOOP IN ALL 3 SPATIAL WAYS. IT DOES THAT FOR EVERY POINT
    AND IN THE END DIVIDES BY 3*VOLUME. */

    double tf;
    double tb;
    double sf;
    double sb;
    double loop;

    int cursor;
    int milestone;

    double wl_re = 0.0;
    double wl_im = 0.0;

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
            wl_re = wl_re + cos(loop);
            wl_im = wl_im + sin(loop);
        }
    }

    wl_re = (double)wl_re/(3.0*vol);
    wl_im = (double)wl_im/(3.0*vol);
    printf("%d %d %.12lf %.12lf\n",r,t,wl_re,wl_im);
}
