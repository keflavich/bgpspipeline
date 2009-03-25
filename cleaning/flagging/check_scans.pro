; check scans for too many flags
; if scan is >60% flagged, flag the rest too

function check_scans, flags, scans_info=scans_info, bolo_params=bolo_params, nbadscan=nbadscan

    goodbolos=where(bolo_params[0,*] eq 1,ngood)
    nscans = n_e(scans_info[0,*])
    nbadscan = 0

    for i=0, nscans-1 do begin    ;loop through subscans
        lb = scans_info[0,i]   
        ub = scans_info[1,i]   
        nperscan = ub-lb+1

        nflagged = total(flags[goodbolos,lb:ub] gt 0)
        npoints = n_e(flags[goodbolos,lb:ub])

        if float(nflagged)/float(npoints) gt .6 then begin
            flags[*,lb:ub]=1
            nbadscan+=1
        endif
    endfor

    return,flags
end













