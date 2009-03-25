
pro prep_map_wrap,phi=phi,theta=theta,ra_map=ra_map,dec_map=dec_map,unflagged=unflagged,$
    pixsize=pixsize,blank_map=blank_map,galactic=galactic,d=d,raw_delined=raw_delined,  $
    weight=weight,lst=lst,fazo=fazo,fzao=fzao,    $
    singlefile=singlefile,blank_map_size=blank_map_size,wt_map=wt_map,_extra=_extra    

        phi = ra_map[unflagged] 
        theta = dec_map[unflagged]
        phi0   = 0; median(phi)
        theta0 = 0; median(theta)
        d = raw_delined[unflagged]
        weight = fltarr(n_e(d)) + 1. / scale_ts[*]
        ts = prepare_map(phi,theta,pixsize=pixsize,blank_map=blank_map,/galactic,projection='CAR',phi0=phi0,theta0=theta0,hdr=hdr)
        add_to_header,hdr,lst=lst,fazo=fazo,fzao=fzao,singlefile=singlefile
        blank_map_size = size(blank_map,/dim)
        wt_map   = blank_map
        wt_map[min(ts):max(ts)] = wt_map[min(ts):max(ts)] + histogram(ts)  ; this is a clever trick that adds 
                                                ; the histogram of the timestream to the weight map: this means that
                                                ; each pixel in the weight map is equal to the number of pixels that
                                                ; will be mapped to that pixel from the data
end
