

; psd flagging based on how close the PSD of each bolometer is to
; the median PSD for the whole observation
pro psd_flag_projection_by_scan,psd_psd=psd_psd,flags=flags,scans_info=scans_info
    if ~keyword_set(scans_info) then message,"Can't flag scans without scans_info available"
    
    nscans = n_e(psd_psd[0,*,0])
    if nscans ne n_e(scans_info[0,*]) then message,"scans_info and psd_psd have a different number of scans.  This is an error."
    for i=0,nscans-1 do begin
        psd_scan    = reform(psd_psd[*,i,*])
        median_psd  = median(psd_scan,dim=1)
        dot_product = total(psd_scan*(median_psd # replicate(1,n_e(psd_scan[*,0]))),2)/total(median_psd*median_psd)
        where_high  = where(dot_product) gt 1.75
        where_low   = where(dot_product) lt 0.25
        flags[where_high,scans_info[0,i]:scans_info[1,i]] = 1
        flags[where_low ,scans_info[0,i]:scans_info[1,i]] = 1
    endfor
end

