function measure_box,map,xcen,ycen,xsize,ysize,ellipse=ellipse
    xl = floor(max([0,xcen-xsize]))
    xu = floor(min([n_e(map[*,0])-1,xcen+xsize]))
    yl = floor(max([0,ycen-ysize]))
    yu = floor(min([n_e(map[0,*])-1,ycen+ysize]))

    if keyword_set(ellipse) then begin
        mapsize = size(map,/dim)
        distmap = dist(mapsize[0],mapsize[1])
        xdist = shift(distmap[*,0],xcen) # (fltarr(mapsize[1])+1)
        ydist = (fltarr(mapsize[0])+1) # shift(distmap[0,*],ycen) 
        mask = ((xdist/xsize)^2+(ydist/ysize)^2) lt 1
        box = map * mask
    endif else begin
        mask = map*0
        mask[xl:xu,yl:yu] = 1
        box = map * mask
    endelse

    return,total(box,/nan)
end

; for i=70,n_e(xwidth)-1 do print,xwidth[i],total(map1[xcen[i]-xwidth[i]:xcen[i]+xwidth[i],ycen[i]-ywidth[i]:ycen[i]+ywidth[i]],/nan),total(map2[xcen[i]-xwidth[i]:xcen[i]+xwidth[i],ycen[i]-ywidth[i]:ycen[i]+ywidth[i]],/nan)
; for i=0,n_e(xwidth)-1 do print,xwidth[i],measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do print,xwidth[i],measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do print,xwidth[i]*7.2,measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do frac[i]=measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])
