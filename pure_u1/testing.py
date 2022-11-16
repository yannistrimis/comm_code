import numpy as np
from utils import *

a=16**4
with open("test4.npy", "rb") as f:
   RNP = np.load(f)
f.close()

l=0.0

for i in range(4):
   for j in range(a):
      l=l+RNP[i,j]

l=l/(a*4)
print(l)