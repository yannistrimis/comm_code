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
n_of_mom = int(input())
for i in range(n_of_mom):
        moml = input()
        mom_list.append(moml)
mom_label = input()
sinks = input()
xq = input()
pre_name = input()

ens_name = vol+'b'+beta+'x'+x0+stream

f_write =  open('%s/l%s/%s_xq%s%s_foldspec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,xq,mom_label,mass1,mass2,sinks,i_file),'w')

for i_line in range(int(nt/2)+1) :
    re = 0.0
    im = 0.0

    for i_mom in range(n_of_mom):
        f_read = open('%s/l%s/%s_xq%s%s_foldspec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,xq,mom_list[i_mom],mass1,mass2,sinks,i_file),'r')
        content = f_read.readlines()
        splitt = content[i_line].split(' ')

        re = re + float(splitt[1])
        im = im + float(splitt[2])

        f_read.close()

    re = re/n_of_mom
    im = im/n_of_mom

    f_write.write('%s %.16f %.16f\n'%(splitt[0],re,im))

f_write.close()

