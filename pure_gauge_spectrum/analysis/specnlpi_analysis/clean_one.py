import numpy as np

ens_name = input()
pre_name = input()
i_file = input()
mom = input()
mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinkop1 = input()
sinkop2 = input()
sinks = input()
out_name = input()

# cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec' # ICER
# out_dir = '/mnt/home/trimisio/plot_data/spec_data' # ICER

cur_dir = '/project/ahisq/yannis_puregauge/outputs/pure_gauge_spec' # FNAL
out_dir = '/home/trimisio/all/spec_data' # FNAL


f_read = open('%s/l%s/%s.%s'%(cur_dir,ens_name,pre_name,i_file),'r')

content = f_read.readlines()

f_write_a = open('%s/l%s/%s.%sa'%(out_dir,ens_name,out_name,i_file),'w')
f_write_b = open('%s/l%s/%s.%sb'%(out_dir,ens_name,out_name,i_file),'w')

source_flag = 0
flag = -1
counter = 0

mom_line = 'MOMENTUM:' + ' ' + mom
mass_line = 'MASSES:' + ' ' + mass1 + ' ' + mass2 + ' '
source_line = 'SOURCE:' + ' ' + source1 + ' ' +  source2
sinkops_line = 'SINKOPS:' + ' ' + sinkop1 + ' ' + sinkop2
sink_line = 'SINKS:' + ' ' + sinks

for line in content:
	split_line = line.split(' ')
	if split_line[0]=='#' and split_line[1]=='source' and split_line[2]=='time':
		source_flag = source_flag + 1

	if line.rstrip('\n') == 'STARTPROP' :
		flag = 0
	elif flag==0 and line.rstrip('\n')==mom_line :
		flag = 1
	elif flag==1 and line.rstrip('\n')==mass_line :
		flag = 2
	elif flag==2 and line.rstrip('\n')==source_line :
		flag = 3		
	elif flag==3 and line.rstrip('\n')==sinkops_line :
		flag = 4
	elif flag==4 and line.rstrip('\n')==sink_line :
		flag = 5
	elif flag==5 and split_line[0]=='0' :
		flag = 6
		counter = 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag==6 and split_line[0]==str(counter) :
		counter = counter + 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag==6 and line.rstrip('\n')=='ENDPROP' :
		flag = -1
		counter = 0

f_write_a.close()
f_write_b.close()

f_read.close()

