; relsens_cal
; each bolometer has a different response 
; scale the bolometers by their response vs. the "atmosphere model" (mean response)
; at each timepoint.
function relsens_cal,timestream,atmosphere,scale_coeffs=scale_coeffs,scans_info=scans_info,scalearr=scalearr

    scalearr = timestream * 0 
    scale_coeffs = replicate(1.0,n_e(timestream[*,0])) ## replicate(1.0,n_e(scans_info[0,*]))

    for i=0,n_e(scans_info[0,*])-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]

        ; although the atmosphere has already been calculated, we want to scale to the mean
        mean_atmo =  ( total(atmosphere[*,lb:ub],1,/nan) / n_e(atmosphere[*,0]) ) ## (intarr(n_e(atmosphere[*,0])) + 1)
        atmo_div_astro = mean_atmo / timestream[*,lb:ub]  
        scale_coeffs[i,*] = median(atmo_div_astro,dimension=2)  ; median along time direction

        scalearr[*,lb:ub] = reform(scale_coeffs[i,*]) # (fltarr(ub-lb+1)+1)

    endfor

    return,scale_coeffs
end
