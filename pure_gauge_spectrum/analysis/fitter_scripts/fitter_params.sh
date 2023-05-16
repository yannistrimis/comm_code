nx=16
nt=32
beta=6850
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=0 # tmin IS INCLUDED !!!
tmin_max=2 # tmin IS INCLUDED !!!
tmax_arr=("16") # tmax IS ALSO INCLUDED !!!

mass1=0.01576
mass2=0.01576

source1="eow"
source2="eow_fw"

sinks="PION_i"

spec_type="specnlpi"
my_fitter_suffix="n"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=-0.0025
En=0.5

ao=-0.001
Eo=0.5

a1n=0.001
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_tmin=0
one_tmax=16
