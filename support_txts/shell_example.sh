#!/bin/bash

############### S E C T I O N  1 ############################
#This section creates one file per tau per observble per xf. Then this is also done for
#the energy derivatives needed for scale setting with w_0.

mkdir /home/trimis/Code/june_2022_flow/obs_files
mkdir /home/trimis/Code/june_2022_flow/der_files

python extract_obs.py << 'EOF'
196
EOF

python extract_obs.py << 'EOF'
198
EOF

python extract_obs.py << 'EOF'
200
EOF

python extract_obs.py << 'EOF'
202
EOF

python extract_obs.py << 'EOF'
204
EOF

python derivative.py << 'EOF'
196
EOF

python derivative.py << 'EOF'
198
EOF

python derivative.py << 'EOF'
200
EOF

python derivative.py << 'EOF'
202
EOF

python derivative.py << 'EOF'
204
EOF
################## S E C T I O N  2 ##############################
#This section jackknives the data and creates one file per observable per xf per nof jackknife bins.

# DIRECTORY OF OBS FILES: /home/trimis/Code/june_2022_flow/obs_files
# DIRECTORY OF DER FILES: /home/trimis/Code/june_2022_flow/der_files

dir_obs="/home/trimis/Code/june_2022_flow/obs_files"
dir_der="/home/trimis/Code/june_2022_flow/der_files"
dir_averjack="/home/trimis/Code/autocorr_stuff/dat_utils_v0.12/src"

dir_temp="/home/trimis/Code/june_2022_flow/temp_jack"
dir_fin="/home/trimis/Code/june_2022_flow/fin_jack"

mkdir "${dir_temp}"

########################## Es Et Q sector #####################################
for nbins in 20 40
do
for name in "Es_time" "Et_time" "Q_time"
do
for xf in 196 198 200 202 204
do

	time=0.000
	for i_time in {0..96..1}
	do
		temp_jack_1="${dir_temp}/temp_${nbins}_${name}${time}xf${xf}.dat"
		file="${dir_obs}/${name}${time}xf${xf}.dat"
		
		"${dir_averjack}/"averjack "$file" "$nbins" > "${temp_jack_1}"		
		time=$(awk "BEGIN {printf \"%.3f\",${time}+0.025}")
	done
	
done
done
done
########################### dEs dEt sector ####################################
for nbins in 20 40
do
for name in "dEs" "dEt"
do
for xf in 196 198 200 202 204
do

	time=0.000
	for i_time in {0..96..1}
	do
		temp_jack_1="${dir_temp}/temp_${nbins}_${name}${time}xf${xf}.dat"
		file="${dir_der}/${name}${time}xf${xf}.dat"
		
		"${dir_averjack}/"averjack "$file" "$nbins" > "${temp_jack_1}"		
		time=$(awk "BEGIN {printf \"%.3f\",${time}+0.025}")
	done
	
done
done
done
###############################################################################
mkdir "${dir_fin}"
python jack.py
rm -rf "${dir_temp}"

