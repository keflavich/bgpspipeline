
; do_flatfield
; dumb wrapper for bolo_flat (which operates on a scan-by-scan basis)
; and poly_sub, which operates on a single scan from a single bolometer
pro do_flatfield,filelist,doplotting=doplotting
    print,"BEGINNING FLATFIELDING"
    for i=0,n_elements(filelist)-1 do begin
        filename=filelist[i]
        read_ncdf_vars,filename,raw=raw,ac_bolos=ac_bolos,bolo_params=bolo_params,sample_interval=sample_interval,scans_info=scans_info,flags=flags
        nscans = n_e(scans_info[0,*])
        nbolos = total(bolo_params[0,*])
        scanlen = scans_info[1,0]-scans_info[0,0]
        gb = where(bolo_params[0,*])
        ac_flagged = ac_bolos
        ac_flagged[where(flags)] = !values.f_nan

        total_scan_model = 0
        for s = 0,nscans-1 do begin
            lb = scans_info[0,s]
            ub = scans_info[1,s]
            current_scan = ac_flagged[gb,lb:ub]

            if total(finite(current_scan,/nan)) eq n_e(current_scan) then continue

;            current_scan = bolo_flat(current_scan,scan_model=scan_model)
            if keyword_set(doplotting) then tvscl,current_scan

;            current_scan = relsens_flat(current_scan)

            for b=0,nbolos-1 do begin
                ; 0:scanlen is used here because [*] on the left side is discouraged
                current_scan[b,0:scanlen] = poly_sub(current_scan[b,0:scanlen],/sigmareject) 
            endfor
            if keyword_set(doplotting) then tvscl,current_scan

            ac_flagged[gb,lb:ub] = current_scan
          ;  total_scan_model = [total_scan_model,scan_model]
        endfor
        
        if keyword_set(doplotting) then begin
            window,0 & plot,total(ac_bolos[gb,*],2,/nan)
                oplot,total(ac_flagged[gb,*],2,/nan),color=210
          ;  window,1 & plot,total_scan_model
          ;              oplot,total(ac_bolos[gb,*],1,/nan)/nbolos,color=220
        endif

        ac_bolos[where(~flags)] = ac_flagged[where(~flags)]
        ncdf_varput_scale, filename, 'ac_bolos', ac_bolos
    endfor
    print,"DONE FLATFIELDING"
end


