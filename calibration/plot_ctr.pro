
pro plot_ctr,ctrfile,rotang=rotang,scale=scale,overplot=overplot,_extra=_extra
    
    readcol,ctrfile,bolonum,b,c,d,e,x,y,h,comment="#;",format="(I, F, F, F, F, F, F, F)",/silent

    if keyword_set(rotang) then begin
        xx = x
        yy = y
        x =   xx * cos(rotang) + yy * sin(rotang)
        y = - xx * sin(rotang) + yy * cos(rotang)
;        distance = sqrt(x^2+y^2)
;        angle    = atan(y,x)
;        x = distance * cos(angle-rotang)
;        y = distance * sin(angle-rotang)
;        stop
    endif
    if keyword_set(scale) then begin
        x /= scale
        y /= scale
    endif

    xrange=[min(x),max(x)]
    yrange=[min(y),max(y)]

    if keyword_set(overplot) then oplot,x,y,psym=3,_extra=_extra $
    else plot,x,y,psym=3,xrange=xrange,yrange=yrange,_extra=_extra
    oplot,[0,x[0]],[0,y[0]],_extra=_extra

    xyouts,x,y,strc(bolonum),_extra=_extra

end



