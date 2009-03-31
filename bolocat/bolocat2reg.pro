pro bolocat2reg,bgps,regfile,asperpix=asperpix

;+
; NAME:
;    BOLOCAT2REG
; PURPOSE:
;    Generate a DS9 region file from a BOLOCAT catalog
; CALLING SEQUENCE:
;    BOLOCAT2REG, catalog, regionfile
;
; INPUTS:
;    CATALOG - either an IDL variable or an IDL sav file name containing
;              a bolocat catalog
;    REGFILE - an output .reg file for use with DS9
;  
; KEYWORD PARAMETERS:
;    ASPERPIX - if the default BGPS 7.2"/pixel is not used, need to put in
;               this conversion factor

    if size(bgps,/type) eq 7 then begin
        if not file_test(bgps,/regular) then begin 
        message, 'Error: File not found!', /con
        return
      endif else restore,bgps
    endif else if size(bgps,/type) ne 8 then begin
        message, 'Error: Wrong data type input for the catalog.',/con
        return
    endif

    if ~keyword_set(asperpix) then asperpix=7.2

    openw,outf,regfile,'w',/get_lun
    printf,outf,'global color=red font="helvetica 10 normal" select=1 highlite=1 edit=1 move=1 delete=1 include=1 fixed=0 source'
    printf,outf,'galactic'
    for i=0,n_e(bgps.filename)-1 do begin
        if finite(bgps[i].glon,/nan) or finite(bgps[i].posang,/nan) or finite(bgps[i].mommajpix,/nan) or finite(bgps[i].momminpix,/nan) then continue
        printf,outf,bgps[i].glon,bgps[i].glat,bgps[i].mommajpix*asperpix,bgps[i].momminpix*asperpix,bgps[i].posang/!dtor,bgps[i].name,$
              format='("ellipse(",F10.6,1H,,F10.6,1H,,F9.5,2H",,F9.5,2H",,F8.4,1H) # text={A})'
          ; the nH formatting code is to output commas
          ; posang is assumed to be the angle from galactic coordinates
    endfor
    close,outf
    free_lun,outf
    return
end


