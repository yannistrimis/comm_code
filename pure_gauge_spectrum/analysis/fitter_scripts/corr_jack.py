import numpy as np
from python_funcs import *

nx = 16
lat_nt = 32
vol = str(nx) + str(lat_nt)
beta = '6850'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
sinks = input()
pre_name = input()

n_bins = 40

nt = int(lat_nt/2)+1 # QUICK SOLUTION FOR FOLDED DATA


cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/%s_m1_%s_m2_%s_%s.fold.data'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'r')
content = f_read.readlines()
n_of_files = len(content)

if (n_of_files%n_bins) != 0 :
    print('WARNING: number of bins does not divide number of files')

tau_arr = np.zeros(nt)
for i in range(nt) :
    tau_arr[i] = i

f_read.close()

write_1_re = open('%s/l%s/%s_m1_%s_m2_%s_%s.fold.jack.data'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'w')
write_2_re = open('%s/l%s/%s_m1_%s_m2_%s_%s.averr'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'w')

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
    write_2_re.write( '%d %.16f %.16f\n'%(tau_arr[i],my_av_re[i],my_err_re[i]) )

for i_bin in range(n_bins) :
    write_1_re.write('PROP')
    for i in range(nt) :
        write_1_re.write( ' %.16f'%my_bin_array_re[i,i_bin] )
    write_1_re.write('\n')
   

write_1_re.close()
write_2_re.close()

