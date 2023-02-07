import numpy as np
from python_funcs import *

nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

first_file = 101
last_file = 300 # DON'T FORGET, THERE ARE 2 FILES PER NUMBER

n_bins = 5

cur_dir = '/mnt/home/trimisio/plot_data/spec_data/'+'l'+ens_name

try_file = open('%s/folded_spec%s.lat.%da'%(cur_dir,ens_name,first_file),'r')
try_content = try_file.readlines()
length = len(try_content)

tau_arr = np.zeros(length)
for i in range(length) :
    line = try_content[i].split(' ')
    tau_arr[i] = int(line[0])

try_file.close()

write_1_re = open('%s/bins_re.dat'%(cur_dir),'w')
write_2_re = open('%s/av_err_re.dat'%(cur_dir),'w')
write_1_im = open('%s/bins_im.dat'%(cur_dir),'w')
write_2_im = open('%s/av_err_im.dat'%(cur_dir),'w')

my_bin_array_re = np.zeros(( length , n_bins ))
my_bin_array_im = np.zeros(( length , n_bins ))

my_array_re = np.zeros(( length , 2*(last_file-first_file+1) ))
my_array_im = np.zeros(( length , 2*(last_file-first_file+1) ))

my_av_re = np.zeros(length)
my_av_im = np.zeros(length)

my_err_re = np.zeros(length) 
my_err_im = np.zeros(length)

j = -1
for jj in range(first_file,last_file+1) :
    for i_source in ['a','b'] :
        j = j + 1
        f_read = open('%s/folded_spec%s.lat.%d%s'%(cur_dir,ens_name,jj,i_source),'r')
        content = f_read.readlines()
        for i in range(length) :
            line = content[i].split(' ')
            my_array_re[i,j] =  float(line[1])
            my_array_im[i,j] = float(line[2])
        
        f_read.close()

for i in range(length) :
    my_bin_array_re[i,:] = jackknife(my_array_re[i,:],n_bins,'bins')
    my_bin_array_im[i,:] = jackknife(my_array_im[i,:],n_bins,'bins')
    
    my_av_re[i] = jackknife(my_array_re[i,:],n_bins,'average')
    my_av_im[i]	= jackknife(my_array_im[i,:],n_bins,'average')
    
    my_err_re[i] = jackknife(my_array_re[i,:],n_bins,'error')
    my_err_im[i] = jackknife(my_array_im[i,:],n_bins,'error')

for i in range(length) :
    write_1_re.write( '%f '%(tau_arr[i]) )
    write_2_re.write( '%f '%(tau_arr[i]) )
    write_1_im.write( '%f '%(tau_arr[i]) )
    write_2_im.write( '%f '%(tau_arr[i]) )

    write_2_re.write( '%f %f\n'%(my_av_re[i],my_err_re[i]) )
    write_2_im.write( '%f %f\n'%(my_av_im[i],my_err_im[i]) )


    for j in range(n_bins) :
        write_1_re.write('%f '%(my_bin_array_re[i,j]))
        write_1_im.write('%f '%(my_bin_array_im[i,j]))

    write_1_re.write('\n')
    write_1_im.write('\n')
   

write_1_re.close()
write_2_re.close()
write_1_im.close()
write_2_im.close()
