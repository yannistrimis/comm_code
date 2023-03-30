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
        action = action + lattice[0][ind]*lattice[0][ind];
        action = action + lamda*(lattice[0][ind]*lattice[0][ind]-1)*(lattice[0][ind]*lattice[0][ind]-1);
        temp = 0.0;
        for(int mu=0;mu<4;mu++){
            nn_mu = nn(ind,mu);
            temp = temp + lattice[0][nn_mu]*cos(lattice[1][ind]-lattice[1][nn_mu]);
        }
        temp = temp*2*kappa*lattice[0][ind];
        action = action - temp;
    }
}





