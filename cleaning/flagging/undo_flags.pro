; undo flags done by flag_manual
; need to specify the bolometer number if you want to un-flag
; a bolometer
;
; basically uses the same syntax as flag_manual just does the opposite
pro undo_flags,filename,bad_bolos=bad_bolos,bad_time=bad_time,wh_scan=wh_scan,$
    bolo_indices=bolo_indices,doboth=doboth,bad_scans=bad_scans
    
    ; to unflag bolometers, must know which bolometers were not flagged in the map
    ; this is done automatically in find_goodbolos
    if keyword_set(bolo_indices) then begin
        bolos_to_flag = bolo_indices[bad_bolos]
    endif else if n_e(bad_bolos) gt 0 then begin
        bolo_indices = find_goodbolos(filename)
        bolos_to_flag = bolo_indices[bad_bolos]
    endif

    ncdf_varget_scale,filename,'flags',flags

    if n_e(bad_time) gt 0 then begin
        if keyword_set(doboth) then ts_bolos_to_flag = bolos_to_flag $
            else ts_bolos_to_flag=indgen(144)
        ncdf_varget_scale,filename,'scans_info',scans_info
        lb = scans_info[bad_time[0,*],0]
        flagpoint = lb + bad_time[1,*]
        flags_ftimes = flags[ts_bolos_to_flag,flagpoint]
        flags_ftimes[where(flags_ftimes) ge 10] -= 10
        flags[ts_bolos_to_flag,flagpoint] = flags_ftimes 
    endif
    
    if n_e(bolos_to_flag) gt 0 then begin
        ncdf_varget_scale,filename,'bolo_params',bolo_params
        flags_fbolos = flags[bolos_to_flag,*]
        flags_fbolos[where(flags_fbolos) ge 10] -= 10
        flags[bolos_to_flag,*] = flags_fbolos
        bolo_params[0,bolos_to_flag] = 1
        ncdf_varput_scale,filename,'bolo_params',bolo_params
    endif

    if n_e(bad_scans) gt 0 then begin
        ncdf_varget_scale,filename,'scans_info',scans_info
        flagged_scans = badscans_to_flags(flags*0,scans_info,bad_scans)
        flags[where(flagged_scans)] = 0
    endif
    
    ncdf_varput_scale,filename,'flags',flags
    
end 

    
