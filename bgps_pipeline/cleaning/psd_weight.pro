; psd_weight - 
; determine the weighting of each timestream point using the inverse PSD^2
; 
; 'var' and 'wt2d' are 2D arrays of variance calculated by two different
; mechanisms, primarily for debugging
;
; Other inputs are standard BGPS data inputs
;
; Output is a timestream of weights with the same shape as the input timestream
function psd_weight,timestream,scans_info,sample_interval,var=var,wt2d=wt2d

    n_scans = n_e(scans_info[0,*])
    n_bolos = n_e(timestream[*,0])
    var=fltarr(n_scans,n_bolos)
    wt2d=fltarr(n_scans,n_bolos)
    t1 = systime(/sec)

    ; optional weight the weight by location in PSD
;    scanlen = abs(scans_info[0,1]-scans_info[0,0])
;    wtwt = (scanlen/2-indgen(scanlen/2))^2

    dk = sample_interval

    ; there is a weight point for every data point
    weight_timestream = timestream*0
    for i=0,n_scans-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]
        scanlen = abs(ub-lb)

        ; eqns. for PSD below from James Aguirre's thesis
        for j=0,n_bolos-1 do begin
            scandata = nantozero(timestream[j,lb:ub])  ; copy data and get rid of NANs
            scandata -= mean(scandata,/nan)            ; forcibly remove DC component of FT (the mean)
            fk = fft(scandata,-1)                      ; forward fourier transform
;            N = n_e(fk)                                ; N
;            fny = N * dk / 2.                          ; def'n Nyquist Freq (A.5)
; NOTE THAT THIS LINE TRUNCATES THE PSD TO n_e(wtwt)
            psd = abs(fk^(2.));*wtwt ; /(N*fny)              ; def'n PSD  (A.8)
            sigmasq  = total(psd,/nan) ;* scanlen/float(n_e(wtwt))                 ; sigmasq (A.4)
            var[i,j] = variance(scandata)
            wt2d[i,j] = 1./sigmasq

            ; error check: don't divide by zero.  Replace bad weights with 1.
            if sigmasq eq 0 then weight = 1. $
                else weight = 1./sigmasq

            weight_timestream[j,lb:ub] = weight
        endfor
    endfor

    ; Normalize the weights
    ; not necessary any more
    wt_mean = median(wt2d)
    wt_std  = mad(wt2d)
    wt_max  = max(wt2d,/nan)
;    weight_timestream /= wt_mean
;    ; I want to limit the weights so that nothing gets hugely over-weighted
;    ; I think data should be nearly evenly weighted above a certain level, 
;    ; only downweighting, not upweighting, should be allowed
    reject_hi = where(weight_timestream gt wt_mean+wt_std) 
    if n_e(reject_hi) gt 0 and min(reject_hi) ge 0 then weight_timestream[reject_hi] = wt_mean+wt_std 
;    reject_lo = where(wt2d lt wt_mean-wt_std) 
;    if n_e(reject_lo) gt 0 then weight_timestream[reject_lo] = wt_mean-wt_std 
    print,"Truncated "+strc(n_e(reject_hi))+" weights with max weight "+strc(wt_mean+wt_std)
    
    print,"Computed PSD weights for "+strc(n_scans*n_bolos)+" scans in ",strcompress(systime(/sec)-t1)," seconds"

    return,weight_timestream
end
