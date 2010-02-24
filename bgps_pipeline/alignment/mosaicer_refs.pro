; creates a mosaic the size of the reference image 
; with the WCS coordinates of the reference image
; should be useful for checking BGPS degree-scale field
; alignments
;
; refim - the 'reference' image: should actually be the BGPS
;   degree-scale field EVEN IF the coordinates are incorrect
; mergeim - either a single image or a list of images with correct
;   pointing to be cross-correlated with the 'refim'.  
; outname - a filename to output the 'mergeim' images to
; shift_out - if specified, the BGPS image with corrected pointing
;   will be output to this file
; out_txt - if specified, will write offsets to a text file, otherwise
;   will write them to the screen
pro mosaicer_refs,refim,mergeim,outname,shift_out=shift_out,out_txt=out_txt,check_shift=check_shift,maxoff=maxoff
    if stregex(mergeim,'\.fits') eq -1 then begin
        readcol,mergeim,filelist,comment="#",format="A80",/silent

        ref = readfits(refim,refhdr,/silent)
        heuler,refhdr,/galactic

        maplist = fltarr([n_e(filelist),size(ref,/dim)])
        for i=0,n_e(filelist)-1 do begin
            m = readfits(filelist[i],mhdr,/silent)

            ; make sure coordinates are in galactic to match ref file
            heuler,mhdr,/galactic
            ; shift & regrid to match ref
            hastrom,m,mhdr,refhdr,missing=0,errmsg=errmsg

            ; NON-ROBUST error checking: basically, you can't add
            ; 'm' to the list of shifted things unless it's been
            ; shifted, so add zero if it hasn't (i.e. if it had no
            ; overlap with the reference)
            ; it's non-robust because if m coincidentally has the same number of data points in it as ref,
            ; the error-check will not be performed
            if n_e(m) ne n_e(ref) then m = fltarr(size(ref,/dim))
            maplist[i,*,*] = m
        endfor

        ; total the input images
        newmap = total(maplist,1,/nan)

        writefits,outname,newmap,refhdr

    endif else outname = mergeim


    if ~keyword_set(out_txt) then out_txt='/dev/tty/'
    image_shifts,outname,refim,out_txt,shift_out=shift_out,check_shift=check_shift,maxoff=maxoff

end


    
