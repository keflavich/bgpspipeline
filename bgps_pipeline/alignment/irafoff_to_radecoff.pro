; takes the output of imalign (approximately)
; and converts pixel offsets to RA/Dec offsets
; ACTUALLY, it doesn't do that.  At all.
pro irafoff_to_radecoff,infile,outfile
    readcol,infile,fname,xoff,xerr,yoff,yerr,a,a,format="(A,F,A,F,A,A,A)",comment="#"
    openw,outf,outfile,/get_lun
    for i=0,n_e(fname)-1 do begin
        m=readfits(fname[i],header,/silent)
        extast,header,astr
        xpix = fxpar(header,'CRPIX1')
        ypix = fxpar(header,'CRPIX2')
        xy2ad,xpix,ypix,astr,ra,dec
        xy2ad,xpix+xoff[i],ypix+yoff[i],astr,ra2,dec2
        raoff = ra2-ra
        decoff = dec2-dec
        printf,outf,fname[i],raoff,decoff,format='(A100,2F18.6)'
    endfor
    close,outf
    free_lun,outf

end
