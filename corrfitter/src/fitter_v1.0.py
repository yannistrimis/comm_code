from __future__ import print_function   # makes this work for python2 and 3

import collections
import gvar as gv
import numpy as np
import corrfitter as cf
from scipy.special import gammainc
from python_funcs import *

def main():

    file_name = '/mnt/home/trimisio/plot_data/spec_data/l1632b6850x100a/p100rcw1632b6850x100xq100a_m0.0788m0.0788PION_5.specdata'

    data = make_data(filename=file_name)

    my_tfit = range(12,17)
    my_tdata = range(0,17)
    my_models = make_models(my_tdata,my_tfit)
    fitter = cf.CorrFitter(models=my_models)

    p0 = None

    print('\ndata from: ',file_name,'\n')
    for N in [1]:
        for M in [0]:
            print(30 * '=', 'nterm =', N,M)
            prior = make_prior(N,M)
            fit = fitter.lsqfit( data=data, prior=prior, p0=p0 )
            print(fit)
            p0 = fit.pmean

            dof_real = len(my_tfit)-2*N-2*M
            chi2_real = fit.chi2

            for i_state in range(N) :
                chi2_real = chi2_real - ( gv.exp(prior['log(an)'])[i_state].mean - fit.p['an'][i_state].mean )**2 / ( gv.exp(prior['log(an)'])[i_state].sdev )**2
                chi2_real = chi2_real - ( gv.exp(prior['log(dEn)'])[i_state].mean - fit.p['dEn'][i_state].mean )**2 / ( gv.exp(prior['log(dEn)'])[i_state].sdev )**2
            
            for i_state in range(M) :
                chi2_real = chi2_real - ( gv.exp(prior['log(ao)'])[i_state].mean - fit.p['ao'][i_state].mean )**2 / ( gv.exp(prior['log(ao)'])[i_state].sdev )**2
                chi2_real = chi2_real - ( gv.exp(prior['log(dEo)'])[i_state].mean - fit.p['dEo'][i_state].mean )**2 / ( gv.exp(prior['log(dEo)'])[i_state].sdev )**2
            
            Q_man = 1-gammainc(0.5*fit.dof,0.5*fit.chi2)
            Q_real = 1-gammainc(0.5*dof_real,0.5*chi2_real)
            
            print('\n')
            print_results(fit,N,M)
            print('[','MY GOODNESS OF FIT:',']','\n',)
            print( 'augmented chi2/dof [dof]: %.3f [%d]\tQ = %.3f\ndeaugmented chi2/dof [dof]:  %.3f [%d]\tQ = %.3f\n'%(fit.chi2/fit.dof,fit.dof,Q_man,chi2_real/dof_real,dof_real,Q_real) )
            print('\n')
            print('#DATA dDATA FIT dFIT REDUCED_DIST')
            for it in my_tfit :
                it_shift = it - my_tfit[0]
                print(data['PROP'][it].mean, data['PROP'][it].sdev, my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].mean, my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].sdev,(data['PROP'][it].mean-my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].mean)/data['PROP'][it].sdev)
            print('\n')
            print('[','GOODNESS OF FIT FROM FIT POINTS (ONLY FOR INFINITELY WIDE PRIORS):',']','\n')

            cov_matrix = np.zeros((len(my_tfit),len(my_tfit)))
            meas_arr = np.zeros(len(my_tfit))
            fit_arr = np.zeros(len(my_tfit))

            for i in my_tfit :
                i_shift = i - my_tfit[0]
                for j in my_tfit :
                    j_shift = j - my_tfit[0]
                    cov_matrix[i_shift,j_shift] = gv.evalcov(data)['PROP','PROP'][i,j]
                meas_arr[i_shift] = data['PROP'][i].mean
                fit_arr[i_shift] = my_models[0].fitfcn(p=fit.p,t=my_tfit)[i_shift].mean                 

            chi2bydof_from_points = chisq_by_dof(meas_arr,fit_arr,cov_matrix,dof_real)
            Q_from_points = q_value(chi2bydof_from_points,dof_real)
            print( 'chi2/dof from fit points [dof]: %.3f [%d]\tQ = %.3f\n'%(chi2bydof_from_points,dof_real,Q_from_points) )
            
def make_data(filename):
    """ Read data, compute averages/covariance matrix for G(t). """
    return gv.dataset.avg_data(cf.read_dataset(filename,binsize=1))

def make_models(my_tdata,my_tfit):
    """ Create corrfitter model for G(t). """
    return [cf.Corr2( datatag='PROP', tp=32, tdata=my_tdata, tfit=my_tfit, a=('an','ao'), b=('an','ao'), dE=('dEn','dEo'), s=(1.0,1.0) )]

def make_prior(N,M):
    """ Create prior for (N,M)-state fit. """
    prior = collections.OrderedDict()
    prior['log(an)'] = gv.log(gv.gvar(N * ['0.1(10000.0)']))
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.1(1000.0)']))
    prior['log(ao)'] = gv.log(gv.gvar(M * ['0.1(10000.0)']))
    prior['log(dEo)'] = gv.log(gv.gvar(M * ['0.1(1000.0)']))
    return prior

def print_results(fit,N,M):
    p = fit.p

    En = np.cumsum(p['dEn'])
    an = p['an']

    if M>0:
        Eo = np.cumsum(p['dEo'])
        ao = p['ao']

    for i_state in range(N) :
        print('an[%d] = %s\t En[%d] = %s\n'%(i_state,an[i_state],i_state,En[i_state]))
    for j_state in range(M) :
        print('ao[%d] = %s\t Eo[%d] = %s\n'%(j_state,ao[j_state],j_state,Eo[j_state]))


if __name__ == '__main__':
    main()
