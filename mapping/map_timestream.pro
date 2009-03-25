; map_timestream assuming that the input is sampled with 1" pixels 
; (i.e. sampled a lot more finely than is really justified)
function map_timestream,timestream,blank_map_size,ts_to,pixsize,smoothmap,hdr,weight_map=weight_map

; DON'T USE THIS:  Even if it works, it really shouldn't.  The gaussian definitely doesn't work, though.

    print,"ERROR: You really shouldn't use this method.  It is probably doing incorrect things."
    print,"specifically, I think the mapping from map to timestream is probably wrong"

    supersampled = ts_to_map(blank_map_size,ts_to,timestream)

    if smoothmap lt 0 then begin
        psfsize = 19
        fwhm = pixsize/float(abs(smoothmap))
        psf = psf_gaussian(npix=psfsize,ndim=2,fwhm=fwhm,/norm)
        convolved = conv_fft(supersampled,psf)
        downsampled = congrid(convolved,blank_map_size[0]/fwhm,blank_map_size[1]/fwhm,/interp)
    endif else begin
        smoothed = smooth(supersampled,float(smoothmap),/nan,missing=0)
        downsampled = congrid(smoothed,blank_map_size[0]/float(smoothmap),blank_map_size[1]/float(smoothmap),/interp)
    endelse

;    ;psf2[blank_map_size[0]/2-psfsize/2:blank_map_size[0]/2+psfsize/2,blank_map_size[1]/2-psfsize/2:blank_map_size[1]/2+psfsize/2] = psf
;    ;convolved = convolve(psf,supersampled)
;    ;convolved = fftconvol(supersampled,psf)

;    fxdelpar,hdr,'CD1_1'
;    fxdelpar,hdr,'CD2_2'
    sxaddpar,hdr,'CD1_1',pixsize/3600.
    sxaddpar,hdr,'CD2_2',pixsize/3600.

    if keyword_set(weight_map) then begin
        wm = congrid(weight_map,blank_map_size[0]/float(abs(smoothmap)),blank_map_size[1]/float(abs(smoothmap)),/interp)
        downsampled[where(wm gt 0)] = downsampled[where(wm gt 0)] / wm[where(wm gt 0)]
    endif

    return,downsampled
end
