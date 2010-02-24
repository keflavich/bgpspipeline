
; find_bad_scans
; searches for scans with std deviations higher than others 
; returns the inputted timestream with bad scans set to NAN
; INPUTS:
;   timestream - nbolos x ntime data stream
;   scans_info - 2 x nscans list of scan start/end positions
;   n_sig      - how far off does a scan have to be to be rejected?
;                defaults to 4-sigma
;                sigma is the standard deviation across all bolometers
;                   for a given scan
; OUTPUTS:
;   timestream - returned value of input data with all flagged values set to NAN
;   flags      - flag array, same size as timestream, with flagged values set to 1
function find_bad_scans,timestream,scans_info,flags=flags,n_sig=n_sig
    if ~keyword_set(n_sig) then n_sig = 4
    if ~keyword_set(flags) then flags = fltarr(size(timestream,/dims))
    nscans = n_e(scans_info[0,*])
    for s=0,nscans-1 do begin
        lb = scans_info[0,s]
        ub = scans_info[1,s]
        n_nan = float(total(finite(timestream[*,lb:ub],/nan)))
        n_flagged = float(total(flags[*,lb:ub]))
        n_points = float((ub-lb+1)*(size(timestream,/dim))[0])
        ; if most of a scan is bad, make sure it is ALL bad, otherwise
        ; polynomial subtraction etc. don't work well and you get flaky
        ; points
        if n_nan/n_points gt .5 or n_flagged/n_points gt .5 then begin
            timestream[*,lb:ub] = !values.f_nan
            flags[*,lb:ub] = 1
        end
        bolo_std = stddevaxis(timestream[*,lb:ub],dim=2,/nan)
        std_std  = stddev(bolo_std)
        std_mean = mean(bolo_std)
        bad_bolo = where(bolo_std gt (std_mean+n_sig*bolo_std))
        if size(bad_bolo,/n_d) gt 0 then begin
            timestream[bad_bolo,lb:ub] = !values.f_nan
            flags[bad_bolo,lb:ub] = 1
        endif
    endfor

    return,timestream
end


