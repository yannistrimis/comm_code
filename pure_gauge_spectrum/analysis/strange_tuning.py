import numpy as np
from scipy.optimize import fsolve

w0 = 1.082917
a = 0.17355/w0

m_ss = 695
m_ss = m_ss/197.3
m_ss = m_ss*a

a0 = 0.141836
a1 = 8.17041
a2 = -51.1507
a3 = 179.744

def func(x):
    return - m_ss + a0 + a1*x + a2*x*x + a3*x*x*x

root = fsolve(func,0)

print(root)

print(func(root))
