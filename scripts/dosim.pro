.run put_gaussian_in_timestream
.run centroid_file_list
.run image_with_centroid
ra_center=0
;gaussmap = put_gaussian_in_timestream('test_target_cyg.nc',pixsize=7.,ra_center=ra_center,dec_center=dec_center)  

;ncdf_varget_scale,'test_target_cyg.nc','array_params',array_params
;array_params[3] = 30
;array_params[4] = -30
;ncdf_varput_scale,'test_target_cyg.nc','array_params',array_params

;workingdir='/Users/adam/work/bolocam/simulations'
spawn,'pwd',workingdir
mem_iter_pc,'test_target_1.nc','test_target_1',workingdir=workingdir,pixsize=1.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=1,niter=[0],minb=10,/median_sky,/fits_timestream,/noflag,/nopolysub,/dontdeline,/dontskysub,/dosave,iter0savename='test1_radec.sav'
;mem_iter_pc,'test_target_cyg.nc','test_target_2',workingdir=workingdir,pixsize=7.,projection='TAN',coordsys='radec',precess=1,aberration=1,nutate=1,niter=[0],minb=10,/median_sky,/fits_timestream,/noflag,/nopolysub,/dontdeline,/dontskysub,/pointoff_correct
mem_iter_pc,'test_target_1.nc','test_target_1_lb',workingdir=workingdir,pixsize=1.,precess=1,aberration=1,nutate=1,niter=[0],minb=10,/median_sky,/fits_timestream,/noflag,/nopolysub,/dontdeline,/dontskysub,/dosave,iter0savename='test1_lb.sav'
;mem_iter_pc,'test_target_cyg.nc','test_target_2_lb',workingdir=workingdir,pixsize=7.,precess=1,aberration=1,nutate=1,niter=[0],minb=10,/median_sky,/fits_timestream,/noflag,/nopolysub,/dontdeline,/dontskysub,/pointoff_correct
;centroid_file_list,'testtarget1maplist.txt','/dev/tty',objra=ra_center,objdec=dec_center,/source_name,/dontconv,fitpars=fitpars,zfit=zfit,fiterr=fiterr,ncfile='test_target_cyg.nc'
;centroid_file_list,'testtarget1maplist.txt','/dev/tty',objra=ra_center+30./3600./cos(dec_center*!dtor),objdec=dec_center-30./3600,/source_name,/dontconv,fitpars=fitpars,zfit=zfit,fiterr=fiterr,ncfile='test_target_cyg.nc'
;centroid_file_list,'testtarget1maplist.txt','testtarget1centroid.txt',objra=ra_center+30./3600./cos(dec_center*!dtor),objdec=dec_center-30./3600,/source_name,/dontconv,fitpars=fitpars,zfit=zfit,fiterr=fiterr,ncfile='test_target_cyg.nc'
;centroid_plots,'testtarget1centroid.txt','test','test'
;image_with_centroid,'testtarget1centroid.txt'     

