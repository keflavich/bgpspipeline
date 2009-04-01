function deconv_map, map_in, pixsize=pixsize, covar = covar, deconv = deconv , deconv_fwhm = deconv_fwhm ,$
    interactive=interactive,deconv_iter=deconv_iter,smoothmap=smoothmap

; Generate the PSF
if ~keyword_set(deconv_fwhm) then fwhm = 14.4 else fwhm=deconv_fwhm ; 31.2 is the beam, deconvolve by HALF a beam
if ~keyword_set(pixsize) then pixsize = 7.2
if ~keyword_set(deconv_iter) then deconv_iter=3
psf = psf_gaussian(npix=19,ndim=2,fwhm=fwhm/pixsize,/norm)

; deal with non-fft-friendly array sizes
mapsize = size(map_in,/dim)
xdim = best_fft_size(mapsize[0],2)
ydim = best_fft_size(mapsize[1],2)
map = fltarr(xdim,ydim)
map[0:mapsize[0]-1,0:mapsize[1]-1] = map_in

; First, get rid of nan's.
whnfin = where(finite(map) eq 0)
; make NAN points average of their neighbors
if keyword_set(smoothmap) then begin 
    map[whnfin] = smoothmap[whnfin]
;    whzero = where(map eq 0)
;    if ~(whzero[0] eq -1) then map[whzero] = smoothmap[whzero]
endif else if ~(whnfin[0] eq -1) then begin
    map[whnfin] = 0.
    smoothmap = convolve(map,psf_gaussian(npix=19,ndim=2,fwhm=2.0,/norm)) ; note different kernel size...
    map[whnfin] = smoothmap[whnfin]
endif

; Then, force the deconvolved map to be positive (for normalization purposes)
if min(map) lt 0 then begin
    whneg = where(map lt 0)
    map[whneg] = 0
endif

; Make a mask based on signficance
if (keyword_set(covar)) then begin
    sn = map/covar
    thresh = 3.
    mask = where(sn ge thresh)
; Allow big negative variations to be considered ...
    imask = where((abs(sn) lt thresh) or (finite(sn) eq 0))
endif 

; Deconvolve the masked map
; For max entropy
mult = 0
psf_ft = 0
; For max likelihood
deconv = (map - map + 1) * mean(map)
for i=0,deconv_iter do begin

    time_s,'Deconvolution iteration '+strcompress(i)+":  ",t0  ;,/no_sticky
;    max_Likelihood, map, psf, deconv, reconv, $
;      ft_psf=psf_ft, /gaussian, positivity_eps=1.d-9
    max_entropy,map,psf,deconv,mult,ft_psf=psf_ft
    time_e,t0
    print,"Residual: ",total(map-deconv)
    if keyword_set(interactive) then begin
;        atv,map
;        common atv_images, main_image, display_image, scaled_image, blink_image1, blink_image2, blink_image3, unblink_image, pan_image
;        blink_image1 = tvrd(true=1)
        atv,deconv
;        blink_image2 = tvrd(true=1)
;        atv,mult
;        blink_image3 = tvrd(true=1)
;        atv,map-deconv
;        atv_activate
        stop
    endif
;    stop

endfor

model = deconv
; Clip the deconvolved map if we have a mask
if (keyword_set(covar)) then begin
    model[imask] = 0.
endif

; Reconvolve with the beam
;model = abs(convolve(model,psf))
;model = convolve(model,psf)


; Normalize the model to best match the actual map
;mnmodel = mean(model)
;mnmap = mean(map)
;stdmap= stddev(map)
;mnmod = mean(deconv)
;stdmod= stddev(deconv)
;whgood = where(map gt mnmap+5*stdmap and deconv gt mnmod+5*stdmod)
;normfac = mean(map[whgood]/deconv[whgood])
;normfac = total( (model-mnmodel)*(map-mnmap) ) / $
;  total( (model-mnmodel)^2 )
;model *= normfac

return,model[0:mapsize[0]-1,0:mapsize[1]-1]

end
