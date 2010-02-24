function gettracking,cleanfile,count=count,offset=offset

;this fuction returns a modified tracking ttl from the npstart,npend, and npoff fields in a cleaned file
;030820 GL -- created
;031016 GL -- error checked if both trck keywords are set
;031211 GL -- added count,offset
;040820 JS -- modified to conform with new scans info

;get scans info
ncdf_varget_scale,cleanfile,'scans_info',scans_info
scanstart=scans_info(0,*)
scanend=scans_info(1,*)
nscans=n_elements(scanstart)

;get observation length
ncdf_varget_scale,cleanfile,'trck_das',trck_temp
nframes=n_elements(trck_temp)

;set trck to 0 
trck=replicate(1,nframes)
;if precise scans was applied then trck_tel will no longer
;be reliable near the begining or end of a scan, so we need
;to look at trck_das
for i_scan=0L,nscans-1L do trck[scanstart[i_scan] : scanend[i_scan]] = 0

if keyword_set(offset) or keyword_set(count) then begin
	if not keyword_set(offset) then offset=0
	if not keyword_set(count) then count=nframes

	;error check
	if offset lt 0 or offset gt nframes-1L then message,'ERROR: invalid offset value'
	if count lt 0 or offset+count-1L gt nframes-1L then message,'ERROR: invalid count value'
	trck=trck(offset:offset+count-1L)
endif

return,trck
end
