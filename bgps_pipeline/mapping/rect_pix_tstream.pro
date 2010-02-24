; "Sweet fancy moses!" this needs to be documented
;
; Given an array of x,y values, rect_pix_tstream returns
; a one-dimensional array of references to x,y coordinates
; on a map that will fit all of the x,y points.
;
; example: ts=rect_pix_tstream(x,y,1.,/makets,pixel_struct=pixel_struct)
; has_been_hit = bytarr(pixel_struct.nx,pixel_struct.ny)
; has_been_hit[ts] = 1
;
; Things to be careful of:
;   1. x,y don't have to be positive, but the map coordinates are IDL 
;      coordinates that are forced positive
;   2. FITS coordinates and IDL coordinates are different: 0,0 in IDL
;      is equivalent to .5,.5 in FITS
function rect_pix_tstream, x, y, res, $
                           xmin = xmin, ymin = ymin, $
                           xmax = xmax, ymax = ymax, $
                           pixel_struct = pixel_struct, $
                           makets = makets

; This can actually work on subsections of the total timestream, since
; the total number of pixels depends only on xmin, ymin, and res,
; which are either supplied or assumed to be contained in the array passed

if (keyword_set(xmin)) then xmin = xmin else xmin = min(x)
if (keyword_set(ymin)) then ymin = ymin else ymin = min(y)
if (keyword_set(xmax)) then xmax = xmax else xmax = max(x)
if (keyword_set(ymax)) then ymax = ymax else ymax = max(y)

nxpix = floor((xmax - xmin)/res)+1
nypix = floor((ymax - ymin)/res)+1

if (double(nxpix) * nypix gt 3.d8) then begin
    print,'Too many damn pixels!'
    print,'What are you trying to do?'
    print,'Map the whole sky?'
    print,'Go work for Planck!'
    print,'nxpix',nxpix,'nypix',nypix
    print,"You had ",nxpix*nypix," pixels"
    message,"You had ",nxpix*nypix," pixels"
    return,-1
endif

; these are no longer necessary
;xcen = (xmax-xmin)/2. + (xmax+xmin)/2.
;ycen = (ymax-ymin)/2. + (ymax+ymin)/2.

if keyword_set(makets) then begin
    xindx = floor((x - xmin)/res)
    yindx = floor((y - ymin)/res)

    pixelmap = reform(lindgen(nxpix*nypix),nxpix,nypix)
    xvals = ((findgen(nxpix)+.5)*res + xmin)#replicate(1.,nypix)
    yvals = replicate(1.,nxpix)#((findgen(nypix)+.5)*res + ymin)
endif else begin ; save time and memory...
    pixelmap = 0
    xvals = 0
    yvals = 0
    xindx = 0
    yindx = 0
endelse

pixel_struct = $
  create_struct('nxpix', nxpix, $
                'nypix', nypix, $
                'pixelmap', pixelmap, $
                'xvals', xvals, $
                'yvals', yvals)
;                'xcen', xcen, $
;                'ycen', ycen )

return, xindx + nxpix*yindx

end
