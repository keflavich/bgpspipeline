
function centroid_map,map,fitmap=fitmap,submap=submap,perror=perror,$
    dontconv=dontconv,pixsize=pixsize,measure_errors=measure_errors

    if ~keyword_set(pixsize) then pixsize=7.2
    fwhm = 31.2/pixsize & hwhm = fwhm / 2.
    IGNOREERROR=check_math()
    psf = psf_gaussian(npix=19,ndim=2,fwhm=hwhm,/norm)

    if total(finite(map,/nan)) gt 0 then map[where(finite(map,/nan))] = 0 

    ; centroiding is not easy because of source finding.  More robust source finding may be useful
;    x = floor(n_e(map[*,0])/2.)
;    y = floor(n_e(map[0,*])/2.)
;    xl = x - 20 ; x/2.  ; 20 pixels at 7"/pix is 140 arcseconds, which is huge but hopefully small enough to cut out anomolous high points
;    xh = x + 20 ; x/2.
;    yl = y - 20 ; y/2.
;    yh = y + 20 ; y/2.
;    submap = map[xl:xh,yl:yh]
;        m = max(submap,whmax)             ; old code used moment-based centroids
;        xm = whmax mod n_e(submap[*,0])   ; and used the x/y max as a 'guess'
;        ym = whmax / n_e(submap[*,0])  
    submap=map
    whneg = where(submap lt 0)
    if size(whneg,/dim) ne 0 then submap[whneg] = 0  ; force positive
    if keyword_set(dontconv) then csm = submap else csm = convolve(submap,psf)
    m = max(total(csm,2),xm)
    m = max(total(csm,1),ym)
    if n_e(measure_errors) eq 0 then measure_errors = (csm*0)+1.0
;        cntrd,submap,xm,ym,xcen,ycen,3.        ; relic of old code
;        gcntrd,submap,xm,ym,xcen,ycen,fwhm     ; one step up...
    zfit = mpfit2dpeak(csm,fitpars,/tilt,/gaussian,perror=perror,estimate=[median(csm),max(csm),hwhm,hwhm,xm,ym,0],measure_errors=measure_errors)
;    fitmap=map*0
;    fitmap[xl:xh,yl:yh] = zfit
    fitmap = zfit
    
;    fitpars[4]+=xl
;    fitpars[5]+=yl
    return,fitpars
end

