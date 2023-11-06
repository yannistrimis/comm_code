import numpy as np
from sympy import cosh, nsolve
from sympy.abc import x

nx=16
nt=64
vol = str(nx)+str(nt)
beta = '70805'
x0 = '18876'
stream = 'a'

# cur_dir = '/mnt/home/trimisio/plot_data/spec_data/l'+vol+'b'+beta+'x'+x0+stream # ICER
cur_dir = '/home/trimisio/all/spec_data/l'+vol+'b'+beta+'x'+x0+stream # FNAL

pre_name = input()
str_n_bins = input()
n_bins = int(str_n_bins)

f_write = open('%s/%s.coshmeffdata'%(cur_dir,pre_name),'w')

def main() :

    meff = np.zeros( (int(nt/2)-1,n_bins) )

    for i_bin in range(n_bins):
        print('i_bin=',i_bin)   
        f_read = open('%s/%s.specdata.jackbin_%d'%(cur_dir,pre_name,i_bin),'r')
        content = f_read.readlines()
        f_read.close()

        y_av = np.zeros(int(nt/2)+1)

        for i in range(int(nt/2)+1):
            line = content[i].strip()
            y_av[i] = float(line)

        for t in range(int(nt/2)-1):
            c1 = t - nt/2
            c2 = c1 + 2 
            f = cosh(x*c1)/cosh(x*c2)-y_av[t]/y_av[t+2]
            if t % 2 == 0 :
                print('t=',t)
                meff[t,i_bin] = nsolve(f,x,0.0,verify=False)

    meff_averr = np.zeros( (int(nt/2)-1,2) )
    for t in range(int(nt/2)-1):

        for i_bin in range(n_bins) :
            meff_averr[t,0] = meff_averr[t,0] + meff[t,i_bin]
        meff_averr[t,0] = meff_averr[t,0] / n_bins

        for i_bin in range(n_bins) :
            meff_averr[t,1] = meff_averr[t,1] + (meff[t,i_bin]-meff_averr[t,0])**2
        meff_averr[t,1] = meff_averr[t,1]*(n_bins-1)/n_bins
        meff_averr[t,1] = np.sqrt(meff_averr[t,1])
        if t % 2 == 0 : 
            f_write.write('%d %f %f\n'%(t, meff_averr[t,0],meff_averr[t,1]))
       
    f_write.close()


if __name__ == '__main__' :
    main()
