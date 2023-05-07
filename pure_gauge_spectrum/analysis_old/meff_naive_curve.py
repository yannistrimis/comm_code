import numpy as np

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
source1 = input()
source2 = input()
sinks = input()

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.fold.data'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'r')
content = f_read.readlines()
f_read.close()

n_of_meas = len(content)
x = np.zeros(int(nt/2)+1)
for i in range(int(nt/2)+1) :
    x[i] = float(i)

def main() :
    y_arr = np.zeros(( int(nt/2)+1, n_of_meas ))
    meff = np.zeros(int(nt/2))
    for kk in range(n_of_meas) :
        line = content[kk].split(' ')
        for i in range(int(nt/2)+1) :
            y_arr[i,kk] = float(line[i+1])
 
    y_av = np.average(y_arr,axis=1) 

    for i in range(int(nt/2)) :
        meff[i] = np.log( y_av[i]/y_av[i+1] )
        x_mid = x[i]+0.5
        print(x_mid,meff[i])



if __name__ == '__main__' :
    main()

