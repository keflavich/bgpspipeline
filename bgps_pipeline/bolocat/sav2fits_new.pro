; Convert IDL savefiles of "result" (iterative mapping) or "mapstruct"
; (normal mapping) to FITS files

; modified to deal with iteratively mapped files 2006/06/05 JA

; Took Glenn's changes and modifying some more

pro sav2fits_new, filename, iterative_flag = iterative_flag, $
              galactic = galactic, output_root = output_root, $
              convolve = convolve, wiener = wiener

restore,filename
; Idiotic!
if keyword_set(iterative_flag) then begin
    mapstruct = result
endif else begin
    result = mapstruct
endelse

iterative_flag=1
if (keyword_set(iterative_flag)) then begin

	; Note that all of this is specific to the map actually being map in
	; RA/Dec
	;read in relevant data from mapstruct structure
    	map = result.map
    	mapcoverage = result.mapcoverage

        mapconvolve = result.mapconvolve
    	wienerconvolve = result.wienerconvolve

        if (keyword_set(convolve)) then begin
            if (n_e(mapconvolve) eq 1) then begin
                message,/info,'No convolved map in mapstruct.'
                message,/info,'Map field will be unconvolved.'
            endif else begin
                map = mapconvolve
            endelse
        endif

        if (keyword_set(wiener)) then begin
            if (n_e(wienerconvolve) eq 1) then begin
                message,/info,'No wiener-filtered map in mapstruct.'
                message,/info,'Map field will be unconvolved.'
            endif else begin
                map = wienerconvolve
            endelse
        endif

	;flip horizontally to get RA increasing to left    
    	if (not(keyword_set(galactic))) then begin
    	    map = reverse(map)
;    	    maperror = reverse(maperror)
    	    mapcoverage = reverse(mapcoverage)
;    	    wienerconvolve = reverse(wienerconvolve)
    	endif

	;get size of map
    	nx = n_e(map[*,0])
    	ny = n_e(map[0,*])
    
	;get reference RA, DEC 
    	x0 = result.ra_mid_pretrim
    	y0 = result.dec_mid_pretrim

	;get resolution in asec
    	dx = result.resolution/3600.0D0
    	dy = result.resolution/3600.0D0

	; Default reference pixel numbers (fortran starts n8mbering with 1)
	indicies=get_map_ij(mapstruct,result.ra_mid_pretrim,result.dec_mid_pretrim)
    	crpix1 = indicies[0]+1.0D0	;ra
	crpix2 = indicies[1]+1.0D0	;dec

    	if (not(keyword_set(galactic))) then begin
	; RA in degrees
	        x0 = x0 * 15.0D0

		; But if we flip, default is lower right
	        crpix1 = nx-crpix1+1.0D0
		dx=-dx

;		dx = dx/cos(y0*!dtor)
;        	dx = dx*24./360./cos(y0*!dtor)
endif    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get RA and dec of each pixel

ra_ij=dindgen(nx)
dec_ij=dindgen(ny)
make_2d,ra_ij,dec_ij

dummy=get_map_radec(mapstruct,ra_ij,dec_ij,ra=ra,dec=dec)
ra=15.0D0*reverse(ra)
dec=reverse(dec)

;ra = reverse((findgen(nx)*dx+x0)#replicate(1.,ny))
;dec = reverse(replicate(1.,nx)#(findgen(ny)*dy+y0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make the primary header, leaving room for extensions
mkhdr,header,map,/extend

; Add additional information
    if (keyword_set(galactic)) then begin
        sxaddpar, header, 'L0', result.ra0
        sxaddpar, header, 'B0', result.dec0
    endif else begin
        sxaddpar, header, 'RA0', result.ra0
        sxaddpar, header, 'DEC0', result.dec0
    endelse

    sxaddpar, header, 'EPOCH', result.epoch
    sxaddpar, header, 'RESO', result.resolution

;060418 GL set to zero for now
;    sxaddpar, header, 'NCOMP', result.ncomp
    sxaddpar, header, 'NCOMP', 0

;060418 GL set to today for now
;    sxaddpar, header, 'CREATED', result.date_created[0]
    sxaddpar, header, 'CREATED', 'May 21, 2004'

    sxaddpar, header, 'PRIMARY', 'Map'
    if (keyword_set(galactic)) then begin
        sxaddpar, header, 'XTEN1', 'L'
        sxaddpar, header, 'XTEN2', 'B'
    endif else begin
        sxaddpar, header, 'XTEN1', 'RA'
        sxaddpar, header, 'XTEN2', 'Dec'
    endelse
    sxaddpar, header, 'XTEN3', 'Map error'
    sxaddpar, header, 'XTEN4', 'Map coverage'
    sxaddpar, header, 'XTEN5', '"Opt. filt." map'

; Add something to nominally let IRAF read the positions
    sxaddpar, header, 'CTYPE1', 'RA---SFL'
    sxaddpar, header, 'CRVAL1',  x0
    sxaddpar, header, 'CRPIX1',  crpix1
    sxaddpar, header, 'CDELT1',  dx
;    sxaddpar, header, 'CROTA1',  0.
    sxaddpar, header, 'CTYPE2',  'DEC--SFL'
    sxaddpar, header, 'CRVAL2',  y0
    sxaddpar, header, 'CRPIX2',  crpix2
    sxaddpar, header, 'CDELT2',  dy
    sxaddpar, header, 'CROTA2',  0.

    if (keyword_set(output_root)) then begin
        
        fits_filename = output_root
        
    endif else begin

        temp = strsplit(filename,'.',/extract)
        fits_filename = temp[0]
; Use only the last "." 
        for i = 1,n_e(temp)-2 do begin
            fits_filename = fits_filename+'.'+temp[i]
        endfor

    endelse 

    fits_filename = fits_filename+'.fits'
    
; Make the extension header so there's also RA/Dec info in there too
    header_ext = header
    sxaddpar,header_ext,'XTENSION','IMAGE','IMAGE Extension',before='SIMPLE'
    sxdelpar,header_ext,'SIMPLE'
    sxaddpar,header_ext,'PCOUNT','0',after='NAXIS2'
    sxaddpar,header_ext,'GCOUNT','1',after='PCOUNT'
    
    help,map

; First two are always map and coverage
    message,/info,'Writing FITS file '+fits_filename
    writefits, fits_filename, map, header

;    mkhdr,header,mapcoverage,/image
    writefits, fits_filename, mapcoverage, header_ext, /append

;    mkhdr,header,mapconvolve,/image
;    writefits, fits_filename, mapconvolve, header, /append

;    mkhdr,header,wienerconvolve,/image
;    writefits, fits_filename, wienerconvolve, header, /append

endif else begin
; Default is to assume it's a normal "mapstruct" that's being restored

endelse

end
