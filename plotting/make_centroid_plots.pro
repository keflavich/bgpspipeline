
centroid_plots,'/scratch/adam_work/texts/nocorr_0506_centroids.txt','0506','nocorr'
centroid_plots,'/scratch/adam_work/texts/nocorr_0707_centroids.txt','0707','nocorr'
centroid_plots,'/scratch/adam_work/texts/nomodel_0506_centroids.txt','0506','nomodel'
centroid_plots,'/scratch/adam_work/texts/nomodel_0707_centroids.txt','0707','nomodel'
centroid_plots,'/scratch/adam_work/texts/ptgmdl_0506_centroids.txt','0506','ptgmdl'
centroid_plots,'/scratch/adam_work/texts/ptgmdl_0707_centroids.txt','0707','ptgmdl'
centroid_plots,'/scratch/adam_work/texts/rawcsoptg_0506_centroids.txt','0506','rawcsoptg'
centroid_plots,'/scratch/adam_work/texts/rawcsoptg_0707_centroids.txt','0707','rawcsoptg'



w3c273 = where(source_name eq '3c273')                                                          
plot,alt[w3c273],altoff[w3c273],psym=1

w1749p096 = where(source_name eq '1749p096')                                                          
oplot,alt[w1749p096],altoff[w1749p096],psym=1,color=100






