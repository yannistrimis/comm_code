nx=16
nt=32
beta=6850
x0=100
stream="a"
ens_name="l${nx}${nt}b${beta}x${x0}${stream}"

tmin_min=0 # tmin IS INCLUDED !!!
tmin_max=8 # tmin IS INCLUDED !!!
tmax_arr=("14" "15" "16") # tmax IS ALSO INCLUDED !!!

mass1=0.01576
mass2=0.01576

sinks="PION_i0"

spec_type="specnlpi"
my_fitter_suffix="o"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=0.1
En=0.5

ao=0.1
Eo=0.5

a1n=0.001
E1n=0.1

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_tmin=5
one_tmax=15
