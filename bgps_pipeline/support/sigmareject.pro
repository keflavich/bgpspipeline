
function sigmareject,data,sigmas,domedian=domedian,goodvals=goodvals,flagarr=flagarr,badvals=badvals
    niter = n_e(sigmas)
    ndata = n_e(data)
    sigmas = float(sigmas)
    datacopy = fltarr(ndata) + !values.f_nan
    if ~keyword_set(goodvals) then gv = indgen(ndata) $
        else gv = goodvals
    datacopy[gv] = data[gv]

    for i=0,niter-1 do begin
        if keyword_set(domedian) then midval = median(data[gv]) $
            else midval = mean(data[gv],/nan)
        std = stddev(data[gv],/nan)
        nsig = sigmas[i]
        flagarr = (datacopy gt midval - nsig*std) and (datacopy lt midval + nsig*std)
        gv = where(flagarr,complement=badvals)
        if badvals[0] ne -1 then datacopy[badvals] = !values.f_nan
    endfor

    return,gv
end
