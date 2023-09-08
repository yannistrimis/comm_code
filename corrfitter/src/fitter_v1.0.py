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
        for M in [0]:
            print(30 * '=', 'nterm =', N,M)
            prior = make_prior(N,M)
            fit = fitter.lsqfit( data=data, prior=prior, p0=p0 )
            print(fit)
            p0 = fit.pmean

            fit_outs = cf.Corr2.fitfcn(p=fit.p)
            print(fit_outs)

            dof_real = len(my_tfit)-2*N-2*M
            chi2_real = fit.chi2

            for i_state in range(N) :
                chi2_real = chi2_real - ( prior['an'][i_state].mean - fit.p['an'][i_state].mean )**2 / ( prior['an'][i_state].sdev )**2
                chi2_real = chi2_real - ( gv.exp(prior['log(dEn)'])[i_state].mean - fit.p['dEn'][i_state].mean )**2 / ( gv.exp(prior['log(dEn)'])[i_state].sdev )**2

            for i_state in range(M) :
                chi2_real = chi2_real - ( prior['ao'][i_state].mean - fit.p['ao'][i_state].mean )**2 / ( prior['ao'][i_state].sdev )**2
                chi2_real = chi2_real - ( gv.exp(prior['log(dEo)'])[i_state].mean - fit.p['dEo'][i_state].mean )**2 / ( gv.exp(prior['log(dEo)'])[i_state].sdev )**2

            Q_man = 1-gammainc(0.5*fit.dof,0.5*fit.chi2)
            Q_real = 1-gammainc(0.5*dof_real,0.5*chi2_real)

            print_results(fit,N,M)
            print('[','BY-HAND GOODNESS OF FIT:',']','\n',)
            print( 'augmented chi2/dof [dof]: %.3f [%d]\tQ = %.3f\ndeaugmented chi2/dof [dof]:  %.3f [%d]\tQ = %.3f'%(fit.chi2/fit.dof,fit.dof,Q_man,chi2_real/dof_real,dof_real,Q_real) )


def make_data(filename):
    """ Read data, compute averages/covariance matrix for G(t). """
    return gv.dataset.avg_data(cf.read_dataset(filename))

def make_models(my_tdata,my_tfit):
    """ Create corrfitter model for G(t). """
    return [cf.Corr2( datatag='PROP', tp=32, tdata=my_tdata, tfit=my_tfit, a=('an','ao'), b=('an','ao'), dE=('dEn','dEo'), s=(1.0,1.0) )]

def make_prior(N,M):
    """ Create prior for N-state fit. """
    prior = collections.OrderedDict()
    prior['an'] = gv.gvar(N * ['2(2)'])
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.5(6)']))
    prior['ao'] = gv.gvar(M * ['0.0(100.0)'])
    prior['log(dEo)'] = gv.log(gv.gvar(M * ['0.5(10.0)']))
    return prior

def print_results(fit,N,M):
    p = fit.p

    En = np.cumsum(p['dEn'])
    an = p['an']
    Eo = np.cumsum(p['dEo'])
    ao = p['ao']

    for i_state in range(N) :
        print('an[%d] = %s\t En[%d] = %s\n'%(i_state,an[i_state],i_state,En[i_state]))
    for j_state in range(M) :
        print('ao[%d] = %s\t Eo[%d] = %s\n'%(j_state,ao[j_state],j_state,Eo[j_state]))


if __name__ == '__main__':
    main()
