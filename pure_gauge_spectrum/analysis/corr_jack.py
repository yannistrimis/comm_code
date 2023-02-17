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

first_file = 101
last_file = 300 # DON'T FORGET, THERE ARE 2 FILES PER NUMBER

n_bins = 30

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

try_file = open('%s/l%s/fold_m1_%s_m2_%s_%s_%s_%s.%sa'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2,first_file),'r')
try_content = try_file.readlines()
length = len(try_content)

tau_arr = np.zeros(length)
for i in range(length) :
    line = try_content[i].split(' ')
    tau_arr[i] = int(line[0])

try_file.close()

write_1_re = open('%s/l%s/bins_re_m1_%s_m2_%s_%s_%s_%s.dat'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'w')
write_2_re = open('%s/l%s/av_err_re_m1_%s_m2_%s_%s_%s_%s.dat'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'w')

my_bin_array_re = np.zeros(( length , n_bins ))

my_array_re = np.zeros(( length , 2*(last_file-first_file+1) ))

my_av_re = np.zeros(length)

my_err_re = np.zeros(length) 

j = -1
for jj in range(first_file,last_file+1) :
    for i_source in ['a','b'] :
        j = j + 1
        f_read = open('%s/l%s/fold_m1_%s_m2_%s_%s_%s_%s.%s%s'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2,jj,i_source),'r')
        content = f_read.readlines()
        for i in range(length) :
            line = content[i].split(' ')
            my_array_re[i,j] =  float(line[1])
        
        f_read.close()

for i in range(length) :
    my_bin_array_re[i,:] = jackknife(my_array_re[i,:],n_bins,'bins')
    my_av_re[i] = jackknife(my_array_re[i,:],n_bins,'average')    
    my_err_re[i] = jackknife(my_array_re[i,:],n_bins,'error')
 
for i in range(length) :
    write_1_re.write( '%f '%(tau_arr[i]) )
    write_2_re.write( '%f '%(tau_arr[i]) )

    write_2_re.write( '%.16f %.16f\n'%(my_av_re[i],my_err_re[i]) )

    for j in range(n_bins-1) :
        write_1_re.write('%.16f '%(my_bin_array_re[i,j]))

    write_1_re.write('%.16f\n'%(my_bin_array_re[i,n_bins-1]))
   

write_1_re.close()
write_2_re.close()

