import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

### THIS SCRIPT SETS THE w0 SCALE AND RENORMALIZED GAUGE ANISOTROPY
### FOR PURE GAUGES ENSEMBLES. IT ALSO PRODUCES JACKKNIFE-BINNED DATA
### WHICH ARE STORED IN FILE FOR PLOTTING.

cur_dir = '/mnt/home/trimisio/outputs'
vol = '1632'
beta = '6850'
xf = '100'
stream = 'a'
flow_type = 's'
obs_type = 'clover'
x0_vec = ['096', '098', '100', '102', '104']
x0_float_vec = [0.96, 0.98, 1.00, 1.02, 1.04]
dt = '0.015625'
n_files = 400
first_file =101
n_bins = 40
i_x0_rec = 2 # WHICH ONE OF THE BARE ANISOTROPIES TO PICK FOR RECORDING

how_input = input("type 0 for by-hand input or 1 for in-script values: ") 
if how_input=="0" :
	cur_dir = input()
	vol = input() 
	beta = input() 
	xf = input() 
	stream = input() 
	flow_type = input() 
	obs_type = input() 
	x0_vec = input() 
	x0_float_vec = input() 
	dt = input() 
	n_files = int(input())
	first_file = int(input())
	n_bins = int(input()) 
	i_x0_rec = int(input()) # WHICH ONE OF THE BARE ANISOTROPIES TO PICK FOR RECORDING

f_write = open( '/mnt/home/trimisio/plot_data/flow_data/data_wupnew_sflow%sb%sx%sxf%sdt%sobs_%s'%(vol,beta,x0[i_x0_rec],xf,dt,obs_type) , 'w' )
f_write.write( '#tau #Et #Et_err #Es #Es_err #dEt #dEt_err #dEs #dEs_err\n' )

i_x0 = -1
for x0 in x0_vec :
    i_x0 += 1
    for i_file in range(first_file,n_files+first_file):
        i = i_file - first_file
		f_read = open( '%s/l%sb%sx%s%s/%sflow%sb%sx%sxf%s%s_dt%s.lat.%d'%(cur_dir,vol,beta,x0,stream,flow_type,vol,beta,x0,xf,stream,dt,i_file) , 'r' )
		content = f_read.readlines()
		f_read.close()
		if i_file == first_file and i_x0 == 0 :
			for i_line in range(len(content)):
				my_line = content[ i_line ].split(' ')
				if my_line[0] == 'Number' and my_line[2] == 'steps' :
					n_steps = int(my_line[4])+1
			tau_arr = np.zeros( n_steps )
			Es_arr = np.zeros(( n_steps , n_files , len(x0_vec) ))
			Et_arr = np.zeros(( n_steps , n_files , len(x0_vec) ))
			dEs_arr = np.zeros(( n_steps , n_files , len(x0_vec) ))
			dEt_arr = np.zeros(( n_steps , n_files , len(x0_vec) ))

        i_time = 0
		for i_line in range(len(content)):
			my_line = content[ i_line ].split(' ')
			if my_line[0] == 'RUNNING': # FOR SECURITY
                break
			if my_line[0] == 'GFLOW:' :
				if i_file == first_file and i_x0 == 0 : #the tau_array will be the same for all, so we form it once
					tau_arr[i_time] = float( my_line[1] )
				if obs_type == 'clover' :	
					Et_arr[i_time,i,i_x0] = float( my_line[2] )
					Es_arr[i_time,i,i_x0] = float( my_line[3] )
				elif obs_type == 'wilson' :
					Et_arr[i_time,i,i_x0] = 6*( 3-float(my_line[4]) )
					Es_arr[i_time,i,i_x0] = 6*( 3-float(my_line[5]) )
				elif obs_type == 'symanzik' :
					Et_arr[i_time,i,i_x0] = 10*( 3-float(my_line[4]) )-( 3-float(my_line[6]) )
					Es_arr[i_time,i,i_x0] = 10*( 3-float(my_line[5]) )-( 3-float(my_line[7]) )
				Et_arr[i_time,i,i_x0] = tau_arr[i_time]*tau_arr[i_time]*Et_arr[i_time,i,i_x0]
				Es_arr[i_time,i,i_x0] = tau_arr[i_time]*tau_arr[i_time]*Es_arr[i_time,i,i_x0]
				i_time = i_time + 1

		dEt_arr[:,i,i_x0] = deriv( Et_arr[:,i,i_x0] , float(dt) )
		dEs_arr[:,i,i_x0] = deriv( Es_arr[:,i,i_x0] , float(dt) )

		for i_time in range(0,n_steps) :
			dEt_arr[i_time,i,i_x0] = dEt_arr[i_time,i,i_x0] * tau_arr[i_time]	
			dEs_arr[i_time,i,i_x0] = dEs_arr[i_time,i,i_x0] * tau_arr[i_time]

### AT THIS STAGE dES AND dEt MEASUREMENT POINTS HAVE BEEN FORMED

dEs_binned = np.zeros( ( n_steps , n_bins , len(x0_vec) ) )
dEs_weight = np.zeros( ( n_steps , len(x0_vec) ) )

dEt_binned = np.zeros( ( n_steps , n_bins , len(x0_vec) ) )
dEt_weight = np.zeros( ( n_steps , len(x0_vec) ) )

