nx=16
nt=32
beta=6850
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=1 # tmin IS INCLUDED !!!
tmin_max=8 # tmin IS INCLUDED !!!
tmax_arr=("13" "14" "15") # tmax IS ALSO INCLUDED !!!

masses=("0.01576")
mas_len=${#masses[@]}

source1="CORNER"
source2="CORNER"

sinks="RHO_i0"

my_fitter_suffix="no"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=500
En=0.64

ao=0.0
Eo=1.2

a1n=0.1
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_mass1=0.01576
one_mass2=0.01576

one_tmin=5
one_tmax=14
