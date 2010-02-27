; simulations 2010
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,minamp=1.0,maxamp=100.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_sim_initial.fits'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,minamp=1.0,maxamp=100.0,minsrc=31.2/2.35/7.2,maxsrc=35/2.35/7.2,separator=10.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_bright_points_sim_sim_measurements.sav'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,minamp=1.0,maxamp=2000.0,minsrc=31.2/2.35/7.2,maxsrc=50/2.35/7.2,separator=10.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_points_sim_sim_measurements.sav'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_spread_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,minamp=1.0,maxamp=2000.0,minsrc=31.2/2.35/7.2,maxsrc=50/2.35/7.2,separator=10.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_spread_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_spread_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_spread_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_spread_points_sim_sim_measurements.sav'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_uniform_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,minamp=1.0,maxamp=2000.0,minsrc=31.2/2.35/7.2,maxsrc=35/2.35/7.2,separator=10.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_uniform_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_uniform_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_uniform_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_verybright_uniform_points_sim_sim_measurements.sav'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000uniform_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,/deconvolve,minamp=0.1,maxamp=2000.0,srcsize=33.0/2.35/7.2,separator=15.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000uniform_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000uniform_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000uniform_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000uniform_points_sim_sim_measurements.sav'
mem_iter,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000logspacing_points',workingdir=getenv('WORKINGDIR'),/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,/logspacing,/deconvolve,minamp=0.1,maxamp=2000.0,srcsize=33.0/2.35/7.2,separator=15.0
measure_flux,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000logspacing_points_sim_sim_sources.sav',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000logspacing_points_sim_map20.fits',getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000logspacing_points_sim_initial.fits'
restore,getenv('WORKINGDIR')+'/l111/v1.0.2_l111_13pca_deconv_0.1to2000logspacing_points_sim_sim_measurements.sav'
device,decompose=0
loadct,39
plot,amplitudes[where(xwidth eq size_uniq[0])],(flux_recov/flux_input)[where(xwidth eq size_uniq[0])],psym=4,/ys,yrange=[0.5,1.1]
for i=1L,7L do begin & oplot,amplitudes[where(xwidth eq size_uniq[i])],(flux_recov/flux_input)[where(xwidth eq size_uniq[i])],psym=4,color=255/6.*i & endfor

mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_14.4',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=14.4,separator=10.0

mem_iter,[getenv('SLICED_POLY')+'/1655p077/070708_ob9_raw_ds1.nc',getenv('SLICED_POLY')+'/1655p077/070708_o10_raw_ds1.nc'],getenv('WORKINGDIR')+'/pointmaps_v1.0/1655p077_070708_ob9-0_13pca',niter=replicate(13,11),/deconvolve,pointing_model=0,mvperjy=[1,0,0],dosave=2
restore,'/Volumes/disk3/adam_work/pointmaps_v1.0/1655p077_070708_ob9-0_13pca_postiter.sav'
gfit=centroid_map(mapstr.astromap,fitmap=fitmap)
mapstr.model = fitmap
bgps.astrosignal = mapstr.model[mapstr.ts]
bgps.raw = bgps.raw - bgps.astrosignal
bgps.ac_bolos = bgps.ac_bolos - bgps.astrosignal
i=0
save,bgps,mapstr,i,filename='/Volumes/disk3/adam_work/pointmaps_v1.0/1655p077_070708_ob9-0_13pca_mask_simstart.sav'



; polysub tests
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o1',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=1,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=2,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o3',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=3,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o5',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=5,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o7',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=7,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_preiter.sav',getenv('WORKINGDIR2')+'/l357/v1.0.2_l357_13pca_o9',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,polysub_order=9,/deconvolve,deconv_fwhm=21.6


mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_uniform',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_uniformrandom',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_uniformrandom_bigsrc',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],widthspread=10,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_uniform',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_uniformrandom',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_uniformrandom_bigsrc',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],widthspread=10,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_uniform',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_uniformrandom',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_uniformrandom_bigsrc',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=500,/uniformsim,/uniformrandom,fluxrange=[.001,.1],widthspread=10,/deconvolve

