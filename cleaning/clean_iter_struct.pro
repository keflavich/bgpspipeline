; clean_iter was originally integrated into the overall wrapper
; but it started getting bloated with lots of extra output stuff, and it was making the big iterator tough to read
; so I pulled it out
; also, sometimes I need to do the cleaning without the mapping etc. (e.g. in psd_flag_and_clean)
; CLEAN_ITER DOES:
;     1. MAKE ATMOSPHERE FROM RAW - bgps.astrosignal
;     2. SKY SUBTRACT ATMOS
;XX     3. DELINE #2
;     4. PCA SUBTRACT #3
;     5. POLYNOMIAL SUBTRACT #4
;XX     6. DELINE #5
;     7. ADD #6 TO bgps.astrosignal
; some of the above are optional:
;     #2 - if /median_sky set, will do a median subtraction
;     #4 - if niter[i] = 0, will be skipped
; MANY things can be output:
;     /fits_nopca - a map of #3 will be made as [prefix]_nopca[i].fits
;     /fits_timestream - a fits file of the timestream (#7) will be made as [prefix]_timestream[i].fits
;     /fits_psd        - a fits file of 3 views of the psd_psd will be made as [prefix]_pca_[pca_type][i].fits
pro clean_iter_struct,bgps,mapstr,niter=niter,$
    boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=i,$
    pca_atmo=pca_atmo,new_astro=new_astro,first_sky=first_sky,atmos_remainder=atmos_remainder,astrosignal_premap=astrosignal_premap,$
    minbaseline=minbaseline,median_sky=median_sky,fits_remainder=fits_remainder,$
    outmap=outmap,do_weight=do_weight,no_polysub=no_polysub,plot_all_timestreams=plot_all_timestreams,_extra=_extra

    if n_e(do_weight) eq 0 then do_weight=1
    if n_e(fits_timestream) eq 0 and bgps.n_obs eq 1 then fits_timestream=1 else fits_timestream=0

    ; set up header first
    sxaddpar,mapstr.hdr,'iternum',i
    sxaddpar,mapstr.hdr,'n_pca',niter[i]
    hdr = mapstr.hdr
    outmap = mapstr.outmap

    bgps.atmosphere = bgps.ac_bolos - bgps.astrosignal 
    if total(bgps.flags) gt 0 then bgps.atmosphere[where(bgps.flags)] = !values.f_nan

    ; atmos_remainder is what is left over after the 'atmosphere' is median subtracted
    atmos_remainder = sky_subtraction_wrapper(bgps.atmosphere,minlen=minbaseline,bolo_params=bgps.bolo_params,$
        flags=bgps.flags,median_sky=median_sky,_extra=_extra) 
    ; first_sky is the median of bgps.atmosphere; it's the first attempt at atmosphere estimation
    first_sky = bgps.atmosphere-atmos_remainder
    if total(finite(atmos_remainder,/nan)) gt 0 then atmos_remainder[where(finite(atmos_remainder,/nan))] = 0
;    atmos_remainder = deline(atmos_remainder,bgps.sample_interval,bgps.scans_info,/flat) 
    if keyword_set(fits_nopca) then begin
        atrem_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,atmos_remainder,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
        writefits,outmap+"_nopcamap"+string(i,format='(I2.2)')+".fits",atrem_map,hdr
    endif

    ; PCA SUBTRACTION
    if niter[i] gt 0 then begin
        pca_subtract,atmos_remainder,niter[i],uncorr_part=new_astro,corr_part=pca_atmo 
        ; the median atmosphere + the PCA atmosphere = new atmosphere.  Used in relsens_cal / scale coefficient calculation
        bgps.atmosphere = first_sky+pca_atmo 
    endif else begin
        new_astro = atmos_remainder
        bgps.atmosphere = first_sky
    endelse


    if ~keyword_set(no_polysub) then new_astro = poly_sub_by_scans(new_astro,bgps.scans_info,flags=bgps.flags,_extra=_extra)
    if keyword_set(fits_remainder) then begin
        atrem_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,atmos_remainder,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
        writefits,outmap+"_remainder"+string(i,format='(I2.2)')+".fits",atrem_map,hdr
    endif

    if keyword_set(boloflat) then new_astro = bolo_flat(new_astro)

    bgps.astrosignal += new_astro
    if keyword_set(fits_timestream) and i eq 0 then begin
        nan_arr = fltarr(size(bgps.flags,/dim))
        if size(where(bgps.flags),/dim) gt 0 then nan_arr[where(bgps.flags)] = !values.f_nan
        writefits,outmap+"_timestream"+string(i,format='(I2.2)')+".fits",reshape_timestream(bgps.astrosignal,bgps.scans_info),hdr
    endif
    if keyword_set(fits_psd) then begin
        psd_psd = all_psds(bgps.astrosignal,bgps.scans_info,flags=bgps.flags,bolo_params=bgps.bolo_params,sample_interval=bgps.sample_interval)   
        writefits,outmap+"_psd_avebolo"+string(i,format='(I2.2)')+".fits",total(psd_psd,1)/n_e(psd_psd[0,*]),hdr
        writefits,outmap+"_psd_avescan"+string(i,format='(I2.2)')+".fits",total(psd_psd,2)/n_e(psd_psd[1,*]),hdr
        writefits,outmap+"_psd_3rddim"+string(i,format='(I2.2)')+".fits",total(psd_psd,3)/n_e(psd_psd[2,*]),hdr
    endif

    astrosignal_premap = bgps.astrosignal

    map_iter,bgps,mapstr,fits_smooth=fits_smooth,i=i,niter=niter,dofits=dofits,_extra=_extra
    if niter[i] gt 0 then bgps.noise = nantozero( bgps.ac_bolos - first_sky - pca_atmo - bgps.astrosignal ) $ 
        else  bgps.noise = nantozero( bgps.ac_bolos - first_sky - bgps.astrosignal )
    if keyword_set(do_weight) then begin
        bgps.weight = psd_weight(bgps.noise,bgps.scans_info,bgps.sample_interval,wt2d=wt2d,var=var2d)
        bgps.wt2d=wt2d & bgps.var2d = var2d ; have to do this b/c passing structs to a function doesn't work
        if max(bgps.flags) gt 0 then bgps.weight[where(bgps.flags)] = 0
        mapstr.wt_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.weight,wtmap=1,weight=1) ; use a normal drizzle
        if dofits then writefits,outmap+"_weightmap"+string(i,format='(I2.2)')+".fits",mapstr.wt_map,hdr
    endif else begin ; uniform weighting
        bgps.weight[*] = 1
        bgps.wt2d[*] = 1
        bgps.var2d[*] = 1
        if max(bgps.flags) gt 0 then bgps.weight[where(bgps.flags)] = 0
        mapstr.wt_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.weight,wtmap=1,weight=1) ; use a normal drizzle
    endelse

    if keyword_set(plot_all_timestreams) then begin
        set_plot,'ps'
        for kk=min(plot_all_timestreams),max(plot_all_timestreams) do begin 
            lb = bgps.scans_info[0,kk]
            ub = bgps.scans_info[1,kk]
            for jj=0,3 do begin
                device,filename=mapstr.outmap+"timestream"+string(kk,format='(I3.3)')+"_plots_"+string(i,format='(I2.2)')+"_bolo"+string(jj,format='(I2.2)')+".ps",/encapsulated,bits=16,/color
                loadct,39
                !P.MULTI=[0,1,2]
                plot,first_sky[jj,lb:ub]
                oplot,bgps.ac_bolos[jj,lb:ub],color=250
                oplot,new_astro[jj,lb:ub],color=50
                oplot,bgps.astrosignal[jj,lb:ub],color=200
                legend,['ac_bolos','first_sky','new_astro','astrosignal'],linestyle=[0,0,0,0],color=[250,0,50,200],/right,/top ;,/right
                plot,atmos_remainder[jj,lb:ub],yrange=[-1,3],/ys,title="bolo "+string(jj,format='(I2.2)')+" scan "+string(kk,format='(I3.3)')
                oplot,new_astro[jj,lb:ub],color=50
                oplot,pca_atmo[jj,lb:ub],color=250
                oplot,bgps.astrosignal[jj,lb:ub],color=200
                oplot,bgps.noise[jj,lb:ub],color=175
                legend,['pca_atmo','atmos_remainder','noise'],color=[250,0,175],/right,/top,linestyle=[0,0,0] ;,/right
                device,/close_file
            endfor
        endfor
        set_plot,'x'
    endif
end
