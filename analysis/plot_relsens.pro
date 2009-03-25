
pro plot_relsens,bgps,meandc=meandc

    nscans = n_e(bgps.scans_info[0,*])

    meandc = fltarr(nscans)

    for i=0,nscans-1 do begin
        lb = bgps.scans_info[0,i]
        ub = bgps.scans_info[1,i]

        meandc[i] = median(bgps.dc_bolos[*,lb:ub])
    endfor

    plot,meandc,bgps.scale_coeffs[*,0],psym=1

end
