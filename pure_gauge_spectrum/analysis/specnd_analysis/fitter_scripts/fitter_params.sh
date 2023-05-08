ens_name="1632b6850x100a"
nt=32
tmin_max=0 # tmin IS INCLUDED !!!
tmax_arr=("13" "14" "15") # tmax IS ALSO INCLUDED !!!

masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

source1="CORNER"
source2="CORNER"

sinks="RHO_i0"

my_fitter_suffix="non"
my_fitter="scipy_fitter.py"

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

one_tmin=1
one_tmax=14
