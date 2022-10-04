import numpy as np
from matplotlib import pyplot as plt

# THIS IS FOR HPCC

N_lat = 20
i_col = 1 # 1 for re[polyakov], 2 for im[polyakov], 4 for ss plaq, 5 for st plaq
obs = 're_polyakov'

dir_a = '/mnt/scratch/trimisio/lattices/lat2448b10167x246a/outs'
dir_b = '/mnt/scratch/trimisio/lattices/lat2448b10167x246b/outs'
dir_c = '/mnt/scratch/trimisio/lattices/lat2448b10167x246c/outs'

out_a = 'out2448b10167x246a'
out_b = 'out2448b10167x246b'
out_c = 'out2448b10167x246c'

f_write_a = open('%s_a'%obs,'w')
f_write_b = open('%s_b'%obs,'w')
f_write_c = open('%s_c'%obs,'w')

time = 0

for i in range(N_lat):
	
	i_lat = i + 1

	f_read_a = open( '%s/%s.%i'%( dir_a , out_a , i_lat  ) , 'r' )  
	f_read_b = open( '%s/%s.%i'%( dir_b , out_b , i_lat  ) , 'r' )
	f_read_c = open( '%s/%s.%i'%( dir_c , out_c , i_lat  ) , 'r' )

	content_a = f_read_a.readlines()
	content_b = f_read_b.readlines()
	content_c = f_read_c.readlines()	

	f_read_a.close()
	f_read_b.close()
	f_read_c.close()
	
	for j in range(4):

		time = time + 1	
		
		if i==0:
			my_line_a = content_a[ 36 + j ].split(' ')
			my_line_b = content_b[ 36 + j ].split(' ')
			my_line_c = content_c[ 36 + j ].split(' ')
		else:
                        my_line_a = content_a[ 39 + j ].split(' ')
                        my_line_b = content_b[ 39 + j ].split(' ')
                        my_line_c = content_c[ 39 + j ].split(' ')

	
		plaq_a = my_line_a[i_col]
		plaq_b = my_line_b[i_col]
		plaq_c = my_line_c[i_col]

		f_write_a.write( '%i %s\n'%(time,plaq_a) )
		f_write_b.write( '%i %s\n'%(time,plaq_b) )
		f_write_c.write( '%i %s\n'%(time,plaq_c) )

f_write_a.close()
f_write_b.close()
f_write_c.close()
