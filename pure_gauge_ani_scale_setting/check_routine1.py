### THIS PROGRAM NEEDS the flow files in a directory named and positioned as shown below. 

import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

# let us define xf_vec
xf_vec = [ '305' ]
xf_float_vec = [ 3.05 ]
# how many files?
n_files = 1
# how many flow steps?
n_steps = 160 # should be one more than flow output says. That is, for us initial point counts as a step!!!
tau_arr = np.zeros( n_steps )
# how many jackknife bins?
n_bins = 10

der_file = open('der_file','w')

dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))

i_xf = -1

print('\n Exracting energy derivative and ratio from flow files...')
for xf in xf_vec:
	
	i_xf = i_xf + 1
	
	for i_file in range(1001,n_files+1001):
		
		i = i_file - 1001
		f_read = open( '/mnt/scratch/trimisio/flows/wflow2448b61x246xf%sc_dt0.025/wflow2448b61x246xf%sc_dt0.025.%d'%( xf, xf, i_file ) , 'r' )
    
		content = f_read.readlines()
    
		i_time = 0

		Et_arr = np.zeros( n_steps )
		Es_arr = np.zeros( n_steps )

		dEt_arr = np.zeros( n_steps )
    
		for i_line in range(34,194): #ADJUST ACCORDING TO STEPS!!!!
        
			my_line = content[ i_line ].split(' ')
			if i_file == 1001 and i_xf == 0 : #the tau_array will be the same for all, so we form it once
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
			

			der_file.write( '%f %f\n'%(tau_arr[i_time],dEs_arr[i_time]) )

der_file.close()
