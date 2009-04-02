

pro plot_beamfits,beamfile,overplot=overplot,numbers,_extra=_extra
    
    readcol,beamfile,bolonum,background,amplitude,xwidth,ywidth,xcen,ycen,angle,comment="#;",format="(I, F, F, F, F, F, F, F)",/silent

    if keyword_set(overplot) then tvellipse,xwidth,ywidth,xcen,ycen,angle,/data,_extra=_extra $
    else begin
        plot,xcen,ycen,psym=3,xrange=[-7,7],yrange=[-7,7],xtickinterval=1,ytickinterval=1,_extra=_extra
        tvellipse,xwidth,ywidth,xcen,ycen,angle,/data,_extra=_extra 
    endelse

    if keyword_set(numbers) then xyouts,xcen,ycen,strc(bolonum),_extra=_extra

end


