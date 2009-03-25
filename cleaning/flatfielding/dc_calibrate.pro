function dc_calibrate,ac_bolos,dc_bolos,_extra=extra
    dcsgfilt = sgfiltfunc(_extra=extra)
    for b=0,n_e(ac_bolos[*,0])-1 do begin
        dcscan = convol(reform(dc_bolos[b,*])/mean(dc_bolos[b,*],/nan),dcsgfilt,/edge_trunc,/nan)
        ac_bolos[b,*] /= dcscan
;        scale_factor = median(dc_bolos)
;        mean_per_bolo = total(dc_bolos,2,/nan) / float(n_e(dc_bolos[0,*]))
;        ac_bolos = ac_bolos / rebin(mean_per_bolo,size(ac_bolos,/dim),/sample) * scale_factor
    endfor
    return,ac_bolos
end

