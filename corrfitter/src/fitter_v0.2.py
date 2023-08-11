from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf

def main():

#    file_name = '/home/trimis/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_5.fold.data' # CMSE
    file_name = '/home/yannis/Physics/LQCD/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_5.fold.data' # LAPTOP

    data = make_data(filename=file_name)

    my_tfit = range(5,17)
    my_tdata = range(0,17)

    fitter = cf.CorrFitter(models=make_models(my_tdata,my_tfit))

    p0 = None

    print('data from: ',file_name)
    for N in [1,2]:
        print(30 * '=', 'nterm =', N)
        prior = make_prior(N)
        fit = fitter.lsqfit(data=data, prior=prior, p0=p0)
        print(fit)
        p0 = fit.pmean

        dof_real = len(my_tfit)-2*N
        chi2_real = fit.chi2

        print_results(fit,N)

def make_data(filename):
    """ Read data, compute averages/covariance matrix for G(t). """
    return gv.dataset.avg_data(cf.read_dataset(filename))

def make_models(my_tdata,my_tfit):
    """ Create corrfitter model for G(t). """
    return [cf.Corr2( datatag='PROP', tp=32, tdata=my_tdata, tfit=my_tfit, a='an', b='an', dE='dEn', s=1.0 )]

def make_prior(N):
    """ Create prior for N-state fit. """
    prior = collections.OrderedDict()
    prior['an'] = gv.gvar(N * ['2(2)'])
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.5(6)']))
    babis = gv.exp(prior['log(dEn)'])[0].sdev
    print(babis)
    return prior

def print_results(fit,N):
    p = fit.p
    En = np.cumsum(p['dEn'])
    an = p['an']

    if N >= 2 :
        print('{:2}  {:15}  {:15}'.format('En', En[0], En[1]))
        print('{:2}  {:15}  {:15}\n'.format('an', an[0], an[1]))

    elif N == 1 :
        print('{:2}  {:15}'.format('En', En[0]))
        print('{:2}  {:15}\n'.format('an', an[0]))


if __name__ == '__main__':
    main()
