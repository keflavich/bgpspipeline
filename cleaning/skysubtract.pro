; skysubtract takes an N x M and a 1 x M array 
; and rescales the 1 x M to N x M, then scales
; each element in the N direction by projection
; onto the corresponding element from the timestream array
; It is meant to return the timestream minus the atmosphere model projected onto each bolometer's timestream
; INPUT:
;   timestream - n_bolos x n_time array
;   atm_model  - 1 x n_time array to be rebinned to match timestream
function skysubtract,timestream,atm_model
    atm_model -= median(atm_model)
    timestream -= ((total(timestream,2,/nan) / n_e(timestream[0,*])) # replicate(1,n_e(timestream[0,*])))
    skm_rebin = rebin(transpose(atm_model),size(timestream,/dim),/sample) 
    scalefactor = rebin(( total(skm_rebin * timestream,2,/nan) / total(atm_model*atm_model,/nan) ),size(timestream,/dim),/sample)
    atmmod_scaled = skm_rebin * scalefactor
    astro_model = timestream - atmmod_scaled
    return,astro_model
end


