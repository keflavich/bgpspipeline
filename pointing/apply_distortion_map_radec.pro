
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
pro apply_distortion_map_radec,ra,dec,rotang,array_params,pa,badbolos=badbolos,bolo_params=bolo_params,$
    _extra=_extra$
    bolo_spacing = array_params[0] ; "/mm?  nominally 7.7
    fid_arr_ang = array_params[2]
    if size(beam_loc_file,/type) eq 7 then begin ; if the beam location file is passed as a string
        readcol,beam_loc_file,bl_num,bl_dist,bl_ang,bl_rms,/silent
        badbolos = where(bl_rms eq 0.0)
        print,"WARNING: Using beam_loc_file instead of distcor"
        print,"Distortion mapping found these bad bolos: ",badbolos
        bolo_params[2,*] = bl_dist
        bolo_params[1,*] = bl_ang
    endif else begin
        bl_dist = reform(bolo_params[2,*])
        bl_ang  = reform(bolo_params[1,*])
    endelse
    nbolos = n_e(bl_ang)
    ntime = n_e(ra)

    if keyword_set(seidel) then begin
        newba = bl_ang + fid_arr_ang - rotang
        x=(bl_dist * cos(!dtor*newba) )
        y=(bl_dist * sin(!dtor*newba) )
        
        S = [0.038426390, -0.0015285472, 0.0012222049, 0.95789015, 0.028520202]
        
        xdistort = -(S[1]*(x*y^2+x^3) + S[2]*2*x*y + S[3]*x) 
        ydistort = S[0] + S[1]*(y^3+y*x^2) + S[2]*(3*y^2 + x^2) + S[3]*y + S[4]*y 

        bl_dist = sqrt(xdistort^2 + ydistort^2)
        bl_ang  = atan(ydistort,xdistort)

        angle = (bl_ang) # replicate(1,ntime) + replicate(1,nbolos) # (pa)
        bl_dist *= 5.*bolo_spacing/3600.   ; bolometer spacing on array is nominally 38 arcseconds
    endif else begin
        ; need to correct for parallactic angle because the fiducial angle is just the angle of the array with the telescope,
        ; but there is a parallactic angle between the telescope and the sky.  The weird thing is that it doesn't change with
        ; time: if you add the parallactic angle in timestream, it goes crazy!  August 2008: the previous statement is not true
        angle = (bl_ang+fid_arr_ang) # replicate(1,ntime) + replicate(1,nbolos) # (pa-rotang)
        bl_dist *= 5.*bolo_spacing/3600.   ; bolometer spacing on array is nominally 38 arcseconds
    endelse

;   so apparently ra + cos(angle), dec - sin(angle) works if angle = boloang + fid_arr_ang + pa[0]....
    new_ra  = replicate(1,nbolos) # ra   + bl_dist # replicate(1,ntime) * cos(angle*!dtor) / cos(replicate(1,nbolos)#dec*!dtor)
    new_dec = replicate(1,nbolos) # dec  - bl_dist # replicate(1,ntime) * sin(angle*!dtor)
    ra = new_ra
    dec  = new_dec

end





