; do_the pointing...
; a wrapper for all of the pointing corrections
; should return an RA/DEC that is correct
; INPUTS:
;    ra, dec - as reported from the telescope, in degrees
;    jd - julian date from ncdf file
;    source_epoch - really needs to be a single number, but OK if it's an array
;    lst - local sidereal time from ncdf file
;    rotang - rotation angle from ncdf file [see apply_distortion_map for details]
;    pointoff - a correction to the pointing in alt/az units (degrees); simple shift
;               encoded in a length-2 vector
;    beam_loc_file - the name of a beam locations file / distortion map file
pro do_the_pointing,ra,dec,jd,source_epoch,lst,rotang,array_params,pa,fazo=fazo,fzao=fzao,$
    beam_loc_file=beam_loc_file,badbolos=badbolos,bolo_params=bolo_params,                $
    el=el,az=az,eel=eel,eaz=eaz,noeeleaz=noeeleaz,nobeamloc=nobeamloc,                    $
    no_offsets=no_offsets,pointing_model=pointing_model,                      $
    nutate=nutate,aberration=aberration,precess=precess,radec_offsets=radec_offsets,      $
    logfile=logfile,_extra=_extra

    latitude=19.82611111D0 

    correct_eaz_eel,ra,dec,el,az,eel,eaz,pa

    ; because we're using precess = 0, eq2hor expects the ra/dec in CURRENT EPOCH, not J2000
    ; allow aberration/nutation correction to be done here even though it's done again later
    ; I'm trying to make my corrections follow the order of the corrections done in eq2hor
    my_eq2hor,ra,dec,jd,alt,az,lat=latitude,alt=4072,lon=-155.473366,refract=0,precess=0,nutate=0,aberration=0,lst=lst
    if keyword_set(pointing_model) then begin 
        apply_pointing_model,alt=alt,az=az,jd=jd,fazo=fazo,fzao=fzao,maltoff=maltoff,mazoff=mazoff,_extra=_extra
        pointing_model = [maltoff,mazoff]
    endif
    my_hor2eq,alt,az,jd,ra,dec,lat=latitude,alt=4072,lon=-155.473366,refract=0,precess=1,nutate=1,aberration=1,lst=lst

    ; Apply the ADDITIONAL pointing correction (offset in RA/Dec)
    ; pointoff = array_params[3:4]

    if ~keyword_set(no_offsets) and n_e(radec_offsets) eq 2 then begin
;        printf,logfile,"APPLYING POINTING OFFSETS: ",pointoff[0] / 3600.  / cos(median(dec)*!dtor),pointoff[1] / 3600. 
        printf,logfile,"APPLYING POINTING OFFSETS: ",radec_offsets
;        print,"APPLYING POINTING OFFSETS: ",radec_offsets
        ra  += radec_offsets[0] ;pointoff[0] / 3600.  / cos(dec*!dtor)
        dec += radec_offsets[1] ;pointoff[1] / 3600. 
    endif else begin
        printf,logfile,"NO OFFSETS APPLIED"
        radec_offsets=[0,0] ; want to make sure the rest of the code knows that no_offets means [0,0]
    endelse

    if ~keyword_set(nobeamloc) then $
    apply_distortion_map_radec,ra,dec,rotang,array_params,pa,beam_loc_file=beam_loc_file,badbolos=badbolos,bolo_params=bolo_params,_extra=_extra $
    else begin
        print,"No distortion map applied."
        ra = ra##(intarr(n_e(bolo_params[1,*]))+1)
        dec = dec##(intarr(n_e(bolo_params[1,*]))+1)
    endelse

end


