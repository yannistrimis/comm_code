import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

beta_x0_length = open('beta_x0_length','r')
xf_file = open('xi_f_arr','r')
xf_float_file = open('xi_f_flo','r')

content_1 = beta_x0_length.readlines()
content_2 = xf_file.readlines()
content_3 = xf_float_file.readlines()

lines_1 = content_1[0].split(' ')
beta = lines_1[0]
x0 = lines_1[1]
length = int( lines_1[2] )

xf_vec = [None]*length
xf_float_vec = [None]*length

for i in range(length):
	xf_vec[i] = content_2[i].strip()
	xf_float_vec[i] = float(content_3[i].strip())

beta_x0_length.close()
xf_file.close()
xf_float_file.close()

n_files = 400
first_file = 101
first_line = 39 # to be fed to range()
last_line = 136 # to be fed to range()
n_steps = 97 # should be one more than flow output says. That is, for us initial point counts as a step!!!
tau_arr = np.zeros( n_steps )
n_bins = 10

dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))


i_xf = -1

for xf in xf_vec:
	
	i_xf = i_xf + 1
	
	for i_file in range(first_file,n_files+first_file):
		
		i = i_file - first_file
		f_read = open( '/home/data/fnal_unzipped/runflowl1632b%sx%sa/sflow1632b%sx%sxf%sa_dt0.025.lat.%d'%(beta,x0,beta,x0,xf,i_file) , 'r' )
    
		content = f_read.readlines()
    
		i_time = 0

		Et_arr = np.zeros( n_steps )
		Es_arr = np.zeros( n_steps )

		dEt_arr = np.zeros( n_steps )
    
		for i_line in range(first_line,last_line): #ADJUST ACCORDING TO STEPS!!!!
        
			my_line = content[ i_line ].split(' ')
			if i_file == first_file and i_xf == 0 : #the tau_array will be the same for all, so we form it once
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

del dEt_arr

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
		if i_time > 0:# the first elements are not going to be needed anyways
			dEs_weight[i_time,i_xf] = 1/(dEs_error)
			ratio_weight[i_time,i_xf] = 1/(ratio_error)
	
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
