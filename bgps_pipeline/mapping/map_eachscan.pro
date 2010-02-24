
function map_eachscan,ra,dec,data,scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,phi0=phi0,theta0=theta0,blank_map=blank_map,hdr=hdr,_extra=_extra

    ts = prepare_map_eachscan(ra,dec,scans_info=scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,phi0=phi0,theta0=theta0,blank_map=blank_map,hdr=hdr,_extra=_extra)

    for i=0,n_e(scans_info[0,*])-1 do begin
        lb = scans_info[0,i]
        ub = scans_info[1,i]

        map = ts_to_map(blank_map[*,0,i],ts[*,*,i],data[lb:ub])

        if i gt 0 then begin
            if ~(blank_map[0,0,i] eq mapsize[0] and blank_map[1,0,i] eq mapsize[1]) then begin
                all_map = [[[all_map]],[[map[0:mapsize[0]-1,0:mapsize[1]-1]]]]
            endif else begin
                all_map = [[[all_map]],[[map]]]
            endelse
        endif else begin
            mapsize = blank_map[*,0,0]
            all_map = map
        endelse

    endfor

    return,all_map
end
