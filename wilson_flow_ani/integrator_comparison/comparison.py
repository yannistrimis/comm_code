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




arr_ct = np.zeros((6,3,15))
arr_cs = np.zeros((6,3,15))

j_name = -1
for name in ["bbb","cf3","ck","lue","rkmk3","rkmk4"]:
	j_name = j_name + 1
	j_dt = -1
	for dt in ["0.0078125","0.015625","0.03125"]:
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

dt1_3 = 0.0078125
dt2_3 = 0.015625
dt3_3 = 0.03125

f_write1 = open("sflow1680b7000x42000xf450a_ct.dat","w")
f_write1.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt1_3,arr_ct[0,0,0],arr_ct[1,0,0],arr_ct[2,0,0],arr_ct[3,0,0],arr_ct[4,0,0],arr_ct[5,0,0]) )
f_write1.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt2_3,arr_ct[0,1,0],arr_ct[1,1,0],arr_ct[2,1,0],arr_ct[3,1,0],arr_ct[4,1,0],arr_ct[5,1,0]) )
f_write1.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f"%(dt3_3,arr_ct[0,2,0],arr_ct[1,2,0],arr_ct[2,2,0],arr_ct[3,2,0],arr_ct[4,2,0],arr_ct[5,2,0]) )


f_write1.close()

f_write2 = open("sflow1680b7000x42000xf450a_cs.dat","w")
f_write2.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt1_3,arr_cs[0,0,0],arr_cs[1,0,0],arr_cs[2,0,0],arr_cs[3,0,0],arr_cs[4,0,0],arr_cs[5,0,0]) )
f_write2.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt2_3,arr_cs[0,1,0],arr_cs[1,1,0],arr_cs[2,1,0],arr_cs[3,1,0],arr_cs[4,1,0],arr_cs[5,1,0]) )
f_write2.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f"%(dt3_3,arr_cs[0,2,0],arr_cs[1,2,0],arr_cs[2,2,0],arr_cs[3,2,0],arr_cs[4,2,0],arr_cs[5,2,0]) )


f_write2.close()

