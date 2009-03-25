@/home/milkyway/student/ginsbura/.idl_startup_publish
workingdir = '/scratch/adam_work/'
individual_obs,'/scratch/sliced_polychrome/3c273/3c273_0506_ds1list.txt','nomodel',find_prefix=1,npca=[0],pixsize=7.
individual_obs,'/scratch/sliced_polychrome/3c273/3c273_0606_ds1list.txt','nomodel',find_prefix=1,npca=[0],pixsize=7.
individual_obs,'/scratch/sliced_polychrome/3c273/3c273_0707_ds1list.txt','nomodel',find_prefix=1,npca=[0],pixsize=7.
;$sed 's:/scratch/sliced_polychrome/3c273/:/scratch/adam_work/3c273/nomodel:' /scratch/sliced_polychrome/3c273/3c273_0506_ds1list.txt | sed 's/ds1.nc/ds1.nc_indiv0pca_map0.fits/' > /scratch/adam_work/3c273/3c273_0506_maplist.txt
;$sed 's:/scratch/sliced_polychrome/3c273/:/scratch/adam_work/3c273/nomodel:' /scratch/sliced_polychrome/3c273/3c273_0606_ds1list.txt | sed 's/ds1.nc/ds1.nc_indiv0pca_map0.fits/' > /scratch/adam_work/3c273/3c273_0606_maplist.txt
;$sed 's:/scratch/sliced_polychrome/3c273/:/scratch/adam_work/3c273/nomodel:' /scratch/sliced_polychrome/3c273/3c273_0707_ds1list.txt | sed 's/ds1.nc/ds1.nc_indiv0pca_map0.fits/' > /scratch/adam_work/3c273/3c273_0707_maplist.txt
;centroid_file_list,'/scratch/adam_work/3c273/3c273_0506_maplist.txt','/scratch/adam_work/3c273/centroids_nomodel_0506.txt',  ra= 187.277915   ,  dec= +02.052388
;centroid_file_list,'/scratch/adam_work/3c273/3c273_0606_maplist.txt','/scratch/adam_work/3c273/centroids_nomodel_0606.txt',  ra= 187.277915   ,  dec= +02.052388
;centroid_file_list,'/scratch/adam_work/3c273/3c273_0707_maplist.txt','/scratch/adam_work/3c273/centroids_nomodel_0707.txt',  ra= 187.277915   ,  dec= +02.052388
;readcol,'/scratch/adam_work/3c273/centroids_nomodel_0506.txt',name,xpix,ypix,ra,dec,raoff,decoff,alt,az,altoff,azoff,fzao,fazo,format="(A80,FFFFFFFFFFFF)"



