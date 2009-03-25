

function map_eachbolo,ra,dec,data,scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,blank_map=blank_map,hdr=hdr,_extra=_extra

    ts = prepare_map_eachbolo(ra,dec,scans_info=scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,blank_map=blank_map,hdr=hdr,_extra=_extra)

    for i=0,n_e(ra[*,0])-1 do begin
        ;blank_map[*,0,i]
;        blank_map_size = size(blank_map,/dim)
        map = ts_to_map(blank_map[*,0,i],ts[0,*,i],data[i,*],wtmap=1,weight=1)

        if i gt 0 then begin
            if ~(blank_map[0,0,i] eq mapsize[0] and blank_map[1,0,i] eq mapsize[1]) then begin
                print,"Warning: some map sizes were not identical"
                upper_x = min([mapsize[0],blank_map[0,0,i]])-1
                upper_y = min([mapsize[1],blank_map[1,0,i]])-1
                newmap = fltarr(mapsize[0],mapsize[1])
;                newmap1 = newmap + map
;                newmap[0:n_e(map[*,0])-1,0:n_e(map[0,*])-1] = map
                newmap[0:upper_x,0:upper_y] = map[0:upper_x,0:upper_y]
                all_map = [[[all_map]],[[newmap]]]     ;[[map[0:mapsize[0]-1,0:mapsize[1]-1]]]]
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

; for i=0,n_e(ra_map[*,0])-1 do begin atv,m[*,*,i],header=hdr[*,0,i] & atv_activate & endfor
; for i=0,n_e(ra_map[*,0])-1 do begin writefits,outmap+'_bolo'+string(i,format='(I3.3)')+".fits",m[*,*,i],hdr[*,0,i] & endfor
