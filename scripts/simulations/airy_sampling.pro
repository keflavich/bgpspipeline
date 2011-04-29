snlist = [50,100,500]
for ii=0,0 do begin

  outdir = getenv('WORKINGDIR')+'/v1_artificial_sims/exp1_airy_sampling/'
  cuts = '0.02,0.1'

  signal_to_noise = snlist[ii]

  psf=psf_gaussian(npix=160*6,fwhm=31.2/7.2*6.0,ndim=2) 
  fakemap = psf/max(psf) + randomn(seed,size(psf,/dim)) / signal_to_noise
  hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 960','NAXIS2  = 960','CDELT1  = 0.00033333','CDELT2  = 0.00033333','CRPIX1  = 480','CRPIX2  = 480','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','END']

  array_angle = 45;ii*10

  make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
    outmap=outdir+'airy_test_superres_ds1_sn'+string(signal_to_noise,format="(I03)"),$
    /dosave,stepsize=15;, array_angle=array_angle,stepsize=15,sample_interval=0.02

  mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
    fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[12],plot_bolos=[12],plot_weights=1,$
    fits_timestream=0,return_reconv=1,sim_input_ts=bgps.ac_bolos


  outmap=mapstr.outmap
  fakemap=readfits(outmap+"_inputmap.fits",hdr)
  map00 = readfits(outmap+"_map00.fits",hdr)
  map20 = readfits(outmap+"_map20.fits",hdr)

  resid00 = fakemap - map00
  resid20 = fakemap - map20

  writefits,outmap+"_simresid00.fits",resid00,hdr
  writefits,outmap+"_simresid20.fits",resid20,hdr

  ; do analysis:
  command = 'python ~/work/bgps_pipeline/plotting/compare_images.py '
  file1 = outmap+"_inputmap.fits "
  file2 = outmap+"_map20.fits "
  options = "--cuts "+cuts+" --wcsaperture 0,0,100,200 --psd "+outmap+"_psds.png --savename "+outmap+"_compare.png --im1 Input --im2 Map20 --point True"
  print,(command+file1+file2+options)
  spawn,(command+file1+file2+options)

  mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap+"_3pca",/fromsave,niter=replicate(3,21),$
    fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[12],plot_bolos=[12],plot_weights=1,$
    fits_timestream=0,return_reconv=1,sim_input_ts=bgps.ac_bolos


  outmap=mapstr.outmap
  map00 = readfits(outmap+"_3pca_map00.fits",hdr)
  map20 = readfits(outmap+"_3pca_map20.fits",hdr)

  resid00 = fakemap - map00
  resid20 = fakemap - map20

  writefits,outmap+"_3pca_simresid00.fits",resid00,hdr
  writefits,outmap+"_3pca_simresid20.fits",resid20,hdr

  ; do analysis:
  command = 'python ~/work/bgps_pipeline/plotting/compare_images.py '
  file1 = outmap+"_inputmap.fits "
  file2 = outmap+"_3pca_map20.fits "
  options = "--cuts "+cuts+" --wcsaperture 0,0,100,200 --psd "+outmap+"_3pca_psds.png --savename "+outmap+"_3pca_compare.png --im1 Input --im2 Map20 --point True"
  print,(command+file1+file2+options)
  spawn,(command+file1+file2+options)



