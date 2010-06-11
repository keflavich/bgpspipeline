; example:
; restore,'/usb/scratch1/l357/v1.0.2_l357_13pca_postiter.sav'
; plot_example,bgps,mapstr
;
; or
; restore,getenv('WORKINGDIR')+'/super_gc/v1.0.2_super_gc_13pca_postiter.sav'
; plot_example,bgps,mapstr
; plot_relsens,bgps,mapstr
;
; for the relsens figure generated June 10, 2010:
; restore,getenv('WORKINGDIR')+'/super_gc/v1.0.2_super_gc_13pca_postiter.sav'
; plot_relsens,bgps,mapstr,scannumber=1571
; (want a longer timestream)
pro plot_example,bgps,mapstr

    set_plot,'ps'
    loadct,39
    device,filename='example_plot_iter00.ps',/color,/encapsulated,/times,font_index=7

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
    multiplot
    plot,bgps.raw[0,lb:ub],/xs,psym=10,yrange=yrange,xthick=2,ythick=2,thick=3,ystyle=1,ytickname=replicate(' ',20) ;,title='!6Raw'
    multiplot
    plot,delined[0,lb:ub],/xs,psym=10,yrange=yrange,xthick=2,ythick=2,thick=3,ystyle=1,ytickname=replicate(' ',20)  ;,title='!6Delined'
    multiplot
    plot,expsub[0,lb:ub],/xs,psym=10,yrange=yrange,xthick=2,ythick=2,thick=3,ystyle=1,ytickname=replicate(' ',20) ;,title='!6Exponent subtraction'
    multiplot
    plot,polysubbed[0,lb:ub],/xs,/ys,psym=10,yrange=yrange,xthick=2,ythick=2,thick=3,ytitle="!6Amplitude (Jy)",xtickformat='(I)'  ;,title='!6Polynomial subtraction'
    ;multiplot,/reset

    device,/close_file

    ymin = min(bgps.ac_bolos[0,lb:ub])
    ymax = max(bgps.ac_bolos[0,lb:ub])
    yrange=[ymin,ymax]

    ; in principle, bgps.ac_bolos and polysubbed should be identical at this point....
;    plot,bgps.ac_bolos[0,lb:ub],psym=10,title='!6Before iterative cleaning',yrange=yrange,xthick=2,ythick=2,thick=3

    bgps.astrosignal[*] = 0
