; adds calibration coefficients to an NCDF file to be read in with the rest of the relevant information
; is a set of 3 polynomial coefficients in DC_BOLOS
pro calcoeffs_to_ncdf,filename,calcoeffs
    if file_test(filename) eq 0 then message,"Could not find file "+filename
    ncdf_new_variable,filename,'cal_coefs',[calcoeffs],'bolo_param'
end
