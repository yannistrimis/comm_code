nx=16
nt=32
beta=6850
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=0 # tmin IS INCLUDED !!!
tmin_max=12 # tmin IS INCLUDED !!!
tmax_arr=("16") # tmax IS ALSO INCLUDED !!!

mass1=0.01576
mass2=0.01576

source1="CORNER"
source2="CORNER"

sinks="PION_05"

spec_type="specnd"
my_fitter_suffix="no"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=-100
En=0.3

ao=10
Eo=0.3

a1n=0.1
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_tmin=6
one_tmax=16
