import numpy as np
import math as mt
from rk_taylor_funcs_1 import *

# the following returns exp(a)*b, without the Y element, so that
# the f_taylor function can work more easily.

def my_exp(a,b,ord): #ord >= 2 !!!

    var2 = add('1',a)
    temp = a
    for i_ord in range(2,ord+1):
        temp = epimeristiki(temp,a)
        fc = mt.factorial(i_ord)
        sfc = str(int(fc))
        frac_sfc = "1" + "/" + sfc
        var = epimeristiki(frac_sfc,temp)
        var2 = add(var2,var)
    var3 = epimeristiki(var2,b)
    list_var3 = break_sum(var3)
    res = '0'
    for i in range(1,len(list_var3)):
        res = add(res,list_var3[i])

    return res

# a as in f(Y+a)=f_taylor(a,ord)
def f_taylor(a,ord):
    var1 = dY('f0')
    temp = a
    var2 = epimeristiki(temp,var1)
    res = add('f0',var2)
    for i_ord in range(2,ord+1):
        var1 = dY(var1)
        temp = epimeristiki(temp,a)
        var2 = epimeristiki(temp,var1)
        fc = mt.factorial(i_ord)
        sfc = str(int(fc))
        frac_sfc = "1" + "/" + sfc
        var3 = epimeristiki(frac_sfc,var2)
        res = add(res,var3)

    return res

# The following returns Y(t+h) as a Taylor expansion
# around t. It is the RHS of the equation that yields
# the order conditions.

def Y_taylor(ord):
    var1 = der('Y')
    temp = 'h'
    var2 = epimeristiki(temp,var1)
    res = add('Y',var2)
    for i_ord in range(2,ord+1):
        var1 = der(var1)
        temp = epimeristiki(temp,'h')
        var2 = epimeristiki(temp,var1)
        fc = mt.factorial(i_ord)
        sfc = str(int(fc))
        frac_sfc = "1" + "/" + sfc
        var3 = epimeristiki(frac_sfc,var2)
        res = add(res,var3)
    
    return res