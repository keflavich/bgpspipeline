;
;cd,'/scratch/adam_work/pointing/'
;compare = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_meredith_ptg_radec.sav',gv=gv)
;plot,compare.altoff[gv],compare.dy[gv],psym=1
;
;set_plot,'ps'
;device,filename='myoffset_vs_meredith.ps',/color     
;plot,compare.alt[gv],compare.altoff[gv],psym=1,xtitle="Alt",ytitle="Altoff",title="Mine (black) vs Meredith's (red)"
;oplot,compare.alt[gv],compare.dy[gv],psym=1,color=250
;device,/close_file          
;
;
;compare_maps = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_raw_radec.sav',gv=gvm)
;
;set_plot,'x'
;;set_plot,'ps'
;;device,filename='myoffset_vs_meredith.ps',/color     
;plot,compare_maps.alt[gvm],compare_maps.altoff[gvm],psym=1,xtitle="Alt",ytitle="Altoff",title="Mine (black or white) vs Meredith's (red)"
;oplot,compare_maps.alt[gvm],compare_maps.dy[gvm],psym=1,color=250
;;device,/close_file          
;window,1
;plot,compare_maps.altoff[gvm],compare_maps.dy[gvm],psym=1
;window,2
;plot,compare_maps.az[gvm],compare_maps.altoff[gvm],psym=1,xtitle="Az",ytitle="Altoff",title="Mine (black or white) vs Meredith's (red)"
;oplot,compare_maps.az[gvm],compare_maps.dy[gvm],psym=1,color=250
;
;
;compare_maps = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_raw_radec.sav',gv=gvm)
;compare_maps = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_rawcsoptg_radec.sav',gv=gvm)
;loadct,39
;plot,compare_maps.az[gvm],compare_maps.altoff[gvm],psym=1,xtitle="Az",ytitle="Altoff",title="Mine (black or white) vs Meredith's (red)"
;oplot,compare_maps.az[gvm],compare_maps.dy[gvm],psym=1,color=250
;oplot,compare_maps.az[gvm],compare_maps.altoff[gvm]-compare_maps.fzao[gvm],psym=1,color=150
;
;loadct,39
;
;compare = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_raw_radec.sav',gv=gv)
;compare = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_meredith_ptg_radec.sav',gv=gv)
;!P.MULTI=[0,2,2]
;plot,compare.az,-compare.altoff+compare.fzao,psym=1
;oplot,compare.az,compare.fzao_new,psym=1,color=250
;oplot,compare.az,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,color=150
;
;plot,compare.az,compare.azoff+compare.fazo,psym=1
;oplot,compare.az,compare.fazo_new,psym=1,color=250
;oplot,compare.az,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,color=150
;
;plot,compare.alt,-compare.altoff+compare.fzao,psym=1
;oplot,compare.alt,compare.fzao_new,psym=1,color=250
;oplot,compare.alt,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,color=150
;
;plot,compare.alt,compare.azoff,psym=1
;oplot,compare.alt,compare.fazo_new,psym=1,color=250
;oplot,compare.alt,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,color=150
;
.run centroid_file_list
.run centroid_plots
centroid_file_list,'/scratch/adam_work/texts/meredith_0707_ptg_radec_maplist.txt','/scratch/adam_work/texts/meredith_0707_ptg_radec_centroids.txt'
centroid_plots,'/scratch/adam_work/texts/meredith_0707_ptg_radec_centroids.txt','0707','meredith_ptg_radec'    
compare = compare_me_meredith('bgps_pointing_model_200707_part2_mmd.sav','0707_meredith_ptg_radec.sav',gv=gv)
set_plot,'ps'
device,filename='/scratch/adam_work/plots/myoffset_vs_meredith.ps',/color     
!P.MULTI=[0,2,2]
loadct,39
plot,compare.az,compare.altoff,psym=1,xtitle='az',ytitle='altoff'
oplot,compare.az,compare.dy,psym=1,color=250

plot,compare.az,compare.azoff,psym=1,xtitle='az',ytitle='azoff'
oplot,compare.az,compare.dx,psym=1,color=250

plot,compare.alt,compare.altoff,psym=1,xtitle='alt',ytitle='altoff'
oplot,compare.alt,compare.dy,psym=1,color=250

plot,compare.alt,compare.azoff,psym=1,xtitle='alt',ytitle='azoff'
oplot,compare.alt,compare.dx,psym=1,color=250

plot,compare.az,-compare.altoff+compare.fzao,psym=1,xtitle='az',ytitle='altoff'
oplot,compare.az,compare.fzao_new,psym=1,color=250

