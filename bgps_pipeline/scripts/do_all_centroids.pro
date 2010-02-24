;@/home/milkyway/student/ginsbura/.idl_startup_bgps
@/home/milkyway/student/ginsbura/.idl_startup_publish
!EXCEPT=0
;@loadeverything
;.run ag_pointing
;.run mem_iter_pc
;.run readall_pc
;.run ts_to_map
workingdir = '/scratch/adam_work/'
cd,workingdir
time_s,"start",all_time

;individual_obs,'/scratch/adam_work/texts/0707_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
;centroid_file_list,'/scratch/adam_work/texts/0707_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0707_rawcsoptg_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/0707_rawcsoptg_centroids.txt','0707','rawcsoptg'

;individual_obs,'/scratch/adam_work/texts/0707_ds1_pointing.txt','myptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
;centroid_file_list,'/scratch/adam_work/texts/0707_myptgmdl_maplist.txt','/scratch/adam_work/texts/0707_myptgmdl_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/0707_myptgmdl_centroids.txt','0707','myptgmdl'
;centroid_file_list,'/scratch/adam_work/texts/0707_myptgmdl_maplist_part1.txt','/scratch/adam_work/texts/0707_myptgmdl_centroids_part1.txt'
;centroid_file_list,'/scratch/adam_work/texts/0707_myptgmdl_maplist_part2.txt','/scratch/adam_work/texts/0707_myptgmdl_centroids_part2.txt'
;centroid_plots,'/scratch/adam_work/texts/0707_myptgmdl_centroids_part1.txt','0707','myptgmdl_part1'
;centroid_plots,'/scratch/adam_work/texts/0707_myptgmdl_centroids_part2.txt','0707','myptgmdl_part2'

;individual_obs,'/scratch/adam_work/texts/0707_ds1_pointing.txt','raw',find_prefix=1,npca=[3],pixsize=7.
;centroid_file_list,'/scratch/adam_work/texts/0707_raw_maplist.txt','/scratch/adam_work/texts/0707_raw_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/0707_raw_centroids.txt','0707','raw'
;centroid_file_list,'/scratch/adam_work/texts/0707_raw_maplist_part1.txt','/scratch/adam_work/texts/0707_raw_centroids_part1.txt'
;centroid_file_list,'/scratch/adam_work/texts/0707_raw_maplist_part2.txt','/scratch/adam_work/texts/0707_raw_centroids_part2.txt'
;centroid_plots,'/scratch/adam_work/texts/0707_raw_centroids_part1.txt','0707','raw_part1'
;centroid_plots,'/scratch/adam_work/texts/0707_raw_centroids_part2.txt','0707','raw_part2'

;individual_obs,'texts/0506_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0506_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0506_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0506_rawcsoptg_centroids.txt','0506','rawcsoptg'

;individual_obs,'texts/0506_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0506_ptgmdl_maplist.txt','/scratch/adam_work/texts/0506_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0506_ptgmdl_centroids.txt','0506','ptgmdl'

;individual_obs,'texts/0507_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0507_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0507_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0507_rawcsoptg_centroids.txt','0507','rawcsoptg'

;individual_obs,'texts/0507_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0507_ptgmdl_maplist.txt','/scratch/adam_work/texts/0507_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0507_ptgmdl_centroids.txt','0507','ptgmdl'

;individual_obs,'texts/0509_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0509_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0509_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0509_rawcsoptg_centroids.txt','0509','rawcsoptg'

;individual_obs,'texts/0509_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0509_ptgmdl_maplist.txt','/scratch/adam_work/texts/0509_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0509_ptgmdl_centroids.txt','0509','ptgmdl'

;individual_obs,'texts/0606_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0606_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0606_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0606_rawcsoptg_centroids.txt','0606','rawcsoptg'

;individual_obs,'texts/0606_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0606_ptgmdl_maplist.txt','/scratch/adam_work/texts/0606_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0606_ptgmdl_centroids.txt','0606','ptgmdl'

