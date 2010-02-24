; do_sky_subtraction is an obsolete wrapper for the sky subtractio algorithm I made...
pro do_sky_subtraction,filelist,minlen=minlen,iternum=iternum,dosmooth=dosmooth,median_sky=median_sky,doplotting=doplotting
    if keyword_set(iternum) and keyword_set(minlen) then print,"Beginning sky subtraction for iteration "+strc(iternum)+" with minimum baseline "+strc(minlen)
    for i=0,n_elements(filelist)-1 do begin
        filename = filelist[i]
        baseline_wrapper,filename,outfilename=filename,varname='raw',outvarname='ac_bolos',minlen=minlen,atmos_model=atmos_model,median_sky=median_sky
        ncdf_new_variable,filename,'atmos_model',atmos_model,['time']

        if keyword_set(doplotting) then compare_mean_psds,filename
    endfor
end

;   pro do_sky_subtraction,filelist,minlen=minlen,iternum=iternum,dosmooth=dosmooth,median_sky=median_sky
;       if keyword_set(iternum) and keyword_set(minlen) then print,"Beginning sky subtraction for iteration "+strc(iternum)+" with minimum baseline "+strc(minlen)
;       for i=0,n_elements(filelist)-1 do begin
;           filename = filelist[i]
;   ;        ncdf_varget_scale,filename,'ac_bolos',acb
;   ;        ncdf_varget_scale, filename, 'flags',flags
;           read_ncdf_vars,filename,flags=flags,ac_bolos=acb,bolo_params=bp,raw=raw
;           acb_nonan = acb
;           acb[where(flags)] = !values.f_nan
;           acb[where(1-bp[0,*]),*] = !values.f_nan
;           if iternum eq 0 or ~keyword_set(dosmooth) then begin
;               if keyword_set(median_sky) then $
;                   atm_model = ave_baseline(file=filename,array=acb,varname='ac_bolos',minlen=minlen) $
;                   else atm_model = median(acb,dimension=1)
;               new_ts = acb_nonan
;           endif else begin
;               print,"BEGINNING ITERATION "+strc(iternum)+" FOR 'SMOOTHED' TIMESTREAM (MAP2TSed TIMESTREAM)"
;               bpairs = bolopairs(filename,minlen=minlen)
;   ;            ncdf_varget_scale,filename,'raw',raw
;               raw[where(flags)] = !values.f_nan
;               source_sub = raw - acb
;               atm_model = ave_baseline(array=source_sub,bpairs=bpairs,minlen=minlen)
;               new_ts = raw
;           endelse
;           skm_rebin = rebin(transpose(atm_model),size(acb,/dim)) 
;           scalefactor = rebin(( total(skm_rebin * new_ts,2,/nan) / total(atm_model*atm_model,/nan) ),size(acb,/dim))
;           atmmod_scaled = skm_rebin * scalefactor
;           astro_model = new_ts - atmmod_scaled
;           ncdf_new_variable, filename, 'atmos_model', atmmod_scaled, ['bolodim','time'], attribute="Minimum Baseline: "+strc(minlen)
;           if iternum eq 0 then ncdf_new_variable, filename, 'raw', acb, ['bolodim','time'] ; don't rewrite raw
;           ncdf_varput_scale, filename, 'ac_bolos', astro_model
;       endfor
;   end
;   

