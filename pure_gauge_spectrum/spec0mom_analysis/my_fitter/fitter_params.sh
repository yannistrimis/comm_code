ens_name="l1632b6850x100a"
tmin_max=0 # tmin IS INCLUDED !!!
tmax_arr=("13" "14" "15") # tmax IS ALSO INCLUDED !!!

masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

source1="CORNER"
source2="CORNER"

sinks="RHO_i0"

my_fitter_suffix="non"
my_fitter="scipy_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=500
# san=10000
En=0.64
# sEn=10000

ao=0.0
# sao=10000
Eo=1.2
# sEo=10000

a1n=0.1
# sa1n=10000
E1n=0.1
# sE1n=10000

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_mass1=0.01576
one_mass2=0.01576

one_tmin=1
one_tmax=14
