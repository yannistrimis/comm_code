# 4 SPACES INSTEAD OF TAB
import numpy as np

# out_dir = '/mnt/home/trimisio/plot_data/spec_data' # ICER

out_dir = '/home/trimisio/all/spec_data' # FNAL


ens_name = input()
name = input()
str_first_file = input()
str_last_file = input()

first_file = int(str_first_file)
last_file = int(str_last_file)

f_write = open('%s/l%s/%s.specdata'%(out_dir,ens_name,name),'w')

for i_file in range(first_file,last_file+1):
    f_read = open('%s/l%s/foldspec%s.%d'%(out_dir,ens_name,name,i_file),'r')
    content = f_read.readlines()
    f_write.write( 'PROP' )
    for i_line in range(len(content)) :
        split = content[i_line].split(' ')
        f_write.write( ' %s'%(split[1]) )
    f_write.write('\n')
    f_read.close()

f_write.close()

print("first file: %d\nlast file: %d"%(first_file,last_file) )
