; polysub tests
mem_iter,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav','/usb/scratch1/l357/v1.0.2_l357_13pca_o3',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=3
mem_iter,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav','/usb/scratch1/l357/v1.0.2_l357_13pca_o4',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=4
mem_iter,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav','/usb/scratch1/l357/v1.0.2_l357_13pca_o5',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=5
mem_iter,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav','/usb/scratch1/l357/v1.0.2_l357_13pca_o6',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=6
mem_iter,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav','/usb/scratch1/l357/v1.0.2_l357_13pca_o7',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=7


mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv_uniform',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,fluxrange=[.005,.25]
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv_uniformrandom',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.005,.25]
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv_uniformrandom_bigsrc',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.005,.25],widthspread=10

mem_iter,'/scratch/adam_work/l034/l034.sav','/scratch/adam_work/l034/v0.7_l034_13pca_deconv31.2',workingdir='/scratch/adam_work',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=31.2
mem_iter,'/scratch/adam_work/l034/l034.sav','/scratch/adam_work/l034/v0.7_l034_13pca_deconv21.6',workingdir='/scratch/adam_work',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=21.6
mem_iter,'/scratch/adam_work/l034/l034.sav','/scratch/adam_work/l034/v0.7_l034_13pca_deconv14.4',workingdir='/scratch/adam_work',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=14.4
mem_iter,'/scratch/adam_work/l034/l034.sav','/scratch/adam_work/l034/v0.7_l034_13pca_deconv7.2',workingdir='/scratch/adam_work',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=7.2

mem_iter,'/usb/scratch1/l001/l001.sav','/usb/scratch1/l001/v0.7_l001_13pca_deconv31.2',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=31.2
mem_iter,'/usb/scratch1/l001/l001.sav','/usb/scratch1/l001/v0.7_l001_13pca_deconv21.6',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=21.6
mem_iter,'/usb/scratch1/l001/l001.sav','/usb/scratch1/l001/v0.7_l001_13pca_deconv14.4',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=14.4
mem_iter,'/usb/scratch1/l001/l001.sav','/usb/scratch1/l001/v0.7_l001_13pca_deconv7.2',workingdir='/usb/scratch1',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=7.2

mem_iter,'/scratch/adam_work/l077/v0.7_l077_13pca_postiter.sav','/scratch/adam_work/l077/v0.7_l077_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim
mem_iter,'/scratch/adam_work/l077/v0.7_l077_13pca_postiter.sav','/scratch/adam_work/l077/v0.7_l077_13pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/w5/v0.7_w5_13pca_postiter.sav','/usb/scratch1/w5/v0.7_w5_13pca',workingdir='/scratch/adam_work',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/w5/v0.7_w5_13pca_postiter.sav','/usb/scratch1/w5/v0.7_w5_13pca_deconv',workingdir='/scratch/adam_work',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_3pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+3,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_7pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+7,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_10pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+10,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_16pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+16,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_31pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+31,/simulate_only,/linearsim
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv_31.2',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=31.2
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_13pca_deconv_21.6',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=21.6
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_3pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+3,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_7pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+7,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_10pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+10,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_16pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+16,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_21pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+21,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_26pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+26,/simulate_only,/linearsim,/deconvolve
mem_iter,'/usb/scratch1/l111/v1.0_l111_13pca_postiter.sav','/usb/scratch1/l111/v0.7_l111_31pca_deconv',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+31,/simulate_only,/linearsim,/deconvolve

mem_iter,'/scratch/adam_work/l082/l082.sav','/scratch/adam_work/l082/v0.7_l082_13pca',workingdir='/scratch/adam_work',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13

mem_iter,'/scratch/adam_work/l065/l065.sav','/scratch/adam_work/l065/v0.7_l065_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,noiselevel=0
mem_iter,'/scratch/adam_work/l024/l024.sav','/scratch/adam_work/l024/v0.7_l024_13pca',workingdir='/scratch/adam_work',/fromsave,smoothmap=0,fits_timestream=0,ts_map=0,niter=intarr(31)+13,simulate_only=1000,/randomsim
mem_iter,'/scratch/adam_work/l024/v0.7_l024_13pca_postiter.sav','/scratch/adam_work/l024/v0.7_l024_13pca',workingdir='/scratch/adam_work',/fromsave,smoothmap=0,fits_timestream=0,ts_map=0,niter=intarr(31)+13,simulate_only=1000,/randomsim,widthspread=5,noiselevel=0
mem_iter,'/usb/scratch1/l009/v0.7_l009_13pca_postiter.sav','/usb/scratch1/l009/v0.7_l009_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=1000,/linearsim,noiselevel=0
mem_iter,'/usb/scratch1/l009/v0.7_l009_13pca_postiter.sav','/usb/scratch1/l009/v0.7_l009_13pca_deconv',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=1000,/linearsim,/deconvolve

mem_iter,'/usb/scratch1/l000/l000.sav','/usb/scratch1/l000/v0.7_l000_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=200,/randomsim,/noflat,/no_polysub

mem_iter,'/usb/scratch1/l351/l351.sav','/usb/scratch1/l351/v0.7_l351_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l354/l354.sav','/usb/scratch1/l354/v0.7_l354_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l357/l357.sav','/usb/scratch1/l357/v0.7_l357_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,'/usb/scratch1/l359/l359.sav','/usb/scratch1/l359/v0.7_l359_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,'/usb/scratch1/l001/l001.sav','/usb/scratch1/l001/v0.7_l001_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,'/usb/scratch1/l003/l003.sav','/usb/scratch1/l003/v0.7_l003_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l006/l006.sav','/usb/scratch1/l006/v0.7_l006_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l009/l009.sav','/usb/scratch1/l009/v0.7_l009_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l012/l012.sav','/usb/scratch1/l012/v0.7_l012_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/l018/l018.sav','/usb/scratch1/l018/v0.7_l018_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l024/l024.sav','/scratch/adam_work/l024/v0.7_l024_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l029/l029.sav','/scratch/adam_work/l029/v0.7_l029_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l030/l030.sav','/scratch/adam_work/l030/v0.7_l030_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l032/l032.sav','/scratch/adam_work/l032/v0.7_l032_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l035/l035.sav','/scratch/adam_work/l035/v0.7_l035_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l040/l040.sav','/scratch/adam_work/l040/v0.7_l040_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l045/l045.sav','/scratch/adam_work/l045/v0.7_l045_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l050/l050.sav','/scratch/adam_work/l050/v0.7_l050_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l055/l055.sav','/scratch/adam_work/l055/v0.7_l055_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l065/l065.sav','/scratch/adam_work/l065/v0.7_l065_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l072/l072.sav','/scratch/adam_work/l072/v0.7_l072_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l077/l077.sav','/scratch/adam_work/l077/v0.7_l077_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l082/l082.sav','/scratch/adam_work/l082/v0.7_l082_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l086/l086.sav','/scratch/adam_work/l086/v0.7_l086_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l111/l111.sav','/scratch/adam_work/l111/v0.7_l111_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/l133/l133.sav','/scratch/adam_work/l133/v0.7_l133_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/gemob1/gemob1.sav','/scratch/adam_work/gemob1/v0.7_gemob1_13pca',workingdir='/scratch/adam_work',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/ic1396/ic1396.sav','/usb/scratch1/ic1396/v0.7_ic1396_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/usb/scratch1/super_gc/super_gc.sav','/usb/scratch1/super_gc/v0.7_super_gc_13pca',workingdir='/usb/scratch1',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,'/scratch/adam_work/w5/w5.sav','/scratch/adam_work/w5/v0.7_w5_13pca',workingdir='/scratch/adam_work',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13





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

