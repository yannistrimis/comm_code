import numpy as np

cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec'
nx=16
nt=16
vol = str(nx)+str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
i_file = input()
ens_name = vol+'b'+beta+'x'+x0+stream

f_write = open('%s/l%s/folded_spec%s.lat.%s'%(cur_dir,ens_name,ens_name,i_file),'w')
f_read_a = open('%s/l%s/clean_spec%s.lat.%sa'%(cur_dir,ens_name,ens_name,i_file),'r')
f_read_b = open('%s/l%s/clean_spec%s.lat.%sb'%(cur_dir,ens_name,ens_name,i_file),'r')

content_a = f_read_a.readlines()
content_b = f_read_b.readlines()

for i_line in range(len(content_a)) :
    split_a = content_a[i_line].split(' ')
    split_b = content_b[i_line].split(' ')
    if split_a[0] != split_b[0] :
        print('ERROR in line %d'%i_line)
    av_re = ( float(split_a[1])+float(split_b[1]) )/2
    av_im = ( float(split_a[2])+float(split_b[2]) )/2

    f_write.write('\n)






f_write.close()
f_read.close()
