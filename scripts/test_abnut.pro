
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/plusabnut_nomodel',find_prefix=0,abnutsign='p'
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/minusabnut_nomodel',find_prefix=0,abnutsign='m'
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/plusabnut_pm',find_prefix=0,abnutsign='p',/pointing_model
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/minusabnut_pm',find_prefix=0,abnutsign='m',/pointing_model
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/plusabnut_mp',find_prefix=0,abnutsign='p',/pointing_model,/mp
individual_obs,'/scratch/adam_work/texts/SINGLE_FILE_TEST.txt','TEST/minusabnut_mp',find_prefix=0,abnutsign='m',/pointing_model,/mp
$echo "/scratch/adam_work/TEST/plusabnut_nomodel070717_ob6_raw_nods.nc_indiv3pca_map0.fits" > /scratch/adam_work/TEST/test_maplist.txt
$echo "/scratch/adam_work/TEST/minusabnut_nomodel070717_ob6_raw_nods.nc_indiv3pca_map0.fits" >> /scratch/adam_work/TEST/test_maplist.txt
$echo "/scratch/adam_work/TEST/plusabnut_pm070717_ob6_raw_nods.nc_indiv3pca_map0.fits" >> /scratch/adam_work/TEST/test_maplist.txt
$echo "/scratch/adam_work/TEST/minusabnut_pm070717_ob6_raw_nods.nc_indiv3pca_map0.fits" >> /scratch/adam_work/TEST/test_maplist.txt
$echo "/scratch/adam_work/TEST/plusabnut_mp070717_ob6_raw_nods.nc_indiv3pca_map0.fits" >> /scratch/adam_work/TEST/test_maplist.txt
$echo "/scratch/adam_work/TEST/minusabnut_mp070717_ob6_raw_nods.nc_indiv3pca_map0.fits" >> /scratch/adam_work/TEST/test_maplist.txt
centroid_file_list,'/scratch/adam_work/TEST/test_maplist.txt','/scratch/adam_work/TEST/test_centroids.txt',  ra= 278.416 ,  dec=   -21.0611


