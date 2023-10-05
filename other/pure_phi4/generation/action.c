#include "utils.h"
#include "action.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void action_func(void){
    double temp;
    int nn_mu;
    action = 0.0;

    for(int ind=0;ind<vol;ind++){
        action = action + phi[0][ind]*phi[0][ind];
        action = action + lamda*(phi[0][ind]*phi[0][ind]-1)*(phi[0][ind]*phi[0][ind]-1);
        temp = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp = temp + phi[0][nn_mu]*cos(phi[1][ind]-phi[1][nn_mu]);
        }
        temp = temp*2*kappa*phi[0][ind];
        action = action - temp;
    }
}


double single_update_rho(int ind, double q_rho){

    double cur = phi[0][ind];
    double act_prop = action;
    int pnn0 = pnn(ind,0);
    int pnn1 = pnn(ind,1);
    int pnn2 = pnn(ind,2);
    int pnn3 = pnn(ind,3);

    int my_array[5] = {ind,pnn0,pnn1,pnn2,pnn3};
    int i;
    int nn_mu;
    double temp1, temp2;

    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        temp1 = phi[0][i]*phi[0][i];
        temp1 = temp1 + lamda*(phi[0][i]*phi[0][i]-1)*(phi[0][i]*phi[0][i]-1);
        temp2 = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp2 = temp2 + phi[0][nn_mu]*cos(phi[1][i]-phi[1][nn_mu]);
        }
        temp2 = temp2*2*kappa*phi[0][i];
        temp1 = temp1 + temp2;
        act_prop = act_prop - temp1;
    }
    
    double aa = (double)rand()/(double)RAND_MAX;
    aa = (2*aa-1)*d_rho;
    phi[0][ind] = cur + aa;

    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        temp1 = phi[0][i]*phi[0][i];
        temp1 = temp1 + lamda*(phi[0][i]*phi[0][i]-1)*(phi[0][i]*phi[0][i]-1);
        temp2 = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp2 = temp2 + phi[0][nn_mu]*cos(phi[1][i]-phi[1][nn_mu]);
        }
        temp2 = temp2*2*kappa*phi[0][i];
        temp1 = temp1 + temp2;
        act_prop = act_prop + temp1;
    }

    if(act_prop<action){
        action = act_prop;
        q_rho = q_rho + 1.0;
    }else{
        double r = (double)rand()/(double)RAND_MAX;
        double exp_action = (phi[0][ind]/cur)*exp(action-act_prop);
        if(r<=exp_action){
            action = act_prop;
            q_rho = q_rho + 1.0;
        }else{
            phi[0][ind] = cur;
        }
    }

    return q_rho;
}


double single_update_theta(int ind, double q_theta){

    double cur = phi[1][ind];
    double act_prop = action;
    int pnn0 = pnn(ind,0);
    int pnn1 = pnn(ind,1);
    int pnn2 = pnn(ind,2);
    int pnn3 = pnn(ind,3);

    int my_array[5] = {ind,pnn0,pnn1,pnn2,pnn3};
    int i;
    int nn_mu;
    double temp1, temp2;

    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        temp1 = phi[0][i]*phi[0][i];
        temp1 = temp1 + lamda*(phi[0][i]*phi[0][i]-1)*(phi[0][i]*phi[0][i]-1);
        temp2 = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp2 = temp2 + phi[0][nn_mu]*cos(phi[1][i]-phi[1][nn_mu]);
        }
        temp2 = temp2*2*kappa*phi[0][i];
        temp1 = temp1 + temp2;
        act_prop = act_prop - temp1;
    }
    
    double aa = (double)rand()/(double)RAND_MAX;
    aa = (2*aa-1)*d_theta;
    phi[1][ind] = cur + aa;

    for(int counter=0;counter<5;counter++){
        i = my_array[counter];
        temp1 = phi[0][i]*phi[0][i];
        temp1 = temp1 + lamda*(phi[0][i]*phi[0][i]-1)*(phi[0][i]*phi[0][i]-1);
        temp2 = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp2 = temp2 + phi[0][nn_mu]*cos(phi[1][i]-phi[1][nn_mu]);
        }
        temp2 = temp2*2*kappa*phi[0][i];
        temp1 = temp1 + temp2;
        act_prop = act_prop + temp1;
    }

    if(act_prop<action){
        action = act_prop;
        q_theta = q_theta + 1.0;
    }else{
        double r = (double)rand()/(double)RAND_MAX;
        double exp_action = exp(action-act_prop);
        if(r<=exp_action){
            action = act_prop;
            q_theta = q_theta + 1.0;
        }else{
            phi[1][ind] = cur;
        }
    }

    return q_theta;
}


void update(int traj){
    static int counter = 1;
    double q_rho;
    double q_theta;
    for(int i_traj=0;i_traj<traj;i_traj++){
        q_rho = 0.0;
        q_theta = 0.0;
        for(int ind=0;ind<vol;ind++){
            q_rho = single_update_rho(ind,q_rho);
        }
        for(int ind=0;ind<vol;ind++){
            q_theta = single_update_theta(ind,q_theta);
        }
        
        q_rho = (double)q_rho/vol;
        q_theta = (double)q_theta/vol;
        if(q_rho>0.7){
            d_rho = d_rho + 0.1;
        }else if(q_rho<0.5){
            d_rho = d_rho - 0.1;
        }
        if(q_theta>0.7){
            d_theta = d_theta + 0.1;
        }else if(q_theta<0.5){
            d_theta = d_theta - 0.1;
        }
    }
    printf("%d",counter);
    counter = counter + 1;
    
    #ifdef show_accept_rho
    printf(" %lf",q_rho);
    #endif

    #ifdef show_accept_theta
    printf(" %lf",q_theta);
    #endif

}

void measurements(){
    printf("\n");
}