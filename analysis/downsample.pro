function downsample,map,hdr=hdr,newcd=newcd,newxy=newxy,outfits=outfits

    if ~keyword_set(hdr) then return,0

    if sxpar(hdr,"CD1_1") ne 0 then begin
        cd11=sxpar(hdr,"CD1_1")
        cd22=sxpar(hdr,"CD2_2")
        cdf = "cd"   ;cd flag
    endif else begin
        cd11=sxpar(hdr,'CDELT1')
        cd22=sxpar(hdr,'CDELT2')
        cdf = "cdelt"
    endelse
    crpix1=sxpar(hdr,"CRPIX1")
    crpix2=sxpar(hdr,"CRPIX2")
    crval1=sxpar(hdr,"CRVAL1")
    crval2=sxpar(hdr,"CRVAL2")

    sz = size(map,/dim)
    nx = sz[0]
    ny = sz[1]

    if keyword_set(newxy) and n_e(newxy) eq 2 then begin
        kwidth = nx / newxy[0]
        mconv = convolve(map,psf_gaussian(npix=kwidth*4,ndim=2,fwhm=kwidth,/normalize))
        mrebin = congrid(mconv,newxy[0],newxy[1],/interp,cubic=-0.5)
        cd11 = nx/newxy[0]*cd11
        cd22 = ny/newxy[1]*cd22
        crpix1 = crpix1 * newxy[0]/nx
        crpix2 = crpix2 * newxy[1]/ny
    endif else if keyword_set(newcd) then begin
        newx = abs(nx * cd11 / newcd)
        newy = abs(ny * cd22 / newcd)
        cd11 = nx/newx*cd11
        cd22 = ny/newy*cd22
        crpix1 = crpix1 * newx/nx
        crpix2 = crpix2 * newy/ny
        kwidth = nx / newx
        mconv = convolve(map,psf_gaussian(npix=kwidth*4,ndim=2,fwhm=kwidth,/normalize))
        mrebin = congrid(mconv,newx,newy,/interp,cubic=-0.5)
    endif else print,"Failed: need to input a new pixel sampling or a new x,y size"

    if cdf eq "cd" then begin
        sxaddpar,hdr,'CD1_1',cd11
        sxaddpar,hdr,'CD2_2',cd22
    endif else if cdf eq "cdelt" then begin
        sxaddpar,hdr,'CDELT1',cd11
        sxaddpar,hdr,'CDELT2',cd22
    endif
    sxaddpar,hdr,'CRPIX1',crpix1+1
    sxaddpar,hdr,'CRPIX2',crpix2+1

    if keyword_set(outfits) then writefits,outfits,mrebin,hdr

    return,mrebin

end
