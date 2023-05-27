nx=16
nt=32
beta=6647
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=0 # tmin IS INCLUDED !!!
tmin_max=8 # tmin IS INCLUDED !!!
tmax_arr=("14" "15" "16") # tmax IS ALSO INCLUDED !!!

mass1=0.12
mass2=0.12

source1="cw"
source2="cw"

sinks="PION_5"

spec_type="spec0mom"
my_fitter_suffix="n"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=1000
En=0.5

ao=-0.001
Eo=0.5

a1n=0.001
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_tmin=6
one_tmax=15
