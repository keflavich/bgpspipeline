
pro plot_beamloc,beamfile,overplot=overplot,noxy=noxy,_extra=_extra
    
    readcol,beamfile,bolonum,bolodist,boloang,err,comment="#;",format="(I, F, F, F)",/silent

    goodbolos = where(bolodist ne 0)

    x = bolodist[goodbolos] * cos(boloang[goodbolos]/180*!dpi)
    y = bolodist[goodbolos] * sin(boloang[goodbolos]/180*!dpi)

    if keyword_set(overplot) then oplot,x,y,psym=3,_extra=_extra $
    else plot,x,y,psym=3,xrange=[-7,7],yrange=[-7,7],xtickinterval=1,ytickinterval=1,_extra=_extra
    oplot,[0,x[0]],[0,y[0]],_extra=_extra

    if ~keyword_set(noxy) then xyouts,x,y,strc(bolonum[goodbolos]),_extra=_extra

end


