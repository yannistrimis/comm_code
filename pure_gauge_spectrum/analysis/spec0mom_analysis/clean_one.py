import numpy as np

cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec'
out_dir = '/mnt/home/trimisio/plot_data/spec_data'

vol = '1632'
beta = '6647'
x0 = '100'
xq = '100'
stream = 'a'

i_file = input()
mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()
pre_name = input()
ens_name_nostream = vol+'b'+beta+'x'+x0
ens_name = ens_name_nostream+stream

f_read = open('%s/l%s/%s%sxq%s%s.%s'%(cur_dir,ens_name,pre_name,ens_name_nostream,xq,stream,i_file),'r')
f_write_a = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%sa'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'w')
f_write_b = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%sb'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'w')

source_flag = 0
flag = 0
counter = 0

mass_line = 'MASSES:' + ' ' + mass1 + ' ' + mass2 + ' '
source_line = 'SOURCE:' + ' ' + source1 + ' ' +  source2
sink_line = 'SINKS:' + ' ' + sinks

content = f_read.readlines()
for line in content:
	split_line = line.split(' ')

	if split_line[0]=='#' and split_line[1]=='source' and split_line[2]=='time':
		source_flag = source_flag + 1

	if line.rstrip('\n') == 'STARTPROP' :
		flag = 1
	elif flag==1 and line.rstrip('\n')==mass_line :
		flag = 2
	elif flag==2 and line.rstrip('\n')==source_line :
		flag = 3		
	elif flag==3 and line.rstrip('\n')==sink_line :
		flag = 4
	elif flag==4 and split_line[0]=='0' :
		flag = 5
		counter = 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag==5 and split_line[0]==str(counter) :
		counter = counter + 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag==5 and line.rstrip('\n')=='ENDPROP' :
		flag = 0
		counter = 0

f_read.close()
f_write_a.close()
f_write_b.close()
