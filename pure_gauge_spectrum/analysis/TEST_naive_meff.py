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

f_bins = open('%s/bins_re.dat'%(cur_dir),'r')
f_averr = open('%s/av_err_re.dat'%(cur_dir),'r')

cont_bins = f_bins.readlines()
n_bins = len( cont_bins[0].split(' ') )-1
cont_averr = f_averr.readlines()

term_count = int( (nm*nm+nm)/2 ) # THE NUMBER OF
# PION_5 STATES FOR ALL MESONS, BOTH DIAGONAL AND
# NON-DIAGONAL
mass_average = np.zeros(term_count)
mass_error = np.zeros(term_count)

for im in range(term_count):
    i = im*4 # FOUR STATES PER MASS COMBINATION YIELDS THE CODE
    bin_arr = np.zeros((nn,n_bins))
    logbin_arr = np.zeros((nn,n_bins))
    mass_arr = np.zeros(n_bins)
    tau_arr = np.zeros(nn)
    err_arr = np.zeros(nn)
    weights = np.zeros(nn)
    i_arr = -1
    for ii in range(nn*i,nn*(i+1)) :
        i_arr = i_arr + 1
        bin_line = cont_bins[ii].split(' ')
        err_line = cont_averr[ii].split(' ')

        err_arr[i_arr] = float( err_line[2] )
        weights[i_arr] = 1/err_arr[i_arr]
        tau_arr[i_arr] = float( bin_line[0] )

        for jj in range(n_bins) :
            bin_arr[i_arr,jj] = float( bin_line[jj+1] )
            logbin_arr[i_arr,jj] = np.log( bin_arr[i_arr,jj] )
            # LOGARITHM NEEDED FOR THE FIT THAT FOLLOWS
    
    for i_bin in range(n_bins) :
        coeffs = np.polyfit( tau_arr , logbin_arr[:,i_bin] , 1 , w=weights )
        mass_arr[i_bin] = (-1)*coeffs[0]

    mass_av = 0
    for i_bin in range(n_bins) :
            mass_av = mass_av + mass_arr[i_bin]
         
    mass_av = mass_av / n_bins    
    mass_err = 0

    for i_bin in range(n_bins) :
            mass_err = mass_err + (mass_arr[i_bin]-mass_av)**2

    mass_err = mass_err*(n_bins-1)/n_bins
    mass_err = np.sqrt(mass_err)
    mass_average[im] = mass_av
    mass_error[im] = mass_err

f_bins.close()
f_averr.close()

print('diagonal mesons:\n')
kk=-1
for ii in range(nm) :
    for jj in range(ii,nm):
        kk=kk+1
        if ii==jj :
            print('%f +/- %f'%(mass_average[kk],mass_error[kk]))


