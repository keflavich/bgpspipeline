; size assumed to be arcseconds FWHM
pro smallmap_sim,amprange=amprange,sizerange=sizerange,nsamples=nsamples,amplitudes=amplitudes,sizes=sizes,$
    pixsize=pixsize,remap=remap,aperture=aperture,flux_in=flux_in,flux_out=flux_out,$
    flux_recov=flux_recov,outfile=outfile,unit=unit,marspsf=marspsf,jitter=jitter,$
    _extra=_extra

    if ~keyword_set(unit) then unit="Jy"  ; else could be "V"
    if ~keyword_set(pixsize) then pixsize=7.2
    if ~keyword_set(nsamples) then if keyword_set(amplitudes) then nsamples=n_e(amplitudes) else if keyword_set(sizes) then nsamples=n_e(sizes) else nsamples=10
    if keyword_set(amprange) and ~keyword_set(amplitudes) then begin
        if amprange[1] gt amprange[0] then amplitudes = findgen(nsamples)/(nsamples-1) * (amprange[1]-amprange[0]) + amprange[0]
        if amprange[1] eq amprange[0] then amplitudes = replicate(amprange[0],nsamples)
    endif else if keyword_set(amplitudes) then begin
        amprange=[min(amplitudes),max(amplitudes)]
    endif
    if keyword_set(sizerange) and ~keyword_set(sizes) then begin 
        if sizerange[1] gt sizerange[0] then sizes = findgen(nsamples)/(nsamples-1) * (sizerange[1]-sizerange[0]) + sizerange[0]
        if sizerange[1] eq sizerange[0] then sizes = replicate(sizerange[0],nsamples)
    endif else if keyword_set(sizes) then begin
        sizerange=[min(sizes),max(sizes)]
    endif
    ;if keyword_set(aprange) and ~keyword_set(apertures) then begin 
    ;    if aprange[1] gt aprange[0] then apertures = findgen(nsamples)/(nsamples-1) * (aprange[1]-aprange[0]) + aprange[0]
    ;    if aprange[1] eq aprange[0] then apertures = replicate(aprange[0],nsamples)
    ;endif else if keyword_set(apertures) then aprange=[min(apertures),max(apertures)]

    filelist = strarr(nsamples)
    xcen = fltarr(nsamples)
    ycen = fltarr(nsamples)
    flux_in = fltarr(nsamples)
    flux_out = fltarr(nsamples)
    flux_recov = fltarr(nsamples)

    for ii=0,(nsamples-1) do begin
        suffix = string(sizes[ii], format="(I03)")+"arc"+string(amplitudes[ii],format="(F06.1)")+unit
        if keyword_set(marspsf) then suffix = suffix+"_marspsf"
        if keyword_set(jitter) then suffix = suffix+"_jitter"
        filelist[ii] = getenv('WORKINGDIR')+'/simulations/smallmap/1730-130_nrao530050710_ob5-6_13pca_'+unit+"_"+suffix

        if keyword_set(remap) then begin
            mem_iter,'/Volumes/disk3/adam_work/pointmaps_v1.0/1730-130_nrao530050710_ob5-6_13pca_'+unit+'_simstart.sav',$
                filelist[ii],workingdir=getenv('WORKINGDIR'),$
                /fromsave,fits_timestream=0,ts_map=0,niter=replicate(13,11),/deconvolve,/smallmap,/simulate_only,$
                meanamp=amplitudes[ii],srcsize=sizes[ii]/pixsize/sqrt(8*alog(2)),marspsf=marspsf,jitter=jitter,$
                _extra=_extra
        endif

        inmap  = readfits(filelist[ii]+"_sim_initial.fits",/silent)
        outmap = readfits(filelist[ii]+"_sim_map10.fits",/silent)
        mapsize = size(outmap,/dim)
        xcen[ii] = mapsize[0]/2.0
        ycen[ii] = mapsize[1]/2.0

        flux_in[ii]  = measure_box(inmap,xcen[ii],ycen[ii],sizes,sizes,/ellipse,aperture=aperture/7.2)
        flux_out[ii] = measure_box(outmap,xcen[ii],ycen[ii],sizes,sizes,/ellipse,aperture=aperture/7.2)
        flux_recov[ii] = flux_out[ii]/flux_in[ii]

    endfor

    if ~keyword_set(outfile) then outfile=getenv('WORKINGDIR')+'/simulations/smallmap/1730-130_nrao530050710_ob5-6_13pca_'+unit+'_amp'+$
        strjoin(string(amprange,format="(I03)"),"-")+"size"+strjoin(string(sizerange,format="(I03)"),"-")+unit+".sav"
    save,filename=outfile
end
