import numpy as np
from scipy.special import gammainc

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


def chisq_by_dof(meas_array,fit_array,y_cov,dof):
    n = len(meas_array)
    
    if len(meas_array) != len(fit_array) :
        print('UNMATCHING DIMENSIONS')
        return 0

    y_cov_inv = np.linalg.inv(y_cov)
    
    res = 0.0

    for i in range(n):
        for j in range(n):
            res = res + (meas_array[i]-fit_array[i])*y_cov_inv[i,j]*(meas_array[j]-fit_array[j])

    res = res/dof

    return res


def q_value(chi2dof,dof) :
    chisq = chi2dof*dof
    p_value = gammainc(0.5*dof,0.5*chisq)
    return 1 - p_value