restore,'test1_lb.sav'
ac_bolos[*]=0
ac_bolos[0,0] = 100.
ac_bolos[0,20] = 100.
ac_bolos[0,40] = 100.
ac_bolos[0,60] = 100.
ac_bolos[0,80] = 100.
ac_bolos[0,90] = 100.
ac_bolos[0,100] = 100.
ac_bolos[0,120] = 100.
ac_bolos[0,140] = 100.
ac_bolos[0,160] = 100.
ac_bolos[0,180] = 100.
ac_bolos[0,200] = 100.
ac_bolos[0,220] = 100.
ac_bolos[0,240] = 100.
print,"point(",ra_map[0,0],",",dec_map[0,0],") # point=x"
print,"point(",ra_map[0,20] ,",",dec_map[0,20],") # point=x"
print,"point(",ra_map[0,40] ,",",dec_map[0,40],") # point=x"
print,"point(",ra_map[0,60] ,",",dec_map[0,60],") # point=x"
print,"point(",ra_map[0,80] ,",",dec_map[0,80],") # point=x"
print,"point(",ra_map[0,90] ,",",dec_map[0,90],") # point=x"
print,"point(",ra_map[0,100],",",dec_map[0,100],") # point=x"
print,"point(",ra_map[0,120],",",dec_map[0,120],") # point=x"
print,"point(",ra_map[0,140],",",dec_map[0,140],") # point=x"
print,"point(",ra_map[0,160],",",dec_map[0,160],") # point=x"
print,"point(",ra_map[0,180],",",dec_map[0,180],") # point=x"
print,"point(",ra_map[0,200],",",dec_map[0,200],") # point=x"
print,"point(",ra_map[0,220],",",dec_map[0,220],") # point=x"
print,"point(",ra_map[0,240],",",dec_map[0,240],") # point=x"
ac_bolos[0,200] = 100.
ac_bolos[0,2020] = 100.
ac_bolos[0,2040] = 100.
ac_bolos[0,2060] = 100.
ac_bolos[0,2080] = 100.
ac_bolos[0,2090] = 100.
ac_bolos[0,2100] = 100.
ac_bolos[0,2120] = 100.
ac_bolos[0,2140] = 100.
ac_bolos[0,2160] = 100.
ac_bolos[0,2180] = 100.
ac_bolos[0,2200] = 100.
ac_bolos[0,2220] = 100.
ac_bolos[0,2240] = 100.
print,"point(",ra_map[0,200], "," ,dec_map[0,200],") # point=x"
print,"point(",ra_map[0,2020] ,",",dec_map[0,2020],") # point=x"
print,"point(",ra_map[0,2040] ,",",dec_map[0,2040],") # point=x"
print,"point(",ra_map[0,2060] ,",",dec_map[0,2060],") # point=x"
print,"point(",ra_map[0,2080] ,",",dec_map[0,2080],") # point=x"
print,"point(",ra_map[0,2090] ,",",dec_map[0,2090],") # point=x"
print,"point(",ra_map[0,2100], ",",dec_map[0,2100],") # point=x"
print,"point(",ra_map[0,2120], ",",dec_map[0,2120],") # point=x"
print,"point(",ra_map[0,2140], ",",dec_map[0,2140],") # point=x"
print,"point(",ra_map[0,2160], ",",dec_map[0,2160],") # point=x"
print,"point(",ra_map[0,2180], ",",dec_map[0,2180],") # point=x"
print,"point(",ra_map[0,2200], ",",dec_map[0,2200],") # point=x"
print,"point(",ra_map[0,2220], ",",dec_map[0,2220],") # point=x"
print,"point(",ra_map[0,2240], ",",dec_map[0,2240],") # point=x"
map=ts_to_map(blank_map_size,ts,ac_bolos[unflagged])
writefits,'lbmap.fits',map,hdr

restore,'test1_radec.sav'
ac_bolos[*]=0
ac_bolos[0,0] = 100.
ac_bolos[0,20] = 100.
ac_bolos[0,40] = 100.
ac_bolos[0,60] = 100.
ac_bolos[0,80] = 100.
ac_bolos[0,90] = 100.
ac_bolos[0,100] = 100.
ac_bolos[0,120] = 100.
ac_bolos[0,140] = 100.
ac_bolos[0,160] = 100.
ac_bolos[0,180] = 100.
ac_bolos[0,200] = 100.
ac_bolos[0,220] = 100.
ac_bolos[0,240] = 100.
ac_bolos[0,200] = 100.
ac_bolos[0,2020] = 100.
ac_bolos[0,2040] = 100.
ac_bolos[0,2060] = 100.
ac_bolos[0,2080] = 100.
ac_bolos[0,2090] = 100.
ac_bolos[0,2100] = 100.
ac_bolos[0,2120] = 100.
ac_bolos[0,2140] = 100.
ac_bolos[0,2160] = 100.
ac_bolos[0,2180] = 100.
ac_bolos[0,2200] = 100.
ac_bolos[0,2220] = 100.
ac_bolos[0,2240] = 100.
map=ts_to_map(blank_map_size,ts,ac_bolos[unflagged])
writefits,'radecmap.fits',map,hdr

