
; apply_distortion_map
; reads a beam distortion file - must pass in one of these!
; beam_loc_files have the format bolonum,distance,angle,RMS
; rotang is the rotation angle of the whole array on the sky; presumably
; it is the rotation angle between the reference line on Bolocam and the
; horizontal (the horizon)
; the distance is in units of 38 arcseconds, but alt and az are in units
; of degrees, hence the correction
; it is assumed that the reference line is w.r.t. the horizon rather than
; the vertical, so the shift in alt is the sine of the given angle and the
; shift in az is the cosine
; ALT and AZ are also output parameters (they are modified by the procedure)
; 
; The signs below are correct:
;   ra  + dist * cos(angle)
;   dec - dist * sin(angle)  [the minus because the array is flipped from the sky]
;   bolo_angle + fid_arr_ang + pa - rotang
;
; EQUIVALENT TO: find_pixel_offsets, map_ncdf_reading 
pro apply_distortion_map_radec_signcheck,ra,dec,rotang,array_params,pa,beam_loc_file=beam_loc_file,badbolos=badbolos,bolo_params=bolo_params,$
    beam_plot=beam_plot,dorotate=dorotate,doposang=doposang,$
    ppa=ppa,mpa=mpa,pra=pra,mra=mra,$
    _extra=_extra
    if n_e(dorotate) eq 1 then if dorotate ne 1 then rotang[*]=0
    if n_e(doposang) eq 1 then if doposang ne 1 then pa[*]=0
    print,"Max PA:",max(pa)," Max rotang:",max(rotang)
    bolo_spacing = array_params[0] ; "/mm?  nominally 7.7
    fid_arr_ang = array_params[2]
    if size(beam_loc_file,/type) eq 7 then begin ; if the beam location file is passed as a string
        readcol,beam_loc_file,bl_num,bl_dist,bl_ang,bl_rms,/silent
        badbolos = where(bl_rms eq 0.0)
        print,"Distortion mapping found these bad bolos: ",badbolos
        bolo_params[2,*] = bl_dist
        bolo_params[1,*] = bl_ang
    endif else begin
        bl_dist = reform(bolo_params[2,*])
        bl_ang  = reform(bolo_params[1,*])
    endelse
    nbolos = n_e(bl_ang)
    ntime = n_e(ra)
    ; need to correct for parallactic angle because the fiducial angle is just the angle of the array with the telescope,
    ; but there is a parallactic angle between the telescope and the sky.  The weird thing is that it doesn't change with
    ; time: if you add the parallactic angle in timestream, it goes crazy!  August 2008: the previous statement is not true
    if keyword_set(ppa) then apt1 = (bl_ang+fid_arr_ang+pa) # replicate(1,ntime) $
    else if keyword_set(mpa) then apt1 = (bl_ang+fid_arr_ang-pa) # replicate(1,ntime)
    if keyword_set(mra) then apt2 = - replicate(1,nbolos) # rotang  $
    else if keyword_set(pra) then apt2 = + replicate(1,nbolos) # rotang 
    angle = apt1+apt2
    bl_dist *= 5.*bolo_spacing/3600.   ; bolometer spacing on array is nominally 38 arcseconds
;   so apparently ra + cos(angle), dec - sin(angle) works if angle = boloang + fid_arr_ang + pa[0]....
    new_ra  = replicate(1,nbolos) # ra   + bl_dist # replicate(1,ntime) * cos(angle*!dtor) / cos(replicate(1,nbolos)#dec*!dtor)
    new_dec = replicate(1,nbolos) # dec  - bl_dist # replicate(1,ntime) * sin(angle*!dtor)
    ra = new_ra
    dec  = new_dec

end





