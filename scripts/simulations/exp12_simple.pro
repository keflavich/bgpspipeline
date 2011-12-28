outdir = getenv('WORKINGDIR')+'/artificial_sims/exp12_v1_simple/'
file_mkdir,outdir
outfile = prep_gaussfitstxt(outdir)
remake_sim = 0

imagpowers = [-1.5]
realpowers = imagpowers
imagscales = imagpowers*0+1
peaklist = [1.0]
atmo_amplitudes = [200.0]
rel_rms = [0.1]

openw,outf,outfile,/get_lun
unit1 = outf+1
unit2 = outf+2
unit3 = outf+3

printf,outf,string(["filename","atmo_amplitude","relrms","pearson_R","covariance"],format='(5A15)')

for oo=0,0 do begin ; relative sensitivity RMS
  for nn=0,0 do begin ; atmo amplitudes
    for kk = 0,0 do begin ; peaklist
      for jj = 0,0 do begin ; random seeds
    ;for kk = 1,1 do begin 
    ;  for jj = 0,0 do begin
        ; fix seeds (but we don't want them the same b/c then they'll be correlated)
        seed1 = (jj+1)
        seed2 = (jj+1)*5
        seed3 = (jj+1)*10
        seed4 = seed3+1

        ;for ii=0,n_elements(imagpowers)-1 do begin ; powers
        for ii=0,0 do begin
          time_s,'Starting simulation with atmo amplitude number '+string(nn)+' peak number '+string(kk)+' power law number '+string(ii)+' seed number '+string(jj)+" and rms "+string(oo),t0,/no_sticky

          dimsize = 512
          pixsize = 7.2 ; this is NOT PASSED to mem_iter or others; it is only used for PSD calculation (July 5 2011)

          realpower = realpowers[ii]
          imagpower = imagpowers[ii]
          imagscale = imagscales[ii]
          peakamp = peaklist[kk]
          noise = 0.1
          ;smoothkernel = psf_gaussian(npix=512,ndim=2,fwhm=31.2/7.2,/normalize)
          smoothkernel_big = readfits(getenv('PIPELINE_ROOT')+'/simulation/model_psf.fits',hdr0)
          smoothkernel = congrid(smoothkernel_big,160,160) 
          smoothkernel /= total(smoothkernel)
          sigma_gp = 128.0 ; sigma-width of the Galactic Plane (can get more accurate value from Cara's paper)

          xx = findgen(dimsize) #  replicate(1.0,dimsize)
          yy = findgen(dimsize) ## replicate(1.0,dimsize)
          rr = sqrt( (xx-255.5)^2 + (yy-255.5)^2 )
          th = atan( (xx-255.5) , (yy-255.5) )
          realpart = (rr^realpower) * randomn(seed1,[dimsize,dimsize])
          imagpart = ((rr*imagscale)^imagpower) * randomn(seed2,[dimsize,dimsize])*complex(0,1) 
          fakesky = abs(fft(shift(realpart + imagpart,0,0),1))
          expweight = exp(-(yy-255.5)^2/(2.0*sigma_gp^2)) ; most power is in the inner plane

          fakesky *= peakamp/max(fakesky)
          ptsrcs = add_point_sources(fltarr([dimsize,dimsize]), n_source_random=25, arrange='random', peak_alpha=-1.0,$
              source_range=[1.0,5.0], sourcesOut=sourcesOut_fakesky, seed=seed4)
          ptsrcs_conv = convolve(ptsrcs,smoothkernel/max(smoothkernel))
          fakesky_sm = convolve(fakesky,smoothkernel)
          ;fakesky_sm = fakesky_sm*expweight
          ; the real sky is not noisy fakesky_sm += randomn(seed3,[dimsize,dimsize]) * noise

          ;atv,fakesky_sm,/linear,max=peakamp
          ;set_plot,'ps'
          ;device,filename=outdir+'exp10_fakesky_sm_realP'+string(realpower,format='(F04.1)',/print)+"_imagP"+string(imagpower,format='(F04.1)',/print)+"_imagS"+string(imagscale,format='(F04.1)',/print)+"_seednum"+string(jj,format="(I02)",/print)+".ps",$
          ;  /encapsul,xsize=8,ysize=8
          title="realP"+string(realpower,format='(F04.1)',/print)+" imagP"+string(imagpower,format='(F04.1)',/print)+" Seed "+string(JJ,format='(I)',/print)+" Peakamp "+string(peakamp,format="(F06.2)")+" imagS"+string(imagscale,format='(F04.1)',/print)
          ;imdisp,fakesky_sm,/axis,title=title
          ;device,/close_file
          ;set_plot,'x'

          array_angle = 45

          filename_prefix = 'exp12_v1_ds2_astrosky_arrang'+string(array_angle,format='(I02)')+ $
            "_atmotest_amp"+string(atmo_amplitudes[nn],format='(E07.1)')+"_sky"+string(ii,format='(I02)')+$
            "_seed"+string(jj,format="(I02)")+"_peak"+string(peakamp,format="(F06.2)")+"_smooth"

          outmap_prefix = outdir+filename_prefix

          ;fakemap = fakesky*expweight
          ;psd,fakesky_sm,wavnumsm,smbefore,/view
          fakemap = fakesky_sm + ptsrcs_conv
          hdr=['SIMPLE  = T','BITPIX  = -64','NAXIS   = 2','NAXIS1  = 512','NAXIS2  = 512','CDELT1  = 0.002','CDELT2  = 0.002','CRPIX1  = 256','CRPIX2  = 256','CRVAL1  = 0.0','CRVAL2  = 0.0','CTYPE1  = GLON-CAR','CTYPE2  = GLAT-CAR','BUNIT   = "Jy/Beam"',"BMAJ    = 0.0091666","BMIN    = 0.00916666","BPA     = 0","END                                                                             "]
          writefits,outmap_prefix+"_pointsource_input.fits",ptsrcs_conv,hdr
          writefits,outmap_prefix+"_diffuse_input.fits",fakesky_sm,hdr

          if remake_sim then begin
            make_artificial_timestreams,fakemap+0,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
              scan_angle=00,needed_once_struct=needed_once_struct,$
              outmap=outmap_prefix+"_scandir1",$
              /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.04
            seed1 = (jj+1)
            fake_atmosphere_ds2 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
              amplitude=atmo_amplitudes[nn],individual_bolonoise_rms=noise,relative_scale_rms=rel_rms[oo],relative_scales=relative_scales_ds2,seed=seed1)
            input_ts_ds2 = bgps.ac_bolos
            bgps.ac_bolos += fake_atmosphere_ds2
            save,bgps,mapstr,needed_once_struct,filename=mapstr.outmap+"_preiter.sav",/verbose
            mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
              fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
              fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds2,/rescale,/verbose
            restore,mapstr.outmap+"_postiter.sav",/verbose
            help,1.0/relative_scales_ds2,bgps.scale_coeffs
            plot_inscale_outscale,1.0/relative_scales_ds2,bgps.scale_coeffs,outmap=mapstr.outmap,rms=rel_rms[oo]
            printf,outf,string(mapstr.outmap,format="(A15)")+string([atmo_amplitudes[nn],rel_rms[oo],correlate(1.0/relative_scales_ds2,bgps.scale_coeffs),correlate(1.0/relative_scales_ds2,bgps.scale_coeffs,/covariance)],format="(4A15)")
            close,unit1
            free_lun,unit1
            spawn,'pstopng -r `find '+pathsplit(mapstr.outmap)+' -name "'+pathsplit(mapstr.outmap,/return_filename)+'*.ps"`',unit=unit1
            relscales_both = relative_scales_ds2

            make_artificial_timestreams,fakemap+0,hdr,ts=ts,astrosignal=astrosignal,bgps=bgps,mapstr=mapstr,$
              scan_angle=90,needed_once_struct=needed_once_struct,$
              outmap=outmap_prefix+"_scandir2",$
              /dosave, array_angle=array_angle,stepsize=120,sample_interval=0.04
            seed2 = (jj+1)*5
            fake_atmosphere_ds2 = make_atmosphere(bgps.ac_bolos,samplerate=bgps.sample_interval,$
              amplitude=atmo_amplitudes[nn],individual_bolonoise_rms=noise,relative_scale_rms=rel_rms[oo],relative_scales=relative_scales_ds2,seed=seed2)
            input_ts_ds2 = bgps.ac_bolos
            bgps.ac_bolos += fake_atmosphere_ds2
            save,bgps,mapstr,needed_once_struct,filename=mapstr.outmap+"_preiter.sav",/verbose
            mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
              fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
              fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds2,/rescale,/verbose
            restore,mapstr.outmap+"_postiter.sav",/verbose
            help,1.0/relative_scales_ds2,bgps.scale_coeffs
            plot_inscale_outscale,1.0/relative_scales_ds2,bgps.scale_coeffs,outmap=mapstr.outmap,rms=rel_rms[oo]
            printf,outf,string(mapstr.outmap,format="(A15)")+string([atmo_amplitudes[nn],rel_rms[oo],correlate(1.0/relative_scales_ds2,bgps.scale_coeffs),correlate(1.0/relative_scales_ds2,bgps.scale_coeffs,/covariance)],format="(4A15)")
            close,unit2
            free_lun,unit2
            spawn,'pstopng -r `find '+pathsplit(mapstr.outmap)+' -name "'+pathsplit(mapstr.outmap,/return_filename)+'*.ps"`',unit=unit2
            relscales_both = ([[relscales_both],[relative_scales_ds2]])
          
            merge_savefiles,outmap_prefix+"_scandir1_preiter.sav",outmap_prefix+"_scandir2_preiter.sav",outmap=outmap_prefix,bgps=bgps,mapstr=mapstr,needed_once_struct=needed_once_struct
          
            mem_iter,mapstr.outmap+"_preiter.sav",mapstr.outmap,/fromsave,niter=replicate(13,21),$
              fits_out=[0,1,2,5,10,20],dosave=2,plot_all_timestreams=[3],plot_bolos=[7],plot_weights=1,$
              fits_timestream=0,return_reconv=1,sim_input_ts=input_ts_ds2,/rescale,/verbose
              ;/pre_expsub,/do_deline,/weight_scans,do_weight=0
            restore,mapstr.outmap+"_postiter.sav",/verbose
            help,1.0/relscales_both,bgps.scale_coeffs
            plot_inscale_outscale,1.0/(relscales_both),bgps.scale_coeffs,outmap=mapstr.outmap,rms=rel_rms[oo]
            printf,outf,string(mapstr.outmap,format=("(A15)"))+string([atmo_amplitudes[nn],rel_rms[oo],correlate(1.0/(relscales_both),bgps.scale_coeffs),correlate(1.0/(relscales_both),bgps.scale_coeffs,/covariance)],format="(4A15)")
            close,unit3
            free_lun,unit3
            spawn,'pstopng -r `find '+pathsplit(mapstr.outmap)+' -name "'+pathsplit(mapstr.outmap,/return_filename)+'*.ps"`',unit=unit3
            ;stop
          endif
          outmap=outmap_prefix
          spawn,"cp "+outmap_prefix+"_scandir1_inputmap.fits "+outmap+"_inputmap.fits"
          fakemap=readfits(outmap+"_inputmap.fits",inhdr)
          map00 = readfits(outmap+"_map00.fits",hdr)
          map20 = readfits(outmap+"_map20.fits",hdr)
          map00g = map00 ;hcongrid,map00,hdr,map00g,inhdr,outsize=size(fakemap,/dim),/half_half
          map20g = map20 ;hcongrid,map20,hdr,map20g,inhdr,outsize=size(fakemap,/dim),/half_half

          ;psd,fakemap,wavnum,fakeafter,/view
          ;oplot,wavnumsm,smbefore,color=250+256
          ;oplot,wavnumsm,smafter1,color=256L^2-200
          ;oplot,wavnumsm,smafter2,color=256^3-200

          resid00 = fakemap - map00g
          resid20 = fakemap - map20g

          writefits,outmap+"_simresid00.fits",resid00,hdr
          writefits,outmap+"_simresid20.fits",resid20,hdr

          bolocat_on_sims,outmap+"_map20.fits"

          ; do analysis:
          compare_images,outmap+"_scandir1",cuts='0.02,0.1,0.5',wcsaperture='--wcsaperture=0,0,800,1600',point=0,title=title,/samescale,vmin=-1,vmax=5
          compare_images,outmap+"_scandir2",cuts='0.02,0.1,0.5',wcsaperture='--wcsaperture=0,0,800,1600',point=0,title=title,/samescale,vmin=-1,vmax=5
          compare_images,outmap,cuts='0.02,0.1,0.5',wcsaperture='--wcsaperture=0,0,800,1600',point=0,title=title,/samescale,vmin=-1,vmax=5
        
          analyze_point_sources, fakemap, outmap+"_map20.fits", sources=sourcesOut_fakesky, outdir=outmap, analyzedSources = analyzedSources, noisemap=outmap+"_noisemap20.fits"

          if total(finite(map20,/nan)) gt 0 then map20[where(finite(map20,/nan))] = 0
          psd,fakemap,wavnum,inpower
          psd,map20  ,wavnum,outpower
          wavelength_arcsec = dimsize * pixsize * ( wavnum[0] / wavnum )
          power_ratio = outpower/inpower
          bins = [[20,30],[30,40],[40,50],[50,60],[60,80],[80,100],[100,150],[150,200],[200,250],[250,300],[300,350],[350,400]]
          outstr = string([realpower,imagpower,imagscale,peakamp,jj],format='(5F12.2)')
          for mm=0,n_elements(bins[0,*])-1 do begin
            bintotal = total( power_ratio[where((wavelength_arcsec ge bins[0,mm])*(wavelength_arcsec lt bins[1,mm]),ninbin)] )
            binavg = bintotal / ninbin
            outstr += string(binavg,format='(G12.2)')
          endfor
          printf,outf,outstr

          v2dir = repstr(outdir,"_v1","")
          v2fn = repstr(filename_prefix,'_v1','')
          compare_images,emptyplaceholder,prefix2=v2dir+v2fn,prefix1=outmap,suffix2="_map20.fits",suffix1="_map20.fits",$
               output_name=outdir+"compare_exp12_v1v2",in1='v1',in2='v2',/samescale,wcsaperture='--wcsaperture=0,0,1000,1500',cuts='2.0',vmin=-1,$
               vmax=5

          time_e,t0,prtmsg='####### Ending simulation with atmo amplitude number '+string(nn)+' peak number '+string(kk)+' power law number '+string(ii)+' seed number '+string(jj)+" and rms "+string(oo)
        endfor
      endfor
    endfor
  endfor
endfor
close,outf
free_lun,outf

end


  ; imshow(fftshift(abs((fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)*((xx+yy<511.5)*-1+(xx+yy>511.5))) + expfunc/1e2  )))))
  ; imshow((abs((fftshift(fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)*((xx+yy<511.5)*-1+(xx+yy>511.5))))) * abs(expfunc)  ))))
  ; imshow((abs((fftshift(fft2(((rr**-1.5) * randn(512,512) + ((rr/5.)**-1) * randn(512,512)*np.complex(0,1)))) * abs(expfunc)  ))))
