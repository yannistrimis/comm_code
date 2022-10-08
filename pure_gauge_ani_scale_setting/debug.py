import numpy as np
from python_funcs import *
from matplotlib import pyplot as plt

# let us define xf_vec
xf_vec = [ '285' ]
xf_float_vec = [ 2.85 ]
# how many files?
n_files = 1
# how many flow steps?
n_steps = 1000 # should be one more than flow output says. That is, for us initial point counts as a step!!!
tau_arr = np.zeros( n_steps )
# how many jackknife bins?
n_bins = 10

dEs_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))
ratio_arr = np.zeros(( n_steps , n_files , len(xf_vec) ))

i_xf = -1

print('\n Exracting energy derivative and ratio from flow files...')
for xf in xf_vec:
        
	i_xf = i_xf + 1
        
	for i_file in range(101,101+n_files,1):
                
		i = i_file - 101
		f_read = open( '/mnt/scratch/trimisio/flows/wflow2448b10167x246xf%sc_dt0.025mitsos/wflow2448b10167x246xf%sc_dt0.025.%d'%( xf, xf, i_file ) , 'r' )
		debug_f1 = open( 'debug_f1', 'w' )
		content = f_read.readlines()
    
		i_time = 0

		Et_arr = np.zeros( n_steps )
		Es_arr = np.zeros( n_steps )

		dEt_arr = np.zeros( n_steps )

		sin_tau = np.zeros( n_steps )
		cos_tau = np.zeros( n_steps )
		

		for i_line in range(34,1034): #ADJUST ACCORDING TO STEPS!!!!
        
			my_line = content[ i_line ].split(' ')
			if i_file == 101 and i_xf == 0 : #the tau_array will be the same for all, so we form it once
				tau_arr[i_time] = float( my_line[1] )
                

			Et_arr[i_time] = float( my_line[2] )
			Es_arr[i_time] = float( my_line[3] )
                        
			Et_arr[i_time] = tau_arr[i_time]*tau_arr[i_time]*Et_arr[i_time]
			Es_arr[i_time] = tau_arr[i_time]*tau_arr[i_time]*Es_arr[i_time]
    
			sin_tau[i_time] = np.sin(tau_arr[i_time])
			
			i_time = i_time + 1

		f_read.close()

		dEt_arr = deriv( Et_arr , 0.025 )
		dEs_arr[:,i,i_xf] = deriv( Es_arr , 0.025 )

		cos_tau = deriv( sin_tau , 0.025 )

#WE WILL OMIT the first element because in the ratio there would be division by zero
		for i_time in range(1,n_steps) :
			dEt_arr[i_time] = dEt_arr[i_time] * tau_arr[i_time]
        
			dEs_arr[i_time,i,i_xf] = dEs_arr[i_time,i,i_xf] * tau_arr[i_time]

			v1 = tau_arr[i_time]
			v2 = sin_tau[i_time]
			v3 = cos_tau[i_time]
			v4 = np.cos(v1)
			
			v5 = dEs_arr[i_time,i,i_xf]

			debug_f1.write( "%f %f %f %f %f\n"%(v1,v2,v3,v4,v5) )



debug_f1.close()
