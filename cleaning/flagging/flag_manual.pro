; manual flagging
; examples:
;  flag a bolometer for the whole timestream:
;   flag_manual,filename,bad_bolos=[1,2,3]
;   or
;   flag_manual,filename,bad_bolos=[1,2,3],bolo_indices=[1,2,3,4,5,6,7,8,...]
;  flag a bolometer at one timepoint:
;   flag_manual,filename,bad_bolos=[3],bad_time=[5,80],/doboth
;  flag a whole scan:
;   flag_manual,filename,bad_scans=[5]
;  flag all bolometers at one time point:
;   flag_manual,filename,bad_time=[5,220]
;
;  the 'bad_time' array is the most confusing and important:
;  it is a 2xN array.  
;    bad_time[0,*] = the scan number
;    bad_time[1,*] = the time point in that scan
;
;  flags are set to (flag+10) to make undoing easier
;
;  REMEMBER: FITS/DS9/IRAF index from 1, IDL indexes from 0
;
pro flag_manual,filename,bad_bolos=bad_bolos,bad_time=bad_time,wh_scan=wh_scan,$
    bolo_indices=bolo_indices,doboth=doboth,bad_scans=bad_scans,timerange=timerange,$
    bolorange=bolorange,scanrange=scanrange

    ; to flag bolometers, must know which bolometers were not flagged in the map
    ; this is done automatically in find_goodbolos
    if keyword_set(bolo_indices) then begin
        if ~keyword_set(bad_bolos) then message,"Must specify bolometers to flag"
        bolos_to_flag = bolo_indices[bad_bolos]
        if ~keyword_set(doboth) then begin
            print,"Going to flag bolometers ",bolos_to_flag," if .continued.  OK?"
            stop
        endif
    endif else if n_e(bad_bolos) gt 0 then begin
        bolo_indices = find_goodbolos(filename)
        bolos_to_flag = bolo_indices[bad_bolos]
        if n_e(bolorange) gt 0 then bolorange = bolo_indices[bolorange]
        if ~keyword_set(doboth) then begin
            print,"Going to flag bolometers ",bolos_to_flag," if .continued.  OK?"
            stop
        endif
    endif

    ; in order to do time flagging, need to know which time points were included
    ; in the timestream map
;    if keyword_set(wh_scan) then begin
;        if ~keyword_set(bad_time) then message,"Must specify times to flag"
;        times_to_flag = wh_scan[bad_time]
;        print,"Going to flag times contained in range ",min(times_to_flag)," - ",max(times_to_flag)," (not necessarily inclusive)."
;        stop
;    endif else if n_e(bad_time) gt 0 then times_to_flag = bad_time

    ncdf_varget_scale,filename,'flags',flags
    ncdf_varget_scale,filename,'scans_info',scans_info

    if n_e(bad_time) gt 0 then begin
        if keyword_set(doboth) then ts_bolos_to_flag = bolos_to_flag $
            else ts_bolos_to_flag=indgen(144)
        lb = scans_info[bad_time[0,*],0]
        flagpoint = lb + bad_time[1,*]
        flagtimes = flags*0
        flagbolos = flags*0
        flagtimes[*,flagpoint] = 1
        flagbolos[ts_bolos_to_flag,*] = 1
        intersection = flagtimes * flagbolos
        print,"About to flag data points at the intersection of bad_bolos and bad_time.  .con to continue"
        stop
        flags[where(intersection)] += 10
;        ub = scans_info[bad_time[0,*],1]
;        for i=0,n_e(lb)-1 do begin
;            flags[ts_bolos_to_flag,lb:ub] += 10
;        endfor
    endif
    
    if n_e(bolos_to_flag) gt 0 then begin
        ncdf_varget_scale,filename,'bolo_params',bolo_params
        flags[bolos_to_flag,*] += 10
        bolo_params[0,bolos_to_flag] = 0
        ncdf_varput_scale,filename,'bolo_params',bolo_params
    endif

    ; deal with boxes / ranges of time
    if n_e(timerange) eq 2 then begin
        flagtimes = flags*0
        flagtimes[*,timerange[0]:timerange[1]] = 1
    endif else if n_e(timerange) eq 1 then begin
        flagtimes = flags*0
        flagtimes[*,timerange] = 1
    endif else flagtimes = flags*0 + 1
    if n_e(bolorange) eq 2 then begin
        flagbolos = flags*0
        flagbolos[bolorange[0]:bolorange[1],*] = 1
    endif else if n_e(bolorange) eq 1 then begin
        flagbolos = flags*0
        flagbolos[bolorange,*] = 1
    endif else flagbolos = flags*0 + 1
    if n_e(scanrange) eq 2 then begin
        flagscans = flags*0
        for j=scanrange[0],scanrange[1] do begin
            flagscans[*,scans_info[0,j]:scans_info[1,j]] = 1
        endfor
;        scanlen = scans_info[1,0]-scans_info[0,0]
;        nscans = n_e(scans_info[0,*])
;        nbolos = n_e(flags[*,0])
;        ntime = n_e(flags[0,*])
;        whscan = indgen(scanlen) + scans_info[0,0] ; endpoint-exclusive, 0th iteration
;        for j=1,n_e(scans_info[0,*])-1 do begin       ; index from one because 0th on previous line
;            whscan = [whscan,indgen(scanlen) + scans_info[0,j]]
;        endfor
;        fs = reform(flags[*,whscan],nbolos,scanlen,nscans)*0
;        fs[*,scanrange[0]:scanrange[1],*] = 1
;        flagscans = flags*0
;        flagscans[where = 
    endif else if n_e(scanrange) eq 1 then begin
        flagscans = flags*0
        flagscans[scans_info[0,scanrange]:scans_info[1,scanrange]] = 1
    endif else flagscans = flags*0 + 1
    intersection = flagscans * flagtimes * flagbolos
    flags[where(intersection)]+=15

;    if n_e(times_to_flag) gt 0 then flags[*,times_to_flag] += 10
    
;    if keyword_set(doboth) then begin
;        tflg = bytarr(size(flags,/dim))
;        bflg = bytarr(size(flags,/dim))
;        bflg[bolos_to_flag,*]   += 10
;        tflg[*,times_to_flag]   += 10
;        flags[where(tflg*bflg)] += 10
;    endif

    if n_e(bad_scans) gt 0 then begin
        ncdf_varget_scale,filename,'scans_info',scans_info
        flags = badscans_to_flags(flags,scans_info,bad_scans)
    endif
    
    ncdf_varput_scale,filename,'flags',flags
    
end 

    
