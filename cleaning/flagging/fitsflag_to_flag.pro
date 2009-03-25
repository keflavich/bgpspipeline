

pro fitsflag_to_flag,flagfile,ncfile
;    date = (stregex(infile,'(0[5-7]0[679])([0-9][0-9]_o[b0-9][0-9])',/extract,/subexpr))[1]
;    ncname = stregex(fname,'[0-9]{6}_o[b0-9][0-9]_raw_ds5.nc',/extract)

    fitsflags = readfits(flagfile,hdr)
    ncdf_varget_scale,ncfile,'flags',flags
    ncdf_varget_scale,ncfile,'bolo_params',bolo_params

    nbolos = n_e(flags[*,0])
    bolo_indices = where(bolo_params[0,*])
    ncdf_varget_scale,ncfile,'scans_info',scans_info
    scanlen = scans_info[1,0]-scans_info[0,0]
    nscans = n_e(scans_info[0,*])
    whscan = indgen(scanlen) + scans_info[0,0] ; endpoint-exclusive, 0th iteration
    for j=1,n_e(scans_info[0,*])-1 do begin       ; index from one because 0th on previous line
        whscan = [whscan,indgen(scanlen) + scans_info[0,j]]
    endfor
    fs = reform(flags[*,whscan],nbolos,scanlen,nscans)*0
    fs[bolo_indices,*,*] = fitsflags
    flags[*,whscan] = reform(fs,nbolos,scanlen*nscans)
    if min(flags) lt 0 then flags[where(flags lt 0)] = 0
    ncdf_varput_scale,ncfile,'flags',flags
end
