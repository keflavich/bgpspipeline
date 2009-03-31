pro map_iter,bgps,mapstr,smoothmap=smoothmap,fits_smooth=fits_smooth,deconvolve=deconvolve,i=i,niter=niter,model_sig=model_sig,fits_out=fits_out,dofits=dofits,_extra=_extra

    if n_e(deconvolve) eq 0 then deconvolve=0
    if n_e(fits_model) eq 0 then fits_model=1
    if n_e(fits_smooth) eq 0 then fits_smooth=1
    if n_e(model_sig) eq 0 then model_sig=1
    if n_e(fits_out) eq 0 then fits_out=[0,1,n_e(niter)-1]
    if total(fits_out eq i) ge 1 then dofits=1 else dofits=0

    hdr = mapstr.hdr
    fxaddpar,hdr,"iternum",i,"Iteration number"
    fxaddpar,hdr,"n_pca"  ,niter[i],"number of PCA components subtracted"
    outmap = mapstr.outmap

    bgps.scale_coeffs = relsens_cal(bgps.atmosphere,bgps.atmosphere,scans_info=bgps.scans_info,scalearr=scalearr)

    mapstr.astromap = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.astrosignal*scalearr,$
        weight=bgps.weight/scalearr,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
    if dofits then writefits,outmap+'_map'+string(i,format='(I2.2)')+'.fits',mapstr.astromap,hdr
    
    if keyword_set(fits_smooth) then begin
        finite_astromap = mapstr.astromap
        if total(finite(finite_astromap,/nan)) gt 0 then finite_astromap[where(finite(finite_astromap,/nan))] = 0
        convolved_map = convolve(finite_astromap,psf_gaussian(npix=19,ndim=2,fwhm=31.2/mapstr.pixsize,/norm))
        if dofits then writefits,outmap+'_smoothmap'+string(i,format='(I2.2)')+'.fits',convolved_map,hdr
    endif
    if keyword_set(deconvolve) then begin
        if n_e(convolved_map) eq n_e(mapstr.astromap) then mapstr.model = deconv_map(mapstr.astromap*(mapstr.astromap gt 0),smoothmap=convolved_map,_extra=_extra) $
            else mapstr.model = deconv_map(mapstr.astromap*(mapstr.astromap gt 0),_extra=_extra)
        mapstr.model *=  total( (mapstr.model-mean(mapstr.model,/nan)) * (mapstr.astromap-mean(mapstr.astromap,/nan)) ,/nan) / total( (mapstr.model-mean(mapstr.model,/nan))^2 ,/nan)
        if keyword_set(fits_model) and dofits then writefits,outmap+'_model'+string(i,format='(I2.2)')+'.fits',mapstr.model,hdr
    endif else mapstr.model = mapstr.astromap * (mapstr.astromap gt model_sig*mad(mapstr.astromap))

    ; chi2 calculations - to show convergence (these may be incorrect as of 8/25/08)
    chi2 = total(((bgps.astrosignal-mapstr.model[mapstr.ts])^2*bgps.weight),/nan) / n_e(bgps.astrosignal)
    print,"Chi2 for iteration "+strc(i)+" is "+strc(chi2) ;+" with "+strc(float(n_e(bgps.bolo_indices)-(niter[i]+1))*n_e(bgps.flags[0,*]))+" degrees of freedom"

    ; noisemap = raw - atmosphere - astrophysical
    dof = (float(n_e(bgps.bolo_indices)-(niter[i]+1))*n_e(bgps.flags[0,*]))
    mapstr.noisemap = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.noise,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra) 
    print,"Mean(noisemap): ",total(mapstr.noisemap,/nan)/float(total(finite(mapstr.noisemap)))," RMS(noisemap): ",stddev(mapstr.noisemap,/nan)," sum of noisemap^2: ",total(mapstr.noisemap^2,/nan)," with "+strc(n_e(mapstr.noisemap))+" d.o.f."
    print,"Mean(noise): ",total(bgps.noise,/nan)/float(total(finite(bgps.noise)))," RMS(noise): ",stddev(bgps.noise,/nan)," sum of noise^2: ",total(bgps.noise^2,/nan)," with "+strc(dof)+" d.o.f."
    if dofits then writefits,outmap+'_noisemap'+string(i,format='(I2.2)')+'.fits',mapstr.noisemap,hdr

    if (i eq 0 and bgps.n_obs gt 1) or keyword_set(force_flag) then begin
        bgps.flags = mad_flagger(bgps.astrosignal,mapstr.ts,bgps.flags,nsig=5,glitchloc=glitchloc) 
        bgps.glitchloc=glitchloc ; why can't procedures write information to structs?
        print,"NUMBER OF FLAGGED POINTS: ", total(bgps.flags gt 0), " OUT OF ",n_e(bgps.flags)," FRACTION: ",total(bgps.flags gt 0)/float(n_e(bgps.flags))
    endif
    if i eq 0 then writefits,outmap+'_flagmap.fits',ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.flags,weight=1,wtmap=1),hdr

    bgps.astrosignal = mapstr.model[mapstr.ts]

    return
end
