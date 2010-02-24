; fix_bad_values takes a 1D timestream with NANs in it and returns said timestream with no NANs
; the NANs are interpolated over by doing a linear interpolation between the two nearest good points
; If the endpoints of the timestream are NAN, all leading/trailing NANs are set to the first/last good
; value respectively
; INPUTS:
;   timestream - a 1D array of values including NaNs
;   threshold  - if the fraction of NaN values exceeds this number, returns an array of all zeroes
function fix_bad_values,timestream,threshold=threshold
    if ~keyword_set(threshold) then threshold=.3
    nanvals = finite(timestream,/nan)
    n_nanvals = total(nanvals)
    tslength = n_e(timestream)
    n_goodvals = tslength - n_nanvals
    if n_nanvals eq 0 then return,timestream                ; return original timestream if no NANs
    if n_nanvals/float(n_e(timestream)) gt threshold then return,fltarr(tslength) ;return zeros if too many NANs
    where_nanvals = where(nanvals,complement=where_goodvals)

    fixed_timestream = timestream

    if nanvals[0] eq 1 then begin ; set all leading NaNs equal to first good value
        fixed_timestream[0:where_goodvals[0]] = timestream[where_goodvals[0]]
        initial_index = where_goodvals[0]
    endif else initial_index = 0

    if nanvals[n_nanvals-1] eq 1 then begin ; set all trailing NaNs equal to last good value
        fixed_timestream[where_goodvals[n_goodvals-1]:tslength-1] = timestream[where_goodvals[n_goodvals-1]]
        a = max((nanvals lt where_goodvals[n_goodvals-1]) * nanvals,final_index)
    endif else final_index = n_nanvals - 1

    for i=initial_index,final_index do begin
        current_nan_index = where_nanvals[i]
        prev_good_value_ind = max((where_goodvals lt current_nan_index) * where_goodvals)
        next_good_value_ind = min((where_goodvals gt current_nan_index) * where_goodvals)
        good_value_indices = [prev_good_value_ind,next_good_value_ind]
        good_values = timestream[good_value_indices]
        ; y = m x + b : linear interpolation between two points
        delta_y = good_values[1] - good_values[0]
        delta_x = next_good_value_ind - prev_good_value_ind
        slope = double(delta_y) / double(delta_x)
        offset = good_values[0] - slope * prev_good_value_ind
        replacement_value = offset + slope * current_nan_index
        fixed_timestream[current_nan_index] = replacement_value
    endfor

    return,fixed_timestream
end


