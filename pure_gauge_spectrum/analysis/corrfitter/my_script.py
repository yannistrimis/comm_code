
from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf

def main():
    data = make_data(filename='/mnt/home/trimisio/plot_data/spec_data/l1616b7000x100a/m1_1_m2_1_PION_5_CORNER_CORNER.data')
    fitter = cf.CorrFitter(models=make_models())
    p0 = None
    for N in [1,2,4]:
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
    return [cf.Corr2(datatag='PION_5', tp=16, tmin=2, a=('an','ao'), b=('an','ao'), dE=('dEn','dEo'), s=(1,-1) )]

def make_prior(N):
    """ Create prior for N-state fit. """
    prior = collections.OrderedDict()
    prior['an'] = gv.gvar(N * ['0(1)'])
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.5(5)']))
    prior['ao'] = gv.gvar(N * ['0(1)'])
    prior['log(dEo)'] = gv.log(gv.gvar(N * ['0.5(5)']))

    return prior

def print_results(fit):
    p = fit.p
    En = np.cumsum(p['dEn'])
    an = p['an']
    print('{:2}  {:15}'.format('En', En[0]))
    print('{:2}  {:15}\n'.format('an', an[0]))

    Eo = np.cumsum(p['dEo'])
    ao = p['ao']
    print('{:2}  {:15}'.format('Eo', Eo[0]))
    print('{:2}  {:15}\n'.format('ao', ao[0]))

if __name__ == '__main__':
    main()
