; make_the_pointing_now is a ridiculous name for a wrapper
; I just feel that the pointing function should be independent
; of the file reading procedure
; INPUTS:
;    filename
;   beam_loc_file - full path to a beam_locations_file 
;   bolo_params   - an alternative to beam_loc_file, just pass the bolo_params, which have essentially the same 
;                   information in the same format, but are not corrected for distortion
; OUTPUTS:
;   ra,dec      - nbolos x ntime
;   badbolos    - array of indices of bad bolos (can be = -1, be sure to error check)
;pro make_the_pointing_now,filename,beam_loc_file=beam_loc_file,ra=ra,dec=dec,badbolos=badbolos,bolo_params=bolo_params,_extra=_extra
; i.hate.idl: ra, dec are ra_all,dec_all because otherwise they're ambiguous with radec_offsets.
pro pointing_wrapper_wrapper,filename,beam_loc_file=beam_loc_file,ra_all=ra_all,dec_all=dec_all,badbolos=badbolos,bolo_params=bolo_params,$
    fazo=fazo,fzao=fzao,jd=jd,logfile=logfile,badscans=badscans,pointing_model=pointing_model,radec_offsets=radec_offsets,$
    altazmap=altazmap,nopointing=nopointing,posang=posang,rotang=rotang,arrang=arrang,ra_bore=ra_bore,dec_bore=dec_bore,_extra=_extra
    
    read_ra_dec_jd,filename,ra_all,dec_all,jd,source_epoch,lst,rotang,beam_loc,$
        array_params,posang,fazo,fzao,el,az,eel,eaz,badscans

    arrang = array_params[2]

    if keyword_set(altazmap) or keyword_set(nopointing) then begin
        print,"NO POINTING CORRECTIONS DONE AT ALL"
        ra_all = transpose(ra_all)
        dec_all= transpose(dec_all)
        radec_offsets=[0,0]
    endif else begin
        do_the_pointing,ra_all,dec_all,jd,source_epoch,lst,rotang,array_params,posang,fazo=fazo,fzao=fzao,$
            beam_loc_file=beam_loc_file,badbolos=badbolos,bolo_params=bolo_params,            $
            el=el,az=az,eel=eel,eaz=eaz,radec_offsets=radec_offsets,pointing_model=pointing_model,$
            logfile=logfile,ra_bore=ra_bore,dec_bore=dec_bore,_extra=_extra
    endelse
end