for i_x0 in range(len(x0_vec)):
    for i_time in range(n_steps):   
        dEs_binned[i_time,:,i_x0] = jackknife(dEs_arr[i_time,:,i_x0],n_bins,'bins')
        dEs_error = jackknife(dEs_arr[i_time,:,i_x0],n_bins,'error')
        dEt_binned[i_time,:,i_x0] = jackknife(dEs_arr[i_time,:,i_x0],n_bins,'bins')
        dEt_error = jackknife(dEs_arr[i_time,:,i_x0],n_bins,'error')

        if i_time > 0: # the first elements are not going to be needed anyways
            dEs_weight[i_time,i_x0] = 1/(dEs_error)
            dEt_weight[i_time,i_x0] = 1/(dEt_error)

### AT THIS STAGE dES AND dEt HAVE BEEN BINNED SO THAT JACKKNIFE PROCESS
### CAN BE APPLIED ON THEM. THE WEIGHTS (JACKKNIFE ERRORS APPLIED EQUIVALENTLY
### TO ALL BINS) WILL BE USED AS WEIGHTS IN THE FITS

for i_time in range(n_steps):
        Et_rec = jackknife(Et_arr[i_time,:,i_x0_rec],n_bins,'average')
        Et_err_rec = jackknife(Et_arr[i_time,:,i_x0_rec],n_bins,'error')
        Es_rec = jackknife(Es_arr[i_time,:,i_x0_rec],n_bins,'average')
        Es_err_rec = jackknife(Es_arr[i_time,:,i_x0_rec],n_bins,'error')
        dEt_rec = jackknife(dEt_arr[i_time,:,i_x0_rec],n_bins,'average')
        dEt_err_rec = jackknife(dEt_arr[i_time,:,i_x0_rec],n_bins,'error')
        dEs_rec = jackknife(dEs_arr[i_time,:,i_x0_rec],n_bins,'average')
        dEs_err_rec = jackknife(dEs_arr[i_time,:,i_x0_rec],n_bins,'error')
        f_write.write('%f %f %f %f %f %f %f %f %f\n'%(tau_arr[i_time],Et_rec,Et_err_rec,Es_rec,Es_err_rec,dEt_rec,dEt_err_rec,dEs_rec,dEs_err_rec))
f_write.close()
del Et_arr
del Es_arr
del dEt_arr     
del dEs_arr

### AT THIS STAGE QUANTITES HAVE BEEN RECORDED FOR A SELECTED x0

w0s_arr = np.zeros( ( n_bins , len(x0_vec) ) )
w0t_arr = np.zeros( ( n_bins , len(x0_vec) ) )

for i_x0 in range(len(x0_vec)):
    for i_bins in range(n_bins):
            y_points = np.zeros(7) # dEs_arr VALUES
            x_points = np.zeros(7) # tau_arr VALUES
            w_points = np.zeros(7) # WEIGHTS
            clos_i = closest( dEs_binned[:,i_bins,i_x0] , 0.15 )
            for j in range(7):
                k = -3+j
                y_points[j] = dEs_binned[clos_i+k,i_bins,i_x0]
                x_points[j] = tau_arr[clos_i+k]
                w_points[j] = dEs_weight[clos_i+k,i_x0]

            coeffs = np.polyfit(x_points,y_points,4,w=w_points)
            coeffs[4] = coeffs[4] - 0.15
            solutions = np.roots(coeffs)
            for ii in range( len(solutions) ): # FOR SECURITY
                if solutions[ii] < tau_arr[clos_i+1] and solutions[ii] > tau_arr[clos_i-1] :
                    w0s_arr[i_bins,i_x0] = np.real(solutions[ii])
                    break

for i_x0 in range(len(x0_vec)):
    for i_bins in range(n_bins):
            y_points = np.zeros(7) # dEt_arr VALUES
            x_points = np.zeros(7) # tau_arr VALUES
            w_points = np.zeros(7) # WEIGHTS
            clos_i = closest( dEt_binned[:,i_bins,i_x0] , 0.15 )
            for j in range(7):
                k = -3+j
                y_points[j] = dEt_binned[clos_i+k,i_bins,i_x0]
                x_points[j] = tau_arr[clos_i+k]
                w_points[j] = dEt_weight[clos_i+k,i_x0]

            coeffs = np.polyfit(x_points,y_points,4,w=w_points)
            coeffs[4] = coeffs[4] - 0.15
            solutions = np.roots(coeffs)
            for ii in range( len(solutions) ): # FOR SECURITY
                if solutions[ii] < tau_arr[clos_i+1] and solutions[ii] > tau_arr[clos_i-1] :
                    w0t_arr[i_bins,i_x0] = np.real(solutions[ii])
                    break

### AT THIS STAGE WE HAVE w0s AND w0t POINTS PER x0 PER BIN

ratios = np.zeros(( n_bins, len(x0_vec) ))
ratio_weights = np.zeros( len(x0_vec) )

for i_x0 in range(len(x0_vec)):
    for i_bins in range(n_bins):
        ratios[i_bins,i_x0] = w0s_arr[i_bins,i_x0]/w0t_arr[i_bins,i_x0]
    ratio_weights = 1.0 / jackknife_for_binned(ratios[:,i_x0])[1]

### AT THIS STAGE WE HAVE RATIO POINTS AND WEIGHTS PER x0 PER BIN

xR_binned = np.zeros(n_bins)
for i_bins in range(n_bins):
    coeffs = np.polyfit(x0_float_vec,ratios[i_bins,i_x0],4,w=ratio_weights)
    coeffs[4] = coeffs[4] - 1.0
    solutions = np.roots(coeffs)
        for ii in range( len(solutions) ): # FOR SECURITY
            if solutions[ii] < x0_float_vec[len(x0_float_vec)-1] and solutions[ii] > x0_float_vec[0] :
                xR_binned[i_bins] = np.real(solutions[ii])
                break

xR = jackknife_for_binned(xR_binned)

print(xR[0],xR[1])





