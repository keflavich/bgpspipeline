; kill scan starts:
; remove the scan starts from the file by changing scans_info to ignore the first 10s of any scan
pro kill_scanstarts,filename,length=length

    ncdf_varget_scale,filename,'scans_info',scans_info
    if ~keyword_set(length) then length = floor(.1 * (scans_info[1,0]-scans_info[0,0]))
    scans_info_new = scans_info
    scans_info_new[0,*] += length
    ncdf_varput_scale,filename,'scans_info',scans_info_new
    ncdf_new_variable,filename,'scans_info_backup',scans_info,['two','scan']

end

