; add the new header parameters to all ds5 files
; they can then be written to later as normal
; (i.e. using ncdf_varput_scale)
pro addnewpars,filelist

    readcol, filelist, thefiles, format='A100',comment="#",/silent  ; read in the raw filenames 

    for i=0,n_e(thefiles)-1 do begin
        filename = thefiles[i]

        ; minor errorchecking
        str = stregex(filename,'(_raw)(_ds5)?(.nc)',/sub,/extract)    
        if str[2] ne '_ds5' or str[3] ne '.nc' then message,'Must input an NCDF file of form _raw_ds5.nc, you had '+filename

        alignment_offsets_to_ncdf,filename,0,0
        calcoeffs_to_ncdf,filename,[-0.00333379,-2.92617,6.97269]
    endfor

end
