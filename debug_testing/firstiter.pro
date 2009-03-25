
minbaseline = 10
median_sky  = 0
niter       = [13]
i = 0
blank_map_size=size(blank_map,/dim)
best_astro_model = 0 ; Should be starting basically from scratch with the iterator

;;dc_bolos = 0         ;CLEANUP MEMORY
;;ac_bolos = 0         ;CLEANUP MEMORY
;;raw = 0              ;CLEANUP MEMORY
;noise_ts         = 0 ;fltarr(size(ac_bolos,/dim))
;
;atmos = raw_delined - best_astro_model 
;if total(flags) gt 0 then atmos[where(flags)] = !values.f_nan
;if keyword_set(boloflat) then atmos = bolo_flat(atmos)
;atmos_remainder = sky_subtraction_wrapper(atmos,minlen=minbaseline,bolo_params=bolo_params,flags=flags,median_sky=median_sky,_extra=extra)
;if total(finite(atmos_remainder,/nan)) gt 0 then atmos_remainder[where(finite(atmos_remainder,/nan))] = 0
;atmos_remainder = deline(atmos_remainder,sample_interval,throwawayvar)
;pca_subtract,atmos_remainder,niter[i],uncorr_part=new_astro
;new_astro = poly_sub_by_scans(new_astro,scans_info,flags=flags)
;new_astro = deline(new_astro,sample_interval,throwawayvar)
;best_astro_model += new_astro
;;        best_astro_model = poly_sub_by_scans(best_astro_model,scans_info,flags=flags)  ; is this worth trying?
;
;; MAPPING
;astromap = ts_to_map(blank_map_size,ts,best_astro_model[unflagged]*wt) / wt_map



clean_iter,best_astro_model=best_astro_model,raw_delined=raw_delined,atmos=atmos,niter=niter,flags=flags,$
    boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=i,$
    minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,$
    sample_interval=sample_interval,scans_info=scans_info,unflagged=unflagged,weight=weight,wt_map=wt_map,$
    ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap


