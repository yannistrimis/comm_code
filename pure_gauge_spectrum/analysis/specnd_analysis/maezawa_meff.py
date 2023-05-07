import numpy as np

# THIS HAS TO BE PIPED INTO A FILE CALLED <something>.maezawa_meff.data

nx = 16
nt = 32
vol = str(nx) + str(nt)
beta = '6850'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()
pre_name = input()
fitter_tag = input()

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/%s_m1_%s_m2_%s_%s.%s.measpoints'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks,fitter_tag),'r')
content = f_read.readlines()
f_read.close()

y_av = np.zeros(int(nt/2))

def main() :
    meff_NO = np.zeros(int(nt/2)-3)
    meff_O = np.zeros(int(nt/2)-3)
    for i in range(int(nt/2)):    
        line = content[i].split(' ')
        y_av[i] = float(line[1])

    for i in range(int(nt/2)-3) :

        g0 = y_av[i]
        g1 = y_av[i+1]
        g2 = y_av[i+2]
        g3 = y_av[i+3]

        A = g1**2-g2*g0
        B = g3*g0 - g2*g1
        C = g2**2 - g3*g1
        
        x_NO = -B/(2*A) + np.sqrt(B**2-4*A*C)/(2*np.abs(A))
       	x_O = B/(2*A) + np.sqrt(B**2-4*A*C)/(2*np.abs(A))

        meff_NO[i] = -np.log(x_NO)
        meff_O[i] = -np.log(x_O) 
        print(i,meff_NO[i],meff_O[i],A*C)



if __name__ == '__main__' :
    main()

