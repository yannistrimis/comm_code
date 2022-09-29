import numpy as np
import math as mt


# A function which deletes empty places at the end of a list

def delete_blanks(a):
    
    length=0
    for i in range(len(a)):
            
        if a[i]=='':
            break
        length=length+1

    a_2=['']*length
        
    for i in range(length):
        a_2[i]=a[i]

    return a_2



  
    
    
# A function that determines whether an object is an integer or
# a division between integers

def isnumber(a):
    
    for i in range(len(a)):
        if a[i].isdigit()==False and a[i] != '/' and a[i]!='-':
            return False
    return True








# Now a function that extracts numerator and denominator from a fraction

def num_den(b):    
            
    loc_b=b.find('/')
    
    if loc_b==-1:    
    
        if b=='' or b=='0':
            
            return '0', '1'
    
        else:
        
            return b, '1'
    
    
    num_b=''
    den_b=''
            
    for k in range(loc_b):
                
        num_b=num_b+b[k]
                
    for k in range(len(b)-loc_b-1):
                
        den_b=den_b+b[loc_b+k+1]    
        
    return num_b, den_b










# Let us define addition for general expressions

def add(a,b):
    
    if isnumber(a) and isnumber(b):
        
        num_a, den_a = num_den(a)
            
        num_b, den_b = num_den(b)

        if int(den_a)==1 and int(den_b)==1:
            
            return str( int(num_a)+int(num_b) )
        
        else:
            
            a1=int(num_a)
            a2=int(den_a)
            b1=int(num_b)    
            b2=int(den_b)
            
            lcm=int(np.lcm(a2,b2))
            denom=str(lcm)
            numer=str( int(a1*lcm/a2) + int(b1*lcm/b2) )
            
            if int( np.gcd( int(numer), int(denom) ) )==int(denom):
                return str( int( int(numer)/int(denom) ) )
            else:
                return numer+'/'+denom
        
    
    elif a=='' or a=='0':
        return b
    elif b=='' or b=='0':
        return a
    else:
        return a+'+'+b













# Let us define multiplication for general expressions. 


def mul(a,b):

    if isnumber(a) and isnumber(b):
        
        num_a, den_a = num_den(a)
                
        num_b, den_b = num_den(b)
        
        if num_a=='0' or num_b=='0':
            return '0'
            
        if int(den_a)*int(den_b)==1:
            res = str( int(num_a)*int(num_b) )
            
        else:
            res = str( int(num_a)*int(num_b) ) \
            +'/'+ str( int(den_a)*int(den_b) )
            
        return res
    
    elif a=='1':
        return b
    elif b=='1':
        return a
    elif b=='0' or a=='0' or b=='' or a=='':
        return '0'  
    else:
        return a+'*'+b
    

    
    
    

# Let us define derivative of f with respect to Y. f0 is f, f1 is f' etc.

def dY(a):
    
    if a=='':
        return '0'
    
    b=list(a)
    c=int(b[1])
    c=c+1
    d=str(c)
    return b[0]+d




# Let us define derivative of an object with respect to time.

def dt(a):
    
    if a=='' or isnumber(a):
        return '0'
    
    if a[0]=='f':
        
        return dY(a)+'*f0*Y'
    
    elif a=='Y':
        
        return 'f0*Y'
    
    
    
    
    
    
    
# Let us define a function that breaks a product into its components.

def break_prod(a): 
    
    el_a=['']*len(a)
    el_a_i=0
    el_a_temp=''
        
# The following bit breaks product into list, 
# but many empty places are left.   
        
    for i in range(len(a)):
        if a[i]=='*':
            el_a[ el_a_i ]=el_a_temp
            el_a_temp=''
            el_a_i=el_a_i+1
        else:
            el_a_temp=el_a_temp+a[i]
                
    el_a[ el_a_i ]=el_a_temp
        
# The following bit will get rid of the empty places.
        
    el_a_2=delete_blanks(el_a)

        
    return el_a_2





# Let us define a function that breaks a sum into its components.

def break_sum(a): 
    
    el_a=['']*len(a)
    el_a_i=0
    el_a_temp=''
        
# The following bit breaks sum into list, 
# but many empty places are left.   
        
    for i in range(len(a)):
        if a[i]=='+':
            el_a[ el_a_i ]=el_a_temp
            el_a_temp=''
            el_a_i=el_a_i+1
        else:
            el_a_temp=el_a_temp+a[i]
                
    el_a[ el_a_i ]=el_a_temp
        
