#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// THE FOLLOWING IS A DEMONSTRATION OF WRITING AND READING ARRAYS TO AND FROM BINARY FILES
// A SINGLE DOUBLE NUMBER IS WRITTEN TO THE BINARY FILE AFTER THE ARRAY, SINCE THIS IS NEEDED
// WHEN d_update IS RECORDER, IN NONCOMPACT U(1) SIMULATIONS.

int main(void){

    double *lattice[4];
    double *post_lattice[4];

    double a = 27.98723412345694;
    char a_char[8];

    double b;
    double b_char[8];

    memcpy(a_char,&a,sizeof(double));

    for(int i=0;i<4;i++){    
        lattice[i] = malloc( sizeof( double ) * 8 );
        post_lattice[i] = malloc( sizeof( double ) * 8 );
    }
    for(int i=0;i<4;i++){
        for(int j=0;j<8;j++){
            lattice[i][j]=i+2*j;
        }
    }
    printf("\nARRAY BEFORE SAVING:\n\n");
    for(int i=0;i<4;i++){
        for(int j=0;j<8;j++){
            printf("%.2lf ",lattice[i][j]);
        }
        printf("\n");
    }
    printf("%.14lf\n",a);

    FILE *f1 = fopen("lat.1","wb");
    for (int i=0; i<4; i++){
        fwrite(lattice[i], sizeof(lattice[i][0]), 8, f1);
    }
    fwrite(&a_char,sizeof(a_char),1,f1);
    fclose(f1);

    FILE *f2 = fopen("lat.1","rb");
    for (int i=0; i<4; i++){
        fread(post_lattice[i], sizeof(post_lattice[i][0]), 8, f2);
    }
    fread(&b_char,sizeof(b_char),1,f2);
    fclose(f2);
    b = *((double*)b_char);

    printf("\nARRAY AFTER SAVING:\n\n");
    for(int i=0;i<4;i++){
        for(int j=0;j<8;j++){
            printf("%.2lf ",post_lattice[i][j]);
        }
        printf("\n");
    }
    printf("%.14lf\n",b);

    printf("\n");
    return 0;
}

