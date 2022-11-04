from skspatial.objects import Line, Plane, Points, Point
import numpy as np

w0_phys = 0.174
a = 0.16

w0_target = w0_phys/a
xi_g_target = 2.0

f1 = open("surface_file","r")

f1_content = f1.readlines()

arr1 = np.zeros((25,4))

for i in range(1,26):
    line = f1_content[i].split(' ')
    
    beta_str = line[0]
    beta = float(beta_str[0]+"."+beta_str[1]+beta_str[2]+beta_str[3])
    
    xi0_str = line[1]
    xi0 = float(xi0_str[0]+"."+xi0_str[1]+xi0_str[2])
    
    arr1[i-1,0] = float( beta )
    arr1[i-1,1] = float( xi0 )
    arr1[i-1,2] = float( line[2] )
    arr1[i-1,3] = float( line[4] )

# first w0

points_1 = [[arr1[0,0],arr1[0,1],arr1[0,2]]]
for j in range(1,25):
    points_1.append([arr1[j,0],arr1[j,1],arr1[j,2]])

points_w0 = Points(points_1)
plane_w0 = Plane.best_fit(points_w0)
coeffs_w0 = plane_w0.cartesian()

a=coeffs_w0[0]
b=coeffs_w0[1]
c=coeffs_w0[2]*w0_target+coeffs_w0[3]

# then xi_g

points_2 = [[arr1[0,0],arr1[0,1],arr1[0,3]]]
for j in range(1,25):
    points_2.append([arr1[j,0],arr1[j,1],arr1[j,3]])

points_xi_g = Points(points_2)
plane_xi_g = Plane.best_fit(points_xi_g)
coeffs_xi_g = plane_xi_g.cartesian()

aa=coeffs_xi_g[0]
bb=coeffs_xi_g[1]
cc=coeffs_xi_g[2]*xi_g_target+coeffs_xi_g[3]

# results

beta_opt = ( b*cc-c*bb )/( a*bb-aa*b )
xi0_opt = -( a*cc-c*aa )/( a*bb-aa*b )
print("beta = %f"%beta_opt)
print("xi0 = %f"%xi0_opt)














f1.close()

