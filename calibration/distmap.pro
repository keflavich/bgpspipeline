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

    p = [1.0,0.0,0.0,0.0,1.0,0.0] ; xscale,xoff,yoff,rotation,yscale,stretch_angle

    ; set limits on parameters
    parinfo = replicate({fixed:0.,limited:[0.,0.],limits:[0.,0.]},6)
    if keyword_set(fixscale) then begin
        print,"USING FIXED SCALE"
        parinfo[0].fixed = 1  ; x scale
        parinfo[4].fixed = 1  ; y scale 
        parinfo[5].fixed = 1  ; stretch (scale) angle
    endif
    parinfo[0].limited=[1,1]
    parinfo[0].limits=[.5,1.5]
    parinfo[4].limited=[1,1]
    parinfo[4].limits=[.5,1.5]
    parinfo[3].limited=[1,1]
    parinfo[3].limits=[0,2*!pi]
    parinfo[5].limited=[1,1]
    parinfo[5].limits=[0,2*!pi]

    nominal.rth[where(nominal.rth[*,1] gt !pi),1] -= 2*!pi             ;force -pi<theta<pi
    angle_guess = mean(abs(nominal.rth[*,1] - meas.rth[*,1]))

    xy2 = hex_grid_fit_func(nominal.rth,[1,0,0,angle_guess,1,0])
    xoff_guess = mean(meas.xy[*,0]-xy2[*,0])
    yoff_guess = mean(meas.xy[*,1]-xy2[*,1])

    invweight = nominal.rth*0+1
    invweight *= (nominal.rth[*,0]^2 # [1,1]) ; weight by 1/(distance from center)^2

    if keyword_set(nofit) then begin
        bestfit_rth = meas.rth
    endif else begin
        ; after going through a slew of confusing and ineffective geometries, this finally seems to work...
        p2 = [1.,0.,0.,angle_guess,1.,0]
        ; find improved guess by fitting fixed grid to measured data
        p2 = mpfitfun('hex_grid_fit_func',nominal.rth,meas.xy,invweight,p2,yfit=bestfit_xy,/quiet,parinfo=parinfo) 
        p = p2
        ; use improved guess to fit data to fixed grid
        p = mpfitfun('inv_hex_gff',meas.xy,nominal.rth,invweight,p,yfit=bestfit_rth,/quiet,parinfo=parinfo)
    endelse

    bestfit_xy_2 = [[bestfit_rth[*,0]*cos(bestfit_rth[*,1])] ,$
        [bestfit_rth[*,0]*sin(bestfit_rth[*,1])] ]

;    polypars = [ 0 ]
;    polypars_fit = mpfitfun('poly2d_mar03',bestfit_xy_2,nominal.xy,invweight*0+1,polypars,yfit=polyfit_xy,/quiet)
;    polypars_fit = mpfitfun('poly2d_mar03',nominal.xy,bestfit_xy_2,invweight*0+1,polypars,yfit=polyfit_xy,/quiet)
;
;    stop

    
    ;BEGIN FLAGGING BAD BOLOS
    residual = (nominal.rth[*,0]-bestfit_rth[*,0])^2
    bad_r = where(residual gt mean(residual) + 3*stddev(residual) or residual gt 1) ; don't allow a full bolometer spacing movement
    
    ; make angles all in the range -pi to pi
    theta_pos = bestfit_rth[*,1]
    if total(theta_pos lt -!dpi) gt 0 then theta_pos[where(theta_pos lt -!dpi)] = theta_pos[where(theta_pos lt -!dpi)]+2*!dpi
;    theta_pos[where(sign(theta_pos) ne sign(nominal.rth[*,1]))] *= -1  ; I think this is a hack....

    residang = (nominal.rth[*,1]-theta_pos)^2
    bad_th = where(residang gt mean(residang) + 3*stddev(residang) or residang gt 1) ; stupid but gt 1 radian is HUGE and not OK

    if keyword_set(flagbolos) then begin
        if bad_r[0] ne -1 then begin
            bestfit_rth[bad_r,*] = 0
            invweight[bad_r] = 1e5
            print,"Bad bolos: ",meas.bolo_indices[bad_r]
        endif 

        if bad_th[0] ne -1 then begin
            bestfit_rth[bad_th,*] = 0
            invweight[bad_th] = 1e5
            print," Angle: ",meas.bolo_indices[bad_th]
        endif
        ; END FLAGGING BAD BOLOS

        ; REFIT with bad bolos flagged out
        if ~keyword_set(nofit) then p = mpfitfun('inv_hex_gff',meas.xy,nominal.rth,invweight,p,yfit=bestfit_rth,/quiet,parinfo=parinfo)
        if bad_th[0] ne -1 then bestfit_rth[bad_th,*] = 0
        if bad_r[0] ne -1 then bestfit_rth[bad_r,*] = 0
    endif

    ; Uncomment this code to fit a fixed array shape to the measured distortion.
    ; Individual bolometers will not move from the fixed grid pattern.
    if keyword_set(fixgrid) then begin
        print,"FITTING FIXED GRID"
        p3 = p
        p3[1:3] = 0 ; don't allow shift
        newxy = hex_grid_fit_func(nominal.rth,p3)
        bestfit_rth = inv_hex_gff(newxy,[1,0,0,0,1,0])
        if bad_th[0] ne -1 then bestfit_rth[bad_th,*] = 0
        if bad_r[0] ne -1 then bestfit_rth[bad_r,*] = 0
    endif

    print,p,total(residual),total(residang)

    ; WRITE BOLOMETER POSITIONS TO TEXT FILE
    openw,outf,outfile+".txt",/get_lun
    printf,outf,"# Array params (scaleX,scaleY,xoff,yoff,angle): ",strc(p[0:2]),strc(p[4]),strc(p[3]/!dtor),format="(A50,F13.4,F13.4,F13.4,F15.4,F15.4)"
    printf,outf,"# Bolometer r theta residual^2"
    j=0
    for i=0,n_e(meas.angle)-1 do begin
        while j lt meas.bolo_indices[i] do begin
            printf,outf,j,0,0,0
            j=j+1
        endwhile
        if residual[i,0] gt 1 or bestfit_rth[i,0] eq 0 then printf,outf,j,0,0,0 $
           else  printf,outf,j,bestfit_rth[i,0],bestfit_rth[i,1]/!dtor,residual[i,0]
        j=j+1
    endfor
    while j lt total_bolos do begin
        printf,outf,j,0,0,0
        j=j+1
    endwhile

    close,outf
    free_lun,outf

    if keyword_set(out_fits_shifted) then begin
        openw,outf,outfile+"_bolofits_shifted.txt",/get_lun
        printf,outf,"Bolometer number","background","amplitude","sigma_x","sigma_y","xcen","ycen","angle",format='(8A20)'
        for i=0,n_e(meas.bolo_indices)-1 do begin
            printf,outf,meas.bolo_indices[i],meas.backgr[i],meas.ampl[i],meas.xysize[i,*],bestfit_xy_2[i,*],meas.angle[i],format='(8F20)'
        endfor
        close,outf
        free_lun,outf
    endif


    if keyword_set(doplot) then begin
        loadct,39,/silent
        if total(bestfit_rth[*,0] eq 0) gt 0 then bestfit_rth[where(bestfit_rth[*,0] eq 0),0] = !values.f_nan
        plot,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        xyouts,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),strc(meas.bolo_indices)
        xyouts,bestfit_rth[*,0]*cos(bestfit_rth[*,1]),bestfit_rth[*,0]*sin(bestfit_rth[*,1]),strc(meas.bolo_indices),color=250
        oplot,[0,nominal.rth[0,0]*cos(nominal.rth[0,1])],[0,nominal.rth[0,0]*sin(nominal.rth[0,1])]
        oplot,[0,bestfit_rth[0,0]*cos(bestfit_rth[0,1])],[0,bestfit_rth[0,0]*sin(bestfit_rth[0,1])],color=250
    endif
    
    if keyword_set(check) then stop

