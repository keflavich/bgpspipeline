
function prepare_map_eachscan,ra,dec,scans_info=scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,blank_map=blank_map,hdr=hdr,_extra=_extra

    for i=0,n_e(scans_info[0,*])-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]

        phi   = ra[*,lb:ub]
        theta = dec[*,lb:ub]
        ts = prepare_map(phi,theta,pixsize=pixsize,blank_map=blank_map,/galactic,projection='CAR',hdr=hdr)
        if i gt 0 then begin
            all_ts = [[[all_ts]],[[ts]]]
            all_blank_map = [[[all_blank_map]],[[size(blank_map,/dim)]]]
            all_hdr = [[[all_hdr]],[[hdr]]]
        endif else begin
            all_ts = ts
            all_blank_map = size(blank_map,/dim)
            all_hdr = hdr
        endelse
    endfor
    ts = all_ts
    blank_map = all_blank_map
    hdr = all_hdr

    return,ts
end

; for i=0,n_e(ra_map[*,0])-1 do begin atv,m[*,*,i],header=hdr[*,0,i] & atv_activate & endfor
