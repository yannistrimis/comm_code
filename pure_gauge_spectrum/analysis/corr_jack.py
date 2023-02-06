import numpy as np
from python_funcs import *

cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec'
nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

out_dir = '/mnt/home/trimisio/plot_data/spec_data/' + ens_name
