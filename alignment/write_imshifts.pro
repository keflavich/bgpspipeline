; takes the output of image_shifts and figures out which files to
; write the ra/dec offsets to, then does it
pro write_imshifts,infile
    readcol,infile,ncfile,raoff,decoff,format='(A21,F20,F20,F20,F20,F20)',comment="#"
    
    for i=0,n_e(ncfile)-1 do begin
        spawn,'find '+getenv('SLICED')+'* -name '+ncfile[i]+' | grep \/sliced | grep -v preclean | grep _raw_ds[15].nc ',fn
        for j=0,n_e(fn)-1 do begin 
;            if fn eq "" then print,"Filename was originally ",ncfile[i]
            print,"Writing offsets to "+fn[j],raoff[i],decoff[i]," (ncfile was ",ncfile[i],")"
            alignment_offsets_to_ncdf,fn[j],raoff[i],decoff[i]
        endfor
;        ncdf_varput_scale,fn[0],'radec_offsets',[raoff[i],decoff[i]]

    endfor
end
