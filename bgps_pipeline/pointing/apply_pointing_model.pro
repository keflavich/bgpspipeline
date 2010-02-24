; 4 final parameters are for testing sign convention empirically
; applies a correction to the fazo/fzao instrument specific model applied
; at the telescope.  The pointing models are quadratic fits to the 
; residual offset after the telescope pointing model has been used to 
; point the telescope and the instrument specific model used at the time
; has accounted for the misalignment between bolocam and the telescope
; pointing axis
; INPUTS:
;   jd - julian date (FULL)
;   alt/az - altitude and azimuth in DEGREES
;   lst - local sidereal time, used to convert ra/dec to alt/az
;   fazo/fzao - the fixed azimuth/zenith angle offsets that were applied to correct
;       for the instrument specific offset from the telescope pointing
;   raw_cso_pointing - use this if you want to remove the FAZO/FZAO but DO NOT want 
;       to apply a calculated pointing model
pro apply_pointing_model,alt=alt,az=az,jd=jd,fazo=fazo,fzao=fzao,$
        maltoff=maltoff,mazoff=mazoff,$
        raw_cso_pointing=raw_cso_pointing,_extra=_extra

    ; need to de-project delta-az into change-in-az-coordinate
    cos_alt = cos(alt*!dtor)
    
    ; fzao/fazo are read in from the RPC files in arcseconds of distance on the sky
    ; FZAO is positive
    ; FAZO is negative
    ; therefore both operations make alt/az smaller!
    alt -= fzao / 3600.            ; fzao is the offset that was added to zenith angle
                                   ; therefore it has to be subtracted from altitude
    az  += fazo / cos_alt / 3600.  ; fazo was added to azimuth, must be subtracted

    if ~keyword_set(raw_cso_pointing) then begin 
        ; the pointing model is just a date-selected polynomial function of alt
        pointing_model,jd,alt,az,altoff_model=altoff_model,azoff_model=azoff_model
        maltoff = median([altoff_model])
        mazoff  = median([azoff_model])
        print,"Applying pointing model with alt/az off ",maltoff,mazoff

        ; the 'pointing models' are calculated as polynomials to add.
        ; both models are negative
        ; subtracting a negative makes something larger!
        ; both things should be larger.
        alt -= altoff_model
        az  -= azoff_model / cos_alt
    endif else begin
        maltoff = 0
        mazoff = 0
    endelse

end

