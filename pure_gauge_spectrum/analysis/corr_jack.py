import numpy as np
from python_funcs import *

nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()

n_bins = 20

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.data'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'r')
content = f_read.readlines()
n_of_files = len(content)

tau_arr = np.zeros(nt)
for i in range(nt) :
    tau_arr[i] = i

f_read.close()

write_1_re = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.bins'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'w')
write_2_re = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.averr'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'w')

my_bin_array_re = np.zeros(( nt , n_bins ))
my_array_re = np.zeros(( nt , n_of_files ))
my_av_re = np.zeros(nt)
my_err_re = np.zeros(nt) 

for j in range(n_of_files) :
    line = content[j].split(' ')
    for i in range(nt) :
        my_array_re[i,j] =  float(line[i+1])

for i in range(nt) :
    my_bin_array_re[i,:] = jackknife(my_array_re[i,:],n_bins,'bins')
    my_av_re[i] = jackknife(my_array_re[i,:],n_bins,'average')    
    my_err_re[i] = jackknife(my_array_re[i,:],n_bins,'error')
 
for i in range(nt) :
    write_1_re.write( '%d '%(tau_arr[i]) )
    write_2_re.write( '%d '%(tau_arr[i]) )

    write_2_re.write( '%.16f %.16f\n'%(my_av_re[i],my_err_re[i]) )

    for j in range(n_bins-1) :
        write_1_re.write('%.16f '%(my_bin_array_re[i,j]))

    write_1_re.write('%.16f\n'%(my_bin_array_re[i,n_bins-1]))
   

write_1_re.close()
write_2_re.close()

