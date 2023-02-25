from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf

nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

filename = cur_dir+'/l'+ens_name+'/m1_'+mass1+'_m2_'+mass2+'_'+sinks+'_'+source1+'_'+source2+'.data'

def main():
    data = make_data(filename=filename)
    fitter = cf.CorrFitter(models=make_models())
    p0 = None
    for N in [1,2]:
        print(30 * '=', 'nterm =', N)
        prior = make_prior(N)
        fit = fitter.lsqfit(data=data, prior=prior, p0=p0)
        print(fit)
        p0 = fit.pmean
        print_results(fit)
def make_data(filename):
    """ Read data, compute averages/covariance matrix for G(t). """
    return gv.dataset.avg_data(cf.read_dataset(filename))

def make_models():
    """ Create corrfitter model for G(t). """
    return [cf.Corr2(datatag='PROP', tp=16, tmin=5, a='a', b='a', dE='dE')]

def make_prior(N):
    """ Create prior for N-state fit. """
    prior = collections.OrderedDict()
    prior['a'] = gv.gvar(N * ['594(5)'])
    prior['log(dE)'] = gv.log(gv.gvar(N * ['0.42(0.05)']))
    return prior

def print_results(fit):
    p = fit.p
    E = np.cumsum(p['dE'])
    a = p['a']
    print('{:2}  {:15}'.format('E', E[0]))
    print('{:2}  {:15}\n'.format('a', a[0]))


if __name__ == '__main__':
    main()
