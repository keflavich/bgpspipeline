@/home/milkyway/student/ginsbura/.idl_startup_publish
;;.run centroid_file_list
.run centroid_plots
!EXCEPT=0
workingdir = '/scratch/adam_work/'
cd,workingdir
time_s,"start",all_time


;;;;individual_obs,'/scratch/adam_work/texts/0707_ds1_pointing.txt','oppositeabnut_rawcso_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=1,/raw_cso_pointing,/pointing_model
;$find /scratch/adam_work/ -name "oppositeabnut_rawcso_radec_radec0707*_map0*.fits" > texts/0707_oppositeabnut_rawcso_radec_maplist.txt
centroid_file_list,'/scratch/adam_work/texts/0707_oppositeabnut_rawcso_radec_maplist.txt','/scratch/adam_work/texts/0707_oppositeabnut_rawcso_radec_centroids.txt'
centroid_plots,'/scratch/adam_work/texts/0707_oppositeabnut_rawcso_radec_centroids.txt','0707','oppositeabnut_rawcso_radec'

;;;;individual_obs,'/scratch/adam_work/texts/0707_ds1_pointing.txt','oppositeabnut_radec',find_prefix=1,npca=[3],pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=1
;$find /scratch/adam_work/ -name "oppositeabnut_radec0707*_map0*.fits" > texts/0707_oppositeabnut_radec_maplist.txt
centroid_file_list,'/scratch/adam_work/texts/0707_oppositeabnut_radec_maplist.txt','/scratch/adam_work/texts/0707_oppositeabnut_radec_centroids.txt'
centroid_plots,'/scratch/adam_work/texts/0707_oppositeabnut_radec_centroids.txt','0707','oppositeabnut_radec'

centroid_file_list,'/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_radec_maplist.txt','/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_radec_centroids.txt'
centroid_plots,'/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_radec_centroids.txt','0707','pcalonly_oppositeabnut_radec'

centroid_file_list,'/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_rawcso_radec_maplist.txt','/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_rawcso_radec_centroids.txt'
centroid_plots,'/scratch/adam_work/texts/0707_pcalonly_oppositeabnut_rawcso_radec_centroids.txt','0707','pcalonly_oppositeabnut_rawcso_radec'

print,"DONE aug16",systime()
time_e,all_time,prtmsg="Finish "
