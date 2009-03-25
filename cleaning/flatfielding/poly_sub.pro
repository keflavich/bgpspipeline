
; poly_sub
; simple code: takes a timestream and returns one with a 2nd order polynomial subtracted from it
; INPUTS:
;   input_ts     - a timestream.  If it includes NANs, they will be ignored but will be present in the output
;   sigmareject  - if set, will ignore points outside of the 1-sigma range when calculating the best fit.  
;                  this is useful if a source is present in the timestream as it will reduce the source's contribution
;                  to the curve
;
;  there is an issue: the total(bad_values) - 1 thing assures that you have 2 or more data points
;  when trying to fit.  BUT it's a common case to get 1 data point because of the way flagging is
;  performed, specifically how the endpoints of scans_info are treated.  This should be fixed but 
;  probably won't because it's not going to have a significant effect.
function poly_sub,input_ts,sigmareject=sigmareject,threshold=threshold,order=order,iterate_sigmareject=iterate_sigmareject
    timestream = input_ts
    if ~keyword_set(order)     then order     = 2
    if ~keyword_set(threshold) then threshold = .3     ; if too many bad / reject values, use lower order poly
    bad_values = finite(timestream,/nan)               ; NAN handling
    if total(bad_values) gt n_e(timestream)*.5 then return,input_ts ; NAN handling for seriously bad stuff (more than 50% flagged)
    tslen = n_e(timestream)
;    timestream[where(total(bad_values) eq tslen) # (fltarr(tslen)+1) ] = 0
    x = findgen(tslen)
    if keyword_set(sigmareject) then begin
        ts_sig = stddev(timestream,/nan)
        reject_condition = (timestream gt ( median(timestream) + ts_sig*sigmareject)) or (timestream lt ( median(timestream) - ts_sig*sigmareject)) or bad_values
        reject_ind = where( reject_condition, complement = keep_ind)
        if keyword_set(iterate_sigmareject) and n_e(keep_ind) gt 1 then begin
            ts_sig2 = stddev(timestream[keep_ind])
            reject_condition2 = (timestream gt ( median(timestream) + ts_sig2*iterate_sigmareject)) or (timestream lt ( median(timestream) - ts_sig2*iterate_sigmareject)) or bad_values
            reject_ind = where( reject_condition2, complement = keep_ind)
        endif
        x_fit = x[keep_ind]
        timestream = timestream[keep_ind]
    endif else if total(bad_values) gt 0 then begin    ; NAN handling
        x_fit = x[where(~bad_values)]
        timestream = timestream[where(~bad_values)]
    endif else x_fit = x
    if n_e(timestream)/float(n_e(input_ts)) lt 1.-threshold then poly_order = 1 else poly_order = order
    if n_e(x_fit) gt 1 then begin
        a = poly_fit(x_fit,timestream,poly_order)
        flat_ts = input_ts - poly(x,a)                     ; Use original timestream in case some values were rejected / NANs
    endif else flat_ts = input_ts
    return,flat_ts                                     ; return timestream must be the same size as input timestream
end


