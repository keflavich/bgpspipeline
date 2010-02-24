pro radecrange,thefiles,outfile
    openw,outf,outfile,/get_lun
    OPENW, logfile, '/dev/null', /GET_LUN, /MORE  
    printf,outf,"Filename","minra","maxra","mindec","maxdec","minl","maxl","minb","maxb",format="(A50,8A20)"
    readcol, thefiles, filelist, format='A80',comment="#",/silent  ; read in the raw filenames 
    for i=0,n_e(filelist)-1 do begin
        filename = filelist[i]

        readall_pc,[filename],ra_map=ra_map,dec_map=dec_map,logfile=logfile,bolo_indices=indgen(144)

        minra = min(ra_map)
        maxra = max(ra_map)
        mindec = min(dec_map)
        maxdec = max(dec_map)
        euler,ra_map,dec_map,l,b,1
        minl = min(l)
        maxl = max(l)
        minb = min(b)
        maxb = max(b)

        printf,outf,filename,minra,maxra,mindec,maxdec,minl,maxl,minb,maxb,format="(A50,8F20.6)"

    endfor
    close,outf
    free_lun,outf
    close,logfile
    free_lun,logfile
end
