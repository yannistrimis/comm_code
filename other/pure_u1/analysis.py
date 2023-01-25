import numpy as np
from matplotlib import pyplot as plt

def jackknife(arr,nbins,fl):
	n = len(arr)
	ninbin = int(n/nbins)
	jack_bins = np.zeros(nbins)
	normal_bins = np.zeros(nbins)
	for i in range(nbins) :
		for j in range(i*ninbin,(i+1)*ninbin):
			normal_bins[i] = normal_bins[i] + arr[j]
	
	total = 0
	for j in range(n) :
		total = total + arr[j]
	for i in range(nbins) :
		jack_bins[i] = total - normal_bins[i]
		jack_bins[i] = jack_bins[i]/(ninbin*(nbins-1))
		
	av = 0
	
	for i in range(nbins) :
		av = av + jack_bins[i]
	av = av / nbins
	
	er = 0
	
	for i in range(nbins) :
		er = er + (jack_bins[i]-av)**2
		
	er = er*(nbins-1)/nbins
	er = np.sqrt(er)
	
	if fl=='bins':
		return jack_bins
	elif fl=='average':
		return av
	elif fl=='error':
		return er

my_dir = "/home/yannis/Physics/LQCD/pure_u1/data/" # LAPTOP
n_of_lat = 20
beta_arr = [1.0, 2.0, 4.0, 6.0, 8.0]
beta_str_arr = ["1","2","4","6","8"]

# Array that contains averages and errors for the two volumes:
plaq = np.zeros((2,len(beta_arr),2))
vol_arr = [4,8]

for i_vol in range(len(vol_arr)) :
    nx = vol_arr[i_vol]
    nt = vol_arr[i_vol]
    
    for i_beta in range(len(beta_arr)) :
        beta = beta_arr[i_beta]
        beta_str = beta_str_arr[i_beta]
        ens_name = "l"+str(nx)+str(nt)+"b"+beta_str   
        f_name = my_dir + ens_name
        f_read = open("%s_plaq"%f_name,"r")
        content = f_read.readlines()

        temp = np.zeros(len(content))
        for j in range(len(content)-n_of_lat,len(content)):
            temp[j] = float(content[j])
        
        plaq[i_vol,i_beta,0] = jackknife(temp,5,"average")
        plaq[i_vol,i_beta,1] = jackknife(temp,5,"error")
        f_read.close()




fig1 = plt.figure()
plt.errorbar(beta_arr,plaq[0,:,0],yerr=plaq[0,:,1],linestyle='None',marker='o',capsize=3,label=r"$4^4$")
plt.errorbar(beta_arr,plaq[1,:,0],yerr=plaq[1,:,1],linestyle='None',marker='o',capsize=3,label=r"$8^4$")
plt.legend(loc="upper right")
plt.title(r"plaquette vs $\beta$")
plt.show()
