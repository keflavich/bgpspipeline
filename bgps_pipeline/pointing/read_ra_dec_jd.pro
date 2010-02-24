; a simple wrapper to read in all of the necessary parameters
; this should be rewritten to do it all in a single read
; until that time, it just takes in a filename and a list of parameters
; they are all output parameters
; RA is converted into DEGREES
pro read_ra_dec_jd,filename,ra,dec,jd,source_epoch,lst,rotang,beam_loc,$
    array_params,pa,fazo,fzao,el,az,eel,eaz,badscans,_extra=_extra
    ncdf_varget_scale,filename,'ra',ra
    ncdf_varget_scale,filename,'pa',pa
    ncdf_varget_scale,filename,'dec',dec
    ncdf_varget_scale,filename,'jd',mjd
    ncdf_varget_scale,filename,'ut',ut
    ncdf_varget_scale,filename,'el',el
    ncdf_varget_scale,filename,'az',az
    ncdf_varget_scale,filename,'eel',eel
    ncdf_varget_scale,filename,'eaz',eaz

    ; instead of dealing with strange modifications to jd/ut/etc, we're carrying around the full JD from now on
    jd = mjd + .5D + ut/24. + 2400000.D
;debug    print,"MEDIAN JD IS: ",median(jd)

    ncdf_varget_scale,filename,'source_epoch',source_epoch
    ncdf_varget_scale,filename,'lst',lst
    ; ERROR CHECKING:  THERE ARE BAD LSTS!
    if (where(lst lt 0))[0] ne -1 then lst[where(lst lt 0)] = 0.
    ncdf_varget_scale,filename,'rotangle',rotang
    ncdf_varget_scale,filename,'scans_info',scans_info

    rotangle = fltarr(size(ra,/dim))
    badscans = fltarr(n_e(scans_info[0,*]))
    for i=0,n_e(scans_info[0,*])-1 do begin   
       lb = scans_info[0,i]
       ub = scans_info[1,i]
       if abs(rotang[ub] - rotang[lb]) gt .3 then begin
           print,'Flagged scan ',i,' in file ',filename,' because rotangle changes by ',rotang[ub] - rotang[lb]
           badscans[i]=1
       endif
       rotangle[lb:ub] = median(rotang[lb:ub])
    endfor
    rotang = rotangle
    
    get_fixed_offsets_file,filename,fazo,fzao,_extra=_extra ; this is where RPC files are read

    ; hack to deal with the fact that RPC files may have been recorded for dates where the pointing model
    ; was calculated without subtracting fazo/fzao
    mjd = median( jd - 2400000.D )
    if mjd lt 53614.5 or (mjd ge 53887.5 and mjd lt 53947.5) then begin 
        fazo = 0 
        fzao = 0
    endif


    ncdf_varget_scale,filename,'beam_locations',beam_loc
    ncdf_varget_scale,filename,'array_params',array_params
    ra *= 15.d
end

