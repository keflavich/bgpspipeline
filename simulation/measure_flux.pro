; measure flux recovery in known sources
; example:
; measure_flux,'v0.7_l111_13pca_deconv_21.6_sim_sim_sources.sav','v0.7_l111_13pca_deconv_21.6_sim_map20.fits','v0.7_l111_13pca_deconv_21.6_sim_initial.fits'
; measure_flux,'v1.0.2_ic1396_13pca_deconv_sim_sim_sources.sav','v1.0.2_ic1396_13pca_deconv_sim_map20.fits','v1.0.2_ic1396_13pca_deconv_sim_initial.fits'
pro measure_flux,savefile,fitsfile,simmapfile,flux_recov=flux_recov,flux_input=flux_input,$
    doplot=doplot,overplot=overplot,dostop=dostop,xax=xax,yax=yax,domedian=domedian,_extra=_extra

    map=readfits(fitsfile)
    simmap=readfits(simmapfile)

    restore,savefile
    numsrc=n_e(xwidth)
    flux_input = dblarr(numsrc)
    flux_recov = dblarr(numsrc)

    for i=0,numsrc-1 do begin
        flux_recov[i] = measure_box(map,xcen[i],ycen[i],xwidth[i],ywidth[i],/ellipse)
        flux_input[i] = measure_box(simmap,xcen[i],ycen[i],xwidth[i],ywidth[i],/ellipse)
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
        if ~keyword_set(domedian) then begin
            fluxrecov_uniq[i] = max(flux_recov[ind])
            throwaway = min(abs(flux_recov[ind]-max(flux_recov[ind])),wheremedian)
        endif else begin
            fluxrecov_uniq[i] = median(flux_recov[ind])
            throwaway = min(abs(flux_recov[ind]-median(flux_recov[ind])),wheremedian)
        endelse
        fluxinput_uniq[i] = (flux_input[ind])[wheremedian]
    endfor

    xax=xwidth[0:n_e(fluxrecov_uniq)-1]*7.2
    yax=fluxrecov_uniq/fluxinput_uniq

    if keyword_set(doplot) then begin
        if keyword_set(overplot) then $
            oplot,xax,yax,psym=1,_extra=_extra $
            else $
            plot,xax,yax,psym=1,_extra=_extra
    endif

    if keyword_set(dostop) then stop

end

