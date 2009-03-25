; dcflux
; output mean/std DC_BOLOS values and flux/fluxerr values
; prefix is a prefix for the whole fits file name
function dcflux,ncfile,prefix,remap=remap,_extra=_extra
    
    if ~file_test(ncfile) then message,"Couldn't find file "+ncfile

    ncdf_varget_scale,ncfile,'dc_bolos',dc_bolos
    ncdf_varget_scale,ncfile,'bolo_params',boloparams
    goodbolos = where(boloparams[0,*])
    meandc = mean(dc_bolos[goodbolos,*])
    stddc  = stddev(dc_bolos[goodbolos,*])

    outfits = prefix + strmid(ncfile,strpos(ncfile,'/',/reverse_search)+1,strlen(ncfile)) + "_indiv0pca"
    if keyword_set(remap) then mem_iter,ncfile,outfits,niter=[0],mvperjy=[1,0,0],do_weight=0,_extra=_extra 

    map = readfits(outfits+"_map03.fits",/silent)
    p = centroid_map(map,fitmap=fitmap)
    nmap = map-fitmap

    r = shift(dist(n_e(map[*,0]),n_e(map[0,*])),p[4],p[5])
    d = sqrt(p[2]^2+p[3]^2)*sqrt(8*alog(2))  ; FWHM, not gaussian width
    sumregion = where(r lt d)
    flux = total(map[sumregion],/nan)
    err  = total(nmap[sumregion],/nan)
    amp = p[1]

    return,[meandc,stddc,flux,err,amp]

end
