import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

cur_dir = '/mnt/home/trimisio/outputs'
vol = '2040'
beta = '7167'
x0 = '18205'
stream = 'a'
flow_type = 'w'
xf_vec = ['180','186','190','194','200']
xf_float_vec = [1.80,1.86,1.90,1.94,2.00]
dt = 0.015625
n_files = 50
first_file = 101
n_bins = 10
n_steps = 193 # one more than the number appearing at the flow file

tau_arr = np.zeros( n_steps )

Es_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
Et_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
dEt_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))

#f_write = open( 'tau_Et_Es_dEt_dEs_ratio_sflow%sb%sx%sdt%s'%(vol,beta,x0,dt) , 'w' )
#i_xf_rec = 0
i_xf = -1

for xf in xf_vec:
	
	i_xf = i_xf + 1
	
	for i_file in range(first_file,n_files+first_file):
		
		i = i_file - first_file
		f_read = open( '%s/l%sb%sx%s%s/%sflow%sb%sx%sxf%s%s_dt%s.lat.%d'%(cur_dir,vol,beta,x0,stream,flow_type,vol,beta,x0,xf,stream,dt,i_file) , 'r' )
    
		content = f_read.readlines()
    
		i_time = 0

		for i_line in range(len(content)): #ADJUST ACCORDING TO STEPS!!!!
        
			my_line = content[ i_line ].split(' ')
            
            if my_line[1] == 'COMPLETED'
                break

			if my_line[0] == 'GFLOW:' :
				if i_file == first_file and i_xf == 0 : #the tau_array will be the same for all, so we form it once
					tau_arr[i_time] = float( my_line[1] )
		

				Et_arr[i_time,i,i_xf] = float( my_line[2] )
				Es_arr[i_time,i,i_xf] = float( my_line[3] )
			
				Et_arr[i_time,i,i_xf] = tau_arr[i_time]*tau_arr[i_time]*Et_arr[i_time,i,i_xf]
				Es_arr[i_time,i,i_xf] = tau_arr[i_time]*tau_arr[i_time]*Es_arr[i_time,i,i_xf]
    
				i_time = i_time + 1

		f_read.close()

		dEt_arr[:,i,i_xf] = deriv( Et_arr[:,i,i_xf] , dt )
		dEs_arr[:,i,i_xf] = deriv( Es_arr[:,i,i_xf] , dt )

#WE WILL OMIT the first element because in the ratio there would be division by zero
		for i_time in range(1,n_steps) :
			dEt_arr[i_time,i,i_xf] = dEt_arr[i_time,i,i_xf] * tau_arr[i_time]
	
			dEs_arr[i_time,i,i_xf] = dEs_arr[i_time,i,i_xf] * tau_arr[i_time] #that one is important
			ratio_arr[i_time,i,i_xf] = (dEs_arr[i_time,i,i_xf])/(dEt_arr[i_time,i,i_xf]) #and that one is important


### AT THIS STAGE we have the 3-dimensional dEs_arr. ratio_arr that contain our data. The tau_arr
#contains the flow time points.

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

#for i_time in range(n_steps):
#	Et_rec = jackknife(Et_arr[i_time,:,i_xf_rec],n_bins,'average')
#	Et_err_rec = jackknife(Et_arr[i_time,:,i_xf_rec],n_bins,'error')
#	Es_rec = jackknife(Es_arr[i_time,:,i_xf_rec],n_bins,'average')
#	Es_err_rec = jackknife(Es_arr[i_time,:,i_xf_rec],n_bins,'error')
#	dEt_rec = jackknife(dEt_arr[i_time,:,i_xf_rec],n_bins,'average')
#	dEt_err_rec = jackknife(dEt_arr[i_time,:,i_xf_rec],n_bins,'error')
#	dEs_rec = jackknife(dEs_arr[i_time,:,i_xf_rec],n_bins,'average')
#	dEs_err_rec = jackknife(dEs_arr[i_time,:,i_xf_rec],n_bins,'error')
#	ratio_rec = jackknife(ratio_arr[i_time,:,i_xf_rec],n_bins,'average')
#	ratio_err_rec = jackknife(ratio_arr[i_time,:,i_xf_rec],n_bins,'error')

