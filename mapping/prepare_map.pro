; prepare_map is a rewrite of a segment of James' make_map code
; it returns an array of indices that map a timestream to a map of a given size
; i.e.  ts = prepare_map(...)
;       map = data[ts]
; except you can't do a simple thing like that because you have to coadd, so 
; instead you use map = ts_to_map(size(blank_map,/dims),ts,data)
; INPUT PARAMETERS:
;   RA and DEC - n_bolos x n_time arrays of ra, dec
;   pixsize    - pixel size in arcseconds (square)
;   OBSOLETE galactic   - flag for galactic coordinates
;   coordsys   - 'galactic' or 'radec'
;   projection - projection type.  CAR = cartesion.  Other options? don't know
; OUTPUT PARAMETERS:
;   blank_map  - a blank n_pix_x x n_pix_y array to use as your starting point map
;   hdr        - the fits header output by mkhdr for use in writefits
function prepare_map,ra,dec,$
                   pixsize=pixsize, $
                   coordsys = coordsys, $
                   projection = projection, $
                   phi0 = phi0, theta0 = theta0, $
                   blank_map=blank_map,$
                   smoothmap=smoothmap,$
                   altazmap=altazmap,jd=jd,lst=lst,source_ra=source_ra,source_dec=source_dec,nopointing=nopointing,$
                   hdr=hdr, silent=silent, _extra=_extra
    if ~keyword_set(silent) then time_s,'Prepare Map ... ',t0
    ;print,""
    ;help,output=helptxt & print,helptxt

    ; Specify the projection
    ; if ~keyword_set(projection) then projection = 'TAN' ; 'SFL' is another option but since DS9 doesn't accept it I won't.
    if ~keyword_set(projection) then projection='CAR'
    ; specify coordinate system
    if ~keyword_set(coordsys) then coordsys = 'galactic'

    ; Now deal with the possibility that we want Galactic coordinates
    if keyword_set(altazmap) then begin
        ; THIS SECTION IS INCOMPLETE AND UNREADY
        ctype1 = 'GLON-CAR'
        ctype2 = 'GLAT-CAR'
        ; need to get jd and lst somehow
        my_eq2hor,ra[0,*],dec[0,*],jd[0],alt,az,lat=19.826111111D0,alt=4073,lon=-155.473366,refract=0,precess=0,nutate=0,aberration=0,lst=lst
        sra = source_ra*15 + fltarr(n_e(ra[0,*]))
        sdec = source_dec + fltarr(n_e(dec[0,*]))
        my_eq2hor,sra,sdec,jd[0],salt,saz,lat=19.826111111D0,alt=4073,lon=-155.473366,refract=0,precess=0,nutate=0,aberration=0,lst=lst
        phi = (fltarr(n_e(ra[*,0]))+1)#(alt-salt)
        theta = (fltarr(n_e(dec[*,0]))+1)#(az-saz)
        phi0=0
        theta0=0
    endif else if coordsys eq 'galactic' then begin
        print,"Creating a map in GALACTIC coordinates"
        ctype1 = 'GLON-'+projection
        ctype2 = 'GLAT-'+projection
        euler, ra, dec, l, b, 1
        phi = l
        theta = b
;        if ~(keyword_set(phi0)) then phi0 = median(l)           ;NOTE: ad2xy wants RA/DEC coordinate center
;        if ~(keyword_set(theta0)) then theta0 = median(b) 
        if keyword_set(source_ra) then euler,(source_ra*15),(source_dec),lmed,bmed,1 $
          else euler,median(ra),median(dec),lmed,bmed,1          ; In principle, this code should be independent of CRVAL...
;        euler,min(ra),min(dec),lmed,bmed,1          ; what if I use the min ra/dec?  a corner?
        if ~(keyword_set(phi0)) then phi0 = lmed          ;NOTE: ad2xy wants RA/DEC coordinate center
        if ~(keyword_set(theta0)) then theta0 = bmed      ;NOTE 2: The above note makes no sense
    endif else if coordsys eq 'radec' then begin
        print,"Creating a map in RA/DEC coordinates"
        ctype1 = 'RA---'+projection
        ctype2 = 'DEC--'+projection
        phi = ra
        theta = dec
        if keyword_set(source_ra) then begin
            if ~(keyword_set(phi0)) then phi0 = (source_ra*15)          ;NOTE: ad2xy wants RA/DEC coordinate center
            if ~(keyword_set(theta0)) then theta0 = (source_dec) 
        endif else begin
            if ~(keyword_set(phi0)) then phi0 = median(phi)          ;NOTE: ad2xy wants RA/DEC coordinate center
            if ~(keyword_set(theta0)) then theta0 = median(theta) 
        endelse
;        if ~(keyword_set(phi0)) then phi0 = min(ra)          ;test 8/28/08
;        if ~(keyword_set(theta0)) then theta0 = min(dec) 
    endif else begin
        message,"Coordinate system "+coordsys+" not recognized."
        stop
    endelse


    ; the code dies horribly if it's trying to map +0.1 and 359.9.... (this is a hack)