end


;        xyouts,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),strc(meas.bolo_indices)
    ;    oplot,bestfit_rth[*,0]*cos(bestfit_rth[*,1]),bestfit_rth[*,0]*sin(bestfit_rth[*,1]),psym=1,color=150
;        xyouts,bestfit3[*,0]*cos(bestfit3[*,1]),bestfit3[*,0]*sin(bestfit3[*,1]),strc(meas.bolo_indices),color=150

;        xyouts,meas.xy[*,0],meas.xy[*,1],strc(meas.bolo_indices),color=100

;        for i=0,nbolos-1 do oplot,[nominal.rth[i,0]*cos(nominal.rth[i,1]),bestfit_rth[i,0]*cos(bestfit_rth[i,1])],[nominal.rth[i,0]*sin(nominal.rth[i,1]),bestfit_rth[i,0]*sin(bestfit_rth[i,1])]
;        for i=0,143 do oplot,[nominal.rth[i,0]*cos(nominal.rth[i,1]),rtn[i,0]*cos(rtn[i,1])],[nominal.rth[i,0]*sin(nominal.rth[i,1]),rtn[i,0]*sin(rtn[i,1])],color=250
;        oplot,[0,rtn[0,0]*cos(rtn[0,1])],[0,rtn[0,0]*sin(rtn[0,1])]

;    plot,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
;    xyouts,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),strc(indgen(total_bolos))
;
;    oplot,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),psym=1,color=150
;    xyouts,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),strc(indgen(total_bolos)),color=250
;    xyouts,bestfit_xy[*,0],bestfit_xy[*,1],strc(meas.bolo_indices),color=50
