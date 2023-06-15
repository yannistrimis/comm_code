import numpy as np
from sympy import cosh, nsolve
from sympy.abc import x

# THIS HAS TO BE PIPED INTO A FILE CALLED <something>.meff.data

nx = 16
nt = 32
vol = str(nx) + str(nt)
beta = '6850'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
sinks = input()
pre_name = input()

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/%s_m1_%s_m2_%s_%s.averr'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'r')
content = f_read.readlines()
f_read.close()

y_av = np.zeros(int(nt/2)+1)

def main() :

    meff = np.zeros(int(nt/2)-1)

    for i in range(int(nt/2)+1):
        line = content[i].split(' ')
        y_av[i] = float(line[1])

    for t in range(int(nt/2)-1):
        c1 = t - nt/2
        c2 = c1 + 2 
        f = cosh(x*c1)/cosh(x*c2)-y_av[t]/y_av[t+2]
        meff[t] = nsolve(f,x,1)

if __name__ == '__main__' :
    main()
