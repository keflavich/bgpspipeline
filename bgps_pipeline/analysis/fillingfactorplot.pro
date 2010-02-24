pro fillingfactorplot,file,outf,cutoff=cutoff,binsize=binsize,_extra=_extra

    if n_e(cutoff) eq 0 then cutoff=.3
    if n_e(binsize) eq 0 then binsize=1

    map=readfits(file,hdr)
    cd11=sxpar(hdr,"CD1_1")
    cd22=sxpar(hdr,"CD2_2")
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

    for j=0,n_e(binsize)-1 do begin
        for k=0,n_e(cutoff)-1 do begin
            npix = floor(abs(1/cd11) * binsize[j])

            temp = min(abs(lind),lzero)
            temp = min(abs(bind),bzero)
            neast = floor(lzero / npix)
            nwest = floor((nx-lzero) / npix)
            least = lzero - npix * neast

            yu = floor(bzero + .5/cd22)
            yl = ceil(bzero - .5/cd22)

            nperbin = npix * ceil(yu-yl)
            lbin = fltarr(neast+nwest)
            nover = fltarr(neast+nwest)
            frac = fltarr(neast+nwest)

            openw,outfile,outf,/get_lun
            printf,outfile,"longitude","n_over_cutoff","fraction_over_cutoff",format="(A25,A25,A25)"
            for i=0,neast+nwest-1 do begin
                xl = floor(least + npix * i)
                xu = floor(least + npix * (i+1))
                lbin[i] = lind[floor(least + npix * (i+.5))]
                nover[i] = total(map[xl:xu,yl:yu] gt cutoff[k])
                frac[i] = double(nover[i]) / double(nperbin)
                printf,outfile,lbin[i],nover[i],frac[i],format="(F25,F25,F25)"
            endfor
            close,outfile
            free_lun,outfile

            if j eq 0 and k eq 0 then plot,lbin,frac,ytitle="Fraction over Cutoff",xtitle="Galactic Longitude",_extra=_extra $
                else oplot,lbin,frac,color=255/(j+k+1),_extra=_extra 
        endfor
    endfor
    stop
end
