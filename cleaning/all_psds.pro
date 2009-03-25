; returns a 3-d set of the PSD of a timestream (nbolos x nscans x frequency)
function all_psds,timestream,scans_info,flags=flags,bolo_params=bolo_params,sample_interval=sample_interval,threshold=threshold,$
        psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,scan_freq=scan_freq
    if ~keyword_set(sample_interval) then sample_interval = .1
    if ~keyword_set(threshold) then threshold = .3
    n_scans = n_e(scans_info[0,*])
    scan_length = scans_info[1,0]-scans_info[0,0]
    goodbolos = where(bolo_params[0,*],complement=bad_bolos)
    n_bolos = n_e(bolo_params[0,*])
    psd_psd = fltarr(n_bolos,n_scans,scan_length/2+1)

    if keyword_set(flags) then if (n_e(flags) gt 0) then if (total(flags) gt 0) then timestream[where(flags)] = !values.f_nan

    for i=0,n_scans-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]
;        scan_length = ub - lb

        for j=0,n_e(goodbolos)-1 do begin
            bolonum = goodbolos[j]
            scan_timestream = fix_bad_values(timestream[bolonum,lb:ub],threshold=threshold)
            if ~(total(scan_timestream eq 0) eq n_e(scan_timestream)) then begin 
                scan_psd = psd_scan(scan_timestream,sample_interval=sample_interval)
                if scan_length/2 lt 1 then begin
                    print,"Scan length is only ",scan_length," and lower/upper bounds are ",lb,ub
                    print,"PSD length is ",n_e(psd_psd[bolonum,i,*])
                    print,"This is probably a very serious error"
                    psd_psd[bolonum,i,*] = 0
                endif else begin
                    if scan_length ne (ub-lb) then psd_psd[bolonum,i,*] = 0 $
                    else psd_psd[bolonum,i,*] = scan_psd[1,0:(scan_length)/2]
;                    print,"Scan length is ",scan_length," and lower/upper bounds are ",lb,ub," at bolonum, iter ",bolonum,i
;                    print,"Is 0 < (scan_length)/2?",0 lt (scan_length)/2,scan_length,2
;                    print,"scan_psd size: ",size(scan_psd,/dim)
                endelse
            endif ; else psd_psd remains zero
        endfor
    endfor

    psd_avebolo = median(psd_psd,dim=1)
    psd_avescan = median(psd_psd,dim=2)
;    scan_freq = scan_psd[0,0:(scan_length)/2]

    return,psd_psd
end