;individual_obs,'texts/0609_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0609_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0609_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0609_rawcsoptg_centroids.txt','0609','rawcsoptg'

;individual_obs,'texts/0609_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0609_ptgmdl_maplist.txt','/scratch/adam_work/texts/0609_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0609_ptgmdl_centroids.txt','0609','ptgmdl'

;individual_obs,'texts/0705_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0705_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0705_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0705_rawcsoptg_centroids.txt','0705','rawcsoptg'

;individual_obs,'texts/0705_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0705_ptgmdl_maplist.txt','/scratch/adam_work/texts/0705_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0705_ptgmdl_centroids.txt','0705','ptgmdl'

;individual_obs,'texts/0706_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0706_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0706_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0706_rawcsoptg_centroids.txt','0706','rawcsoptg'

;individual_obs,'texts/0706_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0706_ptgmdl_maplist.txt','/scratch/adam_work/texts/0706_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0706_ptgmdl_centroids.txt','0706','ptgmdl'
;individual_obs,'texts/0709_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0709_rawcsoptg_maplist.txt','/scratch/adam_work/texts/0709_rawcsoptg_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0709_rawcsoptg_centroids.txt','0709','rawcsoptg'

;individual_obs,'texts/0709_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
centroid_file_list,'/scratch/adam_work/texts/0709_ptgmdl_maplist.txt','/scratch/adam_work/texts/0709_ptgmdl_centroids.txt',/savfile
centroid_plots,'/scratch/adam_work/texts/0709_ptgmdl_centroids.txt','0709','ptgmdl'


;individual_obs,'texts/0606_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
;;$find /scratch/adam_work/ -name "rawcsoptg0606*_map0.fits" > texts/rawcsoptg_0606_maplist.txt
;centroid_file_list,'/scratch/adam_work/texts/rawcsoptg_0606_maplist.txt','/scratch/adam_work/texts/rawcsoptg_0606_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/rawcsoptg_0606_centroids.txt','0606','rawcsoptg'
;
;individual_obs,'texts/0606_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
;;$find /scratch/adam_work/ -name "ptgmdl0606*_map0.fits" > texts/ptgmdl_0606_maplist.txt
;centroid_file_list,'/scratch/adam_work/texts/ptgmdl_0606_maplist.txt','/scratch/adam_work/texts/ptgmdl_0606_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/ptgmdl_0606_centroids.txt','0606','ptgmdl'
print,"DONE do_all_centroids",systime()

time_e,all_time,prtmsg="Finish "

;individual_obs,'texts/all_0506_ds1_pointing.txt','nomodel',find_prefix=1,npca=[3],pixsize=7.
;individual_obs,'texts/all_nods_nopps.txt','nomodel',find_prefix=1,npca=[3],pixsize=7.
;individual_obs,'texts/all_0506_ds1_pointing.txt','nocorr',find_prefix=1,npca=[3],pixsize=7.,/dontprecess,/dontabnut
;individual_obs,'texts/all_nods_nopps.txt','nocorr',find_prefix=1,npca=[3],pixsize=7.,/dontprecess,/dontabnut
;print,"DONE individual_obs in do_all_centroids.  ",systime()
;$find /scratch/adam_work/ -name "nomodel*_map0.fits" > texts/no
;$find /scratch/adam_work/ -name "nomodel0506*_map0.fits" > texts/nomodel_0506_maplist.txt  
;$find /scratch/adam_work/ -name "nocorr0506*_map0.fits" > texts/nocorr_0506_maplist.txt  
;$find /scratch/adam_work/ -name "rawcsoptg0506*_map0.fits" > texts/rawcsoptg_0506_maplist.txt
;$find /scratch/adam_work/ -name "ptgmdl0506*_map0.fits" > texts/ptgmdl_0506_maplist.txt
;centroid_file_list,'/scratch/adam_work/texts/nomodel_0707_maplist.txt','/scratch/adam_work/texts/nomodel_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nomodel_0506_maplist.txt','/scratch/adam_work/texts/nomodel_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nocorr_0707_maplist.txt','/scratch/adam_work/texts/nocorr_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nocorr_0506_maplist.txt','/scratch/adam_work/texts/nocorr_0506_centroids.txt'
;
;
;
;individual_obs,'texts/0707_ds1_pointing.txt','rawcsoptg',find_prefix=1,npca=[3],pixsize=7.,/raw_cso_pointing,/pointing_model
;centroid_file_list,'/scratch/adam_work/texts/rawcsoptg_0707_maplist.txt','/scratch/adam_work/texts/rawcsoptg_0707_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/rawcsoptg_0707_centroids.txt','0707','rawcsoptg'
;
;individual_obs,'texts/0707_ds1_pointing.txt','ptgmdl',find_prefix=1,npca=[3],pixsize=7.,/pointing_model
;centroid_file_list,'/scratch/adam_work/texts/ptgmdl_0707_maplist.txt','/scratch/adam_work/texts/ptgmdl_0707_centroids.txt'
;centroid_plots,'/scratch/adam_work/texts/ptgmdl_0707_centroids.txt','0707','ptgmdl'


