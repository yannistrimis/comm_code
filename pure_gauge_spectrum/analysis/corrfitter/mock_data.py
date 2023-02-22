import numpy as np

d_mock = 0.001
nt = 16
a = 0.22
E = 0.42

t_vec = range(0,16)
imag = 0.0
exact_g = np.zeros(16)
mock_g = np.zeros(16)

for i in range(16) :
    exact_g[i] = a*a*( np.exp(-E*i)+np.exp(-E*(nt-i)) )

filename = '/mnt/home/trimisio/plot_data/spec_data/l1616b7000x100a/spec_m1_1_m2_1_PION_5_CORNER_CORNER'

for i_file in range(101,301) :
    f_write = open( '%s.%d'%(filename,i_file),'w')
    for i in range(16) :
        mock_g[i] = np.random.normal(loc=exact_g[i],scale=d_mock,size=None)
        f_write.write( '%d %.16f %.16f\n'%(i,mock_g[i],imag) )

    f_write.close()
