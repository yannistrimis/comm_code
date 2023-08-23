import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

### THIS SCRIPT SETS THE w0 SCALE AND RENORMALIZED GAUGE ANISOTROPY
### FOR PURE GAUGES ENSEMBLES. IT ALSO PRODUCES JACKKNIFE-BINNED DATA
### WHICH ARE STORED IN FILE FOR PLOTTING.

cur_dir = '/mnt/home/trimisio/outputs'
vol = '1632'
beta = '6850'
x0 = '100'
stream = 'a'
flow_type = 's'
obs_type = 'clover'
xf_vec = ['096', '098', '100', '102', '104']
xf_float_vec = [0.96, 0.98, 1.00, 1.02, 1.04]
dt = '0.015625'
n_files = 400
first_file =101
n_bins = 40
i_xf_rec = 2 # WHICH ONE OF THE FLOW ANISOTROPIES TO PICK FOR RECORDING

how_input = input("type 0 for by-hand input or 1 for in-script values: ") 
if how_input=="0" :
	cur_dir = input()
	vol = input() 
	beta = input() 
	x0 = input() 
	stream = input() 
	flow_type = input() 
	obs_type = input() 
	xf_vec = input() 
	xf_float_vec = input() 
	dt = input() 
	n_files = int(input())
	first_file = int(input())
	n_bins = int(input()) 
	i_xf_rec = int(input()) # WHICH ONE OF THE FLOW ANISOTROPIES TO PICK FOR RECORDING

f_write = open( '/mnt/home/trimisio/plot_data/flow_data/data_sflow%sb%sx%sxf%sdt%sobs_%s'%(vol,beta,x0,xf_vec[i_xf_rec],dt,obs_type) , 'w' )
f_write.write( '#tau #Et #Et_err #Es #Es_err #dEt #dEt_err #dEs #dEs_err #ratio #ratio_err\n' )

i_xf = -1
for xf in xf_vec:	
	i_xf = i_xf + 1
	for i_file in range(first_file,n_files+first_file):
#		print(i_file)
		i = i_file - first_file
		f_read = open( '%s/l%sb%sx%s%s/%sflow%sb%sx%sxf%s%s_dt%s.lat.%d'%(cur_dir,vol,beta,x0,stream,flow_type,vol,beta,x0,xf,stream,dt,i_file) , 'r' )
		content = f_read.readlines()
		f_read.close()
		if i_file == first_file and i_xf == 0 :
			for i_line in range(len(content)):
				my_line = content[ i_line ].split(' ')
				if my_line[0] == 'Number' and my_line[2] == 'steps' :
					n_steps = int(my_line[4])+1
			tau_arr = np.zeros( n_steps )
			Es_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
			Et_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
			dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
			dEt_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
			ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))

		i_time = 0
		for i_line in range(len(content)):
			my_line = content[ i_line ].split(' ')
			if my_line[0] == 'RUNNING': # FOR SECURITY
                break
			if my_line[0] == 'GFLOW:' :
				if i_file == first_file and i_xf == 0 : #the tau_array will be the same for all, so we form it once
					tau_arr[i_time] = float( my_line[1] )
				if obs_type == 'clover' :	
					Et_arr[i_time,i,i_xf] = float( my_line[2] )
					Es_arr[i_time,i,i_xf] = float( my_line[3] )
				elif obs_type == 'wilson' :
					Et_arr[i_time,i,i_xf] = 6*( 3-float(my_line[4]) )
					Es_arr[i_time,i,i_xf] = 6*( 3-float(my_line[5]) )
				elif obs_type == 'symanzik' :
					Et_arr[i_time,i,i_xf] = 10*( 3-float(my_line[4]) )-( 3-float(my_line[6]) )
					Es_arr[i_time,i,i_xf] = 10*( 3-float(my_line[5]) )-( 3-float(my_line[7]) )
				Et_arr[i_time,i,i_xf] = tau_arr[i_time]*tau_arr[i_time]*Et_arr[i_time,i,i_xf]
				Es_arr[i_time,i,i_xf] = tau_arr[i_time]*tau_arr[i_time]*Es_arr[i_time,i,i_xf]
				i_time = i_time + 1

		dEt_arr[:,i,i_xf] = deriv( Et_arr[:,i,i_xf] , float(dt) )
		dEs_arr[:,i,i_xf] = deriv( Es_arr[:,i,i_xf] , float(dt) )

		for i_time in range(0,n_steps) :
			dEt_arr[i_time,i,i_xf] = dEt_arr[i_time,i,i_xf] * tau_arr[i_time]	
			dEs_arr[i_time,i,i_xf] = dEs_arr[i_time,i,i_xf] * tau_arr[i_time]
			if i_time>0 :
				ratio_arr[i_time,i,i_xf] = (dEs_arr[i_time,i,i_xf])/(dEt_arr[i_time,i,i_xf]) # WE OMIT THE FIRST ELEMENT; DIVISION BY ZERO