plot,compare.az,compare.azoff+compare.fazo,psym=1,xtitle='az',ytitle='azoff'
oplot,compare.az,compare.fazo_new,psym=1,color=250

plot,compare.alt,-compare.altoff+compare.fzao,psym=1,xtitle='alt',ytitle='altoff'
oplot,compare.alt,compare.fzao_new,psym=1,color=250

plot,compare.alt,compare.azoff+compare.fazo,psym=1,xtitle='alt',ytitle='azoff'
oplot,compare.alt,compare.fazo_new,psym=1,color=250

plot,compare.az,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,xtitle='az',ytitle='altoff'
plot,compare.az,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,xtitle='az',ytitle='azoff'
plot,compare.alt,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,xtitle='alt',ytitle='altoff'
plot,compare.alt,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,xtitle='alt',ytitle='azoff'

plot,compare.lst,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,xtitle='lst',ytitle='altoff'
plot,compare.lst,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,xtitle='lst',ytitle='azoff'
plot,compare.jd - 2454287,compare.fzao_new-(-compare.altoff+compare.fzao),psym=1,xtitle='alt',ytitle='altoff'
plot,compare.jd - 2454287,compare.fazo_new-(compare.azoff+compare.fazo),psym=1,xtitle='alt',ytitle='azoff'

my_hor2eq,compare.el,compare.az_meredith,compare.jd,merra,merdec,lat=19.8261111,lon=-155.473366,refract=0,precess=0,aberr=0,nutate=0,lst=compare.lst
plot,compare.az_meredith,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='az_meredith',ytitle='raoff',yrange=[-500,500],/ys
plot,compare.az_meredith,3600*(merdec-compare.objdec),psym=1,xtitle='az_meredith',ytitle='decoff',yrange=[-500,500],/ys
plot,compare.el,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='alt',ytitle='raoff',yrange=[-500,500],/ys
plot,compare.el,3600*(merdec-compare.objdec),psym=1,xtitle='alt',ytitle='decoff',yrange=[-500,500],/ys

my_hor2eq,compare.el,compare.az_meredith,compare.jd,merra,merdec,lat=19.8261111,lon=-155.473366,refract=0,precess=1,aberr=0,nutate=0,lst=compare.lst
plot,compare.az_meredith,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='az_meredith',ytitle='raoff',title='precessed',yrange=[-500,500],/ys
plot,compare.az_meredith,3600*(merdec-compare.objdec),psym=1,xtitle='az_meredith',ytitle='decoff',title='precessed',yrange=[-500,500],/ys
plot,compare.el,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='alt',ytitle='raoff',title='precessed',yrange=[-500,500],/ys
plot,compare.el,3600*(merdec-compare.objdec),psym=1,xtitle='alt',ytitle='decoff',title='precessed',yrange=[-500,500],/ys

my_hor2eq,compare.el,compare.az_meredith,compare.jd,merra,merdec,lat=19.8261111,lon=-155.473366,refract=0,precess=1,aberr=1,nutate=1,lst=compare.lst
plot,compare.az_meredith,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='az_meredith',ytitle='raoff',title='precess + abnut',yrange=[-500,500],/ys
plot,compare.az_meredith,3600*(merdec-compare.objdec),psym=1,xtitle='az_meredith',ytitle='decoff',title='precess + abnut',yrange=[-500,500],/ys
plot,compare.el,3600*(merra-compare.objra)*cos(!dtor*merdec),psym=1,xtitle='alt',ytitle='raoff',title='precess + abnut',yrange=[-500,500],/ys
plot,compare.el,3600*(merdec-compare.objdec),psym=1,xtitle='alt',ytitle='decoff',title='precess + abnut',yrange=[-500,500],/ys

set_plot,'x'
;
;my_eq2hor,compare.myra,compare.mydec,compare.jd,myalt,myaz,lat=19.8261111,aberration=1,nutate=1,precess=0,lst=compare.lst
;my_eq2hor,compare.objra,compare.objdec,compare.jd,objalt,objaz,lat=19.8261111,aberration=0,nutate=0,precess=0,lst=compare.lst
;oplot,compare.az,(myalt-objalt)*3600.+compare.fzao,color=150,psym=1
;my_eq2hor,compare.myra,compare.mydec,compare.jd,myalt,myaz,lat=19.8261111,aberration=0,nutate=0,precess=0,lst=compare.lst
;my_eq2hor,compare.objra,compare.objdec,compare.jd,objalt,objaz,lat=19.8261111,aberration=1,nutate=1,precess=0,lst=compare.lst
;oplot,compare.az,(myalt-objalt)*3600.+compare.fzao,color=200,psym=1
;