mem_iter,getenv('WORKINGDIR')+'/l034/l034.sav',getenv('WORKINGDIR')+'/l034/v0.7_l034_13pca_deconv31.2',workingdir=getenv('WORKINGDIR')+'',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=31.2
mem_iter,getenv('WORKINGDIR')+'/l034/l034.sav',getenv('WORKINGDIR')+'/l034/v0.7_l034_13pca_deconv21.6',workingdir=getenv('WORKINGDIR')+'',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR')+'/l034/l034.sav',getenv('WORKINGDIR')+'/l034/v0.7_l034_13pca_deconv14.4',workingdir=getenv('WORKINGDIR')+'',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=14.4
mem_iter,getenv('WORKINGDIR')+'/l034/l034.sav',getenv('WORKINGDIR')+'/l034/v0.7_l034_13pca_deconv7.2',workingdir=getenv('WORKINGDIR')+'',/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/deconvolve,deconv_fwhm=7.2

mem_iter,getenv('WORKINGDIR2')+'/l001/l001.sav',getenv('WORKINGDIR2')+'/l001/v0.7_l001_13pca_deconv31.2',workingdir=getenv('WORKINGDIR2')+'',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=31.2
mem_iter,getenv('WORKINGDIR2')+'/l001/l001.sav',getenv('WORKINGDIR2')+'/l001/v0.7_l001_13pca_deconv21.6',workingdir=getenv('WORKINGDIR2')+'',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l001/l001.sav',getenv('WORKINGDIR2')+'/l001/v0.7_l001_13pca_deconv14.4',workingdir=getenv('WORKINGDIR2')+'',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=14.4
mem_iter,getenv('WORKINGDIR2')+'/l001/l001.sav',getenv('WORKINGDIR2')+'/l001/v0.7_l001_13pca_deconv7.2',workingdir=getenv('WORKINGDIR2')+'',deconvolve=1,/pointing_model,/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,deconv_fwhm=7.2

mem_iter,getenv('WORKINGDIR')+'/l077/v0.7_l077_13pca_postiter.sav',getenv('WORKINGDIR')+'/l077/v0.7_l077_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim
mem_iter,getenv('WORKINGDIR')+'/l077/v0.7_l077_13pca_postiter.sav',getenv('WORKINGDIR')+'/l077/v0.7_l077_13pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/w5/v0.7_w5_13pca_postiter.sav',getenv('WORKINGDIR2')+'/w5/v0.7_w5_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim
mem_iter,getenv('WORKINGDIR2')+'/w5/v0.7_w5_13pca_postiter.sav',getenv('WORKINGDIR2')+'/w5/v0.7_w5_13pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_7.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=7.2
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_14.4',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=14.4
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_31.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=31.2
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_deconv_21.6',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_3pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+3,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_7pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+7,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_10pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+10,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_16pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+16,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_21pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+21,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_26pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+26,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l111/v1.0.2_l111_31pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+31,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_7.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=7.2
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_14.4',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=14.4
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_31.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=31.2
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_deconv_21.6',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=21.6
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_3pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+3,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_7pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+7,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_10pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+10,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_16pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+16,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_21pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+21,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_26pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+26,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_13pca_postiter.sav',getenv('WORKINGDIR2')+'/ic1396/v1.0.2_ic1396_31pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+31,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_3pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+3,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_7pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+7,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_10pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+10,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_16pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+16,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_21pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+21,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_26pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+26,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_31pca_deconv',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+31,/simulate_only,/linearsim,/deconvolve
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_7.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=7.2
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_14.4',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=14.4
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_31.2',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=31.2
mem_iter,getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_postiter.sav',getenv('WORKINGDIR')+'/l072/v1.0.2_l072_13pca_deconv_21.6',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/linearsim,/deconvolve,deconv_fwhm=21.6

mem_iter,getenv('WORKINGDIR')+'/l082/l082.sav',getenv('WORKINGDIR')+'/l082/v0.7_l082_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13

mem_iter,getenv('WORKINGDIR')+'/l065/l065.sav',getenv('WORKINGDIR')+'/l065/v0.7_l065_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,/simulate_only,/uniformsim,noiselevel=0
mem_iter,getenv('WORKINGDIR')+'/l024/l024.sav',getenv('WORKINGDIR')+'/l024/v0.7_l024_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,smoothmap=0,fits_timestream=0,ts_map=0,niter=intarr(31)+13,simulate_only=1000,/randomsim
mem_iter,getenv('WORKINGDIR')+'/l024/v0.7_l024_13pca_postiter.sav',getenv('WORKINGDIR')+'/l024/v0.7_l024_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,smoothmap=0,fits_timestream=0,ts_map=0,niter=intarr(31)+13,simulate_only=1000,/randomsim,widthspread=5,noiselevel=0
mem_iter,getenv('WORKINGDIR2')+'/l009/v0.7_l009_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l009/v0.7_l009_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=1000,/linearsim,noiselevel=0
mem_iter,getenv('WORKINGDIR2')+'/l009/v0.7_l009_13pca_postiter.sav',getenv('WORKINGDIR2')+'/l009/v0.7_l009_13pca_deconv',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=1000,/linearsim,/deconvolve

