import numpy as np

exact_ct = np.zeros(15)
exact_cs = np.zeros(15)

j_lat = -1
for i_lat in [300]:
	j_lat = j_lat + 1
	f_read = open("/mnt/home/trimisio/outputs/l1680b7000x42000a/sflow1680b7000x42000xf450a_dt0.0078125_rkmk8.%d"%(i_lat),"r")
	content = f_read.readlines()
	f_read.close()
	flag = 0
	j = 0
	while flag == 0 :
		my_line = content[j].split(" ")
		if my_line[0] == "GFLOW:" :
			if my_line[1] == "2.4" :
				flag = 1
				exact_ct[j_lat] = float( my_line[2] ) # C_t
				exact_cs[j_lat] = float( my_line[3] ) # C_s

		j = j + 1




arr_ct = np.zeros((6,6,15))
arr_cs = np.zeros((6,6,15))

j_name = -1
for name in ["bbb","cf3","ck","lue","rkmk3","rkmk4"]:
	j_name = j_name + 1
	j_dt = -1
	for dt in ["0.00390625","0.00552427","0.0078125","0.01104854","0.015625","0.03125"]:
		j_dt = j_dt + 1
		j_lat = -1
		for i_lat in [300]:
			j_lat = j_lat + 1
			f_read = open("/mnt/home/trimisio/outputs/l1680b7000x42000a/sflow1680b7000x42000xf450a_dt%s_%s.%d"%(dt,name,i_lat),"r")
			content = f_read.readlines()
			f_read.close()
			flag = 0
			j = 0
			while flag == 0 :
				my_line = content[j].split(" ")
				if my_line[0] == "GFLOW:" :
					if my_line[1] == "2.4" :
						flag = 1
						arr_ct[j_name,j_dt,j_lat] = float( my_line[2] ) # C_t
						arr_cs[j_name,j_dt,j_lat] = float( my_line[3] ) # C_s
												
				j = j + 1

for j_lat in range(15):
        arr_ct[:,:,j_lat] = np.abs( arr_ct[:,:,j_lat]-exact_ct[j_lat] )
        arr_cs[:,:,j_lat] = np.abs( arr_cs[:,:,j_lat]-exact_cs[j_lat] )

dt1 = 0.00390625
dt2 = 0.00552427
dt3 = 0.0078125
dt4 = 0.01104854
dt5 = 0.015625
dt6 = 0.03125

f_write1 = open("sflow1680b7000x42000xf450a_ct.dat","w")
f_write1.write( "%E %E %E %E %E %E %E\n"%(dt1,arr_ct[0,0,0],arr_ct[1,0,0],arr_ct[2,0,0],arr_ct[3,0,0],arr_ct[4,0,0],arr_ct[5,0,0]) )
f_write1.write( "%E %E %E %E %E %E %E\n"%(dt2,arr_ct[0,1,0],arr_ct[1,1,0],arr_ct[2,1,0],arr_ct[3,1,0],arr_ct[4,1,0],arr_ct[5,1,0]) )
f_write1.write( "%E %E %E %E %E %E %E\n"%(dt3,arr_ct[0,2,0],arr_ct[1,2,0],arr_ct[2,2,0],arr_ct[3,2,0],arr_ct[4,2,0],arr_ct[5,2,0]) )
f_write1.write( "%E %E %E %E %E %E %E\n"%(dt4,arr_ct[0,3,0],arr_ct[1,3,0],arr_ct[2,3,0],arr_ct[3,3,0],arr_ct[4,3,0],arr_ct[5,3,0]) )
f_write1.write( "%E %E %E %E %E %E %E\n"%(dt5,arr_ct[0,4,0],arr_ct[1,4,0],arr_ct[2,4,0],arr_ct[3,4,0],arr_ct[4,4,0],arr_ct[5,4,0]) )
f_write1.write( "%E %E %E %E %E %E %E"%(dt6,arr_ct[0,5,0],arr_ct[1,5,0],arr_ct[2,5,0],arr_ct[3,5,0],arr_ct[4,5,0],arr_ct[5,5,0]) )


f_write1.close()

f_write2 = open("sflow1680b7000x42000xf450a_cs.dat","w")
f_write2.write( "%E %E %E %E %E %E %E\n"%(dt1,arr_cs[0,0,0],arr_cs[1,0,0],arr_cs[2,0,0],arr_cs[3,0,0],arr_cs[4,0,0],arr_cs[5,0,0]) )
f_write2.write( "%E %E %E %E %E %E %E\n"%(dt2,arr_cs[0,1,0],arr_cs[1,1,0],arr_cs[2,1,0],arr_cs[3,1,0],arr_cs[4,1,0],arr_cs[5,1,0]) )
f_write2.write( "%E %E %E %E %E %E %E\n"%(dt3,arr_cs[0,2,0],arr_cs[1,2,0],arr_cs[2,2,0],arr_cs[3,2,0],arr_cs[4,2,0],arr_cs[5,2,0]) )
f_write2.write( "%E %E %E %E %E %E %E\n"%(dt4,arr_cs[0,3,0],arr_cs[1,3,0],arr_cs[2,3,0],arr_cs[3,3,0],arr_cs[4,3,0],arr_cs[5,3,0]) )
f_write2.write( "%E %E %E %E %E %E %E\n"%(dt5,arr_cs[0,4,0],arr_cs[1,4,0],arr_cs[2,4,0],arr_cs[3,4,0],arr_cs[4,4,0],arr_cs[5,4,0]) )
f_write2.write( "%E %E %E %E %E %E %E"%(dt6,arr_cs[0,5,0],arr_cs[1,5,0],arr_cs[2,5,0],arr_cs[3,5,0],arr_cs[4,5,0],arr_cs[5,5,0]) )


f_write2.close()