### AT THIS STAGE dES AND RATIO MEASUREMENT POINTS HAVE BEEN FORMED

dEs_binned = np.zeros( ( n_steps , n_bins , len(xf_vec) ) )
ratio_binned = np.zeros( ( n_steps , n_bins , len(xf_vec) ) )
dEs_weight = np.zeros( ( n_steps , len(xf_vec) ) )
ratio_weight = np.zeros( ( n_steps , len(xf_vec) ) )

for i_xf in range(len(xf_vec)):
	for i_time in range(n_steps):	
		dEs_binned[i_time,:,i_xf] = jackknife(dEs_arr[i_time,:,i_xf],n_bins,'bins')
		dEs_error = jackknife(dEs_arr[i_time,:,i_xf],n_bins,'error')
		ratio_binned[i_time,:,i_xf] = jackknife(ratio_arr[i_time,:,i_xf],n_bins,'bins')
		ratio_error = jackknife(ratio_arr[i_time,:,i_xf],n_bins,'error')
		if i_time > 0: # the first elements are not going to be needed anyways
			dEs_weight[i_time,i_xf] = 1/(dEs_error)
			ratio_weight[i_time,i_xf] = 1/(ratio_error)

### AT THIS STAGE dES AND RATIO HAVE BEEN BINNED SO THAT JACKKNIFE PROCESS
### CAN BE APPLIED ON THEM

for i_time in range(n_steps):
	Et_rec = jackknife(Et_arr[i_time,:,i_xf_rec],n_bins,'average')
	Et_err_rec = jackknife(Et_arr[i_time,:,i_xf_rec],n_bins,'error')
	Es_rec = jackknife(Es_arr[i_time,:,i_xf_rec],n_bins,'average')
	Es_err_rec = jackknife(Es_arr[i_time,:,i_xf_rec],n_bins,'error')
	dEt_rec = jackknife(dEt_arr[i_time,:,i_xf_rec],n_bins,'average')
	dEt_err_rec = jackknife(dEt_arr[i_time,:,i_xf_rec],n_bins,'error')
	dEs_rec = jackknife(dEs_arr[i_time,:,i_xf_rec],n_bins,'average')
	dEs_err_rec = jackknife(dEs_arr[i_time,:,i_xf_rec],n_bins,'error')
	ratio_rec = jackknife(ratio_arr[i_time,:,i_xf_rec],n_bins,'average')
	ratio_err_rec = jackknife(ratio_arr[i_time,:,i_xf_rec],n_bins,'error')
	f_write.write('%f %f %f %f %f %f %f %f %f %f %f\n'%(tau_arr[i_time],Et_rec,Et_err_rec,Es_rec,Es_err_rec,dEt_rec,dEt_err_rec,dEs_rec,dEs_err_rec,ratio_rec,ratio_err_rec))
f_write.close()
del Et_arr
del Es_arr
del dEt_arr	
del dEs_arr
del ratio_arr	

### AT THIS STAGE QUANTITES HAVE BEEN RECORDED FOR A SELECTED xf

