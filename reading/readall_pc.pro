
; readall_pc is the modified version of readall
; it reads in all of the necessary parameters from a series of files,
; compiles them into extra-long timestreams, and returns them
; the modification is that the pointing is calculated in this wrapper now
; This is NOT a flexible procedure: in order to work, it has to be passed AT LEAST
; logfile and bolo_indices.  If you wanted to call it doing nothing, I'd recommend something like:
;
;    OPENW, logfile, '/dev/tty', /GET_LUN, /MORE  
;    readall_pc,[filename],logfile=logfile,bolo_indices=indgen(144)
;    close,logfile
;    free_lun,logfile
pro readall_pc,filelist,ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
            raw=raw,sample_interval=sample_interval, scans_info=scans_info,noisefilt_weights=noisefilt_weights,  $
            ra_map=ra_map,dec_map=dec_map,wh_scan=wh_scan,blank_map=blank_map,logfile=logfile,goodbolos=goodbolos, $
            beam_loc_file=beam_loc_file,bolo_indices=bolo_indices,lst=lst,fazo=fazo,fzao=fzao,mvperjy=mvperjy, $
            jd=jd,radec_offsets=radec_offsets,pointing_model=pointing_model,bgps_struct=bgps_struct,distcor=distcor,$
            mars=mars,_extra=_extra
    
; 9/5/08 changed to read from file    if ~keyword_set(mvperjy) then mvperjy = [-0.00333379,-2.92617,6.97269]
    if keyword_set(mvperjy) then mvperjy_temp=mvperjy else mvperjy_temp = 0
    if ~keyword_set(bolo_indices) then bolo_indices = indgen(144)
    if ~keyword_set(logfile) then begin OPENW, logfile, '/dev/tty', /GET_LUN, /MORE  & close_log=1 & endif else close_log=0
;    median_ra = 0
;    median_dec = 0
    ; as per james' request, the hack has been reinstated 9/19/08. ARRR!
    ;    Got rid of the damned hack! 10/24/08.  Ninjas win!
;    beam_loc_file = '/home/milkyway/student/drosback/bolocam_cvs/pipeline/cleaning/parameters/beam_locations_jul05.txt' ; HACK!  Such a hack...
    for i=0,n_e(filelist)-1 do begin
        filename = filelist[i]
        print,"Reading file ",filename

        ; read_ncdf_vars is a reading wrapper that acts in place of ncdf_varget_scale so that each file needs to be opened only
        ; once.  It's not a big time-saver, but it was easier for me to use than ncdf_varget_scale with its varied options
        ; that I'm not familiar with (ok, not easier, but I could follow the steps exactly)
        read_ncdf_vars,filename,ac_bolos=ac_bolos,dc_bolos=dc_bolos,flags=flags,bolo_params=bolo_params, $
            raw=raw,sample_interval=sample_interval, scans_info=scans_info,lst=lst,mvperjy=mvperjy,      $
            radec_offsets=radec_offsets,beam_loc=beam_loc,source_ra=source_ra,source_dec=source_dec
    
        if n_e(mvperjy_temp) eq 3 then mvperjy = mvperjy_temp ; allows keyword to be set to override read_ncdf_vars
        if total(beam_loc[0,*]) gt 0 and keyword_set(distcor) then begin
            print,"Using distortion correction written to beam_locations"
            bolo_params[1,*] = beam_loc[1,*]
            bolo_params[2,*] = beam_loc[0,*]
            bolo_params[0,where(total(beam_loc,1) eq 0)] = 0
        endif

        ; do the pointing first.  ra_map and dec_map are modified
        ; badbolos are read from the beam_locations file/parameter
        ; if the beam_loc_file is specified (not by default!), then the file is used
        ; fazo/fzao are output parameters for later use (they should not be used
        ; for coadds, but I needed them for debugging single observations)
        pointing_wrapper_wrapper,filename,beam_loc_file=beam_loc_file,ra_all=ra_map,dec_all=dec_map,$
            badbolos=badbolos,bolo_params=bolo_params,fazo=fazo,fzao=fzao,radec_offsets=radec_offsets,$
            jd=jd,logfile=logfile,badscans=badscans,pointing_model=pointing_model,_extra=_extra

        if total(badscans) gt 0 then begin
            printf,logfile,"Scans ",where(badscans)," flagged in file "+filename," because of rotation"
            print,"Scans ",where(badscans)," flagged in file "+filename," because of rotation"
        endif

        ; have to check if there are bad bolos, then make sure the bolo_params
        ; recognize that (bolo_params is treated as the 'master' list of bad bolos
        ; after this point)
        if size(badbolos,/n_d) gt 0 then bolo_params[0,badbolos] = 0
        goodbolos = where(bolo_params[0,*])

        ; wh_scan_full is index of where there are scans....
        ; really useful if we want to cut out between-scan stuff for ~25% increase in efficiency
        scanlen = scans_info[1,0]-scans_info[0,0]
        n_in_scan = scanlen+1
        wh_scan_full = indgen(n_in_scan) + scans_info[0,0] ; endpoint-inclusive, 0th iteration
        if badscans[0] then flags[*,scans_info[0,0]:scans_info[1,0]] = 1 ; if first scan is bad, flag it
        for j=1,n_e(scans_info[0,*])-1 do begin       ; index from one because 0th on previous line
            if (scans_info[1,j]-scans_info[0,j]) ne scanlen then message,"Error:  Differing Scan Length."
            wh_scan_full = [wh_scan_full,indgen(n_in_scan) + scans_info[0,j]]
            ; some scans are flagged as bad based on rotation
            if badscans[j] then flags[*,scans_info[0,j]:scans_info[1,j]] = 1
        endfor

        ; then, need to correct scans_info for no between-scans
        scans_info_new = scans_info
        scans_info_new[0,0] = 0        ; start at zero
        scans_info_new[1,0] = scanlen  ; x[0:scanlen] has n_in_scan elements
        for k=1,n_e(scans_info_new[0,*])-1 do begin
            if scanlen ne (scans_info_new[1,k]-scans_info_new[0,k]) then message,"Error:  Differing Scan Length."
            scans_info_new[0,k] = scans_info_new[1,k-1] + 1     ; start of scan is end of previous scan + 1
            scans_info_new[1,k] = scans_info_new[0,k] + scanlen ; end of scan is start of scan + scanlen
        endfor

        ; first iter...
        if i eq 0 then begin
            all_acb = ac_bolos[*,wh_scan_full]
            all_lst = lst[wh_scan_full]
            all_dcb = dc_bolos[*,wh_scan_full]
            all_flags = flags[*,wh_scan_full]

            ; special treatment of good bolos
            all_bpars = bolo_params
            all_bpars[0,*] = bytarr(n_e(all_bpars[0,*])) 
            all_bpars[0,goodbolos] = 1

