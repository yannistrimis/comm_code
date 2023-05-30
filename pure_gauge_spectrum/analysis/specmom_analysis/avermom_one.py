# 4 SPACES INSTEAD OF TAB
import numpy as np

out_dir = '/mnt/home/trimisio/plot_data/spec_data'
nx=16
nt=32
vol = str(nx)+str(nt)
beta = '6850'
x0 = '100'
stream = 'a'

mom_list = []

i_file = input() # FILE NUMBER
mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
n_of_mom = int(input())
for i in range(n_of_mom):
        moml = input()
        mom_list.append(moml)
sinks = input()
pre_name = input()

ens_name = vol+'b'+beta+'x'+x0+stream

f_write = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'w')

for i_line in range(nt) :
    re = 0.0
    im = 0.0

    for i_mom in range(n_of_mom):
        f_read = open('%s/l%s/%s%s_spec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,mom_list[i_mom],mass1,mass2,sinks,i_file),'r')
        content = f_read.readlines()
        splitt = content[i_line].split(' ')

        re = re + float(splitt[1])
        im = im + float(splitt[2])

        f_read.close()

    re = re/n_of_mom
    im = im/n_of_mom

    f_write.write('%s %.16f %.16f\n'%(splitt[0],re,im))

f_write.close()

