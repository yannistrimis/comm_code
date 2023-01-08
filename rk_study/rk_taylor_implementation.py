import numpy as np
import math as mt
from rk_taylor_funcs_1 import *
from rk_taylor_funcs_2 import *

# first we will form the LHS of the equation. This needs
# a sequence of my_exp() and f_taylor() applications.

# then we will subtract the RHS, which is just a single
# Y_talyor() application.

# next we will apply count_h() and write 4 equations for
# h^0, h^1, h^2, h^3. finally we will apply f_factorize()
# in each of the 4 equations.

order = 3

y1 = '1'
k1 = 'f0'

exp_content = mul('h','a121')
exp_content = epimeristiki(exp_content,k1)
y2_wt = my_exp(exp_content,y1,order) # the first Y is missing. Hence wt (without)
y2 = add('Y',y2_wt)
print(y2)

k2 = f_taylor(y2_wt,order-1)
print(k2)

exp_content1 = mul('h','a232')
exp_content1 = epimeristiki(exp_content1,k2)
exp_content2 = mul('h','a231')
exp_content2 = epimeristiki(exp_content2,k1)
exp_content = add(exp_content1,exp_content2)
y3_wt = my_exp(exp_content,y2,order)
y3 = add('Y',y3_wt)
print(y3)
y3_test = f_factorize(y3)
print(y3_test)

# k3 = f_taylor(y3_wt,order-1)
# print(k3)

# exp_content1 = mul('h','b33')
# exp_content1 = epimeristiki(exp_content1,k3)
# exp_content2 = mul('h','b32')
# exp_content2 = epimeristiki(exp_content2,k2)
# exp_content3 = mul('h','b31')
# exp_content3 = epimeristiki(exp_content3,k1)
# exp_content = add(exp_content1,exp_content2)
# exp_content = add(exp_content,exp_content3)
# y4_wt = my_exp(exp_content,y3,order)
# y4 = add('Y',y_wt)
# print(y4)