;  fakemap = psf/max(psf) + randomn(seed,size(psf,/dim)) / signal_to_noise
;  hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 960','NAXIS2  = 960','CDELT1  = 0.00033333','CDELT2  = 0.00033333','CRPIX1  = 480','CRPIX2  = 480','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','END']
;  make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
;    scan_angle=0,offset_timestream=0.0,$
;    outmap=outdir+'airy_test_superres_ds1_smallpix_sn'+string(signal_to_noise,format="(I03)"),$
;    /dosave, array_angle=array_angle,stepsize=15,sample_interval=0.02,cdelt_out=3.6
;
;  mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
;    fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[12],plot_bolos=[12],plot_weights=1,$
;    fits_timestream=0,return_reconv=1,sim_input_ts=bgps.ac_bolos,pixsize=3.6
;
;  outmap=mapstr.outmap
;  fakemap=readfits(outmap+"_inputmap.fits",hdr)
;  map00 = readfits(outmap+"_map00.fits",hdr)
;  map20 = readfits(outmap+"_map20.fits",hdr)
;
;  resid00 = fakemap - map00
;  resid20 = fakemap - map20
;
;  writefits,outmap+"_simresid00.fits",resid00,hdr
;  writefits,outmap+"_simresid20.fits",resid20,hdr
;
;  ; do analysis:
;  command = 'python ~/work/bgps_pipeline/plotting/compare_images.py '
;  file1 = outmap+"_inputmap.fits "
;  file2 = outmap+"_map20.fits "
;  options = "--cuts "+cuts+" --wcsaperture 0,0,100,200 --psd "+outmap+"_psds.png --savename "+outmap+"_compare.png --im1 Input --im2 Map20"
;  print,(command+file1+file2+options)
;  spawn,(command+file1+file2+options)
;
;
;
;
;
;
;  fakemap = psf/max(psf) + randomn(seed,size(psf,/dim)) / signal_to_noise
;  hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 960','NAXIS2  = 960','CDELT1  = 0.00033333','CDELT2  = 0.00033333','CRPIX1  = 480','CRPIX2  = 480','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','END']
;  make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
;    scan_angle=0,offset_timestream=0.0,$
;    outmap=outdir+'airy_test_superres_ds5_filtered_sn'+string(signal_to_noise,format="(I03)"),$
;    /dosave, array_angle=array_angle,stepsize=15,sample_interval=0.1,dofilter=1
;
;  mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
;    fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[12],plot_bolos=[12],plot_weights=1,$
;    fits_timestream=0,return_reconv=1,sim_input_ts=bgps.ac_bolos
;
;  outmap=mapstr.outmap
;  fakemap=readfits(outmap+"_inputmap.fits",hdr)
;  map00 = readfits(outmap+"_map00.fits",hdr)
;  map20 = readfits(outmap+"_map20.fits",hdr)
;
;  resid00 = fakemap - map00
;  resid20 = fakemap - map20
;
;  writefits,outmap+"_simresid00.fits",resid00,hdr
;  writefits,outmap+"_simresid20.fits",resid20,hdr
;
;  ; do analysis:
;  command = 'python ~/work/bgps_pipeline/plotting/compare_images.py '
;  file1 = outmap+"_inputmap.fits "
;  file2 = outmap+"_map20.fits "
;  options = "--cuts "+cuts+" --wcsaperture 0,0,100,200 --psd "+outmap+"_psds.png --savename "+outmap+"_compare.png --im1 Input --im2 Map20"
;  print,(command+file1+file2+options)
;  spawn,(command+file1+file2+options)
;
;  fakemap = psf/max(psf) + randomn(seed,size(psf,/dim)) / signal_to_noise
;  hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 960','NAXIS2  = 960','CDELT1  = 0.00033333','CDELT2  = 0.00033333','CRPIX1  = 480','CRPIX2  = 480','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','END']
;  make_artificial_timestreams,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
;    scan_angle=0,offset_timestream=1.0,$
;    outmap=outdir+'airy_test_superres_ds5_unfiltered_sn'+string(signal_to_noise,format="(I03)"),$
;    /dosave, array_angle=array_angle,stepsize=15,sample_interval=0.1,dofilter=0
;
;  mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
;    fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[12],plot_bolos=[12],plot_weights=1,$
;    fits_timestream=0,return_reconv=1,sim_input_ts=bgps.ac_bolos
;
;  outmap=mapstr.outmap
;  fakemap=readfits(outmap+"_inputmap.fits",hdr)
;  map00 = readfits(outmap+"_map00.fits",hdr)
;  map20 = readfits(outmap+"_map20.fits",hdr)
;
;  resid00 = fakemap - map00
;  resid20 = fakemap - map20
;
;  writefits,outmap+"_simresid00.fits",resid00,hdr
;  writefits,outmap+"_simresid20.fits",resid20,hdr
;
;  ; do analysis:
;  command = 'python ~/work/bgps_pipeline/plotting/compare_images.py '
;  file1 = outmap+"_inputmap.fits "
;  file2 = outmap+"_map20.fits "
;  options = "--cuts "+cuts+" --wcsaperture 0,0,100,200 --psd "+outmap+"_psds.png --savename "+outmap+"_compare.png --im1 Input --im2 Map20"
;  print,(command+file1+file2+options)
;  spawn,(command+file1+file2+options)

endfor
end
