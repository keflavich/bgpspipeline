

pro psd_flag_and_clean,best_astro_model=best_astro_model,raw_delined=raw_delined,atmos=atmos,niter=niter,flags=flags,$     
    boloflat=boloflat,fits_timestream=fits_timestream,fits_nopca=fits_nopca,fits_psd=fits_psd,i=i,$               
    minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,$
    sample_interval=sample_interval,scans_info=scans_info,unflagged=unflagged,weight=weight,wt_map=wt_map,$
    ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap,logfile=logfile,_extra=_extra

    
    clean_iter,best_astro_model=best_astro_model,raw_delined=raw_delined,atmos=atmos,niter=niter,flags=flags,$     
    boloflat=boloflat,i=i,$               
    minbaseline=minbaseline,median_sky=median_sky,bolo_params=bolo_params,psd_psd=psd_psd,$
    sample_interval=sample_interval,scans_info=scans_info,unflagged=unflagged,weight=weight,wt_map=wt_map,$
    ts=ts,hdr=hdr,blank_map_size=blank_map_size,outmap=outmap,_extra=_extra
    
    psd_psd = all_psds(best_astro_model,scans_info,flags=flags,bolo_params=bolo_params,sample_interval=sample_interval)   
    psd_flag_projection,psd_avescan=reform(median(psd_psd,dim=2)),bad_bolos=bad_bolos
    psd_flag_projection_by_scan,psd_psd=psd_psd,flags=flags,scans_info=scans_info
    flags[bad_bolos,*] = 3  ; bad bolometers from psd flagging will be marked by 3

    ; run deglitching on cleaned timestream
;    temp_to_ignore = deglitch_flags(best_astro_model,goodmask_to_ignore,flags=flags,/quiet,/no_interpolate,sigma=5,step=3000) ; 3 Jy   step=3000,
;    print,"Deglitching flagged ",n_e(where(flags eq 2))," points"
;    printf,logfile,"Deglitching flagged ",n_e(where(flags eq 2))," points"

    if total(flags) gt 0 then raw_delined[where(flags)] = !values.f_nan 
    print,"RAW_DELINED has "+strc(total(finite(raw_delined,/nan)))+" NAN points, which is "+strc(total(finite(raw_delined,/nan))/n_e(raw_delined))+" of total after PSD flagging"
    printf,logfile,"RAW_DELINED has "+strc(total(finite(raw_delined,/nan)))+" NAN points, which is "+strc(total(finite(raw_delined,/nan))/n_e(raw_delined))+" of total after PSD flagging"

end
