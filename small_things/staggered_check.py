import numpy as np


Nx = 4
Ny = 4
Nz = 4
Nt = 4

N = (Nx, Ny, Nz, Nt)

gamma1 = np.zeros( (4,4) , dtype = complex )
gamma2 = np.zeros( (4,4) , dtype = complex )
gamma3 = np.zeros( (4,4) , dtype = complex )
gamma4 = np.zeros( (4,4) , dtype = complex )
gamma5 = np.zeros( (4,4) , dtype = complex )

gamma1[0,3] = -1j
gamma1[1,2] = -1j
gamma1[2,1] = 1j
gamma1[3,0] = 1j

gamma2[0,3] = -1
gamma2[1,2] = 1
gamma2[2,1] = 1
gamma2[3,0] = -1

gamma3[0,2] = -1j
gamma3[1,3] = 1j
gamma3[2,0] = 1j
gamma3[3,1] = -1j

gamma4[0,0] = 1
gamma4[1,1] = 1
gamma4[2,2] = -1
gamma4[3,3] = -1


gamma5 = np.matmul(gamma1 , gamma2)
gamma5 = np.matmul(gamma5 , gamma3)
gamma5 = np.matmul(gamma5 , gamma4)



mu1 = [ 1, 0, 0, 0 ]
mu2 = [ 0, 1, 0, 0 ]
mu3 = [ 0, 0, 1, 0 ]
mu4 = [ 0, 0, 0, 1 ]



def print_matrix( A ) :
    
    rolen = len( A )
    colen = len( A[0] )
    
    for i in range(rolen) :
        for j in range(colen) :
                
            if  ( A[i,j].real == 0 ) and ( A[i,j].imag == 0 ) :
                    
                print(0 , end = '  ' )
                    
            elif A[i,j].real == 0 :
                    
                print(A[i,j].imag,'j', end = '  ' )
                    
            elif A[i,j].imag == 0 :
                        
                print(A[i,j].real, end = '  ' )
                    
            else :
                    
                print(A[i,j] , end = '  ' )
                    
                print('\t')
            
        print('\n')
                    



def vec_to_ind( vec ) :
    
    ind = vec[3]*Nx*Ny*Nz+vec[2]*Nx*Ny+vec[1]*Nx+vec[0]
    
    return ind



def ind_to_vec( ind ) :
    
    vec = np.zeros(4)
    
    vec[0] = ( ( ind % (Nx*Ny*Nz) ) % (Nx*Ny) ) % Nx
    vec[1] = ( ( ind % (Nx*Ny*Nz) ) % (Nx*Ny) ) // Nx
    vec[2] = ( ind % (Nx*Ny*Nz) ) // (Nx*Ny)
    vec[3] = ind // (Nx*Ny*Nz)
    
    return vec



def vec_to_hyp( vec ) :
    
    N_hyp = np.zeros(4)
    
    rho_hyp = np.zeros(4)
    
    for i in range(4):
        
        N_hyp[i] = vec[i] // 2
        
        rho_hyp[i] = vec[i] % 2
        
    return N_hyp , rho_hyp



def hyp_to_vec( N_hyp , rho_hyp ) :
    
    vec = np.zeros(4)
    
    for i in range(4):
        
        vec[i] = 2*N_hyp[i] + rho_hyp[i]
        
    return vec


# CAREFUL!!! mu here is supposed to be 1,2,3,4 but in the code it is 0,1,2,3

def forw( vec , mu ) :
    
    vec[mu] = vec[mu] + 1
    
    vec[mu] = vec[mu] % N[mu]
    
    
    
def backw( vec , mu ) :
    
    vec[mu] = vec[mu] - 1
    
    vec[mu] = vec[mu] % N[mu]   
    
    

def delta( vec1 , vec2 ) :
    
    for i in range(4):
    
        if vec1[i] != vec2[i] :
            
            return 0

        
    return 1
    
    
    
def eta( mu , rho ) :
    
    if mu == 0:
        
        return 1
    
    elif mu == 1:
        
        res = (-1)**( rho[0] )
        
    elif mu == 2:
        
        res = (-1)**( rho[0] + rho[1] )
        
    elif mu == 3:
        
        res = (-1)**( rho[0] + rho[1] + rho[2] )
        
    return res

m = 0

rho = np.zeros( (16,4) ) 

for i in [0,1]:
    for j in [0,1]:
        for k in [0,1]:
            for l in [0,1]:
                
                rho[m] = [i,j,k,l]
                
                m = m + 1



GAMMA1 = np.zeros( (16,16) , dtype = complex )
GAMMA2 = np.zeros( (16,16) , dtype = complex )
GAMMA3 = np.zeros( (16,16) , dtype = complex )
GAMMA4 = np.zeros( (16,16) , dtype = complex )

GAMMA5_1 = np.zeros( (16,16) , dtype = complex )
GAMMA5_2 = np.zeros( (16,16) , dtype = complex )
GAMMA5_3 = np.zeros( (16,16) , dtype = complex )
GAMMA5_4 = np.zeros( (16,16) , dtype = complex )




