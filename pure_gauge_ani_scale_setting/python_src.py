### THIS PROGRAM NEEDS the flow files in a directory named and positioned as shown below. 

import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

# let us define xf_vec
xf_vec = [ '285', '295', '305' ]
xf_float_vec = [ 2.85, 2.95, 3.05 ]
# how many files?
n_files = 30
# how many flow steps?
n_steps = 160 # should be one more than flow output says. That is, for us initial point counts as a step!!!
tau_arr = np.zeros( n_steps )
# how many jackknife bins?
n_bins = 10

dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))

i_xf = -1

print('\n Exracting energy derivative and ratio from flow files...')
for xf in xf_vec:
	
	i_xf = i_xf + 1
	
	for i_file in range(101,n_files+101):
		
		i = i_file - 101
		f_read = open( '/mnt/scratch/trimisio/flows/wflow2448b10167x246xf%sc_dt0.025/wflow2448b10167x246xf%sc_dt0.025.%d'%( xf, xf, i_file ) , 'r' )
    
		content = f_read.readlines()
    
		i_time = 0

		Et_arr = np.zeros( n_steps )
		Es_arr = np.zeros( n_steps )

		dEt_arr = np.zeros( n_steps )
    
		for i_line in range(34,194): #ADJUST ACCORDING TO STEPS!!!!
        
			my_line = content[ i_line ].split(' ')
			if i_file == 101 and i_xf == 0 : #the tau_array will be the same for all, so we form it once
				tau_arr[i_time] = float( my_line[1] )
		

			Et_arr[i_time] = float( my_line[2] )
			Es_arr[i_time] = float( my_line[3] )
			
			Et_arr[i_time] = tau_arr[i_time]*tau_arr[i_time]*Et_arr[i_time]
			Es_arr[i_time] = tau_arr[i_time]*tau_arr[i_time]*Es_arr[i_time]
    
			i_time = i_time + 1

		f_read.close()

		dEt_arr = deriv( Et_arr , 0.025 )
		dEs_arr[:,i,i_xf] = deriv( Es_arr , 0.025 )

#WE WILL OMIT the first element because in the ratio there would be division by zero
		for i_time in range(1,n_steps) :
			dEt_arr[i_time] = dEt_arr[i_time] * tau_arr[i_time]
	
			dEs_arr[i_time,i,i_xf] = dEs_arr[i_time,i,i_xf] * tau_arr[i_time] #that one is important
			ratio_arr[i_time,i,i_xf] = (dEs_arr[i_time,i,i_xf])/(dEt_arr[i_time]) #and that one is important
			
	print( '\n%d out of %d'%(i_xf+1,len(xf_vec)) )
print(dEs_arr[:,0,0])
del dEt_arr

### AT THIS STAGE we have the 3-dimensional dEs_arr. ratio_arr that contain our data. The tau_arr
#contains the flow time points.

dEs_binned = np.zeros( ( n_steps , n_bins , len(xf_vec) ) )
ratio_binned = np.zeros( ( n_steps , n_bins , len(xf_vec) ) )

dEs_weight = np.zeros( ( n_steps , len(xf_vec) ) )
ratio_weight = np.zeros( ( n_steps , len(xf_vec) ) )

print('\n Jackkniving...')

for i_xf in range(len(xf_vec)):
	for i_time in range(n_steps):	
		dEs_binned[i_time,:,i_xf] = jackknife(dEs_arr[i_time,:,i_xf],n_bins,'bins')
		dEs_error = jackknife(dEs_arr[i_time,:,i_xf],n_bins,'error')
		
		ratio_binned[i_time,:,i_xf] = jackknife(ratio_arr[i_time,:,i_xf],n_bins,'bins')
		ratio_error = jackknife(ratio_arr[i_time,:,i_xf],n_bins,'error')
		if i_time > 0:# the first elements are not going to be needed anyways
			dEs_weight[i_time,i_xf] = 1/(dEs_error)
			ratio_weight[i_time,i_xf] = 1/(ratio_error)
		
	print( '\n	%d out of %d'%(i_xf+1,len(xf_vec)) )
	
del dEs_arr
del ratio_arr
		
### AT THIS STAGE we have the binned data and the weights for the fits.

w0_arr = np.zeros( ( n_bins , len(xf_vec) ) )

print('\n Calculating w0 points...')
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
		
	print( '\n%d out of %d'%(i_xf+1,len(xf_vec)) )
	
### AT THIS STAGE we have the w0 points.


ratio_val_arr = np.zeros( ( n_bins , len(xf_vec) ) )#the array that has the ratio values specifically at w0.

i_xf = -1

print('\n Calculating ratio points at corresponding w0 points...')

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

	print( '\n	%d out of %d'%(i_xf+1,len(xf_vec)) )

del coeffs
del solutions
### AT THIS STAGE we have the ratio points.
# We will construct #n_files final scale & anisotropy values on our jackknife bins.


xi_g = np.zeros( n_bins )
w0  = np.zeros( n_bins )

print('\n Implementing Wuppertal fig. 2 ...')
for i_bins in range(n_bins):
	
	coeffs = np.polyfit( xf_float_vec , ratio_val_arr[i_bins,:] , 1 )# linear fit, because if curved, then
	#for some configurations more than one intersections with 1.0 in reasonable range are obtained!
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

print('\nw0 = %f +/- %f '%(w0_av,w0_err)) 
print('xi_g = %f +/- %f '%(xi_g_av,xi_g_err))




