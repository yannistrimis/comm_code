import numpy as np

nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

cur_dir = '/mnt/home/trimisio/plot_data/spec_data/'+'l'+ens_name

nm = 5
nn = int(nt/2) +1

f_bins = open(,'r')
f_averr = open(,'r')

cont_bins = f_bins.readlines()
cont_averr = f_averr.readlines()

mass_av = np.zeros(nm)
mass_err = np.zeros(nm)

for im in range(nm):
    i = im*4 # FOUR STATES PER MASS OUTPUTS THE CODE
    bin_arr = np.zeros(nn,n_bins)