;    if max(phi)-min(phi) gt 358 or max(theta)-min(theta) gt 358 then begin
;        if max(phi) gt 358   then phi[where(phi gt 358)] -= 360.
;        if max(theta) gt 358 then theta[where(theta gt 358)] -= 360.
;    endif
        
    if ~keyword_set(pixsize) then pixelsize = 7.2/3600. else pixelsize = pixsize/3600.
    time_s,"Preparing a map with pixel size "+string(pixsize)+" using "+string((memory())[0]/1024.0^3)+"GB",t0pix
    if keyword_set(smoothmap) then pixelsize = pixsize/smoothmap/3600.
    make_astr,astr, $
      DELTA = [-pixelsize,pixelsize], $
      CRPIX = [0,0],$
      CRVAL = [phi0, theta0], $
      CTYPE = [ctype1, ctype2]

    ; Now, compute the pixel numbers for the RA, Dec pointing coordinates
    ad2xy,phi,theta,astr,x,y
; tried this, it's now implemented in pixel_struct.[xy]cen   astr.crpix = [ (max(x)-min(x))/2., (max(y)-min(y))/2.]

    ; Compute the size of the resulting map.  Note that x, y are in decimal pixels
    ts = rect_pix_tstream(x, y, 1.,pixel_struct=pixel_struct)

    nx = pixel_struct.nxpix
    ny = pixel_struct.nypix
    blank_map=fltarr(nx,ny)
;old&bad    xcen = pixel_struct.xcen ; nx/2.
;old&bad    ycen = pixel_struct.ycen ; ny/2.
;old&bad    ad2xy,phi0,theta0,astr,xcen,ycen ; sure it's reduntant, but maybe it works... (no, it doesn't)

    ; I think the problem is that if ad2xy gives a NEGATIVE x,y value, the lowest
    ; x/y value gets mapped to 0,0 and everything else gets mapped to a position positive
    ; of that.  When xcen,ycen are set to the center of the map, the same kind of thing
    ; can happen but it's not likely with a single observation... because in principle the
    ; negative offsets should always be less than half the map size
    ;
    ; My solution: Keep the exact same central position, but IF there are points mapped to
    ; less than 0,0 (there should always be), move crpix such that all map pixel locations
    ; are positive, as they are in an IDL array
    ;
    ; The -.5 is determined empirically (i.e. the sign of that number), but it makes sense
    ; because in the FITS standard the coordinate (1,1) is at the center of the zero'th pixel,
    ; whereas in IDL the coordinate 0,0 is at the bottom left of the zero'th pixel.  i.e. 
    ; the coordinate (.5,.5) in IDL is equivalent to (1,1) in FITS
    if min(x) lt 0 then xcen = -min(x)-.5 else xcen = 0
    if min(y) lt 0 then ycen = -min(y)-.5 else ycen = 0

    make_astr,astr, $
      DELTA = [-pixelsize,pixelsize], $
      CRPIX = [xcen,ycen],$
      CRVAL = [phi0, theta0], $
      CTYPE = [ctype1, ctype2]

;old&bad  ; Instead of 'recomputing' I'm just doing the computations correctly the first time
;old&bad    ; Recompute the translation from RA/Dec to x,y
;old&bad;    ad2xy,phi,theta,astr,x,y
;old&bad    ; instead of using ad2xy, why not manually add the new xcen/ycen?  nothing else has changed... (seems to have same results as above line)
;old&bad;    x += xcen
;old&bad;    y += ycen

    ; Recompute the timestream mapping [makets is a new keyword that makes the code 
    ; calculate ts; made optional to increase efficiency in above step]
    ts = rect_pix_tstream(x, y, 1.,pixel_struct=pixel_struct,/makets)

    mkhdr,hdr,blank_map

    putast,hdr,astr
    lonpole = fxpar(hdr,'LONPOLE')
    latpole = fxpar(hdr,'LATPOLE')
    fxaddpar,hdr,'LONPOLE2',lonpole,"lonpole"
    fxaddpar,hdr,'LATPOLE2',latpole,"latpole"
    sxdelpar,hdr,'LONPOLE'
    sxdelpar,hdr,'LATPOLE'
    if keyword_set(smoothmap) then begin
        if ~keyword_set(pixsize) then pixsize=7.2
        sxaddpar,hdr,'CD1_1',-pixsize/3600.
        sxaddpar,hdr,'CD2_2',pixsize/3600.
;        xy2ad,xcen,ycen,astr,a,d
;        astr.cdelt=[-pixsize/3600.,pixsize/3600.]
;        ad2xy,a,d,astr,x,y
        sxaddpar,hdr,'CRPIX1',xcen/float(smoothmap)
        sxaddpar,hdr,'CRPIX2',ycen/float(smoothmap)
    endif

    if ~keyword_set(silent) then time_e,t0
    return,ts
end

