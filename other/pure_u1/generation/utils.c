#include "utils.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void read_lattice(char* prevlat_name){
    FILE *f1 = fopen(prevlat_name,"rb");
    for(int i=0;i<4;i++){    
        lattice[i] = malloc( sizeof( double ) * vol );
    }
    for(int i=0;i<4;i++){
        fread(lattice[i], sizeof(lattice[i][0]), vol, f1);
    }
    fclose(f1);
}

void save_lattice(char* lat_name){
    FILE *f2 = fopen(lat_name,"wb");
    for(int i=0;i<4;i++){
        fwrite(lattice[i], sizeof(lattice[i][0]), vol, f2);
    }
    fclose(f2);
}

void initialize (int my_seed, double d_hot){
    for(int i=0;i<4;i++){    
        lattice[i] = malloc( sizeof( double ) * vol );
    }
    srand(my_seed);
    for(int ind=0;ind<vol;ind++){
        for(int i=0;i<4;i++){
            double r = (double)rand()/(double)RAND_MAX;
            r = (2*r-1)*d_hot;
            lattice[i][ind] = r;
        }
    }
}

int* ind_to_vec(int ind){
    int it,ix,iy,iz;
    static int vec[4];

    it = ind/(nx*nx*nx);
    iz =(ind%(nx*nx*nx))/(nx*nx);
    iy =((ind%(nx*nx*nx))%(nx*nx))/nx;
    ix =((ind%(nx*nx*nx))%(nx*nx))%nx;

    vec[0] = ix;
    vec[1] = iy;
    vec[2] = iz;
    vec[3] = it;

    return vec;
}

int vec_to_ind(int vec[4]){
    int it,ix,iy,iz,ind;
    it = vec[3];
    iz = vec[2];
    iy = vec[1];
    ix = vec[0];

    ind = it*nx*nx*nx + iz*nx*nx + iy*nx + ix;
    return ind;
}

int nn(int ind, int mu){
    int* vec;
    int vec_mu_nn;
    int ind_nn;
    int vec_nn[4];

    vec = ind_to_vec(ind);
    if( mu==3 ){
        if( *(vec+mu)==(nt-1) ){
            vec_mu_nn = 0;
        }
        else{
            vec_mu_nn = *(vec+mu) + 1;
        }
    }
    else{
        if( *(vec+mu)==(nx-1) ){
            vec_mu_nn = 0;
        }
        else{
            vec_mu_nn = *(vec+mu) + 1;
        }
    }
    for(int i=0;i<4;i++){ 
        vec_nn[i] = *(vec+i);
    }
    vec_nn[mu] = vec_mu_nn;
    ind_nn = vec_to_ind(vec_nn);
    return ind_nn;
}


int pnn(int ind, int mu){
    int* vec;
    int vec_mu_pnn;
    int ind_pnn;
    int vec_pnn[4];

    vec = ind_to_vec(ind);
    if( mu==3 ){
        if( *(vec+mu)==0 ){
            vec_mu_pnn = nt - 1;
        }
        else{
            vec_mu_pnn = *(vec+mu) - 1;
        }
    }
    else{
        if( *(vec+mu)==0 ){
            vec_mu_pnn = nx - 1;
        }
        else{
            vec_mu_pnn = *(vec+mu) - 1;
        }
    }
    for(int i=0;i<4;i++){ 
        vec_pnn[i] = *(vec+i);
    }
    vec_pnn[mu] = vec_mu_pnn;
    ind_pnn = vec_to_ind(vec_pnn);
    return ind_pnn;
}