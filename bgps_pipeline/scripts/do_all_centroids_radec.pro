@/home/milkyway/student/ginsbura/.idl_startup_publish
.run centroid_file_list
.run centroid_plots,homedir='/usb/scratch1'
;!EXCEPT=0
workingdir = '/usb/scratch1'
cd,workingdir
time_s,"start",all_time

;centroid_file_list,'/usb/scratch1/texts/meredith_0707_ptg_radec_maplist.txt','/usb/scratch1/texts/meredith_0707_ptg_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/meredith_0707_ptg_radec_centroids.txt','0707','meredith_ptg_radec',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/meredith_0707_pca_radec_maplist.txt','/usb/scratch1/texts/meredith_0707_pca_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/meredith_0707_pca_radec_centroids.txt','0707','meredith_pca_radec',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/meredith_0707_minus_radec_maplist.txt','/usb/scratch1/texts/meredith_0707_minus_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/meredith_0707_minus_radec_centroids.txt','0707','meredith_minus_radec',homedir='/usb/scratch1'
;
;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','raw_radec',find_prefix=1,npca=[3],pixsize=7.2,projection='TAN',coordsys='radec'
;centroid_file_list,'/usb/scratch1/texts/0707_raw_radec_maplist.txt','/usb/scratch1/texts/0707_raw_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_raw_radec_centroids.txt','0707','raw_radec',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/0707_raw_radec_maplist_part1.txt','/usb/scratch1/texts/0707_raw_radec_centroids_part1.txt'
;centroid_plots,'/usb/scratch1/texts/0707_raw_radec_centroids_part1.txt','0707','raw_radec_part1',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/0707_raw_radec_maplist_part2.txt','/usb/scratch1/texts/0707_raw_radec_centroids_part2.txt'
;centroid_plots,'/usb/scratch1/texts/0707_raw_radec_centroids_part2.txt','0707','raw_radec_part2',homedir='/usb/scratch1'

;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.2,/pointing_model,/raw_cso_pointing,projection='TAN',coordsys='radec',workingdir=workingdir
centroid_file_list,'/usb/scratch1/texts/0707_rawcsoptg_radec_maplist.txt','/usb/scratch1/texts/0707_rawcsoptg_radec_centroids.txt',/savfile
centroid_plots,'/usb/scratch1/texts/0707_rawcsoptg_radec_centroids.txt','0707','rawcsoptg_radec',homedir='/usb/scratch1'

individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','ptgmdl_radec',find_prefix=1,npca=[3],pixsize=7.2,/pointing_model,projection='TAN',coordsys='radec',workingdir=workingdir
centroid_file_list,'/usb/scratch1/texts/0707_ptgmdl_radec_maplist.txt','/usb/scratch1/texts/0707_ptgmdl_radec_centroids.txt'
centroid_plots,'/usb/scratch1/texts/0707_ptgmdl_radec_centroids.txt','0707','ptgmdl_radec',homedir='/usb/scratch1'
centroid_file_list,'/usb/scratch1/texts/0707_rawcsoptg_radec_maplist_part1.txt','/usb/scratch1/texts/0707_rawcsoptg_radec_centroids_part1.txt'
centroid_plots,'/usb/scratch1/texts/0707_rawcsoptg_radec_centroids_part1.txt','0707','rawcsoptg_radec_part1',homedir='/usb/scratch1'
centroid_file_list,'/usb/scratch1/texts/0707_rawcsoptg_radec_maplist_part2.txt','/usb/scratch1/texts/0707_rawcsoptg_radec_centroids_part2.txt'
centroid_plots,'/usb/scratch1/texts/0707_rawcsoptg_radec_centroids_part2.txt','0707','rawcsoptg_radec_part2',homedir='/usb/scratch1'

