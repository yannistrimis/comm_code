ens_name="l1632b6850x100a"
tmin_max=9 # IT IS INCLUDED
tmax=15 # IT IS INCLUDED

masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

source1="CORNER"
source2="CORNER"

sinks="RHO_i0"
my_fitter="my_fitter_n.py"

# STARTING VALUES

En=0.5
an=100

Eo=0.5
ao=1

# En1=
# an1=

# PARAMETERS FOR one_call_my_fitter.sh SCRIPT

one_mass1=0.01576
one_mass2=0.01576

one_tmin=7
one_tmax=15
