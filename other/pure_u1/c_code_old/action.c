#include "utils.h"
#include "action.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


void action_func(void){
    double temp;
    int nna;
    int nnb;

    action = 0.0;

    for(int ind=0;ind<vol;ind++){
        for(int a=0;a<4;a++){
            for(int b=0;b<a;b++){
                nna = nn(ind,a);
                nnb = nn(ind,b);
                temp = lattice[a][ind]+lattice[b][nna]-lattice[a][nnb]-lattice[b][ind];
                action = action + temp*temp;
            }
        }
    }
}


double single_update(int ind, int mu, double q_help){
    double cur = lattice[mu][ind]; 
    double act_prop = action;
    int pnn0 = pnn(ind,0);
    int pnn1 = pnn(ind,1);
    int pnn2 = pnn(ind,2);
    int pnn3 = pnn(ind,3);

    int my_array[5] = {ind,pnn0,pnn1,pnn2,pnn3};
    int i;
    int nna;
    int nnb;
    double temp;
    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        for(int a=0;a<4;a++){
            for(int b=0;b<a;b++){
                nna = nn(i,a);
                nnb = nn(i,b);
                temp = lattice[a][i]+lattice[b][nna]-lattice[a][nnb]-lattice[b][i];
                act_prop = act_prop - temp*temp;
            }
        }
    }
    double aa = (double)rand()/(double)RAND_MAX;
    aa = (2*aa-1)*d_update;
    lattice[mu][ind] = cur + aa;

    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        for(int a=0;a<4;a++){
            for(int b=0;b<a;b++){
                nna = nn(i,a);
                nnb = nn(i,b);
                temp = lattice[a][i]+lattice[b][nna]-lattice[a][nnb]-lattice[b][i];
                act_prop = act_prop + temp*temp;
            }
        }
    }

    if(act_prop<action){
        action = act_prop;
        q_help = q_help + 1.0;
    }else{
        double r = (double)rand()/(double)RAND_MAX;
        double exp_action = exp(-0.5*beta*act_prop+0.5*beta*action);
        if(r<=exp_action){
            action = act_prop;
            q_help = q_help + 1.0;
        }else{
            lattice[mu][ind] = cur;
        }
    }
    return q_help;
}


void update(int traj){
    static int counter = 1;
    double q_help;
    for(int i_traj=0;i_traj<traj;i_traj++){

        q_help = 0.0;
        for(int ind=0;ind<vol;ind++){
            for(int mu=0;mu<4;mu++){
                q_help = single_update(ind,mu,q_help);
            }
        }
        q_help = (double)q_help/(vol*4.0);
        if(q_help>0.7){
            d_update = d_update + 0.1;
        }else if(q_help<0.5){
            d_update = d_update - 0.1;
        }
    }
    printf("%d",counter);
    counter = counter + 1;

    #ifdef show_acceptance
    printf(" %lf",q_help);
    #endif

}


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


double plaquette(){
    double plaq;
    plaq = (double)action/(6*vol);
    return plaq;
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

    return wl;
}