;            median_ra  = ra_map[n_e(ra_map)-1]      ;median(ra_temp[unflagged])
;            median_dec = dec_map[n_e(dec_map)-1]    ;median(dec_temp[unflagged])
            all_ra = ra_map[*,wh_scan_full]
            all_dec = dec_map[*,wh_scan_full]
            all_scans = scans_info_new
            if n_e(raw) eq n_e(ac_bolos) then all_raw = raw[*,wh_scan_full]
            si = sample_interval
        endif else begin
            ts_length = n_e(all_acb[0,*])
            all_acb = [[all_acb],[ac_bolos[*,wh_scan_full]]]
            all_lst = [all_lst,lst[wh_scan_full]]
            all_dcb = [[all_dcb],[dc_bolos[*,wh_scan_full]]]
            all_flags = [[all_flags],[flags[*,wh_scan_full]]]
            all_bpars[0,*] *= bolo_params[0,*]
            all_ra = [[all_ra],[ra_map[*,wh_scan_full]]]
            all_dec = [[all_dec],[dec_map[*,wh_scan_full]]]
                 ; all_scans[ts_length] should be the zeroth index of scans_info_new
            all_scans = [[all_scans],[scans_info_new+ts_length]]  ; follows pattern of scans_info_new set above: first element of new ones is 1+last element of previous
            if n_e(all_raw) gt 0 then all_raw = [[all_raw],[raw[*,wh_scan_full]]]
            if sample_interval ne si then message,"Input files have different sample intervals.  That's not cool."
        endelse

    endfor

    ;ac_bolos = all_acb[goodbolos,*] 
    dc_bolos = all_dcb[goodbolos,*]
    ; flux calibration is done on this line (1000 converts V to mV):
    ac_bolos = all_acb[goodbolos,*] / (mvperjy[0] + dc_bolos*(mvperjy[1]) + dc_bolos^2 * mvperjy[2]) * 1000. ; flux calibration
    if keyword_set(mars) then begin
        print,"TREATING AS A MARS OBSERVATION"
        ac_bolos = -101.0*dc_bolos
    endif
    flags = all_flags[goodbolos,*]
    bolo_params = all_bpars[*,goodbolos]
    ra_map = all_ra[goodbolos,*]
    dec_map = all_dec[goodbolos,*]
    bolo_indices = bolo_indices[goodbolos]
    scans_info = all_scans
    lst = all_lst
;unnecessary?    noisefilt_weights = all_nfw
    if n_e(all_raw) gt 0 then raw = all_raw[goodbolos,*]
    sample_interval = si


    ; wh_scan is not used in the current version of the pipeline
    ; but I think it's potentially VERY useful.  In fact, NOT using it might have caused me
    ; more than a week of grief
;    wh_scan = indgen(n_in_scan) + scans_info[0,0] ; why wouldn't scans_info index from zero? - 1 ;indexing from zero: subtract 1
;    for i=1,n_e(scans_info[0,*])-1 do begin
;        wh_scan = [wh_scan,indgen(n_in_scan) + scans_info[0,i]]
;    endfor
    wh_scan = wh_scan_full

    printf,logfile,"Good bolos: ",goodbolos,format="(A20,144I6)"

    if close_log then begin
        close,logfile
        free_lun,logfile
    endif

    bgps_struct = { $
        scans_info: scans_info ,$
        ac_bolos: ac_bolos,$
        dc_bolos: dc_bolos,$
        raw: ac_bolos,$
        noise: ac_bolos*0,$
        astrosignal: ac_bolos*0,$
        atmosphere: ac_bolos*0,$
        glitchloc: byte(flags*0), $
        sample_interval: sample_interval,$
        flags: byte(flags),$
        mvperjy: mvperjy,$
        radec_offsets: radec_offsets,$
        bolo_params: bolo_params,$
        wh_scan: wh_scan,$
        ra_map: ra_map,$
        dec_map: dec_map,$
        bolo_indices: bolo_indices,$
        lst:lst,$
        jd:jd,$
        fazo:fazo,$
        fzao:fzao,$
        wt2d:fltarr(n_e(scans_info[0,*]),n_e(ac_bolos[*,0])),$
        var2d:fltarr(n_e(scans_info[0,*]),n_e(ac_bolos[*,0])),$
        weight: ac_bolos*0+1,$
        n_obs: n_e(filelist), $
        scale_coeffs: fltarr(n_e(scans_info[0,*]),n_e(goodbolos)) + 1, $
        source_ra: source_ra[0],$
        source_dec: source_dec[0],$ 
        badscans: badscans $
        }

end