;individual_obs,'texts/all_0506_ds1_pointing.txt','nocorr',find_prefix=1,npca=[3],pixsize=7.,/dontprecess,/dontabnut,/galactic
;individual_obs,'texts/all_0506_ds1_pointing.txt','pmm',find_prefix=1,/pointing_model,npca=[3],pixsize=7.,/galactic
;individual_obs,'texts/all_0506_ds1_pointing.txt','mpm',find_prefix=1,/pointing_model,npca=[3],/mp,pixsize=7.,/project_alt
;individual_obs,'texts/all_0506_ds1_pointing.txt','mmm',find_prefix=1,/pointing_model,npca=[3],/mm,pixsize=7.,/galactic
;individual_obs,'texts/all_0506_ds1_pointing.txt','ppm',find_prefix=1,/pointing_model,npca=[3],/pp,pixsize=7.,/galactic
;individual_obs,'texts/all_nods_nopps.txt','nomodel',find_prefix=1,npca=[3],pixsize=7.,/galactic
;individual_obs,'texts/all_nods_nopps.txt','nocorr',find_prefix=1,npca=[3],pixsize=7.,/dontprecess,/dontabnut,/galactic
;individual_obs,'texts/all_nods_nopps.txt','pmm',find_prefix=1,/pointing_model,npca=[3],pixsize=7.,/galactic
;individual_obs,'texts/all_nods_nopps.txt','mpm',find_prefix=1,/pointing_model,/mp,npca=[3],pixsize=7.,/project_alt
;individual_obs,'texts/all_nods_nopps.txt','mmm',find_prefix=1,/pointing_model,/mm,npca=[3],pixsize=7.,/galactic
;individual_obs,'texts/all_nods_nopps.txt','ppm',find_prefix=1,/pointing_model,/pp,npca=[3],pixsize=7.,/galactic
;individual_obs,'texts/sliced_polychrome_ds5s.txt','nomodel',find_prefix=1,npca=[3],pixsize=7.,/galactic
;@pcal_centroiding
;@pcal_centroiding_0506
;$cat texts/pcal*_0707_mpm_centroids.txt > texts/centroids_0707_mpm.txt
;$cat texts/pcal*_0707_pmm_centroids.txt > texts/centroids_0707_pmm.txt
;$cat texts/pcal*_0707_ppm_centroids.txt > texts/centroids_0707_ppm.txt
;$cat texts/pcal*_0707_mmm_centroids.txt > texts/centroids_0707_mmm.txt
;$cat texts/pcal*_0707_nomodel_centroids.txt > texts/centroids_0707_nomodel.txt
;;$cat texts/pcal*_0707_nocorr_centroids.txt > texts/centroids_0707_nocorr.txt
;$cat texts/*mpm_ds1_0506_centroids.txt > texts/centroids_0506_mpm.txt
;$cat texts/*pmm_ds1_0506_centroids.txt > texts/centroids_0506_pmm.txt
;$cat texts/*ppm_ds1_0506_centroids.txt > texts/centroids_0506_ppm.txt
;$cat texts/*mmm_ds1_0506_centroids.txt > texts/centroids_0506_mmm.txt
;$cat texts/*nomodel_ds1_0506_centroids.txt > texts/centroids_0506_nomodel.txt
;;$cat texts/*nocorr_ds1_0506_centroids.txt > texts/centroids_0506_nocorr.txt
;centroid_file_list,'/scratch/adam_work/texts/nocorr_0707_maplist.txt','/scratch/adam_work/texts/nocorr_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nomodel_0707_maplist.txt','/scratch/adam_work/texts/nomodel_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/pmm_0707_maplist.txt','/scratch/adam_work/texts/pmm_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/mpm_0707_maplist.txt','/scratch/adam_work/texts/mpm_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/mmm_0707_maplist.txt','/scratch/adam_work/texts/mmm_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/ppm_0707_maplist.txt','/scratch/adam_work/texts/ppm_0707_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nocorr_0506_maplist.txt','/scratch/adam_work/texts/nocorr_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/nomodel_0506_maplist.txt','/scratch/adam_work/texts/nomodel_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/pmm_0506_maplist.txt','/scratch/adam_work/texts/pmm_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/mpm_0506_maplist.txt','/scratch/adam_work/texts/mpm_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/mmm_0506_maplist.txt','/scratch/adam_work/texts/mmm_0506_centroids.txt'
;centroid_file_list,'/scratch/adam_work/texts/ppm_0506_maplist.txt','/scratch/adam_work/texts/ppm_0506_centroids.txt'
;    readcol,centfile,name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;        fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A80,FFFFFFFFFFFFFFFFFFFFFF)",/silent
;readcol,'/scratch/adam_work/texts/centroids_0707_nomodel.txt',name,xpix,ypix,ra,dec,raoff,decoff,alt,az,altoff,azoff,fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A80,FFFFFFFFFFFF)"
;readcol,'/scratch/adam_work/texts/centroids_0707_pmm.txt',name,xpix1,ypix1,ra1,dec1,raoff1,decoff1,alt1,az1,altoff1,azoff1,fzao1,fazo1,ra_ab1,dec_ab1,ra_nut1,dec_nut1,ra_prec1,dec_prec1,lst1,jd1,format="(A80,FFFFFFFFFFFF)"
;readcol,'/scratch/adam_work/texts/centroids_0707_ppm.txt',name,xpix2,ypix2,ra2,dec2,raoff2,decoff2,alt2,az2,altoff2,azoff2,fzao2,fazo2,ra_ab2,dec_ab2,ra_nut2,dec_nut2,ra_prec2,dec_prec2,lst2,jd2,format="(A80,FFFFFFFFFFFF)"
;readcol,'/scratch/adam_work/texts/centroids_0707_mmm.txt',name,xpix3,ypix3,ra3,dec3,raoff3,decoff3,alt3,az3,altoff3,azoff3,fzao3,fazo3,ra_ab3,dec_ab3,ra_nut3,dec_nut3,ra_prec3,dec_prec3,lst3,jd3,format="(A80,FFFFFFFFFFFF)"
;readcol,'/scratch/adam_work/texts/centroids_0707_mpm.txt',name,xpix4,ypix4,ra4,dec4,raoff4,decoff4,alt4,az4,altoff4,azoff4,fzao4,fazo4,ra_ab4,dec_ab4,ra_nut4,dec_nut4,ra_prec4,dec_prec4,lst4,jd4,format="(A80,FFFFFFFFFFFF)"

