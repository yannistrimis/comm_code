import numpy as np

def deriv( arr, dt ) : #O(dt^4) 
	n = len( arr )
	der = np.zeros( n )

	der[0] =  ( -25*arr[0]+48*arr[1]-36*arr[2]+16*arr[3]-3*arr[4] ) / ( 12*dt ) # FIRST
	der[n-1] = ( 3*arr[n-5]-16*arr[n-4]+36*arr[n-3]-48*arr[n-2]+25*arr[n-1] ) / ( 12*dt ) # LAST

	der[1] =  ( -3*arr[0]-10*arr[1]+18*arr[2]-6*arr[3]+1*arr[4] ) / ( 12*dt ) # SECOND
	der[n-2] = ( -1*arr[n-5]+6*arr[n-4]-18*arr[n-3]+10*arr[n-2]+3*arr[n-1] ) / ( 12*dt ) # LAST BUT ONE

	for i in range(2,n-2):
		der[i] = ( -arr[i+2] + 8*arr[i+1] - 8*arr[i-1] + arr[i-2] ) / ( 12*dt )

	return der
	
	
def jackknife(arr,nbins,fl):
	n = len(arr)
	if (n%nbins) != 0 :
		print('WARNING: NUMBER OF BINS DOES NOT DIVIDE NUMBER OF DATA POINTS')
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

def jackknife_for_binned(arr):

	avg = 0.0
	err = 0.0
	n_bins = len(arr)

	for i in range(n_bins) :
		avg = avg + arr[i] 
	
	avg = avg / n_bins

	err = 0
	for i in range(n_bins) :
		err = err + (arr[i]-avg)**2

	err = err*(n_bins-1)/n_bins
	err = np.sqrt(err)

	return avg, err
	

def closest( arr , num ) :

	index = -1
	dist = 10000
	for i in range( len(arr) ) :
		if abs( arr[i] - num ) < dist :
			index = i
			dist = abs( arr[i] - num )
			
	return index
