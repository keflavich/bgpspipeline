
pro ctr_to_distmap,ctrfile,outdistmap,obs_ap_file=obs_ap_file,array_params=array_params,rotang=rotang,scale=scale,overplot=overplot,_extra=_extra
    
    readcol,ctrfile,bolonum,DCoff,peakvolt,stdX,stdY,x,y,beamPA,comment="#;",format="(I, F, F, F, F, F, F, F)",/silent

    if keyword_set(obs_ap_file) then begin ; observation-specific array params file; VERY unfortunate naming scheme
        readcol,obs_ap_file,junk,ap,delimiter="=",format='(A,F)',/silent
        scale = ap[0]
        rotang = ap[2]*!dtor
        xoff = ap[4]
        yoff = ap[5]
    endif else begin
        xoff = 0
        yoff = 0
    endelse
    xx = x-xoff
    yy = y-yoff
    if keyword_set(array_params) then begin
;        if ~keyword_set(scale) then scale = array_params[0]*25.4/5.0
;        if keyword_set(rotang) then rotang -= array_params[2]*!dtor $
;            else rotang = array_params[2]*!dtor 
;      In the OP, they override the original array parameters
        scale  = array_params[0]*25.4/5.0
        rotang = array_params[2]*!dtor 
    endif
    if keyword_set(scale) then begin
        xx /= scale
        yy /= scale
    endif else scale = 1
    if keyword_set(rotang) then begin
        x =   xx * cos(rotang) + yy * sin(rotang)
        y = - xx * sin(rotang) + yy * cos(rotang)
    endif else rotang = 0

    distance = sqrt(x^2+y^2) 
    angle    = atan(y,x) 
    if max(angle) ge 2*!dpi then angle[where(angle gt 2*!dpi)] -= 2*!dpi

    openw,outf,outdistmap+".txt",/get_lun
    printf,outf,"# Bolometer r theta residual^2"
    j=0
    for i=0,143 do begin
        j = where(bolonum eq i)
        if j ne -1 then begin
           printf,outf,i,distance[j],angle[j]/!dtor,1.0,format="(I10,F20.5,F20.5,F20.5)"
       endif else printf,outf,i,0,0,0,format="(I10,F20.5,F20.5,F20.5)"
    endfor

    close,outf
    free_lun,outf

end



