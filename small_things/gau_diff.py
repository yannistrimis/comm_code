import numpy as np
import math as mt
av1s, err1s = input("type <av1> <er1>: ").split(" ")
av2s, err2s = input("type <av2> <er2>: ").split(" ")

av1 = float(av1s)
err1 = float(err1s)
av2 = float(av2s)
err2 = float(err2s)

test = abs( (av1-av2)/(np.sqrt(err1**2+err2**2)) )
Q = 1 - mt.erf(test/np.sqrt(2))

print(Q)