#	f_write.write('%f %f %f %f %f %f %f %f %f %f %f\n'%(tau_arr[i_time],Et_rec,Et_err_rec,Es_rec,Es_err_rec,dEt_rec,dEt_err_rec,dEs_rec,dEs_err_rec,ratio_rec,ratio_err_rec))

#f_write.close()

del Et_arr
del Es_arr
del dEt_arr	
del dEs_arr
del ratio_arr
		
### AT THIS STAGE we have the binned data and the weights for the fits.

w0_arr = np.zeros( ( n_bins , len(xf_vec) ) )

for i_xf in range(len(xf_vec)):
	
	for i_bins in range(n_bins):
		
		y_points = np.zeros(7) #dEs_arr values
		x_points = np.zeros(7) #tau_arr values
		w_points = np.zeros(7) #weights
		
		clos_i = closest( dEs_binned[:,i_bins,i_xf] , 0.15 )
		
		for j in range(7):
		
			k = -3+j
			
			y_points[j] = dEs_binned[clos_i+k,i_bins,i_xf]
			x_points[j] = tau_arr[clos_i+k]
			w_points[j] = dEs_weight[clos_i+k,i_xf]
			

		coeffs = np.polyfit(x_points,y_points,4,w=w_points) #the coeffs of the fitted polynomial. 
		#It lists the polynomial coeffs from largest power to smallest.
		
		coeffs[4] = coeffs[4] - 0.15
				
		solutions = np.roots(coeffs)

		for ii in range( len(solutions) ): #that polynomial might cross y=0.15 in several locations!!!
			
			if solutions[ii] < tau_arr[clos_i+1] and solutions[ii] > tau_arr[clos_i-1] :
					
				w0_arr[i_bins,i_xf] = np.real(solutions[ii])
				break
	
### AT THIS STAGE we have the w0 points.


ratio_val_arr = np.zeros( ( n_bins , len(xf_vec) ) )#the array that has the ratio values specifically at w0.

i_xf = -1

for xf_float in xf_float_vec:
	
	i_xf = i_xf + 1
	
	ratio_binned[:,:,i_xf] = np.multiply( ratio_binned[:,:,i_xf] , 1/(xf_float_vec[i_xf]*xf_float_vec[i_xf]) )#this
	#is the quantity needed in the Wuppertal paper
	
	for i_bins in range(n_bins):
	
		y_points = np.zeros(7) #ratio_arr values
		x_points = np.zeros(7) #tau_arr values
		w_points = np.zeros(7) #weights
		
		clos_tau = closest( tau_arr , w0_arr[i_bins,i_xf] )
		
		for j in range(7):
		
			k = -3+j
			
			y_points[j] = ratio_binned[clos_tau+k,i_bins,i_xf]
			x_points[j] = tau_arr[clos_tau+k]
			w_points[j] = ratio_weight[clos_i+k,i_xf]
			
		coeffs = np.polyfit(x_points,y_points,4,w=w_points) #the coeffs of the fitted polynomial. 
		#It lists the polynomial coeffs from largest power to smallest.
		ratio_val_arr[i_bins,i_xf] = np.real( np.polyval( coeffs , w0_arr[i_bins,i_xf] ) )


del coeffs
del solutions
### AT THIS STAGE we have the ratio points.
# We will construct #n_files final scale & anisotropy values on our jackknife bins.


xi_g = np.zeros( n_bins )
w0  = np.zeros( n_bins )

for i_bins in range(n_bins):
	
	coeffs = np.polyfit( xf_float_vec , ratio_val_arr[i_bins,:] , 1 )# linear fit, because if curved, then
	#for some bins more than one intersections with 1.0 in reasonable range are obtained!
	coeffs[1] = coeffs[1] - 1.0
	xi_g[ i_bins ] = np.real( np.roots(coeffs) )
	
	### AT THIS STAGE we have the gauge anisotropy.
	
	coeffs2 = np.polyfit( xf_float_vec , w0_arr[i_bins,:] , 4 )
	w0[ i_bins ] = np.real( np.polyval( coeffs2 , xi_g[i_bins] ) )
	w0[ i_bins ] = np.sqrt( w0[ i_bins ]  )	
	
### AT THIS STAGE we have gauge anisotropy and scale for all bins. Now we need to find average and error:

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
