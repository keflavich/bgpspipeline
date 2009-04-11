; distortion mapping wrapper
; takes in a single observation and an output beam locations filename
; calculates the bolometer location
; you can get the map array back by passing the 'allmap' parameter
pro distmap,filename,outfile,allmap=allmap,fitmap=fitmap,check=check,fromsave=fromsave,doplot=doplot,$
    fixscale=fixscale,fixgrid=fixgrid,doatv=doatv,out_fits_shifted=out_fits_shifted,flagbolos=flagbolos,$
    nofit=nofit,_extra=_extra

    if n_e(out_fits_shifted) eq 0 then out_fits_shifted=1
    if n_e(fixscale) eq 0 then fixscale=1
    if n_e(nofit) eq 0 then nofit=1
    if n_e(flagbolos) eq 0 then flagbolos=1

    total_bolos = 144 

    if keyword_set(fromsave) then restore,outfile+".sav" else begin
        distmap_centroids,filename,outfile,doplot=doplot,doatv=doatv,allmap=allmap,fitmap=fitmap,$
            meas=meas,nominal=nominal,coordsys='radec',projection='TAN',_extra=_extra
    endelse

    ;BEGIN FLAGGING BAD BOLOS
    residual = (nominal.xy-meas.xy)^2
    bad_r = where(residual gt mean(residual) + 3*stddev(residual) or residual gt 1) ; don't allow a full bolometer spacing movement
    
    ; make angles all in the range -pi to pi
;    theta_pos = meas.rth[*,1]
;    if total(theta_pos lt -!dpi) gt 0 then theta_pos[where(theta_pos lt -!dpi)] = theta_pos[where(theta_pos lt -!dpi)]+2*!dpi

;    residang = (nominal.rth[*,1]-theta_pos)^2
;    bad_th = where(residang gt mean(residang) + 5*stddev(residang) or residang gt 1) ; stupid but gt 1 radian is HUGE and not OK

    if keyword_set(flagbolos) then begin
        if bad_r[0] ne -1 then begin
            meas.rth[bad_r,*] = 0
            print,"Bad bolos: ",meas.bolo_indices[bad_r]
        endif 

;        if bad_th[0] ne -1 then begin
;            meas.rth[bad_th,*] = 0
;            print," Angle: ",meas.bolo_indices[bad_th]
;        endif
        ; END FLAGGING BAD BOLOS

;        if bad_th[0] ne -1 then meas.rth[bad_th,*] = 0
        if bad_r[0] ne -1 then meas.rth[bad_r,*] = 0
    endif

    ; WRITE BOLOMETER POSITIONS TO TEXT FILE
    openw,outf,outfile+".txt",/get_lun
;    printf,outf,"# Array params (scaleX,scaleY,xoff,yoff,angle): ",strc(p[0:2]),strc(p[4]),strc(p[3]/!dtor),format="(A50,F13.4,F13.4,F13.4,F15.4,F15.4)"
    printf,outf,"# Bolometer r theta residual^2"
    j=0
    for i=0,n_e(meas.angle)-1 do begin
        while j lt meas.bolo_indices[i] do begin
            printf,outf,j,0,0,0
            j=j+1
        endwhile
        if residual[i,0] gt 1 or meas.rth[i,0] eq 0 then printf,outf,j,0,0,0 $
           else  printf,outf,j,meas.rth[i,0],meas.rth[i,1]/!dtor,residual[i,0]
        j=j+1
    endfor
    while j lt total_bolos do begin
        printf,outf,j,0,0,0
        j=j+1
    endwhile

    close,outf
    free_lun,outf

    distmap_centroids,filename,outfile+"_distcor",doplot=doplot,doatv=doatv,allmap=allmap,fitmap=fitmap,$
        meas=meas,nominal=nominal,coordsys='radec',projection='TAN',distcor=outfile+".txt",_extra=_extra

    if keyword_set(doplot) then begin
        loadct,39,/silent
        if total(meas.rth[*,0] eq 0) gt 0 then meas.rth[where(meas.rth[*,0] eq 0),0] = !values.f_nan
        plot,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        xyouts,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),strc(meas.bolo_indices)
        xyouts,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),strc(meas.bolo_indices),color=250
        oplot,[0,nominal.rth[0,0]*cos(nominal.rth[0,1])],[0,nominal.rth[0,0]*sin(nominal.rth[0,1])]
        oplot,[0,meas.rth[0,0]*cos(meas.rth[0,1])],[0,meas.rth[0,0]*sin(meas.rth[0,1])],color=250
    endif
    
    if keyword_set(check) then stop

end


;        xyouts,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),strc(meas.bolo_indices)
    ;    oplot,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),psym=1,color=150
;        xyouts,bestfit3[*,0]*cos(bestfit3[*,1]),bestfit3[*,0]*sin(bestfit3[*,1]),strc(meas.bolo_indices),color=150

;        xyouts,meas.xy[*,0],meas.xy[*,1],strc(meas.bolo_indices),color=100

;        for i=0,nbolos-1 do oplot,[nominal.rth[i,0]*cos(nominal.rth[i,1]),meas.rth[i,0]*cos(meas.rth[i,1])],[nominal.rth[i,0]*sin(nominal.rth[i,1]),meas.rth[i,0]*sin(meas.rth[i,1])]
;        for i=0,143 do oplot,[nominal.rth[i,0]*cos(nominal.rth[i,1]),rtn[i,0]*cos(rtn[i,1])],[nominal.rth[i,0]*sin(nominal.rth[i,1]),rtn[i,0]*sin(rtn[i,1])],color=250
;        oplot,[0,rtn[0,0]*cos(rtn[0,1])],[0,rtn[0,0]*sin(rtn[0,1])]

;    plot,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
;    xyouts,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),strc(indgen(total_bolos))
;
;    oplot,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),psym=1,color=150
;    xyouts,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),strc(indgen(total_bolos)),color=250
;    xyouts,bestfit_xy[*,0],bestfit_xy[*,1],strc(meas.bolo_indices),color=50
