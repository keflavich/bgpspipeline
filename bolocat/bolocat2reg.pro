pro bolocat2reg,bolocat_struct,regfile,asperpix=asperpix,fwhm=fwhm

;+
; NAME:
;    BOLOCAT2REG
; PURPOSE:
;    Generate a DS9 region file from a BOLOCAT catalog
; CALLING SEQUENCE:
;    BOLOCAT2REG, catalog, regionfile
;
; INPUTS:
;    bolocat_struct - either an IDL variable or an IDL sav file name containing
;              a bolocat catalog
;    REGFILE - an output .reg file for use with DS9
;  
; KEYWORD PARAMETERS:
;    ASPERPIX - if the default BGPS 7.2"/pixel is not used, need to put in
;               this conversion factor

    if size(bolocat_struct,/type) eq 7 then begin
        if not file_test(bolocat_struct,/regular) then begin 
        message, 'Error: File not found!', /con
        return
      endif else restore,bolocat_struct
    endif else if size(bolocat_struct,/type) ne 8 then begin
        message, 'Error: Wrong data type input for the catalog.',/con
        return
    endif

    if ~keyword_set(asperpix) then asperpix=7.2
    if keyword_set(fwhm) then asperpix *= sqrt(8*alog(2))/2.0 ; really HWHM

    openw,outf,regfile,'w',/get_lun
    printf,outf,'global color=red font="helvetica 10 normal" select=1 highlite=1 edit=1 move=1 delete=1 include=1 fixed=0 source'
    printf,outf,'galactic'
    for i=0,n_e(bolocat_struct.filename)-1 do begin
        if finite(bolocat_struct[i].glon,/nan) or finite(bolocat_struct[i].posang,/nan) or finite(bolocat_struct[i].mommajpix,/nan)$
            or finite(bolocat_struct[i].momminpix,/nan) then continue
        printf,outf,bolocat_struct[i].glon,bolocat_struct[i].glat,bolocat_struct[i].mommajpix*asperpix,bolocat_struct[i].momminpix*asperpix,bolocat_struct[i].posang/!dtor,strc(bolocat_struct[i].name),$
              format='("ellipse(",F10.6,1H,,F10.6,1H,,F9.5,2H",,F9.5,2H",,F8.4,1H),"# text={",A,"}")'
        printf,outf,bolocat_struct[i].glon_max,bolocat_struct[i].glat_max,$
              format='("point(",F10.6,1H,,F10.6,") # point=x")'
          ; the nH formatting code is to output commas
          ; posang is assumed to be the angle from galactic coordinates
    endfor
    close,outf
    free_lun,outf
    return
end


