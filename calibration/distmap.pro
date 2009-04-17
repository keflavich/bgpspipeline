; distortion mapping wrapper
; takes in a single observation and an output beam locations filename
; calculates the bolometer location
; you can get the map array back by passing the 'allmap' parameter
pro distmap,filename,outfile,allmap=allmap,fitmap=fitmap,check=check,fromsave=fromsave,doplot=doplot,$
    fixscale=fixscale,fixgrid=fixgrid,doatv=doatv,out_fits_shifted=out_fits_shifted,flagbolos=flagbolos,$
    nofit=nofit,fixcenter=fixcenter,_extra=_extra

    if n_e(out_fits_shifted) eq 0 then out_fits_shifted=1
    if n_e(fixscale) eq 0 then fixscale=1
    if n_e(nofit) eq 0 then nofit=1
    if n_e(flagbolos) eq 0 then flagbolos=1

    total_bolos = 144 

    if keyword_set(fromsave) then restore,outfile+".sav" else begin
        distmap_centroids,filename,outfile,doplot=doplot,doatv=doatv,allmap=allmap,fitmap=fitmap,$
            meas=meas,nominal=nominal,coordsys='radec',projection='TAN',distcor=0,_extra=_extra
    endelse

    ;BEGIN FLAGGING BAD BOLOS
    residual = sqrt(total((meas.xyoffs)^2,2))
    bad_r = where(residual gt mean(residual) + 3*stddev(residual) or residual gt 1) ; don't allow a full bolometer spacing movement
    
    if keyword_set(flagbolos) then begin
        if bad_r[0] ne -1 then begin
            meas.rth[bad_r,*] = 0
            print,"Bad bolos: ",meas.bolo_indices[bad_r]
        endif 

        if bad_r[0] ne -1 then meas.rth[bad_r,*] = 0
    endif

    ; assume pointing center is already correct (pointing models were calculated w/o beam locations)
    if keyword_set(fixcenter) then begin
        meas.xyoffs[*,0] -= median(meas.xyoffs[*,0])
        meas.xyoffs[*,1] -= median(meas.xyoffs[*,1])
        meas.xy[*,0] = nominal.xy[*,0] - meas.xyoffs[*,0]
        meas.xy[*,1] = nominal.xy[*,1] - meas.xyoffs[*,1]
        meas.rth[*,0] = sqrt((meas.xy[*,0]*nominal.dec_conversion)^2+meas.xy[*,1]^2)
        meas.rth[*,1] = atan(-meas.xy[*,1],-meas.xy[*,0]*nominal.dec_conversion)-nominal.angle
    endif

    ; WRITE BOLOMETER POSITIONS TO TEXT FILE
    openw,outf,outfile+".txt",/get_lun
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
        meas=meas2,nominal=nominal2,coordsys='radec',projection='TAN',distcor=outfile+".txt",_extra=_extra

    if keyword_set(doplot) then begin
        loadct,39,/silent
        if total(meas.rth[*,0] eq 0) gt 0 then meas.rth[where(meas.rth[*,0] eq 0),0] = !values.f_nan
        plot,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),psym=7,xrange=[-7,7],yrange=[-7,7]
        xyouts,nominal.rth[*,0]*cos(nominal.rth[*,1]),nominal.rth[*,0]*sin(nominal.rth[*,1]),strc(meas.bolo_indices)
        xyouts,nominal.xy[*,0],nominal.xy[*,1],strc(meas.bolo_indices)
; ...        xyouts,-3600/38.5*(bgps.ra_map[*,0]-median(bgps.ra_map[*,0])),(bgps.dec_map[*,0]-median(bgps.dec_map[*,0]))*3600/38.5,strc(meas.bolo_indices)
        xyouts,meas.rth[*,0]*cos(meas.rth[*,1]),meas.rth[*,0]*sin(meas.rth[*,1]),strc(meas.bolo_indices),color=250
        oplot,[0,nominal.rth[0,0]*cos(nominal.rth[0,1])],[0,nominal.rth[0,0]*sin(nominal.rth[0,1])]
        oplot,[0,meas.rth[0,0]*cos(meas.rth[0,1])],[0,meas.rth[0,0]*sin(meas.rth[0,1])],color=250
    endif
    
    if keyword_set(check) then stop

end