mem_iter,getenv('WORKINGDIR2')+'/l000/l000.sav',getenv('WORKINGDIR2')+'/l000/v0.7_l000_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13,simulate_only=200,/randomsim,/noflat,/no_polysub

mem_iter,getenv('WORKINGDIR2')+'/l351/l351.sav',getenv('WORKINGDIR2')+'/l351/v0.7_l351_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l354/l354.sav',getenv('WORKINGDIR2')+'/l354/v0.7_l354_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l357/l357.sav',getenv('WORKINGDIR2')+'/l357/v0.7_l357_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,getenv('WORKINGDIR2')+'/l359/l359.sav',getenv('WORKINGDIR2')+'/l359/v0.7_l359_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,getenv('WORKINGDIR2')+'/l001/l001.sav',getenv('WORKINGDIR2')+'/l001/v0.7_l001_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
;mem_iter,getenv('WORKINGDIR2')+'/l003/l003.sav',getenv('WORKINGDIR2')+'/l003/v0.7_l003_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l006/l006.sav',getenv('WORKINGDIR2')+'/l006/v0.7_l006_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l009/l009.sav',getenv('WORKINGDIR2')+'/l009/v0.7_l009_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l012/l012.sav',getenv('WORKINGDIR2')+'/l012/v0.7_l012_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/l018/l018.sav',getenv('WORKINGDIR2')+'/l018/v0.7_l018_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l024/l024.sav',getenv('WORKINGDIR')+'/l024/v0.7_l024_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l029/l029.sav',getenv('WORKINGDIR')+'/l029/v0.7_l029_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l030/l030.sav',getenv('WORKINGDIR')+'/l030/v0.7_l030_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l032/l032.sav',getenv('WORKINGDIR')+'/l032/v0.7_l032_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l035/l035.sav',getenv('WORKINGDIR')+'/l035/v0.7_l035_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l040/l040.sav',getenv('WORKINGDIR')+'/l040/v0.7_l040_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l045/l045.sav',getenv('WORKINGDIR')+'/l045/v0.7_l045_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l050/l050.sav',getenv('WORKINGDIR')+'/l050/v0.7_l050_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l055/l055.sav',getenv('WORKINGDIR')+'/l055/v0.7_l055_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l065/l065.sav',getenv('WORKINGDIR')+'/l065/v0.7_l065_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l072/l072.sav',getenv('WORKINGDIR')+'/l072/v0.7_l072_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l077/l077.sav',getenv('WORKINGDIR')+'/l077/v0.7_l077_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l082/l082.sav',getenv('WORKINGDIR')+'/l082/v0.7_l082_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l086/l086.sav',getenv('WORKINGDIR')+'/l086/v0.7_l086_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l111/l111.sav',getenv('WORKINGDIR')+'/l111/v0.7_l111_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/l133/l133.sav',getenv('WORKINGDIR')+'/l133/v0.7_l133_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/gemob1/gemob1.sav',getenv('WORKINGDIR')+'/gemob1/v0.7_gemob1_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/ic1396/ic1396.sav',getenv('WORKINGDIR2')+'/ic1396/v0.7_ic1396_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR2')+'/super_gc/super_gc.sav',getenv('WORKINGDIR2')+'/super_gc/v0.7_super_gc_13pca',workingdir=getenv('WORKINGDIR2')+'',/fromsave,fits_timestream=0,ts_map=0,niter=intarr(21)+13
mem_iter,getenv('WORKINGDIR')+'/w5/w5.sav',getenv('WORKINGDIR')+'/w5/v0.7_w5_13pca',workingdir=getenv('WORKINGDIR')+'',/fromsave,/dosave,fits_timestream=0,ts_map=0,niter=intarr(51)+13





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

