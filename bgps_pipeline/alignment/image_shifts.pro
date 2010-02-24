; Erik's image_shifts program heavily modified
; requirest a master and an input image
; imagein - the input image can be a list of images
; fileout - a filename to write the relevant calculated offsets to 
;           use '/dev/tty' to output to the screen
; check_shift - calls a STOP statement in the middle of pixshift
;               so that you can see what pixshift is doing
; shift_out - filename of output file with corrected coordinates 
pro image_shifts,masterimage,imagein,fileout , check_shift = check_shift,$
        shift_out=shift_out,maxoff=maxoff,_extra=_extra

    openw,outf,fileout,/get_lun

    ; read in the file list if it is a file list and not a fits file
    if stregex(imagein,'\.fits') eq -1 then begin
        readcol,imagein,filelist,comment="#",format="A80",/silent
    endif else filelist=[imagein]

    master = mrdfits(masterimage, 0, hdr)
    heuler,hdr,/galactic
    extast, hdr, astr

    ; we use the xcen/ycen as a starting point to add the offsets to
    ; and then calculate the ra/dec at the new point and take the
    ; difference to find the offset
    ; the -1's are needed to get from IRAF to IDL coordinates
    ; (checked empirically, but it makes sense: IRAF indexes from 1,1
    ; and IDL indexes from 0,0.  If I had used xy2ad, it wouldn't matter,
    ; but since I'm using the CRVALs I need to be careful about this)
    xcen = fxpar(hdr,'CRPIX1')-1
    ycen = fxpar(hdr,'CRPIX2')-1
    lcen = fxpar(hdr,'CRVAL1')
    bcen = fxpar(hdr,'CRVAL2')
    euler,lcen,bcen,racen,deccen,2

    ; formatted header for the output file
    printf,outf,"#","Filename","dra","ddec","dra_err(fitting)","ddec_err(fitting)","Stamp_residual",format='(A1,A20,5A20)'

    for i=0,n_e(filelist)-1 do begin
        fname = filelist[i]

        ; modified pixshifts so that the reading happens here 
        image = readfits(fname, hdimage, /silent)
        hdimg_gal = hdimage
        heuler,hdimg_gal,/galactic
        heuler,hdimage,/celestial

        ; the magic of cross-correlation
        pixshift, master, image,hd1=hdr,hd2=hdimg_gal, xoff = dx, yoff = dy ,$
            check_shift = check_shift,maxoff=maxoff,xerr=xerr,yerr=yerr,$
            stamp_residual_fraction=stamp_residual_fraction,_extra=_extra

        ; d[xy] = ref[xy] - image[xy]
        ; therefore [xy]new are the coordinates of the same point in the
        ; image being shifted
        ; ([xy]new = [xy]ref - ([xy]ref - [xy]image))
        xnew = xcen - dx 
        ynew = ycen - dy
        xy2ad,xnew,ynew,astr,lnew,bnew
        euler,lnew,bnew,ranew,decnew,2
        ; offset should be ref - image, so that
        ; image + offset = image + (ref-image) = ref
        dra  = racen  - ranew  
        ddec = deccen - decnew 

        extast,hdimage,cel_astr
        cel_errarr = [xerr,yerr] # cel_astr.cd
        extast,hdimg_gal,gal_astr
        gal_errarr = [xerr,yerr] # cel_astr.cd

        print,'File :',fname,' aligned to ',masterimage,' shifts in pixels:',-dx,-dy,' shifts in arcsec l/b:',-dx*astr.cd[0,0]*3600.,-dy*astr.cd[1,1]*3600.,$
            " delta-ra (as): ",dra*cos(!dtor*decnew)*3600.," delta-dec (as): ",ddec*3600.,$
            " x/y error in pixels: ",xerr,yerr," ra/dec error: ",cel_errarr[0],cel_errarr[1]," gal l/b error: ",gal_errarr[0],gal_errarr[1]
;old output        printf,outf,fname,-dx*astr.cd[0,0],-dy*astr.cd[1,1],format='(A80,F20.6,F20.6)'

        ; if you're aligning an image without an NCDF name in it, there will be no filename output
        ncname = stregex(fname,'[0-9]{6}_o[b0-9][0-9]_raw_ds5.nc',/extract)
        printf,outf,ncname,dra,ddec,cel_errarr[0],cel_errarr[1],stamp_residual_fraction,format='(A21,5G20.6)'


        if keyword_set(shift_out) then begin
            image = readfits(fname, hdimage, /silent)
            sxaddpar, hdimage, 'CRPIX1', sxpar(hdimage, 'CRPIX1')-dx
            sxaddpar, hdimage, 'CRPIX2', sxpar(hdimage, 'CRPIX2')-dy
        
            ;oldcode now split filename in order to write output to new file
            ;oldcode fileout=strsplit(fileout,'.fits',/extract,/regex)+'_test_aligned.fits'
            
            ;now write out new fits file
            if n_e(filelist) gt 1 then begin ; if looping through a list, then output each one with a fixed prefix
                writefits,shift_out+fname,image,hdimage
                print,'Wrote ',shift_out+fname
            endif else begin
                writefits,shift_out,image,hdimage
                print,'Wrote ',shift_out
            endelse
        endif

    endfor

    close,outf
    free_lun,outf


end
