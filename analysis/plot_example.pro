
pro plot_example,savfile

    restore,savfile

    nscans = n_e(bgps.scans_info[0,*])
    midscan = nscans / 2
    lb = bgps.scans_info[0,midscan]
    ub = bgps.scans_info[1,midscan]

    ymin = min([bgps.raw[0,lb:ub],bgps.ac_bolos[0,lb:ub]])
    ymax = max([bgps.raw[0,lb:ub],bgps.ac_bolos[0,lb:ub]])

    ; first the raw timestream

    ; then, step through each part of the process

    ; first, deline
    delined = deline(bgps.raw,bgps.sample_interval,scans_info=bgps.scans_info)   ;deline... does stuff, but not all stuff

    ; exponential tail subtraction
    expsub = exponent_sub(delined,scans_info=bgps.scans_info, flags=bgps.flags, bolo_params=bgps.bolo_params,sample_interval=bgps.sample_interval)

    ; polynomial subtraction
    polysubbed = poly_sub_by_scans(expsub,bgps.scans_info,flags=bgps.flags,_extra=_extra)

    ; "boloflat" is similar to relative sensitivity calibration but not quite the same
    boloflatted = bolo_flat(polysubbed)

;    ymax = max([ymax,reform(boloflatted[0,lb:ub])])
    plot,bgps.raw[0,lb:ub],linestyle=0,yrange=[ymin,ymax]
    oplot,delined[0,lb:ub],linestyle=1
    oplot,expsub[0,lb:ub],linestyle=2
    oplot,polysubbed[0,lb:ub],linestyle=3
    oplot,bgps.ac_bolos[0,lb:ub],linestyle=4

    window,1
    plot,polysubbed[0,lb:ub]
    oplot,bgps.ac_bolos[0,lb:ub],color=250

    stop
    ; also should plot before/after boloflat for each bolo
    plot,total(polysubbed[*,lb:ub],2)/total(polysubbed[*,lb:ub])
    oplot,total(boloflatted[*,lb:ub],2)/total(boloflatted[*,lb:ub])

end




    




