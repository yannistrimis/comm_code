nx=32
nt=64
beta=7600
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=0 # tmin IS INCLUDED !!!
tmin_max=20 # tmin IS INCLUDED !!!
tmax_arr=("30" "32") # tmax IS ALSO INCLUDED !!!

mass1=0.0372
mass2=0.0372

sinks="PION_5"

spec_type="specnd"
my_fitter_suffix="n"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=10000
En=0.5

ao=0.0
Eo=0.0

a1n=1000
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_tmin=12
one_tmax=32
