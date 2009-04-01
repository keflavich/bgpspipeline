pro display_with_wcs,filename,sourcename=sourcename,sourceL=sourceL,sourceB=sourceB,negative=negative,_extra=_extra
    map = readfits(filename,hdr,/silent)

    crpix1 = sxpar(hdr,'CRPIX1')
    crpix2 = sxpar(hdr,'CRPIX2')
    crval1 = sxpar(hdr,'CRVAL1')
    crval2 = sxpar(hdr,'CRVAL2')
    cd1_1 = sxpar(hdr,'CD1_1')
    cd2_2 = sxpar(hdr,'CD2_2')

    x = lindgen(n_e(map[*,0]))
    y = lindgen(n_e(map[0,*]))
    l = (x-crpix1)*cd1_1+crval1
    if max(l) gt 360 then l-=360
    b = (y-crpix2)*cd2_2+crval2

    imdisp,map[*,20:*],/axis,xrange=[max(l),min(l)],yrange=[min(b[20:*]),max(b[20:*])],range=[-.5,4],$
        xtitle="Galactic Longitude",ytitle="Galactic Latitude",ticklen=.001,true=1,erase=0,negative=negative,_extra=_extra

    for i=0,n_e(sourcename)-1 do begin
        if sourceL[i] gt min(l) and sourceL[i] lt max(l) $
            and sourceB[i] gt min(b[20:*]) and sourceB[i] lt max(b[20:*]) then begin
            if keyword_set(negative) then textcolor=0 else textcolor=255
;            textcolor=255    
            xyouts,sourceL[i],sourceB[i],sourcename[i],alignment=0.5,charthick=2,color=textcolor
        endif
    endfor

end
