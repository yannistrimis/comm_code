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
    double q_help;
    double plaq = 0.0;
    for(int i_traj=0;i_traj<traj;i_traj++){

        q_help = 0.0;
        if(i_traj==0){
            plaq = plaquette();
            printf("%.4lf %.12lf\n",q_help,plaq);
        }

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
        plaq = plaquette();
        printf("%.4lf %.12lf\n",q_help,plaq);
    }

}


double plaquette(){
    double plaq;
    plaq = (double)action/(6*vol);
    return plaq;
}
