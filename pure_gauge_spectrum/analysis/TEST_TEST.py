import numpy as np

an=-207
En=0.86
ao=163
Eo=0.522

for i in range(0,16):
    fi = an*( np.exp(-En*i)+np.exp(En*i-En*16) )+(-1)**i*ao*( np.exp(-Eo*i)+np.exp(Eo*i-Eo*16) ) 
    print('%d %f'%(i,fi))
