
; relsens_flat_by_scans
function relsens_flat_by_scans,timestream,scans_info,flags=flags,_extra=extra
    nscans = n_e(scans_info[0,*])
    nbolos = n_e(timestream[*,0])
    ts = timestream
    temp = ts
    if keyword_set(flags) then ts[where(flags)] = !values.f_nan
    for s=0,nscans-1 do begin
        lb = scans_info[0,s]
        ub = scans_info[1,s]
        ts[0:nbolos-1,lb:ub] = relsens_flat(ts[0:nbolos-1,lb:ub],_extra=extra)
    endfor
    if keyword_set(flags) then ts[where(flags)] = temp[where(flags)]
    return,ts
end


