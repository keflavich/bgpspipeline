function measure_cube,map,xcen,ycen,xsize,ysize,ellipse=ellipse,drange=drange,aperture=aperture
    ; all units in pixels!
    if ~keyword_set(drange) then drange = 1.0 ; how big a circle? drange=1 -> radius=2sigma
    xl = floor(max([0,xcen-xsize*drange]))
    xu = floor(min([n_e(map[*,0])-1,xcen+xsize*drange]))
    yl = floor(max([0,ycen-ysize*drange]))
    yu = floor(min([n_e(map[0,*])-1,ycen+ysize*drange]))

    size3 = (size(map,/dim))[2]

    sums = fltarr(size3)
    for jj=0,size3-1 do begin
        box = map[xl:xu,yl:yu,jj]
        if keyword_set(ellipse) then begin
            mapsize = size(box,/dim)
            distmap = dist(mapsize[0],mapsize[1])
            xdist = shift(distmap[*,0],xcen-xl) # (fltarr(mapsize[1])+1)
            ydist = (fltarr(mapsize[0])+1) # shift(distmap[0,*],ycen-yl) 
            if keyword_set(aperture) then begin
                rad = sqrt((xdist)^2+(ydist)^2)
                mask = rad lt aperture
            endif else begin
                rad = sqrt((xdist/xsize)^2+(ydist/ysize)^2)
                mask = rad lt drange
            endelse
            sumbox = box * mask
        endif else begin
            sumbox = box
        endelse
        sums[jj] = total(sumbox,/nan)
    endfor

    return,sums
end

; for i=70,n_e(xwidth)-1 do print,xwidth[i],total(map1[xcen[i]-xwidth[i]:xcen[i]+xwidth[i],ycen[i]-ywidth[i]:ycen[i]+ywidth[i]],/nan),total(map2[xcen[i]-xwidth[i]:xcen[i]+xwidth[i],ycen[i]-ywidth[i]:ycen[i]+ywidth[i]],/nan)
; for i=0,n_e(xwidth)-1 do print,xwidth[i],measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do print,xwidth[i],measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i]),measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do print,xwidth[i]*7.2,measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])
; for i=0,n_e(xwidth)-1 do frac[i]=measure_box(map2,xcen[i],ycen[i],xwidth[i],ywidth[i])/measure_box(map1,xcen[i],ycen[i],xwidth[i],ywidth[i])

