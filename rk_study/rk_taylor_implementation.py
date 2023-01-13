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

y1 = 'Y'
k1 = 'f0'

exp_content = mul('h','a121')
exp_content = epimeristiki(exp_content,k1)
y2_wt = my_exp(exp_content,y1,order) # the first Y is missing. Hence wt (without)
y2 = add('Y',y2_wt)
y2 = gather(y2)
# print(y2)

k2 = f_taylor(y2_wt,order-1)
k2 = gather(k2)
# print(k2)

exp_content1 = mul('h','a232')
exp_content1 = epimeristiki(exp_content1,k2)
exp_content2 = mul('h','a231')
exp_content2 = epimeristiki(exp_content2,k1)
exp_content = add(exp_content1,exp_content2)
y3_wt = my_exp(exp_content,y2,order)
y3 = add('Y',y3_wt)
y3 = gather(y3)
# print(y3)

k3 = f_taylor(y3_wt,order-1)
k3 = gather(k3)
# print(k3)

exp_content1 = mul('h','b33')
exp_content1 = epimeristiki(exp_content1,k3)
exp_content2 = mul('h','b32')
exp_content2 = epimeristiki(exp_content2,k2)
exp_content3 = mul('h','b31')
exp_content3 = epimeristiki(exp_content3,k1)
exp_content = add(exp_content1,exp_content2)
exp_content = add(exp_content,exp_content3)
y4_wt = my_exp(exp_content,y3,order)
y4 = add('Y',y4_wt)
y4 = remove_Y(y4)
y4 = gather(y4) # This is the final form of the LHS.
# print(y4)  

rhs = Y_taylor(3)
rhs = remove_Y(rhs)
rhs = gather(rhs) # This is the final form of the RHS.
# print(rhs)

rhs = epimeristiki('-1',rhs)
all_lhs = add(y4,rhs) # all is brought to the LHS


# LHS is broken in powers of h:
all_0 = '0'
all_1 = '0'
all_2 = '0'
all_3 = '0'

list_all_lhs = break_sum(all_lhs)

for el in list_all_lhs :
    if count_h(el) == 0 :
        all_0 = add(all_0,el)
    elif count_h(el) == 1 :
        all_1 = add(all_1,el)
    elif count_h(el) == 2 :
        all_2 = add(all_2,el)
    elif count_h(el) == 3 :
        all_3 = add(all_3,el)

all_0 = remove_h(all_0)
all_1 = remove_h(all_1)
all_2 = remove_h(all_2)
all_3 = remove_h(all_3)

# print("%s = 0"%all_0)
# print('-----------------------------------')
# print("%s = 0"%all_1)
# print('-----------------------------------')
# print("%s = 0"%all_2)
# print('-----------------------------------')
# print("%s = 0"%all_3)
# print('-----------------------------------')

coef_0 = f_factorize(all_0)
coef_1 = f_factorize(all_1)
coef_2 = f_factorize(all_2)
coef_3 = f_factorize(all_3)

for i in range(len((coef_0)[0])) :
    print("%s = 0 , %s\n"%(coef_0[1][i],coef_0[0][i]))
for i in range(len((coef_1)[0])) :
    print("%s = 0 , %s\n"%(coef_1[1][i],coef_1[0][i]))
for i in range(len((coef_2)[0])) :
    print("%s = 0 , %s\n"%(coef_2[1][i],coef_2[0][i]))
for i in range(len((coef_3)[0])) :
    print("%s = 0 , %s\n"%(coef_3[1][i],coef_3[0][i]))