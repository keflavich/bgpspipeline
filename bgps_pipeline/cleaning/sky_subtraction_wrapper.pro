; the currently used sky subtraction wrapper
; ac_bolos should be the NCDF ac_bolos variable, maybe processed by flagging etc.
; minlen is important to specify as the minimum baseline length to subtract
; however, you can use /median_sky to ignore this parameter and just subtract the median straight up
function sky_subtraction_wrapper,ac_bolos,minlen=minlen,bolo_params=bolo_params,flags=flags,median_sky=median_sky,_extra=extra
    ac_copy = ac_bolos
    if n_e(minlen) eq 0 then minlen = 0
    if minlen gt 5 and ~keyword_set(median_sky) then begin
        time_s,"BEGINNING SKY SUBTRACTION WITH BASELINE LENGTH "+strc(minlen)+"... ",t0 
        bpairs = bolopairs(minlen=minlen,bolo_params=bolo_params,_extra=extra)
        atmos_model = ave_baseline(bpairs=bpairs,flags=flags,array=ac_copy) 
    endif else begin 
        time_s,"SKY SUBTRACTION - MEDIAN",t0
        median_atmos_model = median(ac_copy,dim=1)
        atmos_model = median_atmos_model 
    endelse 
;    if max(atmos_model) gt stddev(atmos_model)*5 then begin   ; this is a hack because sometimes there are huge excesses at the first/last points that throw off the scaling
;        high_points = where(atmos_model gt stddev(atmos_model)*5)
;        atmos_model[high_points] = median_atmos_model[high_points]
;    endif
    ac_copy = skysubtract(ac_bolos,atmos_model)
    time_e,t0
    return,ac_copy
end

