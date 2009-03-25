; psd_calc_flags
; returns an n_bolo x n_scan array in which BAD bolometers/scans are flagged with a value of 1
; the matrix columns / rows are not independent: there is really ONE array of bad bolometers and 
; ONE array of bad scans, but they are replicated so that they can be returned as a single matrix
; Bad bolometers and scans are determined by a 3-sigma rejection by medianing across the PSD
;; NOTE / HACK / I'M A BAD PERSON FOR THIS:  I hard-coded in the n_sigma
;; rejections.  Those should be more-precisely determined parameters.... or left
;; as user input.  It's easy to fix, but also a pain because it means 4 more
;; parameters 
;
; REQUIRED INPUT:
;   One of:
;       psd_avebolo - 'psd_avebolo' from the netcdf file after the psd clean has been run
;       psd_avescan - 'psd_avescan' from the netcdf file after the psd clean has been run
; OPTIONAL INPUT:
;       bad_scans   - output badscans into a vector listing bad scan locations
;       bad_bolos   - output badbolos into a vector listing bad bolometer locations
;       preflagged  - if given, values of 1 in BAD_SCANS,BAD_BOLOS are treated as bad and NOT used in flagging calculations 
;                     if preflagged is specified, then the PSD_ corresponding to the BAD_ must also be specified
function psd_calc_flags,psd_avebolo=psd_avebolo,psd_avescan=psd_avescan,bad_scans=bad_scans,bad_bolos=bad_bolos,preflagged=preflagged
    if keyword_set(preflagged) then begin
        message,"Preflagging not allowed: it's a little more complicated than I had originally allowed for."
        if keyword_set(bad_scans) then psd_avescan = psd_avescan[where(~bad_scans),*]
        if keyword_set(bad_bolos) then psd_avebolo = psd_avebolo[where(~bad_bolos),*]
    endif

    if keyword_set(psd_avebolo) then begin                  ; for now, assuming that no scans are uniformly 0
        scan_med = median(psd_avebolo,dim=2) 
        scan_med_std = stddev(scan_med)
        scan_med_median = median(scan_med)
        bad_scans_arr = fltarr(n_e(scan_med))
            ; scan rejection is +4 sig / -2 sig
        where_bad_scans = where((scan_med gt (scan_med_median + 4 * scan_med_std)) or (scan_med lt (scan_med_median - 2 * scan_med_std)))
        if size(where_bad_scans,/n_dim) ne 0 then bad_scans_arr[where_bad_scans] = 1
        bad_scans = where_bad_scans
    endif else bad_scans_arr = fltarr(1)

    if keyword_set(psd_avescan) then begin
        n_bolos = n_e(psd_avescan[*,0])
        good_bolos = where(total(psd_avescan,2))            ; some bolometers have already been flagged, so their PSDs are uniformly 0
        if n_e(good_bolos) eq 1 and size(good_bolos,/dim) eq 0 then begin
            print,"CAN'T FLAG ON PSDS BECAUSE THEY COULD NOT BE CALCULATED FOR VARYING SCANLENGTHS"
            print,"or... can't flag because there were no good bolos?"
            len_bad_bolo = n_bolos
            len_bad_scan = n_e(bad_scans_arr)
            bad_bolos_arr = fltarr(n_bolos)
            badarr = rebin(bad_bolos_arr,len_bad_bolo,len_bad_scan) 
            return,badarr
        endif
        bolo_med = median(psd_avescan,dim=2)
        bolo_med_std = stddev(bolo_med[good_bolos])         ; only want to include bolometers in calculation that are not already flagged
        bolo_med_median = median(bolo_med[good_bolos])
        bad_bolos_arr = fltarr(n_bolos)
        
        ; sigma rejection of bolometers based on median of PSD: +4 sigma, -2
        ; sigma (can be more aggressive on the low end)
        where_bad_bolos = where((bolo_med gt bolo_med_median + 5 * bolo_med_std) or (bolo_med lt bolo_med_median - 3 * bolo_med_std))
        if size(where_bad_bolos,/n_dim) ne 0 then bad_bolos_arr[where_bad_bolos] = 1
        bad_bolos = where_bad_bolos
    endif else bad_bolos_arr=fltarr(0)

    len_bad_bolo = n_e(bad_bolos_arr)
    len_bad_scan = n_e(bad_scans_arr)
    badarr = rebin(bad_bolos_arr,len_bad_bolo,len_bad_scan) + rebin(transpose(bad_scans_arr),len_bad_bolo,len_bad_scan)

    return,badarr
end