w0_arr = np.zeros( ( n_bins , len(xf_vec) ) )
for i_xf in range(len(xf_vec)):
	for i_bins in range(n_bins):
		y_points = np.zeros(7) # dEs_arr VALUES
		x_points = np.zeros(7) # tau_arr VALUES
		w_points = np.zeros(7) # WEIGHTS
		clos_i = closest( dEs_binned[:,i_bins,i_xf] , 0.15 )
		for j in range(7):
			k = -3+j
			y_points[j] = dEs_binned[clos_i+k,i_bins,i_xf]
			x_points[j] = tau_arr[clos_i+k]
			w_points[j] = dEs_weight[clos_i+k,i_xf]

		coeffs = np.polyfit(x_points,y_points,4,w=w_points)
		coeffs[4] = coeffs[4] - 0.15
		solutions = np.roots(coeffs)
		for ii in range( len(solutions) ): # FOR SECURITY
			if solutions[ii] < tau_arr[clos_i+1] and solutions[ii] > tau_arr[clos_i-1] :
				w0_arr[i_bins,i_xf] = np.real(solutions[ii])
				break

### AT THIS STAGE WE HAVE w0 POINTS FOR EACH BIN

ratio_val_arr = np.zeros( ( n_bins , len(xf_vec) ) )
i_xf = -1
for xf_float in xf_float_vec:
	i_xf = i_xf + 1
	ratio_binned[:,:,i_xf] = np.multiply( ratio_binned[:,:,i_xf] , 1/(xf_float_vec[i_xf]*xf_float_vec[i_xf]) )
	for i_bins in range(n_bins):
		y_points = np.zeros(7) # ratio_arr VALUES
		x_points = np.zeros(7) # tau_arr VALUES
		w_points = np.zeros(7) # WEIGHTS
		clos_tau = closest( tau_arr , w0_arr[i_bins,i_xf] )
		for j in range(7):
			k = -3+j
			y_points[j] = ratio_binned[clos_tau+k,i_bins,i_xf]
			x_points[j] = tau_arr[clos_tau+k]
			w_points[j] = ratio_weight[clos_i+k,i_xf]
		coeffs = np.polyfit(x_points,y_points,4,w=w_points)
		ratio_val_arr[i_bins,i_xf] = np.real( np.polyval( coeffs , w0_arr[i_bins,i_xf] ) )
del coeffs
del solutions

### AT THIS STAGE WE HAVE THE RATIO POINTS FOR EACH BIN

### WE WILL CONSTRUCT FINAL SCALE AND ANISOTROPY VALUES ON OUR BINS.

xi_g = np.zeros( n_bins )
w0  = np.zeros( n_bins )
for i_bins in range(n_bins):
	coeffs = np.polyfit( xf_float_vec , ratio_val_arr[i_bins,:] , 1 ) # LINEAR FIT FOR SECURITY
	coeffs[1] = coeffs[1] - 1.0
	xi_g[ i_bins ] = np.real( np.roots(coeffs) )

### AT THIS STAGE WE HAVE THE RENORMALIZED ANISOTROPY FOR EACH BIN

	coeffs2 = np.polyfit( xf_float_vec , w0_arr[i_bins,:] , 2 )
	w0[ i_bins ] = np.real( np.polyval( coeffs2 , xi_g[i_bins] ) )
	w0[ i_bins ] = np.sqrt( w0[ i_bins ]  )		

### AT THIS STAGE WE HAVE w0 FOR EACH BIN
### JACKKNIFE AVERAGING AND ERROR FOR SCALE AND ANISOTROPY FOLLOWS

w0_av = 0
xi_g_av = 0
for i in range(n_bins) :
	w0_av = w0_av + w0[i]
	xi_g_av = xi_g_av + xi_g[i]	
w0_av = w0_av / n_bins
xi_g_av = xi_g_av / n_bins
w0_err = 0
xi_g_err = 0
for i in range(n_bins) :
	w0_err = w0_err + (w0[i]-w0_av)**2
	xi_g_err = xi_g_err + (xi_g[i]-xi_g_av)**2
w0_err = w0_err*(n_bins-1)/n_bins
w0_err = np.sqrt(w0_err)
xi_g_err = xi_g_err*(n_bins-1)/n_bins
xi_g_err = np.sqrt(xi_g_err)

print('%s %s %f %f %f %f'%(beta,x0,w0_av,w0_err,xi_g_av,xi_g_err))
