
; poly_sub_by_scans
; simply applies poly_sub to each scan given by scan info in a timestream
function poly_sub_by_scans,timestream,scans_info,flags=flags,polysub_order=polysub_order
    nscans = n_e(scans_info[0,*])
    nbolos = n_e(timestream[*,0])
    temp = timestream
    if ~keyword_set(polysub_order) then polysub_order = 5
    if ~keyword_set(nsigmareject) then nsigmareject = 3
    time_s,"Flatfielding (polynomial subtraction) with polysub_order "+strc(polysub_order)+" ...",t0
    if total(flags) gt 0 then timestream[where(flags)] = !values.f_nan
    for s=0,nscans-1 do begin
        lb = scans_info[0,s]
        ub = scans_info[1,s]
        for b=0,nbolos-1 do begin
;            temp[b,lb:ub] = poly_sub(temp[b,lb:ub],sigmareject=1,iterate_sigmareject=1,polysub_order=2)  ; old version: use sigma-rejection and a line fit
            temp[b,lb:ub] = poly_sub(temp[b,lb:ub],sigmareject=nsigmareject,$
                iterate_sigmareject=nsigmareject,order=polysub_order)  
            ; new version (8/11/08): I think a higher polysub_order polynomial will work better: it won't take out sources
            ; but it does better at fitting out exponent_sub residuals
            ; the worry is that it might pick up bright sources and fit those: the 2-sigma rejection works in 
            ; at least some fields to mitigate this effect
        endfor
    endfor
;    if total(flags) gt 0 then timestream[where(flags)] = temp[where(flags)]  
        ; replace flagged values with original values.... for no good reason
    time_e,t0
    return,temp
end


