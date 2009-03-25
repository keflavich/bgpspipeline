; takes coordinates found by imalign or starfind or something
; then does the same general thing that imalign does:
; finds the average offset
; however, it does it in RA/Dec coords (I hope)
pro irafcoords_to_radecoff,infile,outfile
    readcol,infile,fname,x,xerr,y,yerr,starnum,format="(A,F,A,F,A,I)",comment="#"
    openw,outf,outfile,/get_lun
    printf,outf,"Filename","x","xerr","y","yerr","starnumber","ra","dec",format="(A100,7A18)"
    refname = fname[0]
    m=readfits(refname,refheader,/silent)
    refpix1 = fxpar(refheader,'CRPIX1')
    refpix2 = fxpar(refheader,'CRPIX2')
    refval1 = fxpar(refheader,'CRVAL1')
    refval2 = fxpar(refheader,'CRVAL2')
    newfile = where(starnum[1:n_e(starnum)-1]-starnum[0:n_e(starnum)-2] lt 0)
    newfile = [-1,newfile,n_e(starnum)-1]
    nstars  = max(starnum)
    nfiles  = n_e(newfile)-1
    ra_arr  = dblarr(nfiles,nstars) + !values.f_nan
    dec_arr = dblarr(nfiles,nstars) + !values.f_nan
    xarr    = dblarr(nfiles,nstars) + !values.f_nan
    yarr    = dblarr(nfiles,nstars) + !values.f_nan
    for i=0,n_e(newfile)-2 do begin
        m=readfits(fname[newfile[i+1]],header,/silent)
        extast,header,astr
        crpix1 = fxpar(header,'CRPIX1')
        crpix2 = fxpar(header,'CRPIX2')
        crval1 = fxpar(header,'CRVAL1')
        crval2 = fxpar(header,'CRVAL2')
        ctype1 = fxpar(header,'CTYPE1')
        print,"pix/val parameters: ",fname[newfile[i+1]],crpix1,crpix2,crval1,crval2
        for j=newfile[i]+1,newfile[i+1] do begin
            xy2ad,x[j],y[j],astr,v1,v2
            if ctype1 eq 'GLON-CAR' then euler,v1,v2,ra,dec,2 $
                else begin & ra = v1 & dec = v2 & endelse
            ra_arr[i,starnum[j]-1]  = ra
            dec_arr[i,starnum[j]-1] = dec
            xarr[i,starnum[j]-1]    = x[j]
            yarr[i,starnum[j]-1]    = y[j]
            printf,outf,fname[j],x[j],xerr[j],y[j],yerr[j],starnum[j],ra,dec,format='(A100,F18.6,A18,F18.6,A18,3F18.6)'
        endfor
        printf,outf,""
    endfor

    ; backwards sign: these are image - ref
    ra_offs = ra_arr[1:*,*] - replicate(1,nfiles-1) # ra_arr[0,*]
    dec_offs = dec_arr[1:*,*] - replicate(1,nfiles-1) # dec_arr[0,*]
    x_offs = xarr[1:*,*] - replicate(1,nfiles-1) # xarr[0,*]
    y_offs = yarr[1:*,*] - replicate(1,nfiles-1) # yarr[0,*]

    printf,outf,""
    printf,outf,"#Offsets:","Filename","raoff","decoff","raoff(dist)","decoff(dist)","xoff","yoff",format="(A9,A91,6A18)"
    refdone = 0
    for i=0,n_e(ra_offs[*,0])-1 do begin
        raoff  = mean(ra_offs[i,*],/nan)
        decoff = mean(dec_offs[i,*],/nan)
        xoff  = mean(x_offs[i,*],/nan)
        yoff = mean(y_offs[i,*],/nan)
        if refdone eq 0 then printf,outf,fname[newfile[i+1]+1],raoff,decoff,3600D*raoff*cos(!dtor*dec),3600D*decoff,xoff,yoff,format="(A100,6F18.6)"
        if fname[newfile[i+1]+1] eq refname then refdone=1
    endfor

    printf,outf,""
    printf,outf,"# IDL COMMANDS"
    spawn,'pwd',pwd
    current_field = stregex(pwd,'l[0-9][0-9][0-9]',/extract)
    refdone = 0
    for i=0,n_e(ra_offs[*,0])-1 do begin
        ncname = stregex(fname[newfile[i+1]+1],'[0-9]{6}_o[b0-9][0-9]_raw_ds5.nc',/extract)
        raoff  = mean(ra_offs[i,*],/nan)
        decoff = mean(dec_offs[i,*],/nan)
        if refdone eq 0 then begin
            printf,outf,"ncdf_varput_scale,'"+"/scratch/sliced/"+current_field+"/"+ncname+"','radec_offsets',["+strc(-raoff)+","+strc(-decoff)+"]"
            print,"ncdf_varput_scale,'"+"/scratch/sliced/"+current_field+"/"+ncname+"','radec_offsets',["+strc(-raoff)+","+strc(-decoff)+"]"
        endif
        if fname[newfile[i+1]+1] eq refname then refdone=1
    endfor

    close,outf
    free_lun,outf

end
