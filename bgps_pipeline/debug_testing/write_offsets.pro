; write offsets in a text file to the file specified...
; input file format: FILENAME, RA_OFF, DEC_OFF , DEC - RA_OFF and DEC_OFF should be the positive offsets of the source from its 
; true location.  I.E. they will be added negatively.

pro write_offsets,infile
    readcol,infile,filename,raoff,decoff,dec,format='(A72,F20,F20,F)',comment="#"
    for i=0,n_e(filename)-1 do begin
        ncdf_varget_scale,filename[i],'array_params',array_params
        array_params[3] = -raoff[i]*cos(!dtor*dec[i]) ; offsets in DISTANCE ON THE SKY units
        array_params[4] = -decoff[i]
        ncdf_varput_scale,filename[i],'array_params',array_params
    endfor
end
