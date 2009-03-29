; example:
; restore,'/usb/scratch1/l357/v1.0.2_13pca_preiter.sav'
; plot_example,bpgs,mapstr
pro plot_example,bgps,mapstr

    set_plot,'ps'
    loadct,39
    device,filename='example_plot.ps',/color,/encapsulated

    nscans = n_e(bgps.scans_info[0,*])
    midscan = nscans / 2
    lb = bgps.scans_info[0,midscan]
    ub = bgps.scans_info[1,midscan]


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

    ymin = min([bgps.raw[0,lb:ub],delined[0,lb:ub],boloflatted[0,lb:ub],expsub[0,lb:ub],polysubbed[0,lb:ub]])
    ymax = max([bgps.raw[0,lb:ub],delined[0,lb:ub],boloflatted[0,lb:ub],expsub[0,lb:ub],polysubbed[0,lb:ub]])
    yrange=[ymin,ymax]

;    ymax = max([ymax,reform(boloflatted[0,lb:ub])])
    !p.multi=[0,1,4]
    plot,bgps.raw[0,lb:ub],linestyle=0,title='Raw',yrange=yrange
    plot,delined[0,lb:ub],linestyle=0,title='Delined',yrange=yrange
    plot,expsub[0,lb:ub],linestyle=0,title='Exponent subtraction',yrange=yrange
    plot,polysubbed[0,lb:ub],linestyle=0,title='Polynomial subtraction',yrange=yrange


    ymin = min(bgps.ac_bolos[0,lb:ub])
    ymax = max(bgps.ac_bolos[0,lb:ub])
    yrange=[ymin,ymax]

    ; in principle, bgps.ac_bolos and polysubbed should be identical at this point....
;    plot,bgps.ac_bolos[0,lb:ub],linestyle=0,title='Before iterative cleaning',yrange=yrange

    bgps.astrosignal[*] = 0
;    bgps.atmosphere = bgps.ac_bolos - bgps.astrosignal 
;    atmos_remainder = sky_subtraction_wrapper(bgps.atmosphere,minlen=0,bolo_params=bgps.bolo_params,$
;        flags=bgps.flags,_extra=_extra) 
;    first_sky = bgps.atmosphere-atmos_remainder
;
;    plot,atmos_remainder[0,lb:ub],title='Median atmosphere subtraction',yrange=yrange
;    oplot,first_sky[0,lb:ub],linestyle=1
;
;    pca_subtract,atmos_remainder,13,uncorr_part=new_astro,corr_part=pca_atmo 
;
;    plot,new_astro[0,lb:ub],title="PCA astrophysical signal",yrange=yrange
;    plot,(pca_atmo+first_sky)[0,lb:ub],title="PCA + median atmosphere",yrange=yrange
;
;    new_astro = poly_sub_by_scans(new_astro,bgps.scans_info,flags=bgps.flags,_extra=_extra)
;    bgps.astrosignal+=new_astro
;
;    plot,bgps.astrosignal[0,lb:ub],title="Astrophysical signal before mapping",yrange=yrange
;    map_iter,bgps,mapstr,i=0,niter=[13]
;    plot,bgps.astrosignal[0,lb:ub],title="Astrophysical signal from map",yrange=yrange
;
;    bgps.weight = psd_weight(bgps.noise,bgps.scans_info,bgps.sample_interval,wt2d=wt2d,var=var2d)
;    bgps.wt2d=wt2d & bgps.var2d = var2d ; have to do this b/c passing structs to a function doesn't work
;    mapstr.wt_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.weight,wtmap=1,weight=1) ; use a normal drizzle

    ; rinse and repeat

    for i=0,20 do begin

        !p.multi=[0,1,4]

        plot,bgps.ac_bolos[0,lb:ub],linestyle=0,title='Before iterative cleaning (black) astrosignal (red) difference (green)',yrange=yrange
        oplot,bgps.astrosignal[0,lb:ub],color=250
        bgps.atmosphere = bgps.ac_bolos - bgps.astrosignal 
        oplot,bgps.atmosphere[0,lb:ub],color=150

        if i eq 0 then begin
            atmos_remainder = sky_subtraction_wrapper(bgps.atmosphere,minlen=0,bolo_params=bgps.bolo_params,$
                flags=bgps.flags,_extra=_extra) 
            first_sky = bgps.atmosphere-atmos_remainder
            pca_subtract,atmos_remainder,13,uncorr_part=new_astro,corr_part=pca_atmo 
            astrosignal_premap = poly_sub_by_scans(new_astro,bgps.scans_info,flags=bgps.flags,_extra=_extra)
        endif

        plot,atmos_remainder[0,lb:ub],title="Median atmosphere (red) remainder (black) (Iter "+strc(i)+")",yrange=yrange
        oplot,first_sky[0,lb:ub],linestyle=0,color=250
        oplot,bgps.atmosphere[0,lb:ub],color=150

        plot,new_astro[0,lb:ub],title="Astrophysical signal (red - total, black - Iter "+strc(i)+")",yrange=yrange
        oplot,astrosignal_premap[0,lb:ub],color=250
        plot,(pca_atmo+first_sky)[0,lb:ub],title="Atmosphere (PCA + median, Iter "+strc(i)+")",yrange=yrange

        x=bgps ;RIDICULOUS hack
        clean_iter_struct,x,mapstr,niter=intarr(51)+13,i=i,$
            pca_atmo=pca_atmo,new_astro=new_astro,first_sky=first_sky,$
            atmos_remainder=atmos_remainder,astrosignal_premap=astrosignal_premap,$
            fits_timestream=0,/deconvolve
        bgps=x

    endfor

    device,/close_file

    device,filename='relsens_cal.ps',/color,/encapsulated
    
    !p.multi=[0,1,2]

    lb=bgps.scans_info[0,0]
    ub=bgps.scans_info[1,0]

    yrange=[min(bgps.ac_bolos[0:2,lb:ub]),max(bgps.ac_bolos[0:2,lb:ub])]

    xax = findgen(ub-lb)*.05

    plot,median(bgps.ac_bolos[*,lb:ub],dimension=1),yrange=yrange,ytitle="Amplitude (Jy)",xtitle="Time (s)" ;bgps.ac_bolos[0,lb:ub]
    oplot,xax,bgps.ac_bolos[1,lb:ub],color=250
    oplot,xax,bgps.ac_bolos[2,lb:ub],color=150

    plot,median(bgps.ac_bolos[*,lb:ub],dimension=1),yrange=yrange,ytitle="Amplitude (Jy)",xtitle="Time (s)" ;bgps.ac_bolos[0,lb:ub]*bgps.scale_coeffs[0,0]
    oplot,xax,bgps.ac_bolos[1,lb:ub]*bgps.scale_coeffs[0,1],color=250
    oplot,xax,bgps.ac_bolos[2,lb:ub]*bgps.scale_coeffs[0,2],color=150

    device,/close_file

    set_plot,'x'


    stop

    ; also should plot before/after boloflat for each bolo
    plot,total(polysubbed[*,lb:ub],2)/total(polysubbed[*,lb:ub])
    oplot,total(boloflatted[*,lb:ub],2)/total(boloflatted[*,lb:ub])

end




    




