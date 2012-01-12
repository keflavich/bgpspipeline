function galaxy_model
; intent is to develop a very simple galactic model from which to draw a source count list
;

    r0 = 8.5
    imsize = 2048
    npoints = 100000L
    th = findgen(npoints)/npoints * 4 * !dpi
    r1 = A * exp( th * B )
    r2 = A * exp( (th+!dpi) * B )

    sunx = imsize/2
    suny = imsize/2
    x0 = imsize/2
    y0 = 0

    x1 = r1*cos(th) + x0
    y1 = r1*sin(th)
    OK1 = where((x1 lt imsize) and (y1 lt imsize))

    x2 = r2*cos(th) + x0
    y2 = r2*sin(th)
    OK2 = where((x2 lt imsize) and (y2 lt imsize))

    im = fltarr(imsize,imsize)
    im[x1,y1] = 1
    im[x2,y2] = 1

    smoothim = convolve(im,psf_gaussian(ndim=2,npix=25,fwhm=imsize/128))

    return,smoothim
end


