; bolo_flat
;
;  finds the median timestream of all bolometers, smooths it, 
;  then takes the projection of each bolometer's timestream with
;  the smoothed median timestream
;  the projection is averaged over time points so that a scaling for
;  each bolometer can be found
;
; in summary:
;  MODEL = SMOOTH ( MEDIAN_ACROSS_BOLOMETERS ( TIMESTREAM ) )
;  PROJECTION = MODEL dot TIMESTREAM / TIMESTREAM dot TIMESTREAM
;  SCALING_COEFFICIENTS = MEDIAN_ACROSS_TIMESTREAM ( PROJECTION )
;
; INPUTS:
;   timestream - n_bolo x scan_length input array - i.e. one scan segment of a total timestream
;   scan_average - if the average is already computed, can pass it as an input
; OUTPUT PARAMETERS:
;   scan_model - scan_length  array that is the median of the timestream over bolometers
; EXTRAS:
;   see sgfiltfunc - takes 4 possible inputs
function bolo_flat,timestream,scan_model=scan_model,scan_average=scan_average,scale_coeffs=scale_coeffs,scale_ts=scale_ts,_extra=extra
        scanlength = n_e(timestream[0,*])
        n_bolos    = n_e(timestream[*,0])
        if n_e(timestream) eq total(finite(timestream,/nan)) then return,timestream ; NAN handling

        savgolfilt = sgfiltfunc(_extra=extra)         ; smooth-timestream filter

        if ~keyword_set(scan_average) then scan_average = median(timestream,dimension=1) ; scanlength array that is the median over bolometers
        average_overall  = median(scan_average)       ; median of that so that the model is zeroed
        scan_model = convol(scan_average - average_overall,savgolfilt,/edge_trunc) ; smooth the zeroed scan mean
    
        scan_model_array = rebin(transpose(scan_model),n_bolos,scanlength,/sample)  ; rescale scan_model to be same size as ts
        ts_dot_average = total (timestream * scan_model_array,2,/nan) ; scale factor per bolometer
        ts_dot_ts      = total (timestream^2,2,/nan)                  ; denominator of projection eqn
        scale_coeffs   = ts_dot_average / ts_dot_ts                   ; projection coefficient - has length n_bolos
        scale_coeffs  /= median(scale_coeffs)                         ; somehow the scale coeffs don't always come out to flat. ???? might be OK ??
        if total(finite(scale_coeffs,/inf)) gt 0 then scale_coeffs[where(finite(scale_coeffs,/inf))] = 0  ; div by 0 -> zero weight
        if n_e(scale_coeffs) eq total(finite(scale_coeffs,/nan)) then message,"Error: all coefficients are NAN, data would be destroyed."

        ; must transpose the n_bolos array in order to shape it like timestream
        scale_ts = scale_coeffs # replicate(1,scanlength)
        flatfielded_ts = timestream * scale_ts
        
        return,flatfielded_ts
end