for r1 in range(16):
    for r2 in range(16):
        
        phase1 = eta( 0 , rho[r1] )
        phase2 = eta( 1 , rho[r1] )
        phase3 = eta( 2 , rho[r1] )
        phase4 = eta( 3 , rho[r1] )
        
        
        GAMMA1[r1,r2] = phase1 * ( delta( rho[r1] - mu1 , rho[r2] ) + delta( rho[r1] + mu1 , rho[r2] ) )
        GAMMA2[r1,r2] = phase2 * ( delta( rho[r1] - mu2 , rho[r2] ) + delta( rho[r1] + mu2 , rho[r2] ) )
        GAMMA3[r1,r2] = phase3 * ( delta( rho[r1] - mu3 , rho[r2] ) + delta( rho[r1] + mu3 , rho[r2] ) )
        GAMMA4[r1,r2] = phase4 * ( delta( rho[r1] - mu4 , rho[r2] ) + delta( rho[r1] + mu4 , rho[r2] ) )
        
        GAMMA5_1[r1,r2] = phase1 * ( delta( rho[r1] - mu1 , rho[r2] ) - delta( rho[r1] + mu1 , rho[r2] ) )
        GAMMA5_2[r1,r2] = phase2 * ( delta( rho[r1] - mu2 , rho[r2] ) - delta( rho[r1] + mu2 , rho[r2] ) )
        GAMMA5_3[r1,r2] = phase3 * ( delta( rho[r1] - mu3 , rho[r2] ) - delta( rho[r1] + mu3 , rho[r2] ) )
        GAMMA5_4[r1,r2] = phase4 * ( delta( rho[r1] - mu4 , rho[r2] ) - delta( rho[r1] + mu4 , rho[r2] ) )
        




U = np.zeros( (16,16), dtype = complex )

for r in range(16):
    
    
    g1 = np.linalg.matrix_power( gamma1 , int(rho[r,0]) )
    g2 = np.linalg.matrix_power( gamma2 , int(rho[r,1]) )
    g3 = np.linalg.matrix_power( gamma3 , int(rho[r,2]) )
    g4 = np.linalg.matrix_power( gamma4 , int(rho[r,3]) )

    T_r = np.matmul( g1 , g2 )
    T_r = np.matmul( T_r , g3 )
    T_r = np.matmul( T_r , g4 )
    
    ab = 0
    
    for a in range(4):
        for b in range(4):



            U[ab,r] = 0.5 * T_r[ a , b ]

            ab = ab + 1




U_dagger = np.transpose(U)

U_dagger = np.conjugate(U_dagger)

# UU = np.matmul( U_dagger , U )

# print_matrix( UU )




Lamda1 = np.matmul( U , GAMMA1 )
Lamda1 = np.matmul( Lamda1, U_dagger )

Lamda2 = np.matmul( U , GAMMA2 )
Lamda2 = np.matmul( Lamda2, U_dagger )

Lamda3 = np.matmul( U , GAMMA3 )
Lamda3 = np.matmul( Lamda3, U_dagger )

Lamda4 = np.matmul( U , GAMMA4 )
Lamda4 = np.matmul( Lamda4, U_dagger )




Lamda5_1 = np.matmul( U , GAMMA5_1 )
Lamda5_1 = np.matmul( Lamda5_1, U_dagger )

Lamda5_2 = np.matmul( U , GAMMA5_2 )
Lamda5_2 = np.matmul( Lamda5_2, U_dagger )

Lamda5_3 = np.matmul( U , GAMMA5_3 )
Lamda5_3 = np.matmul( Lamda5_3, U_dagger )

Lamda5_4 = np.matmul( U , GAMMA5_4 )
Lamda5_4 = np.matmul( Lamda5_4, U_dagger )



# The Lamda1,2,3,4 are ok, that's easy to see cuz they're direct products of unit matrix with some gamma matrix.
# But the Lamda5_1,2,3,4 are not straightforward to check, so let's construct them via the direct product and 
# see if we get the same.

t1 = np.conjugate( gamma1 )
t2 = np.conjugate( gamma2 )
t3 = np.conjugate( gamma3 )
t4 = np.conjugate( gamma4 )

t5 = gamma5

t1t5 = np.matmul( t1 , t5 )
t2t5 = np.matmul( t2 , t5 )
t3t5 = np.matmul( t3 , t5 )
t4t5 = np.matmul( t4 , t5 )

Lamda5_1_test = np.kron( gamma5 , t1t5 )
Lamda5_2_test = np.kron( gamma5 , t2t5 )
Lamda5_3_test = np.kron( gamma5 , t3t5 )
Lamda5_4_test = np.kron( gamma5 , t4t5 )


print_matrix( Lamda5_1 )
print('\n\n')
print_matrix( Lamda5_1_test)