;    bgps.atmosphere = bgps.ac_bolos - bgps.astrosignal 
;    atmos_remainder = sky_subtraction_wrapper(bgps.atmosphere,minlen=0,bolo_params=bgps.bolo_params,$
;        flags=bgps.flags,_extra=_extra) 
;    first_sky = bgps.atmosphere-atmos_remainder
;
;    plot,atmos_remainder[0,lb:ub],title='!6Median atmosphere subtraction',yrange=yrange,xthick=2,ythick=2,thick=3
;    oplot,first_sky[0,lb:ub],linestyle=1
;
;    pca_subtract,atmos_remainder,13,uncorr_part=new_astro,corr_part=pca_atmo 
;
;    plot,new_astro[0,lb:ub],title="PCA astrophysical signal",yrange=yrange,xthick=2,ythick=2,thick=3
;    plot,(pca_atmo+first_sky)[0,lb:ub],title="PCA + median atmosphere",yrange=yrange,xthick=2,ythick=2,thick=3
;
;    new_astro = poly_sub_by_scans(new_astro,bgps.scans_info,flags=bgps.flags,_extra=_extra)
;    bgps.astrosignal+=new_astro
;
;    plot,bgps.astrosignal[0,lb:ub],title="Astrophysical signal before mapping",yrange=yrange,xthick=2,ythick=2,thick=3
;    map_iter,bgps,mapstr,i=0,niter=[13]
;    plot,bgps.astrosignal[0,lb:ub],title="Astrophysical signal from map",yrange=yrange,xthick=2,ythick=2,thick=3
;
;    bgps.weight = psd_weight(bgps.noise,bgps.scans_info,bgps.sample_interval,wt2d=wt2d,var=var2d)
;    bgps.wt2d=wt2d & bgps.var2d = var2d ; have to do this b/c passing structs to a function doesn't work
;    mapstr.wt_map = ts_to_map(mapstr.blank_map_size,mapstr.ts,bgps.weight,wtmap=1,weight=1) ; use a normal drizzle

    ; rinse and repeat

    for i=0,20 do begin

        device,filename='example_plot_iter'+string(i+1,format='(I2.2)')+'.ps',/color,/encapsulated,/times
        !p.multi=[0,1,4]

        multiplot
        plot,bgps.ac_bolos[0,lb:ub],psym=10,/xs,/ys,yrange=yrange,xthick=2,ythick=2,thick=3,ytickname=replicate(' ',20)  ;,title='!6Before iterative cleaning (black) astrosignal (red) difference (green)'
        oplot,bgps.astrosignal[0,lb:ub],psym=10,color=250,thick=3
        bgps.atmosphere = bgps.ac_bolos - bgps.astrosignal 
        oplot,bgps.atmosphere[0,lb:ub],psym=10,color=150,thick=3

        if i eq 0 then begin
            atmos_remainder = sky_subtraction_wrapper(bgps.atmosphere,minlen=0,bolo_params=bgps.bolo_params,$
                flags=bgps.flags,_extra=_extra) 
            first_sky = bgps.atmosphere-atmos_remainder
            pca_subtract,atmos_remainder,13,uncorr_part=new_astro,corr_part=pca_atmo 
            astrosignal_premap = poly_sub_by_scans(new_astro,bgps.scans_info,flags=bgps.flags,_extra=_extra)
        endif

        multiplot
        plot,atmos_remainder[0,lb:ub],psym=10,/xs,/ys,yrange=yrange,xthick=2,ythick=2,thick=3,ytickname=replicate(' ',20)  ;,title="Median atmosphere (red) remainder (black) (Iter "+strc(i)+")"
        oplot,first_sky[0,lb:ub],psym=10,color=250,thick=3
        oplot,bgps.atmosphere[0,lb:ub],psym=10,color=150,thick=3

        multiplot
        plot,new_astro[0,lb:ub],psym=10,/xs,/ys,yrange=yrange,xthick=2,ythick=2,thick=3,ytickname=replicate(' ',20)  ;,title="Astrophysical signal (red - total, black - Iter "+strc(i)+")"
        oplot,astrosignal_premap[0,lb:ub],psym=10,color=250,thick=3
        multiplot
        plot,(pca_atmo+first_sky)[0,lb:ub],psym=10,/xs,/ys,yrange=yrange,xthick=2,ythick=2,thick=3,ytitle="!6Amplitude (Jy)",xtickformat='(I)'  ;,title="Atmosphere (PCA + median, Iter "+strc(i)+")"
        ;multiplot,/reset

        device,/close_file

        x=bgps ;RIDICULOUS hack
        clean_iter_struct,x,mapstr,niter=intarr(51)+13,i=i,$
            pca_atmo=pca_atmo,new_astro=new_astro,first_sky=first_sky,$
            atmos_remainder=atmos_remainder,astrosignal_premap=astrosignal_premap,$
            fits_timestream=0,/deconvolve,fits_out=[-1]
        bgps=x

    endfor

    ;device,/close_file

end
pro plot_relsens,bgps,mapstr,scannumber=scannumber

    set_plot,'ps'
    device,filename='relsens_cal.ps',/color,/encapsulated
    
    !p.multi=[0,1,2]

    if ~keyword_set(scannumber) then scannumber = 0 
    lb=bgps.scans_info[0,scannumber]
    ub=bgps.scans_info[1,scannumber]

    yrange=[min(bgps.ac_bolos[0:2,lb:ub]),max(bgps.ac_bolos[0:2,lb:ub])]

    xax = findgen(ub-lb)*.05

    multiplot
    plot,xax,median(bgps.ac_bolos[*,lb:ub],dimension=1),yrange=yrange,xthick=2,ythick=2,thick=3,/xs,/ys,ytickname=replicate(' ',20)  ;bgps.ac_bolos[0,lb:ub]
    oplot,xax,bgps.ac_bolos[1,lb:ub],psym=10,color=250,thick=3
    oplot,xax,bgps.ac_bolos[2,lb:ub],psym=10,color=150,thick=3

    multiplot
    plot,xax,median(bgps.ac_bolos[*,lb:ub],dimension=1),yrange=yrange,xthick=2,ythick=2,thick=3,/xs,/ys,ytitle="!6Amplitude (Jy)",xtitle="!6Time (s)",xtickformat='(I)'  ;bgps.ac_bolos[0,lb:ub]*bgps.scale_coeffs[0,0]
    oplot,xax,bgps.ac_bolos[1,lb:ub]*bgps.scale_coeffs[0,1],psym=10,color=250,thick=3
    oplot,xax,bgps.ac_bolos[2,lb:ub]*bgps.scale_coeffs[0,2],psym=10,color=150,thick=3
    ;multiplot,/reset

    device,/close_file

    set_plot,'x'


    ;stop

    ; ; also should plot before/after boloflat for each bolo
    ; plot,total(polysubbed[*,lb:ub],2)/total(polysubbed[*,lb:ub])
    ; oplot,total(boloflatted[*,lb:ub],2)/total(boloflatted[*,lb:ub])

end




    




