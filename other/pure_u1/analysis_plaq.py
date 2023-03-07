import numpy as np
from python_funcs import *

my_dir = "/home/yannis/Physics/LQCD/pure_u1/data" # LAPTOP

n_of_lat = 60
beta_arr = [0.125, 0.25, 0.5, 1.0, 2.0, 4.0]
beta_str_arr = ["125", "250", "500", "1000","2000","4000"]

vol_arr = [8]

for i_vol in range(len(vol_arr)) :
    nx = vol_arr[i_vol]
    nt = vol_arr[i_vol]
    f_write = open('%s/l%s%s.averr'%(my_dir,str(nx),str(nt)),'w')

    for i_beta in range(len(beta_arr)) :
        beta = beta_arr[i_beta]
        beta_str = beta_str_arr[i_beta]
        ens_name = "l"+str(nx)+str(nt)+"b"+beta_str   
        f_name = my_dir +'/'+ ens_name
        f_read = open("%s_plaq"%f_name,"r")
        content = f_read.readlines()
        f_read.close()

        temp = np.zeros(n_of_lat)
        k=-1
        for j in range(len(content)-n_of_lat,len(content)):
            k = k + 1
            line = content[j].split(' ')
            temp[k] = float(line[1])

        average = jackknife(temp,12,"average")
        error = jackknife(temp,12,"error")
        f_write.write('%lf %lf %lf\n'%(beta,average,error))

    f_write.close()
