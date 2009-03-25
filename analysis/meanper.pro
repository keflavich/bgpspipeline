
pro meanper,file,outf,binsize=binsize,inverse=inverse,lmin=lmin,lmax=lmax,_extra=_extra

    if n_e(binsize) eq 0 then binsize=1
    if ~keyword_set(lmin) then lmin =-10.5
    if ~keyword_set(lmax) then lmax =84.5

    map=readfits(file,hdr)
    if sxpar(hdr,"CD1_1") ne 0 then begin
        cd11=sxpar(hdr,"CD1_1")
        cd22=sxpar(hdr,"CD2_2")
    endif else begin
        cd11=sxpar(hdr,'CDELT1')
        cd22=sxpar(hdr,'CDELT2')
    endelse
    crpix1=sxpar(hdr,"CRPIX1")
    crpix2=sxpar(hdr,"CRPIX2")
    crval1=sxpar(hdr,"CRVAL1")
    crval2=sxpar(hdr,"CRVAL2")

    nx = n_e(map[*,0])
    ny = n_e(map[0,*])
    xind = lindgen(nx)
    yind = lindgen(ny)

    lind = (xind-crpix1)*cd11+crval1
    bind = (yind-crpix2)*cd22+crval2
    if max(lind) gt 360 then lind[where(lind gt 360)]-=360

    if lmax lt max(lind) then temp = min(abs(lind-lmax),eastmost) $
    else eastmost=0
    if lmin gt min(lind) then temp = min(abs(lind-lmin),westmost) $
    else westmost=nx

    temp = min(abs(lind),lzero)
    temp = min(abs(bind),bzero)

    for j=0,n_e(binsize)-1 do begin
        npix = floor(abs(1/cd11) * binsize[j])

        neast = floor(abs(lzero-eastmost) / npix)
        nwest = floor(abs(westmost-lzero) / npix)
        least = lzero - npix * neast

        yu = floor(bzero + .5/cd22)
        yl = ceil(bzero - .5/cd22)

        nperbin = npix * ceil(yu-yl)
        lbin = fltarr(neast+nwest)
        meann = fltarr(neast+nwest)
        stdn = fltarr(neast+nwest)

        openw,outfile,outf,/get_lun
        printf,outfile,"longitude","mean_noise","std(noise)",format="(A25,A25,A25)"
        for i=0,neast+nwest-1 do begin
            xl = floor(least + npix * i)
            xu = floor(least + npix * (i+1))
            lbin[i] = lind[floor(least + npix * (i+.5))]
            if keyword_set(inverse) then begin
                meann[i] = sqrt(1./mean(map[xl:xu,yl:yu],/nan))
                stdn[i] = stddev(sqrt(1/map[xl:xu,yl:yu]),/nan)
            endif else begin
                meann[i] = mean(map[xl:xu,yl:yu],/nan)
                stdn[i]  = stddev(map[xl:xu,yl:yu],/nan)
            endelse
            printf,outfile,lbin[i],meann[i],stdn[i],format="(F25,F25,F25)"
        endfor
        close,outfile
        free_lun,outfile

        if j eq 0 then plot,lbin,meann,ytitle="Mean Noise",xtitle="Galactic Longitude",_extra=_extra $
            else oplot,lbin,meann,color=255/(j+k+1),_extra=_extra 
    endfor
    stop
end
