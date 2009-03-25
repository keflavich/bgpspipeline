
; remove_bad_bolos
; takes the bolometers listed in bad_bolos and removes them from all
; timestream-sized data passed to the procedure except for bad_bolos and
; good_bolos, all of these are OUTPUT parameters
pro remove_bad_bolos,bad_bolos=bad_bolos,good_bolos=good_bolos,flags=flags,$
    bolo_params=bolo_params,raw=raw,ac_bolos=ac_bolos,$
    dc_bolos=dc_bolos,ra_map=ra_map,dec_map=dec_map,bolo_indices=bolo_indices
    
    if (~keyword_set(good_bolos) or n_e(good_bolos) eq 0) and size(bad_bolos,/dim) gt 0 then begin
        bolo_params[0,bad_bolos] = 0
        good_bolos = where(bolo_params[0,*])
    endif

    if keyword_set(flags)       then flags       = flags[good_bolos,*]
    if keyword_set(ac_bolos)    then ac_bolos    = ac_bolos[good_bolos,*]
    if keyword_set(raw)         then raw         = raw[good_bolos,*]
    if keyword_set(dc_bolos)    then dc_bolos    = dc_bolos[good_bolos,*]
    if keyword_set(ra_map)      then ra_map      = ra_map[good_bolos,*]
    if keyword_set(dec_map)     then dec_map     = dec_map[good_bolos,*]
    if keyword_set(bolo_params) then bolo_params = bolo_params[*,good_bolos]
    if keyword_set(bolo_indices)then bolo_indices= bolo_indices[good_bolos]

end


