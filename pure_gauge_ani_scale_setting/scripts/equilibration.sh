#!/bin/bash

ens="/mnt/home/trimisio/outputs/l2080b7667x35480a/sflow2080b7667x35480xf360a_dt0.015625.lat"
my_0="/mnt/home/trimisio/plot_data/equil_zero"
my_h="/mnt/home/trimisio/plot_data/equil_half"
my_m="/mnt/home/trimisio/plot_data/equil_max"


if [ -f "${my_0}" ]; then rm "${my_0}"; fi
if [ -f "${my_h}" ]; then rm "${my_h}"; fi
if [ -f "${my_m}" ]; then rm "${my_m}"; fi

for i_file in {101..430..1}
do
	filename="${ens}.${i_file}"
	cat ${filename} | awk '$1=="GFLOW:" && $2=="0" {print $5}' >> "${my_0}"
	cat ${filename} | awk '$1=="GFLOW:" && $2=="2" {print $5}' >> "${my_h}"
	cat ${filename} | awk '$1=="GFLOW:" && $2=="4" {print $5}' >> "${my_m}"
done

