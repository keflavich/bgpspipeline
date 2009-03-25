; attempts to correct for relative sensitivities across a scan (not across bolos) using dc_bolos
function dc_calibrate_by_scans,ac_bolos,dc_bolos,scans_info,flags=flags,_extra=extra
    nscans = n_e(scans_info[0,*])
    nbolos = n_e(ac_bolos[*,0])
    temp = ac_bolos
    if keyword_set(flags) then ac_bolos[where(flags)] = !values.f_nan
    for s=0,nscans-1 do begin
        lb = scans_info[0,s]
        ub = scans_info[1,s]
        ac_bolos[0:nbolos-1,lb:ub] = dc_calibrate(ac_bolos[0:nbolos-1,lb:ub],dc_bolos[0:nbolos-1,lb:ub])
    endfor
    if keyword_set(flags) then ac_bolos[where(flags)] = temp[where(flags)]
    return,ac_bolos
end

