#!/bin/bash

source params.sh

i_curr=$1

prompt 0
nx 4
ny 4
nz 4
nt 8
anisotropy 2.0

reload_serial ../../binary_samples/lat.sample.l4448
wilson
exp_order 8
stepsize 0.1
stoptime 1.0
forget