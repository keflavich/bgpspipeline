; find (small) shifts between images
; then median stack them

function shift_and_stack,masterimage,imagelist,normalize=normalize

    if stregex(imagelist,'\.fits') eq -1 then begin
        readcol,imagelist,filelist,comment="#",format="A80",/silent
    endif else filelist=[imagelist]

    master = mrdfits(masterimage, 0, hdr)
    if keyword_set(normalize) then normfactor = median(master) else normfactor=1

    imsize = 10*size(master,/dim)
    maplist = fltarr([n_e(filelist)+1,imsize])

    maplist[0,*,*] = congrid(master,imsize[0],imsize[1]) / normfactor

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
            stamp_residual_fraction=stamp_residual_fraction

        if keyword_set(normalize) then imnorm = median(image) else imnorm = 1

        bigim = congrid(image,imsize[0],imsize[1]) / imnorm
        
        maplist[i+1,*,*] = shift(bigim,round(dx*10),round(dy*10))
    endfor

    mapstack = congrid(median(maplist,dim=1),imsize[0]/10,imsize[1]/10) * normfactor

    stop
    return,mapstack
end




