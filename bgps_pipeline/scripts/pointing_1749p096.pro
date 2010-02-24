@/home/milkyway/student/ginsbura/.idl_startup_publish
workingdir = '/scratch/adam_work/'
individual_obs,'/scratch/sliced_polychrome/1749p096/1749p096_0506_ds1list.txt','nomodel',find_prefix=1,npca=[0],pixsize=7.
individual_obs,'/scratch/sliced_polychrome/1749p096/1749p096_0707_ds1list.txt','nomodel',find_prefix=1,npca=[0],pixsize=7.
$sed 's:/scratch/sliced_polychrome/1749p096/:/scratch/adam_work/1749p096/nomodel:' /scratch/sliced_polychrome/1749p096/1749p096_0506_ds1list.txt | sed 's/ds1.nc/ds1.nc_indiv0pca_map0.fits/' > /scratch/adam_work/1749p096/1749p096_0506_maplist.txt
$sed 's:/scratch/sliced_polychrome/1749p096/:/scratch/adam_work/1749p096/nomodel:' /scratch/sliced_polychrome/1749p096/1749p096_0707_ds1list.txt | sed 's/ds1.nc/ds1.nc_indiv0pca_map0.fits/' > /scratch/adam_work/1749p096/1749p096_0707_maplist.txt
centroid_file_list,'/scratch/adam_work/1749p096/1749p096_0506_maplist.txt','/scratch/adam_work/1749p096/centroids_nomodel_0506.txt',  ra= 267.887 ,  dec=   9.65019
centroid_file_list,'/scratch/adam_work/1749p096/1749p096_0707_maplist.txt','/scratch/adam_work/1749p096/centroids_nomodel_0707.txt',  ra= 267.887 ,  dec=   9.65019 
readcol,'/scratch/adam_work/1749p096/centroids_nomodel_0506.txt',name,xpix,ypix,ra,dec,raoff,decoff,alt,az,altoff,azoff,fzao,fazo,format="(A80,FFFFFFFFFFFF)"
readcol,'/scratch/adam_work/1749p096/centroids_nomodel_0707.txt',name,xpix,ypix,ra,dec,raoff,decoff,alt,az,altoff,azoff,fzao,fazo,format="(A80,FFFFFFFFFFFF)"



; in /scratch/sliced_polychrome/1749p096
; ls `pwd`/0506*_ds1.nc > 1749p096_0506_ds1list.txt
; ls `pwd`/0707*_ds1.nc > 1749p096_0707_ds1list.txt
