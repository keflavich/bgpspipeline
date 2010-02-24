; clean_iter was originally integrated into the overall wrapper
; but it started getting bloated with lots of extra output stuff, and it was making the big iterator tough to read
; so I pulled it out
; also, sometimes I need to do the cleaning without the mapping etc. (e.g. in psd_flag_and_clean)
; CLEAN_ITER DOES:
;     1. MAKE ATMOSPHERE FROM RAW - BEST_ASTRO_MODEL
;     2. SKY SUBTRACT ATMOS
;     3. DELINE #2
;     4. PCA SUBTRACT #3
;     5. POLYNOMIAL SUBTRACT #4
;     6. DELINE #5
;     7. ADD #6 TO BEST_ASTRO_MODEL
; some of the above are optional:
;     #2 - if /median_sky set, will do a median subtraction
;     #4 - if niter[i] = 0, will be skipped
; MANY things can be output:
;     /fits_nopca - a map of #3 will be made as [prefix]_nopca[i].fits
;     /fits_timestream - a fits file of the timestream (#7) will be made as [prefix]_timestream[i].fits
;     /fits_psd        - a fits file of 3 views of the psd_psd will be made as [prefix]_pca_[pca_type][i].fits
pro clean_iter,best_astro_model=best_astro_model,raw_delined=raw_delined,atmos=atmos,niter=niter,flags=flags,$
    boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=i,$
    minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,$
    sample_interval=sample_interval,scans_info=scans_info,weight=weight,wt_map=wt_map,fits_remainder=fits_remainder,$
    dontdeline=dontdeline,dontskysub=dontskysub,nopolysub=nopolysub,noise_ts=noise_ts,$
    ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap,do_weight=do_weight,_extra=_extra

    if n_e(do_weight) eq 0 then do_weight=1

    ; set up header first
    sxaddpar,hdr,'iternum',i
    sxaddpar,hdr,'n_pca',niter[i]

    atmos = raw_delined - best_astro_model 
    if total(flags) gt 0 then atmos[where(flags)] = !values.f_nan
    if keyword_set(boloflat) then atmos = bolo_flat(atmos)
    if ~keyword_set(dontskysub) then atmos_remainder = sky_subtraction_wrapper(atmos,minlen=minbaseline,bolo_params=bolo_params,flags=flags,median_sky=median_sky,_extra=_extra) $
        else atmos_remainder = atmos
    first_sky = atmos-atmos_remainder
    if total(finite(atmos_remainder,/nan)) gt 0 then atmos_remainder[where(finite(atmos_remainder,/nan))] = 0
    if ~keyword_set(dontdeline) then atmos_remainder = deline(atmos_remainder,sample_interval,scans_info,/flat) 
    if keyword_set(fits_nopca) then begin
        atrem_map = ts_to_map(blank_map_size,ts,atmos_remainder*weight) / wt_map
        writefits,outmap+"_nopcamap"+string(i,format='(I2.2)')+".fits",atrem_map,hdr
    endif
    if niter[i] gt 0 then pca_subtract,atmos_remainder,niter[i],uncorr_part=new_astro,corr_part=pca_atmo $
                     else new_astro = atmos_remainder
    if ~keyword_set(dontdeline) then new_astro = deline(new_astro,sample_interval,scans_info,/flat)
    if ~keyword_set(nopolysub) then new_astro = poly_sub_by_scans(new_astro,scans_info,flags=flags)
    if keyword_set(fits_remainder) then begin
        atrem_map = ts_to_map(blank_map_size,ts,atmos_remainder*weight) / wt_map
        writefits,outmap+"_remainder"+string(i,format='(I2.2)')+".fits",atrem_map,hdr
    endif
    best_astro_model += new_astro
    if keyword_set(fits_timestream) and i eq 0 then begin
        nan_arr = fltarr(size(flags,/dim))
        if size(where(flags),/dim) gt 0 then nan_arr[where(flags)] = !values.f_nan
;        writefits,outmap+"_timestream"+string(i,format='(I2.2)')+".fits",reshape_timestream(best_astro_model + nan_arr,scans_info),hdr
;        writefits,outmap+"_timestream"+string(i,format='(I2.2)')+".fits",reform(best_astro_model,nbolos,ntime/nscans,nscans),hdr
        writefits,outmap+"_timestream"+string(i,format='(I2.2)')+".fits",reshape_timestream(best_astro_model,scans_info),hdr
    endif
    if keyword_set(fits_psd) then begin
        psd_psd = all_psds(best_astro_model,scans_info,flags=flags,bolo_params=bolo_params,sample_interval=sample_interval)   
        writefits,outmap+"_psd_avebolo"+string(i,format='(I2.2)')+".fits",total(psd_psd,1)/n_e(psd_psd[0,*]),hdr
        writefits,outmap+"_psd_avescan"+string(i,format='(I2.2)')+".fits",total(psd_psd,2)/n_e(psd_psd[1,*]),hdr
        writefits,outmap+"_psd_3rddim"+string(i,format='(I2.2)')+".fits",total(psd_psd,3)/n_e(psd_psd[2,*]),hdr
    endif
    if niter[i] gt 0 then noise_ts = raw_delined - first_sky - pca_atmo - best_astro_model $ 
        else  noise_ts = raw_delined - first_sky - best_astro_model 
;        best_astro_model = poly_sub_by_scans(best_astro_model,scans_info,flags=flags)  ; is this worth trying? my answer has been no
    if keyword_set(do_weight) then begin
        weight = psd_weight(noise_ts,scans_info,sample_interval,wt2d=wt2d,var=var)
        if max(flags) gt 0 then weight[where(flags)] = 0
        wt_map = ts_to_map(blank_map_size,ts,weight)
        writefits,outmap+"_weightmap"+string(i,format='(I2.2)')+".fits",wt_map,hdr
    endif
end
