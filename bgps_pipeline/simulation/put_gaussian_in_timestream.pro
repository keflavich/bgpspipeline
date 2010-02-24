

function put_gaussian_in_timestream,filename,pixsize=pixsize,ra_center=ra_center,dec_center=dec_center,$
    coordsys=coordsys,projection=projection,precess=precess,aberration=aberration,nutate=nutate,$
    _extra=_extra

    thefiles = [filename]

    if n_e(coordsys) eq 0 then coordsys = 'radec'
    if n_e(projection) eq 0 then projection = 'TAN'
    if n_e(precess) eq 0 then precess = 1
    if n_e(aberration) eq 0 then aberration = 1
    if n_e(nutate) eq 0 then nutate = 1
    if n_e(pixsize) eq 0 then pixsize=7.2

    if ~keyword_set(ra_center) then begin
        ncdf_varget_scale,filename,'source_ra',source_ra
        ncdf_varget_scale,filename,'source_dec',source_dec
        ra_center = median(source_ra)*15.
        dec_center = median(source_dec)
        print,"RA: ",ra_center," DEC: ",dec_center
    endif

    ncdf_varget_scale,filename,'ac_bolos',ac_bolos
    timestream = ac_bolos

    OPENW, logfile, '/dev/tty', /GET_LUN, /MORE  
    bolo_indices = indgen(144)
    readall_pc,thefiles,ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
           raw=raw,sample_interval=sample_interval, scans_info=scans_info,noisefilt_weights=noisefilt_weights,  $
           ra_map=ra_map,dec_map=dec_map,wh_scan=wh_scan,bolo_indices=bolo_indices,lst=lst,fazo=fazo,fzao=fzao, $
           logfile=logfile,goodbolos=goodbolos,mvperjy=mvperjy,jd=jd,     $
           precess=precess,aberration=aberration,nutate=nutate,$
           _extra=_extra

    phi0 = 0
    theta0 = 0

    unflagged = where(~flags)
    phi = ra_map[unflagged] 
    theta = dec_map[unflagged]

    ts = prepare_map(phi,theta,pixsize=pixsize,blank_map=blank_map,phi0=phi0,theta0=theta0,hdr=hdr,$
        coordsys=coordsys,projection=projection)
       
    blank_map_size = size(blank_map,/dim)

    psf = psf_gaussian(ndim=2,npix=31,fwhm=31.2/pixsize)

    extast,hdr,astr

    ad2xy,ra_center,dec_center,astr,x,y
    x=floor(x) & y = floor(y)
    xy2ad,x,y,astr,ra_center,dec_center & print,"Real RA: ",ra_center," Dec: ",dec_center
    map = blank_map
    map[x-15:x+15,y-15:y+15] = psf

    timestream[*] = 0.
    t = timestream[goodbolos,*]
    t[*,wh_scan] = map[ts]
    timestream[goodbolos,*] = t

    ncdf_varput_scale,filename,'ac_bolos',timestream

    close,logfile
    free_lun,logfile

    return,map

end

