; reshape timestream to (scans*nbolos) x scanlength array for easier viewing
;
function reshape_timestream,timestream,scans_info,nbolos=nbolos,ntime=ntime
    if n_e(nbolos) eq 0 then nbolos = long(n_e(timestream[*,0]))
    nscans = long(n_e(scans_info[0,*]))
    scanlen = long(max(scans_info[1,*]-scans_info[0,*]))
    if n_e(ntime) eq 0 then ntime = long(n_e(timestream[0,*]))

;    reshaped_array = fltarr( long(nbolos+1)*nscans , scanlen+1 )
    reshaped_array = fltarr(nbolos,scanlen,nscans)
    reshaped_array[*] = !values.f_nan ; NANs to separate scans

    if size(timestream,/n_dim) ne 2 then $
        ts = float(rebin(timestream,[nbolos,ntime],/sample)) $
    else ts = timestream

    for i=0,nscans-1 do begin
        scanlen = long(scans_info[1,i]-scans_info[0,i])
        reshaped_array[0:nbolos-1,0:scanlen-1,i] = ts[0:nbolos-1,scans_info[0,i]:scans_info[1,i]-1]
;        reshaped_array[nbolos*i+i:nbolos*(i+1)-1+i,0:scanlen] = timestream[0:nbolos-1,scans_info[0,i]:scans_info[1,i]]
    endfor

    return,reshaped_array
end
