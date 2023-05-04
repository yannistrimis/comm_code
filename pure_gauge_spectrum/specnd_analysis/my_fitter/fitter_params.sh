ens_name="l1632b6850x100a"
tmin_max=0 # IT IS INCLUDED
tmax=14 # IT IS INCLUDED

masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

source1="CORNER"
source2="CORNER"

sinks="RHO_i0"

my_fitter_suffix="non_priors"
my_fitter="my_fitter_${my_fitter_suffix}.py"

# STARTING VALUES

an=450
san=10000
En=0.60
sEn=10000

ao=100
sao=10000
Eo=5.0
sEo=10000

a1n=0.0
sa1n=10000
E1n=0.0
sE1n=10000

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_mass1=0.01576
one_mass2=0.01576

one_tmin=0
one_tmax=14
