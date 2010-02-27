; size assumed to be arcseconds FWHM
pro smallmap_sim,amprange=amprange,sizerange=sizerange,nsamples=nsamples,amplitudes=amplitudes,sizes=sizes,$
    pixsize=pixsize,remap=remap,aperture=aperture,flux_in=flux_in,flux_out=flux_out,$
    flux_recov=flux_recov,outfile=outfile

    if ~keyword_set(pixsize) then pixsize=7.2
    if ~keyword_set(nsamples) then nsamples=10
    if keyword_set(amprange) and ~keyword_set(amplitudes) then begin
        if amprange[1] gt amprange[0] then amplitudes = findgen(nsamples)/(nsamples-1) * (amprange[1]-amprange[0]) + amprange[0]
        if amprange[1] eq amprange[0] then amplitudes = replicate(amprange[0],nsamples)
    endif else if keyword_set(amplitudes) then amprange=[min(amplitudes),max(amplitudes)]
    if keyword_set(sizerange) and ~keyword_set(sizes) then begin 
        if sizerange[1] gt sizerange[0] then sizes = findgen(nsamples)/(nsamples-1) * (sizerange[1]-sizerange[0]) + sizerange[0]
        if sizerange[1] eq sizerange[0] then sizes = replicate(sizerange[0],nsamples)
    endif else if keyword_set(sizes) then sizerange=[min(sizes),max(sizes)]
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
        suffix = string(sizes[ii], format="(I03)")+"arc"+string(amplitudes[ii],format="(F03.2)")+"V"
        strarr[ii] = getenv('WORKINGDIR')+'/simulations/smallmap/v1.0.2_1655p077_13pca_'+suffix

        if keyword_set(remap) then begin
            mem_iter,'/Volumes/disk3/adam_work/pointmaps_v1.0/1655p077_070708_ob9-0_13pca_mask_simstart.sav',$
                strarr[ii],workingdir=getenv('WORKINGDIR'),$
                /fromsave,fits_timestream=0,ts_map=0,niter=replicate(13,11),/deconvolve,/smallmap,/simulate_only,$
                meanamp=meanamp,srcsize=srcsize/pixsize/sqrt(8*alog(2))
        endif

        inmap  = readfits(strarr[ii]+"_initial.fits")
        outmap = readfits(strarr[ii]+"_map10.fits")
        mapsize = size(outmap,/dim)
        xcen[ii] = mapsize[0]/2.0
        ycen[ii] = mapsize[1]/2.0

        flux_in[ii]  = measure_box(inmap,xcen[ii],ycen[ii],sizes,sizes,/ellipse,aperture=aperture)
        flux_out[ii] = measure_box(outmap,xcen[ii],ycen[ii],sizes,sizes,/ellipse,aperture=aperture)
        flux_recov[ii] = flux_out/flux_in

    endfor

    if ~keyword_set(outfile) then outfile=getenv('WORKINGDIR')+'/simulations/smallmap/v1.0.2_1655p077_13pca_amp'+$
        strjoin(string(amprange,format="(I03)"),"-")+"size"+strjoin(string(sizerange,format="(I03)"),"-")
    save,filename=outfile
end
