import numpy as np
from sympy import cosh, nsolve
from sympy.abc import x

nx=16
nt=32
vol = str(nx)+str(nt)
beta = '6850'
x0 = '100'
stream = 'a'

cur_dir = '/mnt/home/trimisio/plot_data/spec_data/l'+vol+'b'+beta+'x'+x0+stream


f1 = input()

f_read = open('%s/%s.averr'%(cur_dir,f1),'r')
content = f_read.readlines()
f_read.close()

f_write = open('%s/%s.coshmeff.data'%(cur_dir,f1),'w')

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
        if t % 2 == 0 :
            meff[t] = nsolve(f,x,1)
            f_write.write( '%d %f\n'%(t,meff[t]) )
    f_write.close()

if __name__ == '__main__' :
    main()
