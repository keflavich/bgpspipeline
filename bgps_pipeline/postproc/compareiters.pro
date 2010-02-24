; compare iterations: show flux as a function of iteration, prove convergence
;

forward_function extract_aperture

function compareiters,prefix,aplist,_extra=_extra
    mapcube = get_iter_mapcube(prefix)
    readcol,aplist,x,y,r,/silent
    nap = n_e(aplist)
    nf  = n_e(mapcube[0,0,*])
    flux = fltarr(nap,nf)
    for i=0,nap-1 do begin
        f[i,*] = extract_aperture_cube(mapcube,x[i],y[i],r[i])
    endfor
    return,f
end

function extract_aperture_cube,mapcube,x,y,r
    nf = n_e(mapcube[0,0,*])
    flux = fltarr(nf)
    for i=0,nf-1 do begin
        flux[i] = extract_aperture(mapcube[*,*,i],x,y,r,_extra=_extra)
    endfor
    return,flux
end

function get_iter_mapcube,prefix
    spawn,'ls '+prefix+'*.fits',filelist
    m = readfits(filelist[0],/silent)
    ms = size(m,/dim)
    nf = n_e(filelist)
    mapcube = fltarr(ms[0],ms[1],nf)
    for i=0,nf-1 do begin
        mapcube[*,*,i] = readfits(filelist[i],/silent)
    endfor
    return,mapcube
end

function extract_aperture,map,x,y,radius,inner_radius=inner_radius
    if n_e(inner_radius) eq 0 then inner_radius = 0
    nx = n_e(map[*,0])
    ny = n_e(map[0,*])
    d  = sqrt((replicate(1.,nx) # findgen(ny) -y)^2 + (findgen(nx) # replicate(1.,ny) - x)^2)
    wh = where(d lt radius and d ge inner_radius)
    return,total(map[wh],/nan)
end
