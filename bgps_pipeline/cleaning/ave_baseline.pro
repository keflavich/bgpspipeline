; ave_baseline
;   returns a sky model based on the median (or average) of the correlated components of
;   bolometer pairs specified in bpairs; typically bolometer pairs with a certain minimum length
;
;   REQUIRED INPUT:
;       bpairs - a 2xN list of bolometer pairs such as the one returned by bolopairs
;       array  - a N_bolo x N_time timestream array from which to calculate the sky model  
; 
;   OPTIONAL INPUT
;       do_average - if set, will return the mean instead of the median of the data
;       flags      - if specified, must be the same size as array [THIS IS NOT CHECKED]
;                    flagged values will contribute ZERO to the correlation and ZERO
function ave_baseline,bpairs=bpairs,array=array,do_average=do_average,flags=flags,verbose=verbose
    timestream = array
    if n_e(flags) gt 0 and total(flags) gt 0 then timestream[where(flags)] = 0 ; flagged values should give zero contribution to dot product
    
    bp_size = size(bpairs,/dim)   ; WARNING: there can be up to 10296 baseline pairs, which will make this a slow loop
    if ~(bp_size[0] eq 2) then message,"Error: Bolometer pair array has wrong dimensions: ",bp_size 

    ts_size = size(timestream,/dim)                     ; length of time series
    sum_vec = fltarr(bp_size[1],ts_size[1])             ; zero array: will be averaged over to get sky model
    if keyword_set(verbose) then print,"Looping over "+strc(bp_size[1])+" bolometer pairs"
    for i=0,bp_size[1]-1 do begin                       ; LOOP over bolometer pairs
        ts1 = timestream[bpairs[0,i],*]                 ; two timestreams to cross-correlate
        ts2 = timestream[bpairs[1,i],*]
        fts = bytarr(ts_size[1]) + 1                    ; flag array corresponding to timestreams
        if keyword_set(flags) then begin                ; FLAGGING - can't set NaNs before matrix mult
            bad_bolo_1 = where(flags[bpairs[0,i],*])
            bad_bolo_2 = where(flags[bpairs[1,i],*])
            if size(bad_bolo_1,/n_dim) ne 0 then fts[bad_bolo_1] = !values.f_nan
            if size(bad_bolo_2,/n_dim) ne 0 then fts[bad_bolo_2] = !values.f_nan
        endif
        ts = [ [transpose(ts1)] , [transpose(ts2)] ]    ; time series becomes 2xn array
        crosscorr = transpose(ts) # ts                  ; cross correlation = [2 x n] # [n x 2]

        ; diagonalize the matrix
        coef1 = crosscorr[0,1] / crosscorr[0,0]
        coef2 = crosscorr[1,0] / ( crosscorr[1,1] - coef1 * crosscorr[1,0] ) 
        ; compute the diagonal matrix to determine which is the correlated component
        diagm = crosscorr - [ [0,0] , [crosscorr[0,0]*coef1,crosscorr[0,1]*coef1] ]
        diagm -= [ [0,diagm[1,1]*coef2] , [0,0] ]
        ; use coefficients to create eigenvectors
        ts[1,*] = ts[1,*] - ts[0,*] * coef1 * fts
        ts[0,*] = ts[0,*] - ts[1,*] * coef2 * fts
        ; use the larger of the two eigenvalues as the correlated component
        if diagm[0,0] gt diagm[1,1] then sum_vec[i,*] = transpose(ts[*,0]) $
                                    else sum_vec[i,*] = transpose(ts[*,1])

    endfor
    if keyword_set(verbose) then print,"Completed bolometer pair correlation loop."

    ; default behavior is to take the median
    if keyword_set(do_average) then ave_bl = total(sum_vec,dimension=1,/NAN) / double(bp_size[1]) $
                               else ave_bl = median(sum_vec,dimension=1) ; the median function automatically treats NaNs as missing data

    if (total(finite(ave_bl,/nan)) gt 0) then begin 
        ave_bl[where(finite(ave_bl,/nan))] = 1 
        print,"WARNING: the atmos model contained NAN values.  These will be set to zero."   
    endif
         
    return,ave_bl
end

