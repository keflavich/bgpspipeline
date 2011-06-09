; takes the output of image_shifts and figures out which files to
; write the ra/dec offsets to, then does it
pro write_imshifts,infile,slicedir=slicedir
    readcol,infile,ncfile,raoff,decoff,format='(A,F,F,F,F,F)',comment="#"
    print,"Mean/stddev ra/dec offsets: ",mean(raoff)*3600,mean(decoff)*3600,stddev(raoff)*3600,stddev(decoff)*3600
    if ~keyword_set(slicedir) then slicedir=getenv('SLICED')
    
    for i=0,n_e(ncfile)-1 do begin
        spawn,'find '+slicedir+'* -name '+ncfile[i]+' -follow | grep \/sliced | grep -v preclean | grep _raw_ds | grep nc ',fn
        if n_elements(fn) le 1 then if strlen(fn) eq 0 then begin
            print,'"find '+slicedir+'* -name '+ncfile[i]+' -follow | grep \/sliced | grep -v preclean | grep _raw_ds | grep nc "'
            message,"ERROR: ncdf file not found!"
        endif
        for j=0,n_e(fn)-1 do begin 
;            if fn eq "" then print,"Filename was originally ",ncfile[i]," and was not matched."
            if file_test(fn[j]) then begin
                print,"Writing offsets to "+fn[j],raoff[i],decoff[i]," (ncfile was ",ncfile[i],")"
                alignment_offsets_to_ncdf,fn[j],raoff[i],decoff[i]
            endif else begin
                print,"File ",fn[j]," does not exist.  SKIPPING."
            endelse
        endfor
;        ncdf_varput_scale,fn[0],'radec_offsets',[raoff[i],decoff[i]]

    endfor
end
