; drizzle or drizzle-median
function ts_to_map,blank_map_size,inds,data,scans_info=scans_info,tstomapmedian=tstomapmedian

if keyword_set(tstomapmedian) and n_e(scans_info) gt 0 then begin
    nscans = n_e(scans_info[0,*])
    map_cube = fltarr(blank_map_size[0],blank_map_size[1],nscans)
    map_cube[*] = !values.f_nan

    ts = reform(inds,size(data,/dim))

    for i=0,nscans-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]
        map_cube[*,*,i] = drizzle(blank_map_size,ts[*,lb:ub],data[*,lb:ub])
    endfor

    return,median(map_cube,dim=3)
endif else return,drizzle(blank_map_size,ts,data)
end
