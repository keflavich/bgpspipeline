; OBSOLETE CODE!!!
; baseline wrapper
;   will do the whole baseline model calculation/subtraction
;   INPUT:
;       filename    - required, the input file name
;       outfilename - file to write to.  If not specified, will overwrite FILENAME
;       varname     - NCDF variable to use for sky calculation.  Defaults to 'ac_bolos'
;       outvarname  - output variable to put sky-subtracted data into.  If not specified, defaults to VARNAME
;       bpairs      - Can specify bolometer pairs as a 2xN array of bolometer numbers.  If not specified, 
;                     will be calculated by "bolopairs.pro"
;       minlen,maxlen - input variables for bolopairs if BPAIRS not given as an input value
pro baseline_wrapper,filename,outfilename=outfilename,varname=varname,bpairs=bpairs,outvarname=outvarname,minlen=minlen,maxlen=maxlen,atmos_model=atmos_model,median_sky=median_sky
    if ~keyword_set(varname) then varname='ac_bolos'
    if n_e(minlen) eq 0 then minlen = 0
    ncdf_varget_scale,filename,varname,timestream 
    ncdf_varget_scale,filename,'flags',flags
    ncdf_varget_scale,filename,'bolo_params',bolo_params
    if ~keyword_set(bpairs) and minlen ne 0 then begin
        if ~(keyword_set(minlen) or keyword_set(maxlen)) then print,"WARNING: No min/max length specified"
        if minlen gt 5 then bpairs = bolopairs(file=file,minlen=minlen,maxlen=maxlen,bolo_params=bolo_params) $
            else print,"Minimum baseline too short.  Will not calculate baselines."
    endif
    
    median_atmos_model = median(timestream,dim=1)
    if keyword_set(median_sky) or minlen eq 0 then atmos_model = median_atmos_model $
       else atmos_model = ave_baseline(bpairs=bpairs,flags=flags,array=timestream) 

;    if max(atmos_model) gt stddev(atmos_model)*5 then begin   ; this is a hack because sometimes there are huge excesses at the first/last points that throw off the scaling
;        high_points = where(atmos_model gt stddev(atmos_model)*5)
;        atmos_model[high_points] = median_atmos_model[high_points]
;    endif
    
    acb_skysubtracted = skysubtract(timestream,atmos_model)

;    if ~keyword_set(outfilename) then outfilename = filename   ; am I seriously overwriting variables?  WHAT?!
;    if ~keyword_set(outvarname) then outvarname = varname
;    ncdf_varput_scale,filename,outvarname,acb_skysubtracted
end