individual_obs,'/usb/scratch1/texts/0709_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.2,/pointing_model,/raw_cso_pointing,projection='TAN',coordsys='radec',workingdir=workingdir
centroid_file_list,'/usb/scratch1/texts/0709_rawcsoptg_radec_maplist.txt','/usb/scratch1/texts/0709_rawcsoptg_radec_centroids.txt',/savfile
centroid_plots,'/usb/scratch1/texts/0709_rawcsoptg_radec_centroids.txt','0709','rawcsoptg_radec',homedir='/usb/scratch1'

individual_obs,'/usb/scratch1/texts/0709_ds1_pointing.txt','ptgmdl_radec',find_prefix=1,npca=[3],pixsize=7.2,/pointing_model,projection='TAN',coordsys='radec',workingdir=workingdir
centroid_file_list,'/usb/scratch1/texts/0709_ptgmdl_radec_maplist.txt','/usb/scratch1/texts/0709_ptgmdl_radec_centroids.txt'
centroid_plots,'/usb/scratch1/texts/0709_ptgmdl_radec_centroids.txt','0709','ptgmdl_radec',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/0709_rawcsoptg_radec_maplist_part1.txt','/usb/scratch1/texts/0709_rawcsoptg_radec_centroids_part1.txt'
;centroid_plots,'/usb/scratch1/texts/0709_rawcsoptg_radec_centroids_part1.txt','0709','rawcsoptg_radec_part1',homedir='/usb/scratch1'
;centroid_file_list,'/usb/scratch1/texts/0709_rawcsoptg_radec_maplist_part2.txt','/usb/scratch1/texts/0709_rawcsoptg_radec_centroids_part2.txt'
;centroid_plots,'/usb/scratch1/texts/0709_rawcsoptg_radec_centroids_part2.txt','0709','rawcsoptg_radec_part2',homedir='/usb/scratch1'


;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.,/pointing_model,/raw_cso_pointing,projection='TAN',coordsys='radec'

print,"DONE do_all_radec_centroids",systime()
time_e,all_time,prtmsg="Finish "



;;centroid_file_list,'/usb/scratch1/texts/0707_ptgmdl_radec_maplist03.txt','/usb/scratch1/texts/0707_ptgmdl_radec_centroids03.txt'
;__; ;;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','ptgmdl_radec_corr',find_prefix=1,npca=[3],pixsize=7.,/pointing_model,projection='TAN',coordsys='radec',/pointoff_correct
;;$find /usb/scratch1/ -name "ptgmdl_radec0707*_map0*.fits" > texts/ptgmdl_0707_radec_maplist.txt
;
;__; ;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model,projection='TAN',coordsys='radec'
;__; ;;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','rawcsoptg_radec_corr',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model,projection='TAN',coordsys='radec',/pointoff_correct
;;$find /usb/scratch1/ -name "rawcsoptg_radec0707*_map0*.fits" > texts/rawcsoptg_0707_radec_maplist.txt
;;centroid_file_list,'/usb/scratch1/texts/0707_rawcsoptg_corr_maplist.txt','/usb/scratch1/texts/0707_rawcsoptg_radec_corr_centroids.txt'
;;centroid_file_list,'/usb/scratch1/texts/0707_rawcsoptg_radec_maplist03.txt','/usb/scratch1/texts/0707_rawcsoptg_radec_centroids03.txt'

