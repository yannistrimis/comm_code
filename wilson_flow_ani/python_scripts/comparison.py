import numpy as np

exact_ct = np.zeros(15)
j_lat = -1
for i_lat in [1000,950,900,850,800,750,700,650,600,550,500,450,400,350,300]:
	j_lat = j_lat + 1
	f_read = open("/mnt/home/trimisio/outputs/l1616b7000x100a/sflow1616b7000x100xf100a_dt0.0078125_rkmk8.%d"%(i_lat),"r")
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
		j = j + 1




arr_ct = np.zeros((6,3,15))
j_name = -1
for name in ["bbb","cf3","ck","lue","rkmk3","rkmk4"]:
	j_name = j_name + 1
	j_dt = -1
	for dt in ["0.0078125","0.015625","0.03125"]:
		j_dt = j_dt + 1
		j_lat = -1
		for i_lat in [1000,950,900,850,800,750,700,650,600,550,500,450,400,350,300]:
			j_lat = j_lat + 1
			f_read = open("/mnt/home/trimisio/outputs/l1616b7000x100a/sflow1616b7000x100xf100a_dt%s_%s.%d"%(dt,name,i_lat),"r")
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
				j = j + 1



for j_lat in range(15):
	arr_ct[:,:,j_lat] = np.abs( arr_ct[:,:,j_lat]-exact_ct[j_lat] )

dt1_3 = 0.0078125
dt2_3 = 0.015625
dt3_3 = 0.03125

f_write = open("ct.dat","w")
f_write.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt1_3,arr_ct[0,0,0],arr_ct[1,0,0],arr_ct[2,0,0],arr_ct[3,0,0],arr_ct[4,0,0],arr_ct[5,0,0]) )
f_write.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f\n"%(dt2_3,arr_ct[0,1,0],arr_ct[1,1,0],arr_ct[2,1,0],arr_ct[3,1,0],arr_ct[4,1,0],arr_ct[5,1,0]) )
f_write.write( "%.16f %.16f %.16f %.16f %.16f %.16f %.16f"%(dt3_3,arr_ct[0,2,0],arr_ct[1,2,0],arr_ct[2,2,0],arr_ct[3,2,0],arr_ct[4,2,0],arr_ct[5,2,0]) )


f_write.close()
