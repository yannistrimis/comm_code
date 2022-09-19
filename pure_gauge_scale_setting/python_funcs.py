import numpy as np

def deriv( arr, dt ) : #O(dt^2) error for first, second, last but one and last elements, O(dt^4) error for the rest 
	n = len( arr )
	der = np.zeros( n )

	der[0] = (-3*arr[0] + 4*arr[1] - arr[2] ) / ( 2*dt ) #first
	der[n-1] = ( 3*arr[n-1] - 4*arr[n-2] + arr[n-3] ) / ( 2*dt ) #last

	der[1] = ( arr[2] - arr[0] ) / ( 2*dt )#second
	der[n-2] = ( arr[n-1] - arr[n-3] ) / ( 2*dt )#last but one

	for i in range(2,n-2): #the rest
		der[i] = ( -arr[i+2] + 8*arr[i+1] - 8*arr[i-1] + arr[i-2] ) / ( 12*dt )

	return der
	
	
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

def closest( arr , num ) :

	index = -1
	dist = 10000
	for i in range( len(arr) ) :
		if abs( arr[i] - num ) < dist :
			index = i
			dist = abs( arr[i] - num )
			
	return index
