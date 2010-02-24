function add_source,blank_map,xcen,ycen,xsize,ysize,amplitude,angle

; this simple version is superior in terms of readability, but can be slow for
; very large maps
;    r = shift(dist(mapstr.blank_map_size),xcen,ycen)
;    x = indgen(mapstr.blank_map_size(0)) # (intarr(mapstr.blank_map_size(1))+1)
;    y = (intarr(mapstr.blank_map_size(0))+1) # (indgen(mapstr.blank_map_size(1)))
;
;    xxcen = xcen * cos(angle) - ycen * sin(angle)
;    yycen = xcen * sin(angle) + ycen * cos(angle)
;
;    xx = x * cos(angle) - y * sin(angle)
;    yy = x * sin(angle) + y * cos(angle)
;
;    g = amplitude*exp(-(xx-xxcen)^2/(2*xsize^2)-(yy-yycen)^2/(2*ysize^2))

    xtop = n_e(blank_map[*,0])
    ytop = n_e(blank_map[0,*])
    if xcen ge xtop or ycen ge ytop then return,0
    if xsize lt 1 or ysize lt 1 then return,0

    nx = max([floor(abs(xsize*cos(angle)-ysize*sin(angle))),floor(xsize)])*12
    ny = max([floor(abs(xsize*sin(angle)+ysize*cos(angle))),floor(ysize)])*12

;    xxcen = xcen * cos(angle) - ycen * sin(angle)
;    yycen = xcen * sin(angle) + ycen * cos(angle)
    xxcen = xcen
    yycen = ycen

    x = indgen(nx) # (intarr(ny)+1)   + xxcen-nx/2
    y = (intarr(nx)+1) # (indgen(ny)) + yycen-ny/2

    xx = (x-xcen) * cos(angle) - (y-ycen) * sin(angle)
    yy = (x-xcen) * sin(angle) + (y-ycen) * cos(angle)

    g = amplitude*exp(-(xx)^2/(2*xsize^2)-(yy)^2/(2*ysize^2))

    bm = blank_map
    if floor(xxcen)-nx/2 lt 0 then begin xl=0 & gxl = nx/2-floor(xxcen) & endif else begin xl = floor(xxcen)-nx/2 & gxl=0 & endelse
    if floor(xxcen)+nx/2 ge xtop then begin xu=xtop-1 & gxu = xtop-xl-1+gxl & endif else begin xu = floor(xxcen)+nx/2-1 & gxu=nx-1 & endelse
    if floor(yycen)-ny/2 lt 0 then begin yl=0 & gyl = ny/2-floor(yycen) & endif else begin yl = floor(yycen)-ny/2 & gyl=0 & endelse
    if floor(yycen)+ny/2 ge ytop then begin yu=ytop-1 & gyu = ytop-yl-1+gyl & endif else begin yu = floor(yycen)+ny/2-1 & gyu=ny-1 & endelse
    bm[xl:xu,yl:yu] = g[gxl:gxu,gyl:gyu]

;    timestream += bm[mapstr.ts]
    
;    if keyword_set(map) then map += bm else map=bm

    return,bm

end





