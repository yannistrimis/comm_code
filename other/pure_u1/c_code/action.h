void action_func(void);
double single_update(int,int,double,double);
double update(double,int);
double plaquette(void);
void measurements(void);

struct wilsonloop_re_im{
    double re, im;
};
typedef struct wilsonloop_re_im wl_struct;
wl_struct wilson_loop(int,int);

// #define show_wilson_loop
#define show_acceptance