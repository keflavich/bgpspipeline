; distortion mapping wrapper
; takes in a single observation and an output beam locations filename
; calculates the bolometer location
; you can get the map array back by passing the 'allmap' parameter
pro distmap,filename,outfile,allmap=allmap,fitmap=fitmap,check=check,fromsave=fromsave,doplot=doplot,$
    fixscale=fixscale,fixgrid=fixgrid,doatv=doatv,_extra=_extra

    total_bolos = 144 

    if keyword_set(fromsave) then restore,outfile+".sav" else begin
        ncdf_varget_scale,filename,'bolo_params',bolo_params
        radius = reform(bolo_params[2,*])
        theta =  reform(bolo_params[1,*])
        rtheta = [[radius],[theta*!dtor]] ;fltarr(total_bolos,2)

        ; larger pixel size selected for mapping to reduce blank pixels
        pixsize=10.0

        thefiles = [filename]
        readall_pc,thefiles,bgps_struct=bgps,bolo_indices=bolo_indices,bolo_params=bolo_params,$
            pointing_model=0,/nobeamloc,_extra=_extra

        ; some pca subtraction is necessary to clean up the image for fitting
        pca_subtract,bgps.ac_bolos,13,uncorr_part=new_astro
        if total(bgps.flags) gt 0 then new_astro[where(bgps.flags)] = 0

        ; makes a data cube with one map for each bolometer
        allmap = map_eachbolo(bgps.ra_map,bgps.dec_map,new_astro,bgps.scans_info,pixsize=pixsize,$
            blank_map=blank_map,hdr=hdr,$
            jd=bgps.jd,lst=bgps.lst,source_ra=bgps.source_ra,source_dec=bgps.source_dec,_extra=_extra)

        bolospacing = pixsize/38.5  ; arcseconds per pixel / arcseconds per bolospacing
        xcen = n_e(allmap[*,0,0])/2. ; assumes the center of the map is the pointing center.  This may be off by +/- .5 pixels
        ycen = n_e(allmap[0,*,0])/2. ; because of the frustrating error where not all bolometers have the same map size
                                    ; 3/20/09 - I'm pretty sure there's no such error

        fitmapcube = allmap*0

        nbolos = n_e(bolo_indices)
        xy = fltarr(nbolos,2) ; will store measured x,y positions 
        invweight = fltarr(nbolos,2) + 1
        chi2arr = fltarr(n_e(bolo_indices))

        if keyword_set(doplot) and doplot gt 1 then begin
            !p.multi=[0,5,5]
            set_plot,'ps'
            device,filename=outfile+"_boloplots.ps",/color,bits_per_pixel=16
            loadct,0
        endif

        openw,fitparfile,outfile+"_bolofits.txt",/get_lun
        printf,fitparfile,"Bolometer number","background","amplitude","sigma_x","sigma_y","xcen","ycen","angle",format='(8A20)'

        for i=0,n_e(allmap[0,0,*])-1 do begin

            ; centroid: background, amplitude, xwidth, ywidth, xcenter, ycenter, angle
            fitpars = centroid_map(allmap[*,*,i],perror=perror,fitmap=fitmap,pixsize=pixsize)
            fitmapcube[*,*,i] = fitmap
            chi2arr[i] = total((allmap[*,*,i]-fitmap)^2)/n_e(fitmap)

            xdist = (fitpars[4]-xcen)*bolospacing
            ydist = (fitpars[5]-ycen)*bolospacing
            err = sqrt(perror[4]^2+perror[5]^2)*bolospacing
            distance = sqrt(xdist^2+ydist^2)
            angle = atan(ydist,xdist)

            xy[i,0] = xdist
            xy[i,1] = ydist

            printf,fitparfile,bolo_indices[i],fitpars,format='(8F20)'
            if keyword_set(doatv) then begin ; plotting
                atv,allmap[*,*,i]
                atvxyouts,[fitpars[4]],[fitpars[5]],strc(bolo_indices[i]),charsize=4,color='red'
                atv_plot1ellipse,fitpars[2],fitpars[3],fitpars[4],fitpars[5],fitpars[6],color=250
            endif

            if keyword_set(doplot) and doplot gt 1 then begin
                loadct,0,/silent
                imdisp,reform(allmap[*,*,i]),erase=0,/axis
                loadct,39,/silent
                tvellipse,fitpars[2],fitpars[3],fitpars[4],fitpars[5],fitpars[6],color=250,/data
                tvellipse,fitpars[2]*2.35,fitpars[3]*2.35,fitpars[4],fitpars[5],fitpars[6],color=250,/data
            endif

        endfor
        device,/close_file

        rtf = rtheta[bolo_indices,*]

        fitmap=fitmapcube

        close,fitparfile
        free_lun,fitparfile 

        save,filename=outfile+".sav"
    endelse

    ; x,y nominal beam locations
    xybp = [[rtf[*,0]*cos(rtf[*,1])],[rtf[*,0]*sin(rtf[*,1])]]

    ; x,y->r,th measured
    rth_meas = xy
    rth_meas[*,0] = sqrt(xy[*,0]^2+xy[*,1]^2)
    rth_meas[*,1] = atan(xy[*,1],xy[*,0])

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

    rtf[where(rtf[*,1] gt !pi),1] -= 2*!pi             ;force -pi<theta<pi
    angle_guess = mean(abs(rtf[*,1] - rth_meas[*,1]))

    xy2 = hex_grid_fit_func(rtf,[1,0,0,angle_guess,1,0])
    xoff_guess = mean(xy[*,0]-xy2[*,0])
    yoff_guess = mean(xy[*,1]-xy2[*,1])

    invweight *= (rtf[*,0]^2 # [1,1]) ; ARGH I HATE IDL WHY WOULD YOU TRUNCATE MY ARRAY?!

; after going through a slew of confusing and ineffective geometries, this finally seems to work...
    p2 = [1.,0.,0.,angle_guess,1.,0]
    ; find improved guess by fitting fixed grid to measured data
    p2 = mpfitfun('hex_grid_fit_func',rtf,xy,invweight,p2,yfit=bestfit2,/quiet,parinfo=parinfo) 
    p = p2
    ; use improved guess to fit data to fixed grid
    p = mpfitfun('inv_hex_gff',xy,rtf,invweight,p,yfit=bestfit,/quiet,parinfo=parinfo)
    
    ;BEGIN FLAGGING BAD BOLOS
    residual = (rtf[*,0]-bestfit[*,0])^2
    bad_r = where(residual gt mean(residual) + 3*stddev(residual) or residual gt 1) ; don't allow a full bolometer spacing movement
    if bad_r[0] ne -1 then begin
        bestfit[bad_r,*] = 0
        invweight[bad_r] = 1e5
        print,"Bad bolos: ",bolo_indices[bad_r]
    endif 

    ; make angles all in the range -pi to pi
    theta_pos = bestfit[*,1]
    if total(theta_pos lt -!dpi) gt 0 then theta_pos[where(theta_pos lt -!dpi)] = theta_pos[where(theta_pos lt -!dpi)]+2*!dpi
;    theta_pos[where(sign(theta_pos) ne sign(rtf[*,1]))] *= -1  ; I think this is a hack....

    residang = (rtf[*,1]-theta_pos)^2
    bad_th = where(residang gt mean(residang) + 3*stddev(residang) or residang gt 1) ; stupid but gt 1 radian is HUGE and not OK
    if bad_th[0] ne -1 then begin
        bestfit[bad_th,*] = 0
        invweight[bad_th] = 1e5
        print," Angle: ",bolo_indices[bad_th]
    endif
    ; END FLAGGING BAD BOLOS

    ; REFIT with bad bolos flagged out
    p = mpfitfun('inv_hex_gff',xy,rtf,invweight,p,yfit=bestfit,/quiet,parinfo=parinfo)
    if bad_th[0] ne -1 then bestfit[bad_th,*] = 0
    if bad_r[0] ne -1 then bestfit[bad_r,*] = 0

    ; Uncomment this code to fit a fixed array shape to the measured distortion.
    ; Individual bolometers will not move from the fixed grid pattern.
    if keyword_set(fixgrid) then begin
        print,"FITTING FIXED GRID"
        p3 = p
        p3[1:3] = 0 ; don't allow shift
        newxy = hex_grid_fit_func(rtf,p3)
        bestfit = inv_hex_gff(newxy,[1,0,0,0,1,0])
        if bad_th[0] ne -1 then bestfit[bad_th,*] = 0
        if bad_r[0] ne -1 then bestfit[bad_r,*] = 0
    endif

    print,p,total(residual),total(residang)

    ; WRITE BOLOMETER POSITIONS TO TEXT FILE
    openw,outf,outfile+".txt",/get_lun
    printf,outf,"# Array params (scaleX,scaleY,xoff,yoff,angle): ",strc(p[0:2]),strc(p[4]),strc(p[3]/!dtor),format="(A50,F13.4,F13.4,F13.4,F15.4,F15.4)"
    printf,outf,"# Bolometer r theta residual^2"
    j=0
    for i=0,nbolos-1 do begin
        while j lt bolo_indices[i] do begin
            printf,outf,j,0,0,0
            j=j+1
        endwhile
        if residual[i,0] gt 1 or bestfit[i,0] eq 0 then printf,outf,j,0,0,0 $
           else  printf,outf,j,bestfit[i,0],bestfit[i,1]/!dtor,residual[i,0]
        j=j+1
    endfor
    while j lt total_bolos do begin
        printf,outf,j,0,0,0
        j=j+1
    endwhile

    close,outf
    free_lun,outf

    if keyword_set(doplot) then begin
        loadct,39
        if total(bestfit[*,0] eq 0) gt 0 then bestfit[where(bestfit[*,0] eq 0),0] = !values.f_nan
        plot,rtf[*,0]*cos(rtf[*,1]),rtf[*,0]*sin(rtf[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        xyouts,rtf[*,0]*cos(rtf[*,1]),rtf[*,0]*sin(rtf[*,1]),strc(bolo_indices)
        xyouts,bestfit[*,0]*cos(bestfit[*,1]),bestfit[*,0]*sin(bestfit[*,1]),strc(bolo_indices),color=250
        oplot,[0,rtf[0,0]*cos(rtf[0,1])],[0,rtf[0,0]*sin(rtf[0,1])]
        oplot,[0,bestfit[0,0]*cos(bestfit[0,1])],[0,bestfit[0,0]*sin(bestfit[0,1])],color=250
    endif
    
    if keyword_set(check) then stop

end


;        xyouts,rth_meas[*,0]*cos(rth_meas[*,1]),rth_meas[*,0]*sin(rth_meas[*,1]),strc(bolo_indices)
    ;    oplot,bestfit[*,0]*cos(bestfit[*,1]),bestfit[*,0]*sin(bestfit[*,1]),psym=1,color=150
;        xyouts,bestfit3[*,0]*cos(bestfit3[*,1]),bestfit3[*,0]*sin(bestfit3[*,1]),strc(bolo_indices),color=150

;        xyouts,xy[*,0],xy[*,1],strc(bolo_indices),color=100

;        for i=0,nbolos-1 do oplot,[rtf[i,0]*cos(rtf[i,1]),bestfit[i,0]*cos(bestfit[i,1])],[rtf[i,0]*sin(rtf[i,1]),bestfit[i,0]*sin(bestfit[i,1])]
;        for i=0,143 do oplot,[rtf[i,0]*cos(rtf[i,1]),rtn[i,0]*cos(rtn[i,1])],[rtf[i,0]*sin(rtf[i,1]),rtn[i,0]*sin(rtn[i,1])],color=250
;        oplot,[0,rtn[0,0]*cos(rtn[0,1])],[0,rtn[0,0]*sin(rtn[0,1])]

;    plot,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
;    xyouts,rt[*,0]*cos(rt[*,1]),rt[*,0]*sin(rt[*,1]),strc(indgen(total_bolos))
;
;    oplot,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),psym=1,color=150
;    xyouts,bf[*,0]*cos(bf[*,1]),bf[*,0]*sin(bf[*,1]),strc(indgen(total_bolos)),color=250
;    xyouts,bestfit2[*,0],bestfit2[*,1],strc(bolo_indices),color=50
