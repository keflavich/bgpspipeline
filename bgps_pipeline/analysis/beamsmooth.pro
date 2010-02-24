function beamsmooth,map,kerneltype=kerneltype,width=width,hdr=hdr,outfits=outfits

    if n_e(kerneltype) eq 0 then kerneltype="tophat"
    if n_e(width) eq 0 then width=4.3333

    npix = 4*width
    if kerneltype eq "tophat" then begin
        d = shift( dist(npix,npix) , npix/2,npix/2)
        kernel = d lt width
        kernel /= total(kernel)
    endif else if kerneltype eq "gaussian" then begin
        kernel = psf_gaussian(npix=npix,ndim=2,fwhm=width,/normalize)
    endif

    if total(finite(map,/nan)) gt 0 then map[where(finite(map,/nan))]=0
    mconv = convolve(map,kernel)

    if keyword_set(hdr) and keyword_set(outfits) then writefits,outfits,mconv,hdr

    return,mconv

end


