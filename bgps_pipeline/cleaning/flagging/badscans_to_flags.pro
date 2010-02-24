; badscans_to_flags
; returns a set of flags with all data in the bad_scans set to 1
; REQUIRED INPUT:
;   flags      - a flags array.  A modified version of this array will be returned
;   scans_info - listing of scan start/end points, loaded from the NCDF file variable of the same name
;   bad_scans  - a list of bad scan numbers. If it is a number and not an array, no changes to the flags will be made
function badscans_to_flags,flags,scans_info,bad_scans
   if size(bad_scans,/n_dim) eq 0 then return,flags  ; make sure there is at least one bad scan to flag
;   n_scans = n_e(scans_info[0,*])   
   n_bad_scans = n_e(bad_scans)       ; how many bad scans are there?
   for i=0,n_bad_scans-1 do begin   
       scan_to_flag = bad_scans[i]    
       lb = scans_info[0,scan_to_flag]
       ub = scans_info[1,scan_to_flag]
       flags[*,lb:ub] = 1
   endfor
   return,flags
end

