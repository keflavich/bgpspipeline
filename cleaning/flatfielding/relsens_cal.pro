; relsens_cal
; each bolometer has a different response 
; scale the bolometers by their response vs. the "atmosphere model" (mean response)
; at each timepoint.
function relsens_cal,timestream,atmosphere,scale_coeffs=scale_coeffs

    mean_atmo =  ( total(atmosphere,1,/nan) / n_e(atmosphere[*,0]) ) ## (intarr(n_e(atmosphere[*,0])) + 1)
    atmo_div_astro = mean_atmo / timestream
    scale_coeffs = median(atmo_div_astro,dimension=2)

    return,scale_coeffs
end
