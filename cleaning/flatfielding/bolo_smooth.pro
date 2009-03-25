function bolo_smooth,timestream,_extra=_extra
    scanlength = n_e(timestream[0,*])
    n_bolos    = n_e(timestream[*,0])
    if n_e(timestream) eq total(finite(timestream,/nan)) then return,timestream ; NAN handling

    savgolfilt = savgol(2,2,0,2)         ; smooth-timestream filter
    ts_smoothed = fltarr([n_bolos,scanlength])
    for i=0,n_bolos-1 do begin
        ts_smoothed[i,*] = convol(reform(timestream[i,*]),savgolfilt,/edge_trunc) ; smooth the zeroed scan mean
    endfor

    return,ts_smoothed
end

