from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf
from scipy.special import gammainc

def main():

    file_name = '/home/trimis/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_5.fold.data' # CMSE
#    file_name = '/home/yannis/Physics/LQCD/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_5.fold.data' # LAPTOP

    data = make_data(filename=file_name)

    my_tfit = range(10,17)
    my_tdata = range(0,17)

    fitter = cf.CorrFitter(models=make_models(my_tdata,my_tfit))

    p0 = None

    print('data from: ',file_name)
    for N in [1]:
        print(30 * '=', 'nterm =', N)
        prior = make_prior(N)
        fit = fitter.lsqfit(data=data, prior=prior, p0=p0)
        print(fit)
        p0 = fit.pmean

        dof_real = len(my_tfit)-2*N
        chi2_real = fit.chi2

        for i_state in range(N) :
            chi2_real = chi2_real - ( prior['an'][i_state].mean - fit.p['an'][i_state].mean )**2 / ( prior['an'][i_state].sdev )**2
            chi2_real = chi2_real - ( gv.exp(prior['log(dEn)'])[i_state].mean - fit.p['dEn'][i_state].mean )**2 / ( gv.exp(prior['log(dEn)'])[i_state].sdev )**2
        Q_man = 1-gammainc(0.5*fit.dof,0.5*fit.chi2)
        Q_real = 1-gammainc(0.5*dof_real,0.5*chi2_real)

        print_results(fit,N)
        print('[','BY-HAND GOODNESS OF FIT:',']','\n',)
        print( 'augmented chi2/dof [dof]: %.3f [%d]\tQ = %.2f\ndeaugmented chi2/dof [dof]:  %.3f [%d]\tQ = %.2f'%(fit.chi2/fit.dof,fit.dof,Q_man,chi2_real/dof_real,dof_real,Q_real) )
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
