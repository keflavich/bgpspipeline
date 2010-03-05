; measure flux recovery in known sources
; example:
; measure_flux,'v0.7_l111_13pca_deconv_21.6_sim_sim_sources.sav','v0.7_l111_13pca_deconv_21.6_sim_map20.fits','v0.7_l111_13pca_deconv_21.6_sim_initial.fits'
; measure_flux,'v1.0.2_ic1396_13pca_deconv_sim_sim_sources.sav','v1.0.2_ic1396_13pca_deconv_sim_map20.fits','v1.0.2_ic1396_13pca_deconv_sim_initial.fits'
pro measure_flux,savefile,fitsfile,simmapfile,flux_recov=flux_recov,flux_input=flux_input,$
    doplot=doplot,overplot=overplot,dostop=dostop,xax=xax,yax=yax,drange=drange,$
    aperture=aperture,outfile=outfile,_extra=_extra

    ; aperture is a RADIUS
    if keyword_set(aperture) then begin 
        drange = 0 
    endif else begin
        if ~keyword_set(drange) then drange = 2.0 ; go out to 2 sigma RADIUS by default
    endelse


    map=readfits(fitsfile)
    simmap=readfits(simmapfile)
    whnan = where(finite(map,/nan),nnan)
    if nnan gt 0 then simmap[whnan] = !values.f_nan

    restore,savefile
    numsrc=n_e(xwidth)
    flux_input = dblarr(numsrc)
    flux_recov = dblarr(numsrc)

    for i=0,numsrc-1 do begin
        flux_recov[i] = measure_box(map,xcen[i],ycen[i],xwidth[i],ywidth[i],/ellipse,aperture=aperture,drange=drange)
        flux_input[i] = measure_box(simmap,xcen[i],ycen[i],xwidth[i],ywidth[i],/ellipse,aperture=aperture,drange=drange)
    endfor

    xsort = sort(xwidth)
    unique = uniq(xwidth[xsort])
    size_uniq = xwidth[unique]
    fluxrecov_uniq = dblarr(n_e(unique))
    fluxinput_uniq = dblarr(n_e(unique))
    low = 0
    for i=0,n_e(unique)-1 do begin
        ind = xsort[low:unique[i]]
        low = unique[i]
        fluxrecov_uniq[i] = median(flux_recov[ind])
        throwaway = min(abs(flux_recov[ind]-median(flux_recov[ind])),wheremedian)
        fluxinput_uniq[i] = (flux_input[ind])[wheremedian]
    endfor

    xax=xwidth[0:n_e(fluxrecov_uniq)-1]*7.2*sqrt(8*alog(2))
    yax=fluxrecov_uniq/fluxinput_uniq

    if keyword_set(doplot) then begin
        if keyword_set(overplot) then $
            oplot,xax,yax,psym=1,_extra=_extra $
            else $
            plot,xax,yax,psym=1,_extra=_extra
    endif

    if ~keyword_set(outfile) then outfile = strjoin(strsplit(savefile,'sources',/regex,/extract,/preserve_null),'measurements')
    save,filename=outfile

    if keyword_set(dostop) then stop

end

