import numpy as np
from scipy.optimize import fsolve

w0 = 0.87915
a = 0.17355/w0 # FLAG 2021

m_ss = 685.8 # MeV FROM 0910.1229
m_ss = m_ss/197.3
m_ss = m_ss*a

a0 = 0.00346978
a1 = 4.70716
a2 = 0
a3 = 0

def func(x):
    return - m_ss**2 + a0 + a1*x + a2*x*x + a3*x*x*x

root = fsolve(func,0)
print(root)

print(func(root))
