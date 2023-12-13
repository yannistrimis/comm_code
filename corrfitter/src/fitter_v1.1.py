from __future__ import print_function   # makes this work for python2 and 3

# RUN conda deactivate IF ON CMSE WORKSTATION

import collections
import gvar as gv
import numpy as np
import corrfitter as cf
from scipy.special import gammainc
from python_funcs import *

def main():

    my_dir = input()
    file_name = input()
    str_tmin = input()
    str_tmax = input()
    str_tdatamax = input()
    str_tp = input()
    str_N = input()
    str_M = input()
    str_so = input()
    str_bin = input()
    fittype = input()
    print_state = input()


    file_name = my_dir+'/'+file_name
    tmin = int(str_tmin)
    tmax = int(str_tmax)
    tdatamax = int(str_tdatamax)
    my_tp = int(str_tp)

    data = make_data(file_name,str_bin)

    my_tfit = range(tmin,tmax)
    my_tdata = range(0,tdatamax)
    my_models = make_models(my_tdata,my_tfit,my_tp,str_so)
    fitter = cf.CorrFitter(models=my_models)

    N = int(str_N)
    M = int(str_M)

    p0 = None

    if fittype == 'onefit' :
        print('\ndata from: ',file_name,'\n')
        print('tmin = ',tmin,'   tmax = ',tmax,'\n')

    prior = make_prior(N,M)
    fit = fitter.lsqfit( data=data, prior=prior, p0=p0 )
    if fittype == 'onefit' :
        print(30 * '=', 'nterm =', N,M)
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

    if fittype == 'onefit' :
        print('\n')
        print_results(fit,N,M)
        print('[','GOODNESS OF FIT FROM corrfitter CHI_2:',']','\n',)
        print( 'augmented chi2/dof [dof]: %.3f [%d]\tQ = %.3f\ndeaugmented chi2/dof [dof]:  %.3f [%d]\tQ = %.3f\n'%(fit.chi2/fit.dof,fit.dof,Q_man,chi2_real/dof_real,dof_real,Q_real) )
        print('\n')
        print('#DATA dDATA FIT dFIT REDUCED_DIST')
        for it in my_tfit :
            it_shift = it - my_tfit[0]
            print(it, data['PROP'][it].mean, data['PROP'][it].sdev, my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].mean, my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].sdev,(data['PROP'][it].mean-my_models[0].fitfcn(p=fit.p,t=my_tfit)[it_shift].mean)/data['PROP'][it].sdev)

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
    if fittype == 'onefit' :
        print('\n')
        print('[','GOODNESS OF FIT FROM MANUALLY CALCD CHI_2 (ONLY FOR INFINITELY WIDE PRIORS):',']','\n')
        print( 'chi2/dof from fit points [dof]: %.3f [%d]\tQ = %.3f\n'%(chi2bydof_from_points,dof_real,Q_from_points) )
    elif fittype == 'scanfit' :
        if test_param(fit,N,M) == 'ok' :
            if print_state == 'n0' :
                print(N,M,tmin,tmax,chi2bydof_from_points,dof_real,Q_from_points,fit.p['dEn'][0].mean,fit.p['dEn'][0].sdev)
            elif print_state == 'o0' :
                print(N,M,tmin,tmax,chi2bydof_from_points,dof_real,Q_from_points,fit.p['dEo'][0].mean,fit.p['dEo'][0].sdev)
        elif test_param(fit,N,M) == 'not_ok' :
            print(N,M,tmin,tmax,0,0,0,0,0)


    # bootstrap analysis
    dset = cf.read_dataset(file_name,binsize=int(str_bin))

    print('\n\nBOOTSTRAP FIT RESULTS:\n\n')
    nbootstrap = 10
    bs_datalist = (gv.dataset.avg_data(d) for d in gv.dataset.bootstrap_iter(dset, nbootstrap))
    bs = gv.dataset.Dataset()
    for bs_fit in fitter.bootstrapped_fit_iter(bs_datalist):
        p = bs_fit.pmean
        if N > 0 :
            bs.append('an', p['an'])
            bs.append('dEn', p['dEn'])
        if M > 0:
            bs.append('ao', p['ao'])
            bs.append('dEo', p['dEo'])

    bs = gv.dataset.avg_data(bs, bstrap=True)


def make_data(filename,str_bin):
    return gv.dataset.avg_data(cf.read_dataset(filename,binsize=int(str_bin)))

def make_models(my_tdata,my_tfit,my_tp,str_so):
    return [cf.Corr2( datatag='PROP', tp=my_tp, tdata=my_tdata, tfit=my_tfit, a=('an','ao'), b=('an','ao'), dE=('dEn','dEo'), s=(1.0,float(str_so)) )]

def make_prior(N,M):
    prior = collections.OrderedDict()
    prior['log(an)'] = gv.log(gv.gvar(N * ['0.1(10000.0)']))
    prior['log(dEn)'] = gv.log(gv.gvar(N * ['0.1(10.0)']))
    prior['log(ao)'] = gv.log(gv.gvar(M * ['0.1(10000.0)']))
    prior['log(dEo)'] = gv.log(gv.gvar(M * ['0.1(10.0)']))
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

def test_param(fit,N,M):

    p = fit.p

    if N>0:
        En = np.cumsum(p['dEn'])
        an = p['an']

    if M>0:
        Eo = np.cumsum(p['dEo'])
        ao = p['ao']

    for i_state in range(N) :
        if ( np.abs(an[i_state].sdev) > 10*np.abs(an[i_state].sdev) ) :
            return 'not_ok'

    for j_state in range(M) :
        if ( np.abs(ao[j_state].sdev) > 10*np.abs(ao[j_state].sdev) ) :
            return 'not_ok'

    return 'ok'


if __name__ == '__main__':
    main()

