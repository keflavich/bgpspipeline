; flagging_wrapper is the new, simple flagging wrapper
; it is not all that transparent:  
; and order matters a lot
;   1a. flag_between_scans removes the parts where the telescope is moving around / not really observing the sky
;   1b. flag_scan_starts removes the first 20% (by default) of scans for given bolometers
;   1c. find_bad_scans flags out single bolometers for single scans based on high STDDEV
;   2. calculate_flags is an automated flagging procedure - see below for details
;   3. psd_calc_flags is a PSD-based automatic flagger
;   4. badscans_to_flags takes the psd_calc_flags output and applies it to the flag data
;   5. remove_bad_bolos does the same as 4. by bolometer instead of by flag
pro flagging_wrapper,ac_bolos=ac_bolos,scans_info=scans_info,flags=flags,bolo_params=bolo_params,$
        sample_interval=sample_interval,psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,         $
        bad_scans=bad_scans,bad_bolos=bad_bolos,raw=raw,dc_bolos=dc_bolos,ra_map=ra_map,         $
        dec_map=dec_map,psd_psd=psd_psd,reflag=reflag,bolo_indices=bolo_indices,                 $
        psd_flag=psd_flag,logfile=logfile,_extra=_extra


;        flags = calculate_flags(ac_bolos,flags=flags,bp=bolo_params,/preflagged,reflag=reflag,_extra=extra)
;    ac_bolos = find_bad_scans(ac_bolos,scans_info,flags=flags)

    ; flag_between_scans - reasonably self-evident, gets rid of turnaround times
;062508 not necessary any more    ac_bolos = flag_between_scans(ac_bolos,scans_info,flags=flags)

    ; psd calculations are done in
    if keyword_set(psd_flag) then begin
        flagtot = total(flags)
        psd_psd = all_psds(ac_bolos,scans_info,flags=flags,bolo_params=bolo_params,sample_interval=sample_interval,  $
            psd_avescan=psd_avescan,psd_avebolo=psd_avebolo,_extra=extra)
        badarr = psd_calc_flags(psd_avebolo=psd_avebolo,psd_avescan=psd_avescan,bad_scans=bad_scans,bad_bolos=bad_bolos)
        flags = badscans_to_flags(flags,scans_info,bad_scans)
        print,"PSDFLAG: Flagged on PSDs: ",total(flags)-flagtot," points flagged"
    endif

    if n_e(bad_bolos) gt 0 then if total(bad_bolos) gt 0 then print,"These bolos were determined to be bad based on PSD flagging:",bad_bolos
    if size(bad_bolos,/n_dim) ne 0 or (size(bad_bolos,/n_dim) eq 0 and size(bad_bolos,/type) ne 0 and n_e(bad_bolos) ne 0) then $
        flags[*,bad_bolos] = 1
;        if total(bad_bolos) gt 0 then $ 
;        remove_bad_bolos,bad_bolos=bad_bolos,flags=flags,bolo_params=bolo_params,$
;        raw=raw,ac_bolos=ac_bolos,dc_bolos=dc_bolos,ra_map=ra_map,dec_map=dec_map,$
;        bolo_indices=bolo_indices
;    if n_e(bad_bolos) gt 0 and size(bad_bolos,/n_dim) gt 0 and n_e(bolo_indices) eq 144 then stop ; debug: if bolos are flagged, they shouldn't exist any more

    ac_bolos = find_bad_scans(ac_bolos,scans_info,flags=flags)
;    flags = calculate_flags(ac_bolos,flags=flags,bp=bolo_params,/preflagged,reflag=reflag,_extra=extra)
;    if keyword_set(reflag) then begin
;        ac_bolos = flag_scan_starts(ac_bolos,scans_info=scans_info,flags=flags,start_fraction=.15) 
;    endif
    if total(flags) gt 0 then begin
        ac_bolos[where(flags)] = !values.f_nan 
        print,"Total of ",n_e(where(flags))," points flagged"
        printf,logfile,"Total of ",n_e(where(flags))," points flagged"
    endif else print,"No values flagged as bad!"
end

