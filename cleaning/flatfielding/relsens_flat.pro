; relsens_flat
; attempts to correct for relative sensitivities across bolometers by making them have
; the same median response across the whole observation (the whole timestream)
; INPUTS:
;   timestream - n_relsens x scan_length input array - i.e. one scan segment of a total timestream
function relsens_flat,timestream,_extra=extra
        if n_e(timestream) eq total(finite(timestream,/nan)) then return,timestream ; NAN handling

        bolo_average = median(timestream,dimension=2) ; scanlength array that is the median over the scan for each bolo
        average_overall  = median(bolo_average)       ; median of that 
    
        bolo_model_array = rebin(bolo_average,size(timestream,/dim),/sample)  ; rescale scan_model to be same size as ts
        flatfielded_ts = timestream / bolo_model_array * average_overall

        return,flatfielded_ts
end

