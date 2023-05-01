import numpy as np


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

