n_of_lat=2

nx=20
ny=20
nz=20
nt=20

set_i_lat=101
set_seed=5672138

beta_name="7167"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/scripts1"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/runs/run_spec${lat_name}"

u0=1
set_source_start=0
source_inc=9
n_sources=2
nmasses=2
mass=( 0.08 0.08 )
err=1e-6

error_for_propagator=( ${err} ${err} )
pbp_error_for_propagator=${err}
max_cg_iterations=300
action=hisq
precision=2

