import numpy as np
from utils import *
from action import *

nx=4
nt=4

lattice = np.zeros((4,nx**3*nt))
lattice = hot(nx**3*nt,D_hot)

