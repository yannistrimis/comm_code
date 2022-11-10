import numpy as np
import random as rd
from matplotlib import pyplot as plt
# PART (a)
time = 10.0
dt = 0.01

n_t = int(time/dt)
n_toy = 1000

res = np.zeros(n_t)

for i_toy in range(n_toy) :
