; add the alignment offsets (calculated by hand) to the ncdf file
; note that the agreed-upon units convention is coordinate RA/Dec
pro alignment_offsets_to_ncdf,filename,raoff,decoff
    if file_test(filename) eq 0 then message,"Could not find file "+filename
    ncdf_new_variable,filename,'radec_offsets',[raoff,decoff],'two'
end
