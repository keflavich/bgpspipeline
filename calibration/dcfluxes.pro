; example: 
; dcfluxes,'/usb/scratch1/texts/planetlist.txt','/usb/scratch1/planets/','planet_dcfluxes.txt'
; dcfluxes,'/usb/scratch1/texts/planetlist.txt','/usb/scratch1/planets/BL','planet_dcfluxes_distcor.txt'
pro dcfluxes,inlist,prefix,outfile,remap=remap,_extra=_extra
    ; extras of interest: distcor

    readcol,inlist,filelist,format='(A80)',comment="#",/silent

    openw,outf,outfile,/get_lun

    printf,outf,"filename","planet","meandc","stddc","volts","err","ampl","volts/flux","err/flux","ampl/flux","flux","jd",format="('#',A80,11A20)"
    for i=0,n_e(filelist)-1 do begin
        if file_test(filelist[i]) then begin
            vals = dcflux(filelist[i],prefix,remap=remap,_extra=_extra)
            if stregex(filelist[i],'uranus') gt 0 then planet='uranus'
            if stregex(filelist[i],'mars') gt 0 then planet='mars'
            if stregex(filelist[i],'neptune') gt 0 then planet='neptune'
            if stregex(filelist[i],'g34.3') gt 0 then planet='g34.3'
            ncdf_varget_scale,filelist[i],'jd',jd
            if n_e(planet) eq 0 then pflux=100 else pflux = planetflux(planet,median(jd))
            printf,outf,filelist[i],planet,vals,vals[2:4]/pflux,pflux,median(jd),format="(A80,A20,9F20.8,I20)"
            print,filelist[i],planet,vals,vals[2:4]/pflux,pflux,median(jd),format="(A80,A20,9F20.8,I20)"
        endif else print,"Couldn't find file ",filelist[i]
    endfor

    close,outf
    free_lun,outf

end

; ephemerides from the JCMT
; MARS:
; June 30 2005: 730.14 Jy   UT:53551
; July 15 2005: 872.83 Jy   UT:53566           
; Sept 10 2005: 1941.72 Jy  UT:53623 
; June 5  2006: 553.13 Jy   UT:53891
; June 23 2006: 674.14 Jy   UT:53544
; Sept 10 2006: 135.79 Jy   UT:53896 
; July 20 2007: 381.18 Jy   UT:54301           
; Sept 10 2007: 597.87 Jy   UT:54353           
;
; URANUS:
; June 30 2005: 43.43 Jy   UT:53551
; July 15 2005: 44.35 Jy   UT:53566           
; Sept 10 2005: 45.78 Jy   UT:53623 
; June 5  2006: 41.71 Jy   UT:53891
; June 23 2006: 42.96 Jy   UT:53544
; Sept 10 2006: 41.62 Jy   UT:53896 
; July 20 2007: 43.90 Jy   UT:54301           
; Sept 10 2007: 45.57 Jy   UT:54353           
; 
; NEPTUNE:
; June 30 2005: 17.42 Jy   UT:53551
; July 15 2005: 17.58 Jy   UT:53566           
; Sept 10 2005: 17.50 Jy   UT:53623 
; June 5  2006: 17.04 Jy   UT:53891
; June 23 2006: 17.33 Jy   UT:53544
; Sept 10 2006: 17.09 Jy   UT:53896 
; July 20 2007: 17.59 Jy   UT:54301           
; Sept 10 2007: 17.56 Jy   UT:54353           