# The following bit will get rid of the empty places.
        
    el_a_2=delete_blanks(el_a)

        
    return el_a_2
  
    
    
  
    
    
    
# Let us define a function that takes a product and places 
# all numbers in front.
    
def num_in_front(a):
    
    a_list=break_prod(a)
    
    nums=['']*len(a_list)
    
    i_nums=-1
    
    for i in range(len(a_list)):
        
        if isnumber(a_list[i]):
            
            i_nums=i_nums+1
            
            nums[i_nums]=a_list[i]
            
            
    new_a='1'
    
    for i in range(i_nums+1):

        new_a=mul(new_a,nums[i])
            
    for i in range(len(a_list)):
            
            if isnumber(a_list[i]):
                continue
            else:
                new_a=mul(new_a,a_list[i])
                
    return new_a
    
    
    
    
    
    
    
    
 
    
# Let us define derivative of a product with respect to time. "a" is 
# a string like '...*f0*f1*Y*f1*...'

def d_prod(a):
    
    if a=='' or isnumber(a):
        return '0'
    

# The following bit will calculate the derivative and put terms in list.

    prod_list=break_prod(a)
    
    res_list=['1']*len(prod_list)
    
    
    
    for i in range(len(prod_list)):
        
        temp_list=list(prod_list)
        
        temp_list[i] = dt(prod_list[i])
        
# The following 4 lines are just for checking. Instead of calculating the 
# actual derivative, a 'd' is added in front of every object.
        
        # if isnumber(temp_list[i]):
        #     temp_list[i]='0'
        # else:
        #     temp_list[i] = 'd' + prod_list[i]
        
        for j in range(len(prod_list)):
            
            res_list[i]=mul(res_list[i],temp_list[j])
            
# The following bit will add the terms and create the actual derivative
# the product.

    result=''
    
    for i in range(len(res_list)):
        result=add(result, num_in_front(res_list[i]) )
   

    return result





# Now our most general derivative of a quantity.

def der(a):
    

    a_list=break_sum(a)
    
    result=''
    
    for i in range( len(a_list) ):
        
        result=add( result,d_prod(a_list[i]) )
        
    return result
   





# The following functions accepts a sum and removes all Y's

def remove_Y(a):
    
    a_list = break_sum(a)
    
    a_new=''
    
    for i in range(len(a_list)):
        
        a_list_list=break_prod(a_list[i])
        
        for j in range(len(a_list_list)):
            
            if a_list_list[j]=='Y':
                a_list_list[j]='1'
                
        a_list_list_new='1'
        
        for j in range(len(a_list_list)):
            
            a_list_list_new=mul(a_list_list_new , a_list_list[j])
    
        a_new=add(a_new,a_list_list_new)
        
    return a_new
            
            



# The following function accepts a product and separates the
# f-terms from everything else


def f_structure(a):
    
    
    a_list=break_prod(a)
    
    a_f='1'
    a_rest='1'
    
    for i in range(len(a_list)):
        
        if a_list[i][0]=='f':
            
            a_f=mul(a_f,a_list[i])
            
            a_list[i]='1'
            
    for i in range(len(a_list)):
         
         a_rest=mul(a_rest,a_list[i])


    return a_f, a_rest 







# Now a function that accepts a sum and factorizes with respect to
# f structures


def f_factorize(a):
    
    a_list=break_sum(a)
      
    check=[0]*len(a_list)
    structures=['']*len(a_list)
    coeffs=['']*len(a_list)
    
    i_struct=-1
    
    for i in range( len(a_list) ):
        
        if check[i]==0:
            
            check[i]=1
            
            a_f,a_rest=f_structure(a_list[i])
            
            i_struct=i_struct+1
            
            
            structures[i_struct] = a_f
            coeffs[i_struct]     = a_rest
            
            if i<len(a_list):
            
                for j in range( i+1,len(a_list) ):
                    
                    if check[j]==0:
                            
                            
                        if f_structure(a_list[j])[0]==a_f:
                                
                            check[j]=1
                                
                            coeffs[i_struct] = add( coeffs[i_struct], \
                            f_structure(a_list[j])[1] )

        
    structures=delete_blanks(structures)
    coeffs=delete_blanks(coeffs)
    
    
    
    
    return structures, coeffs
     





# The following function counts the number of 'h' in a product.

def count_h(a):
    
    
    a_list=break_prod(a)
    
    h_count=0
    
    for i in range(len(a_list)):
        if a_list[i]=='h':
            h_count=h_count+1
            
    return h_count





       
            
