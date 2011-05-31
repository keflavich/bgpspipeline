outdir = getenv('WORKINGDIR')+'/artificial_sims/exp7_astrotest1_v1/'
file_mkdir,outdir
outfile = prep_gaussfitstxt(outdir)

imagpowers = [-1.5,-1.5,-1.5,-1.0,-2.0,-1.0]
realpowers = [-1.5,-1.5,-1.0,-1.5,-2.0,-1.0]
imagscales = [ 1.0,1/5., 1.0, 1.0, 1.0, 1.0]
peaklist = [0.25, 1.0, 5.0, 10.0]

for kk = 0,3 do begin 
  for jj = 0,3 do begin
    ; fix seeds (but we don't want them the same b/c then they'll be correlated)
    seed1 = (jj+1)
    seed2 = (jj+1)*5
    seed3 = (jj+1)*10

    for ii=0,5 do begin

      dimsize = 512

      realpower = realpowers[ii]
      imagpower = imagpowers[ii]
      imagscale = imagscales[ii]
      peakamp = peaklist[kk]
      noise = 0.03
      ;smoothkernel = psf_gaussian(npix=512,ndim=2,fwhm=31.2/7.2,/normalize)
      smoothkernel_big = readfits(getenv('PIPELINE_ROOT')+'/simulation/model_psf.fits',hdr0)
      smoothkernel = congrid(smoothkernel_big,160,160) 
      smoothkernel /= total(smoothkernel)
      sigma_gp = 128.0 ; sigma-width of the Galactic Plane (can get more accurate value from Cara's paper)

      xx = findgen(dimsize) #  replicate(1.0,dimsize)
      yy = findgen(dimsize) ## replicate(1.0,dimsize)
      rr = sqrt( (xx-255.5)^2 + (yy-255.5)^2 )
      realpart = (rr^realpower) * randomn(seed1,[dimsize,dimsize])
      imagpart = ((rr*imagscale)^imagpower) * randomn(seed2,[dimsize,dimsize])*complex(0,1) 
      fakesky = abs(fft(shift(realpart + imagpart,0,0),1))
      expweight = exp(-(yy-255.5)^2/(2.0*sigma_gp^2)) ; most power is in the inner plane

      fakesky *= peakamp/max(fakesky)
      fakesky_sm = convolve(fakesky,smoothkernel)
      fakesky_sm = fakesky_sm*expweight
      ; the real sky is not noisy fakesky_sm += randomn(seed3,[dimsize,dimsize]) * noise

      ;atv,fakesky_sm,/linear,max=peakamp
      ;set_plot,'ps'
      ;device,filename=outdir+'exp7_fakesky_sm_realP'+string(realpower,format='(F04.1)',/print)+"_imagP"+string(imagpower,format='(F04.1)',/print)+"_imagS"+string(imagscale,format='(F04.1)',/print)+"_seednum"+string(jj,format="(I02)",/print)+".ps",$
      ;  /encapsul,xsize=8,ysize=8
      title="realP"+string(realpower,format='(F04.1)',/print)+" imagP"+string(imagpower,format='(F04.1)',/print)+" Seed "+string(JJ,format='(I)',/print)+" Peakamp "+string(peakamp,format="(F06.2)")+" imagS"+string(imagscale,format='(F04.1)',/print)
      ;imdisp,fakesky_sm,/axis,title=title
      ;device,/close_file
      ;set_plot,'x'

      fakemap = fakesky*expweight
      hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 512','NAXIS2  = 512','CDELT1  = 0.002','CDELT2  = 0.002','CRPIX1  = 256','CRPIX2  = 256','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','BUNIT   = "Jy/Beam"',"BMAJ    = 0.0091666","BMIN    = 0.00916666","BPA     = 0",'END']

      array_angle = 45

      outmap_prefix = outdir+'exp7_ds1_astrosky_arrang'+string(array_angle,format='(I02)')+ $
        "_atmotest_amp"+string(1.0,format='(E07.1)')+"_sky"+string(ii,format='(I02)')+$
        "_seed"+string(jj,format="(I02)")+"_peak"+string(peakamp,format="(F06.2)")+"_nosmooth"
      make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
        scan_angle=00,needed_once_struct=needed_once_struct,$
        outmap=outmap_prefix+"_scandir1",$
        /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.02
      fake_atmosphere_ds1 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
        amplitude=1.0,individual_bolonoise_rms=noise*4.0,relative_scale_rms=0.01,relative_scales=relative_scales_ds1)
      input_ts_ds1 = bgps.ac_bolos
      bgps.ac_bolos += fake_atmosphere_ds1
      save,bgps,mapstr,filename=mapstr.outmap+"_preiter.sav",/verbose
      save,needed_once_struct,filename=mapstr.outmap+"_neededonce.sav",/verbose
      mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
        fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
        fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds1,/rescale

      make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
        scan_angle=90,needed_once_struct=needed_once_struct,$
        outmap=outmap_prefix+"_scandir2",$
        /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.02
      fake_atmosphere_ds1 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
        amplitude=1.0,individual_bolonoise_rms=noise*4.0,relative_scale_rms=0.01,relative_scales=relative_scales_ds1)
      input_ts_ds1 = bgps.ac_bolos
      bgps.ac_bolos += fake_atmosphere_ds1
      save,bgps,mapstr,filename=mapstr.outmap+"_preiter.sav",/verbose
      save,needed_once_struct,filename=mapstr.outmap+"_neededonce.sav",/verbose
      mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
        fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
        fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds1,/rescale
    
      merge_savefiles,outmap_prefix+"_scandir1_preiter.sav",outmap_prefix+"_scandir2_preiter.sav",outmap=outmap_prefix,bgps=bgps,mapstr=mapstr,needed_once_struct=needed_once_struct
    
      mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
        fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
        fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds1,/rescale
    
      outmap=mapstr.outmap
      spawn,"cp "+outmap_prefix+"_scandir1_inputmap.fits "+outmap+"_inputmap.fits"
      fakemap=readfits(outmap+"_inputmap.fits",hdr)
      map00 = readfits(outmap+"_map00.fits",hdr)
      map20 = readfits(outmap+"_map20.fits",hdr)

      resid00 = fakemap - map00
      resid20 = fakemap - map20

      writefits,outmap+"_simresid00.fits",resid00,hdr
      writefits,outmap+"_simresid20.fits",resid20,hdr

      ; do analysis:
      compare_images,outmap,cuts='0.02,0.1,0.5',wcsaperture="",point=0,title=title

      fakemap = fakesky_sm
      hdr=['SIMPLE  = T','BITPIX  = -32','NAXIS   = 2','NAXIS1  = 512','NAXIS2  = 512','CDELT1  = 0.002','CDELT2  = 0.002','CRPIX1  = 256','CRPIX2  = 256','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','BUNIT   = "Jy/Beam"',"BMAJ    = 0.0091666","BMIN    = 0.00916666","BPA     = 0",'END']

      array_angle = 45

      outmap_prefix = outdir+'exp7_ds1_astrosky_arrang'+string(array_angle,format='(I02)')+ $
        "_atmotest_amp"+string(1.0,format='(E07.1)')+"_sky"+string(ii,format='(I02)')+$
        "_seed"+string(jj,format="(I02)")+"_peak"+string(peakamp,format="(F06.2)")+"_smooth"

      make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
        scan_angle=00,needed_once_struct=needed_once_struct,$
        outmap=outmap_prefix+"_scandir1",$
        /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.02
      fake_atmosphere_ds1 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
        amplitude=1.0,individual_bolonoise_rms=noise*4.0,relative_scale_rms=0.01,relative_scales=relative_scales_ds1)
      input_ts_ds1 = bgps.ac_bolos
      bgps.ac_bolos += fake_atmosphere_ds1
      save,bgps,mapstr,filename=mapstr.outmap+"_preiter.sav",/verbose
      save,needed_once_struct,filename=mapstr.outmap+"_neededonce.sav",/verbose

      make_artificial_timestreams_v1,fakemap,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
        scan_angle=90,needed_once_struct=needed_once_struct,$
        outmap=outmap_prefix+"_scandir2",$
        /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.02
      fake_atmosphere_ds1 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
        amplitude=1.0,individual_bolonoise_rms=noise*4.0,relative_scale_rms=0.01,relative_scales=relative_scales_ds1)
      input_ts_ds1 = bgps.ac_bolos
      bgps.ac_bolos += fake_atmosphere_ds1
      save,bgps,mapstr,filename=mapstr.outmap+"_preiter.sav",/verbose
      save,needed_once_struct,filename=mapstr.outmap+"_neededonce.sav",/verbose

      merge_savefiles,outmap_prefix+"_scandir1_preiter.sav",outmap_prefix+"_scandir2_preiter.sav",outmap=outmap_prefix,bgps=bgps,mapstr=mapstr,needed_once_struct=needed_once_struct
    
      mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
        fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
        fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds1,/rescale
    
      outmap=mapstr.outmap
      spawn,"cp "+outmap_prefix+"_scandir1_inputmap.fits "+outmap+"_inputmap.fits"
      fakemap=readfits(outmap+"_inputmap.fits",hdr)
      map00 = readfits(outmap+"_map00.fits",hdr)
      map20 = readfits(outmap+"_map20.fits",hdr)

      resid00 = fakemap - map00
      resid20 = fakemap - map20

      writefits,outmap+"_simresid00.fits",resid00,hdr
      writefits,outmap+"_simresid20.fits",resid20,hdr

      ; do analysis:
      compare_images,outmap,cuts='0.02,0.1,0.5',wcsaperture="",point=0,title=title
      stop

    endfor
  endfor
endfor

end


; imshow(fftshift(abs((fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)*((xx+yy<511.5)*-1+(xx+yy>511.5))) + expfunc/1e2  )))))
; imshow((abs((fftshift(fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)*((xx+yy<511.5)*-1+(xx+yy>511.5))))) * abs(expfunc)  ))))
; imshow((abs((fftshift(fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)))) * abs(expfunc)  ))))
