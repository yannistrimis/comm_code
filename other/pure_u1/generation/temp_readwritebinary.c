#include <stdio.h>
#include <stdlib.h>

// THE FOLLOWING IS A DEMONSTRATION OF WRITING AND READING ARRAYS TO AND FROM BINARY FILES

int main(void){

    double *lattice[4];
    double *post_lattice[4];

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

    FILE *f1 = fopen("lat.1","wb");
    for (int i=0; i<4; i++){
        fwrite(lattice[i], sizeof(lattice[i][0]), 8, f1);
    }
    fclose(f1);

    FILE *f2 = fopen("lat.1","rb");
    for (int i=0; i<4; i++){
        fread(post_lattice[i], sizeof(post_lattice[i][0]), 8, f2);
    }
    fclose(f2);

    printf("\nARRAY AFTER SAVING:\n\n");
    for(int i=0;i<4;i++){
        for(int j=0;j<8;j++){
            printf("%.2lf ",post_lattice[i][j]);
        }
        printf("\n");
    }


    printf("\n");
    return 0;
}

