; drizzle or drizzle-median
function ts_to_map,blank_map_size,inds,data,scans_info=scans_info,tstomapmedian=tstomapmedian,wtmap=wtmap,weight=weight

if keyword_set(tstomapmedian) and n_e(scans_info) gt 0 then begin
    print,"Median Mapping"
    nscans = n_e(scans_info[0,*])
    map_cube = fltarr(blank_map_size[0],blank_map_size[1],nscans) + !values.f_nan

    ts = reform(inds,size(data,/dim))

    for i=0,nscans-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]
        map_cube[*,*,i] = drizzle(blank_map_size,ts[*,lb:ub],data[*,lb:ub])
    endfor

    if total(map_cube eq 0) gt 0 then map_cube[where(map_cube eq 0)] = !values.f_nan ; ignore zero values when medianing
    map = nantozero( median(map_cube,dim=3) ) ; median! (with NAN rejection that should never happen)

    return,map
endif else begin
    if n_e(wtmap) eq 0 then message,"Error: input a weight map"
    return,drizzle(blank_map_size,inds,nantozero(data*weight)) / wtmap
endelse
end