;__; ;individual_obs,'/usb/scratch1/texts/all_0506_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model,projection='TAN',coordsys='radec'
;$find /usb/scratch1/ -name "rawcsoptg_radec0506*_map0*.fits" > texts/rawcsoptg_0506_radec_maplist.txt
;centroid_file_list,'/usb/scratch1/texts/rawcsoptg_0506_radec_maplist.txt','/usb/scratch1/texts/rawcsoptg_0506_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/rawcsoptg_0506_radec_centroids.txt','0506','rawcsoptg_radec',homedir='/usb/scratch1'
;
;__; ;individual_obs,'/usb/scratch1/texts/all_0506_ds1_pointing.txt','ptgmdl_radec',find_prefix=1,npca=[3],pixsize=7.,/pointing_model,projection='TAN',coordsys='radec'
;$find /usb/scratch1/ -name "ptgmdl_radec0506*_map0*.fits" > texts/ptgmdl_0506_radec_maplist.txt
;centroid_file_list,'/usb/scratch1/texts/ptgmdl_0506_radec_maplist.txt','/usb/scratch1/texts/ptgmdl_0506_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/ptgmdl_0506_radec_centroids.txt','0506','ptgmdl_radec',homedir='/usb/scratch1'
;
;__; ;individual_obs,'/usb/scratch1/texts/all_0606_ds1_pointing.txt','rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model,projection='TAN',coordsys='radec'
;$find /usb/scratch1/ -name "rawcsoptg_radec0606*_map0*.fits" > texts/rawcsoptg_0606_radec_maplist.txt
;centroid_file_list,'/usb/scratch1/texts/rawcsoptg_0606_radec_maplist.txt','/usb/scratch1/texts/rawcsoptg_0606_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/rawcsoptg_0606_radec_centroids.txt','0606','rawcsoptg_radec',homedir='/usb/scratch1'
;
;__; ;individual_obs,'/usb/scratch1/texts/all_0606_ds1_pointing.txt','ptgmdl_radec',find_prefix=1,npca=[3],pixsize=7.,/pointing_model,projection='TAN',coordsys='radec'
;$find /usb/scratch1/ -name "ptgmdl_radec0606*_map0*.fits" > texts/ptgmdl_0606_radec_maplist.txt
;centroid_file_list,'/usb/scratch1/texts/ptgmdl_0606_radec_maplist.txt','/usb/scratch1/texts/ptgmdl_0606_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/ptgmdl_0606_radec_centroids.txt','0606','ptgmdl_radec',homedir='/usb/scratch1'
;
;__; ;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','corrall_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=1
;centroid_file_list,'/usb/scratch1/texts/0707_corrall_radec_maplist.txt','/usb/scratch1/texts/0707_corrall_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_corrall_radec_centroids.txt','0707','corrall_radec',homedir='/usb/scratch1'

;__; individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','nocorr_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=0,aberration=0,nutate=0
;centroid_file_list,'/usb/scratch1/texts/0707_nocorr_radec_maplist.txt','/usb/scratch1/texts/0707_nocorr_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_nocorr_radec_centroids.txt','0707','nocorr_radec',homedir='/usb/scratch1'

;__; individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','noab_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=0,nutate=1
;centroid_file_list,'/usb/scratch1/texts/0707_noab_radec_maplist.txt','/usb/scratch1/texts/0707_noab_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_noab_radec_centroids.txt','0707','noab_radec',homedir='/usb/scratch1'

;__; individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','nonut_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=0
;centroid_file_list,'/usb/scratch1/texts/0707_nonut_radec_maplist.txt','/usb/scratch1/texts/0707_nonut_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_nonut_radec_centroids.txt','0707','nonut_radec',homedir='/usb/scratch1'

;__; ;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','noabnut_rawcsoptg_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=0,nutate=0,/pointing_model,/raw_cso_pointing
;centroid_file_list,'/usb/scratch1/texts/0707_noabnut_rawcsoptg_radec_maplist.txt','/usb/scratch1/texts/0707_noabnut_rawcsoptg_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_noabnut_rawcsoptg_radec_centroids.txt','0707','noabnut_rawcsoptg_radec',homedir='/usb/scratch1'
;
;__; ;individual_obs,'/usb/scratch1/texts/0707_ds1_pointing.txt','noabnut_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=0,nutate=0
;centroid_file_list,'/usb/scratch1/texts/0707_noabnut_radec_maplist.txt','/usb/scratch1/texts/0707_noabnut_radec_centroids.txt'
;centroid_plots,'/usb/scratch1/texts/0707_noabnut_radec_centroids.txt','0707','noabnut_radec',homedir='/usb/scratch1'
;
