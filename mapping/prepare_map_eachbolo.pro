

function prepare_map_eachbolo,ra,dec,scans_info=scans_info,pixsize=pixsize,galactic=galactic,$
        projection=projection,blank_map=blank_map,hdr=hdr,_extra=_extra

    ts = prepare_map(ra,dec,pixsize=pixsize,blank_map=blank_map,hdr=hdr,/silent,_extra=_extra)
    for i=0,n_e(ra[*,0])-1 do begin
        
        if i gt 0 then begin
            all_ts = [[[all_ts]],[[ts[i,*]]]]
            all_blank_map = [[[all_blank_map]],[[size(blank_map,/dim)]]]
            all_hdr = [[[all_hdr]],[[hdr]]]
        endif else begin
            all_ts = ts[i,*]
            all_blank_map = size(blank_map,/dim)
            all_hdr = hdr
        endelse
    endfor
    ts = all_ts
    blank_map = all_blank_map
; can't do this hack    blank_map[0,*,*] = max(blank_map[0,*,*])
;    blank_map[1,*,*] = max(blank_map[1,*,*])
    hdr = all_hdr

    return,ts
end

