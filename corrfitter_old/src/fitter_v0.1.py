from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf

def main():
    osc = 'yes'
    file_name = '/home/trimis/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_5.data'
    data = make_data(filename=file_name)
    fitter = cf.CorrFitter(models=make_models(osc))
    p0 = None
    print('data from: ',file_name)
    for N in [1,2]:
        print(30 * '=', 'nterm =', N)
        prior = make_prior(N,osc)
        fit = fitter.lsqfit(data=data, prior=prior, p0=p0)
        print(fit)
        p0 = fit.pmean
        print_results(fit,N,osc)

def make_data(filename):
    """ Read data, compute averages/covariance matrix for G(t). """
    return gv.dataset.avg_data(cf.read_dataset(filename))

def make_models(osc):
    """ Create corrfitter model for G(t). """
    if osc == 'yes' :
        return [cf.Corr2( datatag='PROP', tp=32, tmin=6, a=('an','ao'), b=('an','ao'), dE=('dEn','dEo'), s=(1.0,1.0) )]
    elif osc == 'no' :
        return [cf.Corr2( datatag='PROP', tp=32, tmin=6, a='an', b='an', dE='dEn', s=1.0 )]

def make_prior(N,osc):
    """ Create prior for N-state fit. """
    prior = collections.OrderedDict()
    prior['an'] = gv.gvar(N * ['2(2)'])
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.5(5)']))
    if osc == 'yes' :
        prior['ao'] = gv.gvar(N * ['2(2)'])
        prior['log(dEo)'] = gv.log(gv.gvar(N * ['0.5(5)']))    
    return prior

def print_results(fit,N,osc):
    p = fit.p
    En = np.cumsum(p['dEn'])
    an = p['an']
    if osc == 'yes' :
        Eo = np.cumsum(p['dEo'])
        ao = p['ao']

    if N >= 2 :
        print('{:2}  {:15}  {:15}'.format('En', En[0], Eo[1]))
        print('{:2}  {:15}  {:15}\n'.format('an', an[0], an[1]))
        if osc == 'yes' :
            print('{:2}  {:15}  {:15}'.format('Eo', Eo[0], Eo[1]))
            print('{:2}  {:15}  {:15}\n'.format('ao', ao[0], ao[1]))

    elif N == 1 :
        print('{:2}  {:15}'.format('En', En[0]))
        print('{:2}  {:15}\n'.format('an', an[0]))
        if osc == 'yes' :
            print('{:2}  {:15}'.format('Eo', Eo[0]))
            print('{:2}  {:15}\n'.format('ao', ao[0]))


if __name__ == '__main__':
    main()
