
pro average_beamloc,infile,outfile,blarr=blarr,doplot=doplot,check=check
    
    readcol,infile,infilelist,format="(A80)",/silent

    ninfiles=n_e(infilelist)
    BLarr = fltarr(144,3,ninfiles)

    for i=0,n_e(infilelist)-1 do begin
        readcol,infilelist[i],bolonum,bolodist,boloang,err,comment="#;",format="(I, F, F, F)",/silent
        BLarr[*,0,i] = bolodist
        BLarr[*,1,i] = boloang
        BLarr[*,2,i] = err
        if keyword_set(doplot) then begin
            if i eq 0 then plot,bolodist*cos(boloang*!pi/180),bolodist*sin(boloang*!pi/180),xrange=[-7,7],yrange=[-7,7],psym=3,color=255-(i+1)*20,xtickinterval=1,ytickinterval=1 $
            else oplot,bolodist*cos(boloang*!pi/180),bolodist*sin(boloang*!pi/180),psym=3,color=255-(i+1)*20
        endif
    endfor

    BLarr[where(BLarr eq 0)] = !values.f_nan

    bldist = reform(blarr[*,0,*])
    blangles = reform(BLarr[*,1,*])
    if total(blangles lt -180) gt 0 then blangles[where(blangles lt -180)] =  blangles[where(blangles lt -180)]+360

    means = fltarr(144,3)
    means[*,0] = median(reform(blarr[*,0,*]),dim=2)
    means[*,1] = median(reform(blangles),dim=2) 
    means[*,2] = median(reform(blarr[*,2,*]),dim=2)

    stds = fltarr(144,3)
    stds[*,0] = stddevaxis(reform(blarr[*,0,*]),dim=2,/mad) 
    stds[*,1] = stddevaxis(reform(blangles),dim=2,/mad)     
    stds[*,2] = stddevaxis(reform(blarr[*,2,*]),dim=2,/mad) 
    
    lower_threshold = rebin((means-stds),[144,3,ninfiles])
    upper_threshold = rebin((means+stds),[144,3,ninfiles])
    blarr[*,1,*] = blangles

    baddist = reform((blarr[*,0,*] lt lower_threshold[*,0,*]) or (blarr[*,0,*] gt upper_threshold[*,0,*]))
    badangle = reform((blarr[*,1,*] lt lower_threshold[*,1,*]) or (blarr[*,1,*] gt upper_threshold[*,1,*]))
    bad = baddist+badangle+finite(bldist,/nan)+finite(blangles,/nan)
    whbad = where(bad)
    ngood = total(bad eq 0,2)

    bldist = reform(blarr[*,0,*])
    blangles = reform(BLarr[*,1,*])
    blrms = reform(blarr[*,2,*])
    bldist[whbad] = !values.f_nan
    blangles[whbad] = !values.f_nan
    blrms[whbad] = !values.f_nan

    outbl = fltarr(144,3)
    outbl[*,0] = total(bldist,2,/nan)/ngood ; total( reform(blarr[*,0,*]/blarr[*,2,*]) , 2,/nan) / total(1/reform(blarr[*,2,*]),2,/nan) ; median(reform(blarr[*,0,*]),dim=2) ;
    outbl[*,1] = total(blangles,2,/nan)/ngood             ; total( blangles/reform(blarr[*,2,*]) , 2,/nan) / total(1/reform(blarr[*,2,*]),2,/nan) ;     median(reform(blangles),dim=2) ;
    outbl[*,2] = total(blrms,2,/nan)/ngood ; total(reform(blarr[*,2,*]),2,/nan) / total(finite(reform(blarr[*,2,*])),/nan) ;             median(reform(blarr[*,2,*]),dim=2) ;

    if keyword_set(doplot) then oplot,outbl[*,0]*cos(outbl[*,1]*!pi/180),outbl[*,0]*sin(outbl[*,1]*!pi/180),psym=1

;    outbl[where(finite(outbl,/nan))] = 0

    openw,outf,outfile,/get_lun
    printf,outf,"# Bolometer r theta residual^2"
    for i=0,143 do begin
        printf,outf,i,outbl[i,0],outbl[i,1],outbl[i,2]
    endfor
    close,outf
    free_lun,outf

    if keyword_set(check) then stop

end