;stop
;
;
;
;plot,allalt,altoff_model_sep05*3600.,color=250,yrange=[-100,100]
;oplot,allalt,altoff_model_jul07_1*3600.,color=50
;oplot,allalt,altoff_model_jul07_2*3600.,color=150
;oplot,allalt,altoff_model_jul05*3600.,color=100
;oplot,allalt,altoff_model_jul06*3600.,color=200
;oplot,allalt,altoff_model_sep06*3600.,color=75
;oplot,allalt,-poly(allalt,my_altoff_model),color=225,psym=3
;plot,allalt,azoff_model_sep05*3600.,color=250,yrange=[-100,100]
;oplot,allalt,azoff_model_jul07_1*3600.,color=50
;oplot,allalt,azoff_model_jul07_2*3600.,color=150
;oplot,allalt,azoff_model_jul05*3600.,color=100
;oplot,allalt,azoff_model_jul06*3600.,color=200
;oplot,allalt,azoff_model_sep06*3600.,color=75
;oplot,allalt,poly(my_azoff_model,alt),color=225
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,altpfzao[goodvals],altoff[goodvals],psym=1   
;oplot,allalt,-altoff_model_jul07_1*3600.,color=100   
;plot,altpfzao[goodvals],azoff[goodvals],psym=1   
;oplot,allalt,-azoff_model_jul07_1*3600.,color=100   
;plot,altpfzao[goodvals],nofzao_altoff[goodvals],psym=1   
;oplot,allalt,-altoff_model_jul07_1*3600.,color=100   
;plot,altpfzao[goodvals],nofazo_azoff[goodvals],psym=1   
;oplot,allalt,-azoff_model_jul07_1*3600.,color=100   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,altpfzao[goodvals],dalt_nut[goodvals]+nofzao_altoff[goodvals],psym=1   
;plot,altpfzao[goodvals],daz_nut[goodvals] +nofazo_azoff[goodvals],psym=1   
;plot,altpfzao[goodvals],dalt_ab[goodvals] +nofzao_altoff[goodvals],psym=1   
;plot,altpfzao[goodvals],daz_ab[goodvals]  +nofazo_azoff[goodvals],psym=1   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,altpfzao[goodvals],dalt_abnut[goodvals]+nofzao_altoff[goodvals],psym=1   
;plot,altpfzao[goodvals],daz_abnut[goodvals] +nofazo_azoff[goodvals],psym=1   
;plot,altpfzao[goodvals],dalt_prec[goodvals] +nofzao_altoff[goodvals],psym=1   
;plot,altpfzao[goodvals],daz_prec[goodvals]  +nofazo_azoff[goodvals],psym=1   
;
;
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,alt[goodvals],altoff[goodvals],psym=1   
;oplot,allalt,-altoff_model_jul07_1*3600.,color=100   
;oplot,allalt,-altoff_model_jul07_2*3600.,color=200   
;oplot,allalt,poly(allalt,my_altoff_model),color=225,psym=3
;plot,alt[goodvals],azoff[goodvals],psym=1   
;oplot,allalt,-azoff_model_jul07_1*3600.,color=100   
;oplot,allalt,-azoff_model_jul07_2*3600.,color=200   
;oplot,allalt,poly(allalt,my_azoff_model),color=225,psym=3
;plot,alt[good_alts],altoff[good_alts],psym=1   
;oplot,allalt,-altoff_model_jul07_1*3600.,color=100   
;oplot,allalt,-altoff_model_jul07_2*3600.,color=200   
;oplot,allalt,poly(allalt,my_altoff_model2),color=225,psym=3
;plot,alt[good_azs],azoff[good_azs],psym=1   
;oplot,allalt,-azoff_model_jul07_1*3600.,color=100   
;oplot,allalt,-azoff_model_jul07_2*3600.,color=200   
;oplot,allalt,poly(allalt,my_azoff_model2),color=225,psym=3
;
;
;!P.MULTI=[0,2,2,0,1]
;plot,alt[good_alts],altoff[good_alts]+dalt_nut[good_alts]  *3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]-dalt_nut[good_alts]  *3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]+dalt_ab[good_alts]   *3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]-dalt_ab[good_alts]   *3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]+dalt_abnut[good_alts]*3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]-dalt_abnut[good_alts]*3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]+dalt_prec[good_alts] *3600.,psym=1
;plot,alt[good_alts],altoff[good_alts]-dalt_prec[good_alts] *3600.,psym=1
;
;
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,alt[goodvals],decoff[goodvals],psym=1   
;plot,alt[goodvals],raoff[goodvals],psym=1   
;plot,alt[goodvals],altoff[goodvals],psym=1   
;plot,alt[goodvals],azoff[goodvals],psym=1   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,alt[goodvals],altoff[goodvals],psym=1   
;plot,alt[goodvals],altoff_ab[goodvals],psym=1   
;plot,alt[goodvals],altoff_nut[goodvals],psym=1   
;plot,alt[goodvals],altoff_abnut[goodvals],psym=1   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,az[goodvals],altoff[goodvals],psym=1   
;plot,az[goodvals],altoff_ab[goodvals],psym=1   
;plot,az[goodvals],altoff_nut[goodvals],psym=1   
;plot,az[goodvals],altoff_abnut[goodvals],psym=1   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,az[goodvals],azoff[goodvals],psym=1   
;plot,az[goodvals],azoff_ab[goodvals],psym=1   
;plot,az[goodvals],azoff_nut[goodvals],psym=1   
;plot,az[goodvals],azoff_abnut[goodvals],psym=1   
;
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,ra[goodvals],ra[goodvals],psym=1   
;plot,ra[goodvals],ra_abcorr[goodvals],psym=1   
;plot,ra[goodvals],ra_nutcorr[goodvals],psym=1   
;plot,ra[goodvals],ra_abnutcorr[goodvals],psym=1   
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,lst[goodvals],altoff[goodvals],psym=1   
;plot,lst[goodvals],altoff_ab[goodvals],psym=1   
;plot,lst[goodvals],altoff_nut[goodvals],psym=1   
;plot,lst[goodvals],altoff_abnut[goodvals],psym=1   
;
;!P.MULTI=[0, 2, 2, 0, 1]
;plot,lst[goodvals],fzao[goodvals],psym=1   
;plot,lst[goodvals],fzao[goodvals]-altoff_prec[goodvals],psym=1   
;plot,alt[goodvals],fzao[goodvals],psym=1   
;plot,alt[goodvals],fzao[goodvals]-altoff_prec[goodvals],psym=1   
;
;
;plot,alt,daz_ab,psym=1                     
;plot,alt,daz_nut,psym=1
;plot,alt,daz_ab-daz_nut,psym=1
;plot,alt,daz_ab+daz_ab,psym=1 
;
;plot,alt,dalt_ab,psym=1                     
;plot,alt,dalt_nut,psym=1
;plot,alt,dalt_ab-dalt_nut,psym=1
;plot,alt,dalt_ab+dalt_ab,psym=1 
;
;
;
;;readcol,'/scratch/adam_work/texts/centroids_0707_nomodel.txt',name,xpix,ypix,ra,dec,raoff,decoff,alt,az,altoff,azoff,fzao,fazo,format="(A80,FFFFFFFFFFFF)"
;;    readcol,'/scratch/adam_work/texts/centroids_0707_nomodel.txt',name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;;        fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A80,FFFFFFFFFFFFFFFFFFFFFF)",/silent
;;readcol,'/scratch/adam_work/texts/centroids_0707_pmm.txt',name,xpix1,ypix1,ra1,dec1,raoff1,decoff1,alt1,az1,altoff1,azoff1,fzao1,fazo1,format="(A80,FFFFFFFFFFFF)"
;;readcol,'/scratch/adam_work/texts/centroids_0707_ppm.txt',name,xpix2,ypix2,ra2,dec2,raoff2,decoff2,alt2,az2,altoff2,azoff2,fzao2,fazo2,format="(A80,FFFFFFFFFFFF)"
;;readcol,'/scratch/adam_work/texts/centroids_0707_mmm.txt',name,xpix3,ypix3,ra3,dec3,raoff3,decoff3,alt3,az3,altoff3,azoff3,fzao3,fazo3,format="(A80,FFFFFFFFFFFF)"
;;readcol,'/scratch/adam_work/texts/centroids_0707_mpm.txt',name,xpix4,ypix4,ra4,dec4,raoff4,decoff4,alt4,az4,altoff4,azoff4,fzao4,fazo4,format="(A80,FFFFFFFFFFFF)"
;;goodvals = where(abs(raoff) lt 150)                                                                                                                               
;;goodvals1 = where(abs(raoff1) lt 150)
;;goodvals2 = where(abs(raoff2) lt 150)
;;goodvals3 = where(abs(raoff3) lt 150)
;;goodvals4 = where(abs(raoff4) lt 150)
;;loadct,39
;;
;;plot,alt[goodvals],raoff[goodvals],psym=2   
;;oplot,alt1[goodvals1],raoff1[goodvals1],psym=1,color=200
;;oplot,alt2[goodvals2],raoff2[goodvals2],psym=4,color=100
;;oplot,alt3[goodvals3],raoff3[goodvals3],psym=5,color=150
;;oplot,alt4[goodvals4],raoff4[goodvals4],psym=6,color=220
;;
;;plot,alt[goodvals],decoff[goodvals],psym=2   
;;oplot,alt1[goodvals1],decoff1[goodvals1],psym=1,color=200
;;oplot,alt2[goodvals2],decoff2[goodvals2],psym=4,color=100
;;oplot,alt3[goodvals3],decoff3[goodvals3],psym=5,color=150
;;oplot,alt4[goodvals4],decoff4[goodvals4],psym=6,color=220
;;
;;totaloff = sqrt(raoff^2+decoff^2)
;;totaloff1 = sqrt(raoff1^2+decoff1^2)
;;totaloff2 = sqrt(raoff2^2+decoff2^2)
;;totaloff3 = sqrt(raoff3^2+decoff3^2)
;;totaloff4 = sqrt(raoff4^2+decoff4^2)
;;
;;window,0
;;plot,alt[goodvals],decoff[goodvals],psym=2   
;;oplot,alt3[goodvals3],decoff3[goodvals3],psym=5,color=150
;;window,1
;;plot,alt[goodvals],raoff[goodvals],psym=2   
;;oplot,alt3[goodvals3],raoff3[goodvals3],psym=5,color=150
;;window,2
;;plot,alt[goodvals],totaloff[goodvals],psym=2   
;;oplot,alt3[goodvals3],totaloff3[goodvals3],psym=5,color=150
;;
;;plot,alt[goodvals],totaloff[goodvals],psym=2   
;;oplot,alt1[goodvals1],totaloff1[goodvals1],psym=1,color=200
;;oplot,alt2[goodvals2],totaloff2[goodvals2],psym=4,color=100
;;oplot,alt3[goodvals3],totaloff3[goodvals3],psym=5,color=150
;;oplot,alt4[goodvals4],totaloff4[goodvals4],psym=6,color=220
;;
;;plot,alt[goodvals],altoff[goodvals],psym=2   
;;plot,alt1[goodvals1],altoff1[goodvals1],psym=1,color=200
;;plot,alt2[goodvals2],altoff2[goodvals2],psym=4,color=100
;;plot,alt3[goodvals3],altoff3[goodvals3],psym=5,color=150
;;plot,alt4[goodvals4],altoff4[goodvals4],psym=6,color=220
;;
;;print,mean(altoff[goodvals]),stddev(altoff[goodvals]),mean(azoff[goodvals]),stddev(azoff[goodvals])
;;print,mean(altoff[goodvals1]),stddev(altoff[goodvals1]),mean(azoff[goodvals1]),stddev(azoff[goodvals1])
;;print,mean(altoff[goodvals2]),stddev(altoff[goodvals2]),mean(azoff[goodvals2]),stddev(azoff[goodvals2])
;;print,mean(altoff[goodvals3]),stddev(altoff[goodvals3]),mean(azoff[goodvals3]),stddev(azoff[goodvals3])
;;print,mean(altoff[goodvals4]),stddev(altoff[goodvals4]),mean(azoff[goodvals4]),stddev(azoff[goodvals4])
;;
;;
;;; compare to Meredith's:
;;loadct,39
;;plot,90-alt[goodvals],fzao[goodvals],psym=2
;;oplot,90-alt[goodvals],fzao[goodvals]-altoff[goodvals],color=200,psym=3
;;
;;
;;readcol,'/scratch/adam_work/texts/centroids_0707_nomodel.txt',name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;;    fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A80,FFFFFFFFFFFFFFFFFFFFFF)",/silent
;;goodvals = where(abs(raoff) lt 150)                                                                                                                               
;;set_plot,'ps'
;;device,filename='/scratch/adam_work/plots/fzao_vs_za.ps',/color   
;;plot,90-alt[goodvals],fzao[goodvals],psym=2,xtitle="Az (deg)",ytitle="FZAO (arcsec)",yrange=[0,150]
;;oplot,90-alt[goodvals],fzao[goodvals]+altoff[goodvals],psym=1,color=254 
;;
;;device,filename='/scratch/adam_work/plots/raoff_vs_za.ps',/color   
;;plot,90-alt[goodvals],raoff[goodvals],psym=2,xtitle="Az (deg)",ytitle="RA offset (arcsec)"
;;
;;device,filename='/scratch/adam_work/plots/decoff_vs_za.ps',/color   
;;plot,90-alt[goodvals],decoff[goodvals],psym=2,xtitle="Az (deg)",ytitle="Dec offset (arcsec)"
;;
;;restore,'/home/milkyway/student/drosback/pointing/bgps_pointing_model_200707_part1_mmd.sav'
;;set_plot,'ps'
;;goodvals = where(za lt 90)
;;device,filename='/scratch/adam_work/plots/meredith_fzao_vs_za_part1.ps',/color   
;;plot,za[goodvals],fzao_set[goodvals],psym=2,yrange=[0,150] ,xtitle="Az (deg)",ytitle="FZAO (arcsec)"
;;oplot,za[goodvals],fzao_new[goodvals],psym=1,color=254    
;;
;;
;;
;;restore,'/home/milkyway/student/drosback/pointing/bgps_pointing_model_200707_part2_mmd.sav'
;;set_plot,'ps'
;;goodvals = where(za lt 90)
;;device,filename='/scratch/adam_work/plots/meredith_fzao_vs_za_part2.ps',/color   
;;plot,za[goodvals],fzao_set[goodvals],psym=2,yrange=[0,150]  ,xtitle="Az (deg)",ytitle="FZAO (arcsec)"
;;oplot,za[goodvals],fzao_new[goodvals],psym=1,color=254    
;;
;;
;;ra_nocorr = ra - ra_ab - ra_nut
;;dec_nocorr = dec - dec_ab - dec_nut
;;latitude=19.82611111D0 
;;getaltaz,dec_nocorr,latitude,lst-ra_nocorr/15.,alt_nocorr,az_nocorr
;;dalt_abnut = alt_nocorr - alt
;;daz_abnut = az_nocorr - az
;;plot,alt[goodvals],dalt_abnut[goodvals],psym=1
;;plot,alt[goodvals],daz_abnut[goodvals],psym=1
;;plot,alt[goodvals],fzao[goodvals]+altoff[goodvals]+dalt_abnut[goodvals],psym=1
;;
;;
;;
;;readcol,'/scratch/adam_work/texts/nomodel_0707_centroids.txt',name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;;    fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A100,FFFFFFFFFFFFFFFFFFFFFF)",/silent
;;
;;readcol,'/scratch/adam_work/texts/nocorr_0707_centroids.txt',name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;;    fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A100,FFFFFFFFFFFFFFFFFFFFFF)",/silent
;;centroid_file_list,'/scratch/adam_work/texts/ptgmdl_0707_maplist.txt','/scratch/adam_work/texts/ptgmdl_0707_centroids.txt'
;;
;;centroid_file_list,'/scratch/adam_work/texts/rawcsoptg_0707_maplist.txt','/scratch/adam_work/texts/rawcsoptg_0707_centroids.txt'
;;readcol,'/scratch/adam_work/texts/rawcsoptg_0707_centroids.txt',name,source_name,xpix,ypix,ra,dec,raoff,decoff,objra,objdec,alt,az,altoff,azoff,$
;;    fzao,fazo,ra_ab,dec_ab,ra_nut,dec_nut,ra_prec,dec_prec,lst,jd,format="(A100,A20,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,D)",/silent
;;    pointing_model,[2454289],allalt,az,altoff_model=altoff_model_jul07_2,azoff_model=azoff_model_jul07_2
;;    pointing_model,[2454287],allalt,az,altoff_model=altoff_model_jul07_1,azoff_model=azoff_model_jul07_1
;;    pointing_model,[2454007],allalt,az,altoff_model=altoff_model_sep06,azoff_model=azoff_model_sep06
;;    pointing_model,[2453945],allalt,az,altoff_model=altoff_model_jul06,azoff_model=azoff_model_jul06
;;    pointing_model,[2453643],allalt,az,altoff_model=altoff_model_sep05,azoff_model=azoff_model_sep05
;;    pointing_model,[2453523],allalt,az,altoff_model=altoff_model_jul05,azoff_model=azoff_model_jul05
