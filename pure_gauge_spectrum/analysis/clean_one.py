import numpy as np

cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec'
vol = '1616'
beta = '7000'
x0 = '100'
stream = 'a'
i_file = input()
mass_line = input()
source_line = input()
sink_line = input()
ens_name = vol+'b'+beta+'x'+x0+stream
f_read = open('%s/l%s/spec%s.lat.%s'%(cur_dir,ens_name,ens_name,i_file),'r')
f_write_a = open('%s/l%s/clean_spec%s.lat.%sa'%(cur_dir,ens_name,ens_name,i_file),'w')
f_write_b = open('%s/l%s/clean_spec%s.lat.%sb'%(cur_dir,ens_name,ens_name,i_file),'w')

source_flag = 0
flag = 0
counter = 0

content = f_read.readlines()
for line in content:
	split_line = line.split(' ')

	if split_line[0]=='#' and split_line[1]=='source' and split_line[2]=='time':
		source_flag = source_flag + 1

	if line == 'STARTPROP\n' :
		flag = 1
	elif flag == 1 and line == mass_line :
		flag = 2
	elif flag == 2 and line == source_line :
		flag = 3
	elif flag ==3 and line == sink_line :
	elif flag == 3 and split_line[0] == '0' :
		flag = 4
		counter = 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag == 4 and split_line[0] == str(counter) :
		counter = counter + 1
		if source_flag == 1 :
			f_write_a.write('%s'%(line))
		elif source_flag == 2 :
			f_write_b.write('%s'%(line))
	elif flag == 4 and line == 'ENDPROP\n' :
		flag = 0
		counter = 0

f_read.close()
f_write_a.close()
f_write_b.close()
