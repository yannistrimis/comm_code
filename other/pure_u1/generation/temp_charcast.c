#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void){

    double a = 27.98723412345694;
    char a_char[8];

    memcpy(a_char,&a,sizeof(double));
    printf("%.14lf\n",a);

    FILE *f1 = fopen("temp_file","wb");
    fwrite(&a_char,sizeof(a_char),1,f1);

    fclose(f1);

    double b;
    double b_char[8];
    FILE *f2 = fopen("temp_file","rb");
    fread(&b_char,sizeof(b_char),1,f2);

    b = *((double*)b_char);
    printf("%.14lf\n",b);

    return 0;
}
