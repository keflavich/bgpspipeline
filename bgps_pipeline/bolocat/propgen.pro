function propgen, data, hd, obj, err
;+
; NAME:
;    PROPGEN
; PURPOSE:
;    Calculates properties of objects in BOLOCAM maps
; CALLING SEQUENCE:
;    p = PROPGEN( data, hdr, object, err )
;
;
; INPUTS:
;   DATA -- Original data map
;   HDR -- FITS header from original data
;   OBJECT -- Object label map such that the Ith label corresponds to
;             the Ith object in the map.
;   ERR -- Map of uncertainty.
;
; OUTPUTS:
;   P -- array of structures corresponding to the properties for each
;        object.  
; MODIFICATION HISTORY:
;
;       Tue May 29 12:29:23 2007, Erik <eros@yggdrasil.local>
;
;		Documented.
;
;-

; Header parsing
  extast, hd, astrom
  galhd = hd
  heuler, galhd, /galactic
  heuler, hd, /celestial
  extast, galhd, galastrom
  getrot, galhd, angle, cdelt
  rdhd, galhd, s = h  


; CONSTANTS

  if h.ppbeam eq 0 then ppbeam = 1.0 else ppbeam = h.ppbeam
  if string(sxpar(hd, 'BUNIT')) eq 'JY/PIX' then ppbeam = 1.0
  bmsize = sqrt((sxpar(hd, 'BMAJ')*sxpar(hd, 'BMIN')))*3600d0
  if bmsize eq 0 then bmsize = 31.2
  psize = sqrt(abs(cdelt[0]*cdelt[1]))
  bmpix = bmsize/psize/3600d0/sqrt(8*alog(2))

; This parameter relates the RMS of the moment to the radius of the
; object.  For some reason, Solomon et al. (1987) value works really well.  
  rms2rad = 1.91


  s = replicate({bolocat}, max(obj))

  vectorify, data, mask = obj, id = id, $
    x = x, y = y, t = t
  vectorify, err, mask = obj, id = id, $
    x = x, y = y, t = evec


  for i = 0, max(obj)-1 do begin
    useind = where(id eq i+1)
    s[i].cloudnum = i+1
    s[i].npix = n_elements(useind) 
    xuse = x[useind]
    yuse = y[useind]
    vuse = replicate(1, n_elements(useind)) 
    tuse = t[useind]
    errs = evec[useind]
;    mom = cloudmom(xuse, yuse, vuse, tuse, targett = targett)
    null = max(tuse, /nan, maxind)
    xmax = xuse[maxind]
    ymax = yuse[maxind]

    momx = wt_moment(xuse, tuse, errors = errs)
    momy = wt_moment(yuse, tuse, errors = errs)

;    mom_noex = cloudmom(xuse, yuse, vuse, tuse, targett = targett, $
;                        /noextrap)
;   FIND THE MAJOR AXIS AND ROTATE THEN MEASURE MAJOR/MINOR AXES
    pa = pa_moment(xuse, yuse, tuse)

    xrot = xuse*cos(pa)+yuse*sin(pa)
    yrot = -xuse*sin(pa)+yuse*cos(pa)    
;    mom_rot = $ 
;      cloudmom(xrot, yrot, vuse, tuse, targett = targett)
;    mom_noex_rot = $
;      cloudmom(xrot, yrot, vuse, tuse, targett = targett, /noextrap)

    mommaj = wt_moment(xrot, tuse, errors = errs)
    mommin = wt_moment(yrot, tuse, errors = errs)
    s[i].xdata = momx.mean
    s[i].ydata = momy.mean
    s[i].xdata_err = momx.errmn
    s[i].ydata_err = momy.errmn
    s[i].xerror_as = momx.errmn*abs(cdelt[0])*3600
    s[i].yerror_as = momy.errmn*abs(cdelt[1])*3600

    s[i].momxpix = momx.stdev
    s[i].momypix = momy.stdev
    s[i].momxpix_err = momx.errsd
    s[i].momypix_err = momy.errsd
    s[i].mommajpix = mommaj.stdev > mommin.stdev
    s[i].momminpix = mommaj.stdev < mommin.stdev
    s[i].posang = pa+(!pi/2*(mommaj.stdev lt mommin.stdev))
    s[i].posang = s[i].posang - !pi*(s[i].posang gt !pi)

    s[i].maxxpix = xmax
    s[i].maxypix = ymax

    
    xy2ad, s[i].xdata, s[i].ydata, astrom, ra, dec
    xy2ad, s[i].xdata, s[i].ydata, galastrom, glon, glat
    xy2ad, s[i].maxxpix, s[i].maxypix, astrom, ramax, decmax
    
    
    s[i].ra = ra
    s[i].dec = dec
    s[i].glon = glon
    s[i].glat = glat
    if glon lt 0 then glon_str = decimals(360-glon, 3) else $
       glon_str = decimals(glon, 3)
    if glon lt 10 then glon_str = '0'+glon_str
    if glon lt 100 then glon_str = '0'+glon_str
    glat_str = decimals(abs(glat), 3)
    if abs(glat) lt 10 then glat_str = '0'+glat_str

    if glat ge 0 then glat_str = '+'+glat_str else glat_str = '-'+glat_str

    s[i].name = 'G'+glon_str+glat_str
    s[i].maxra = ramax
    s[i].maxdec = decmax

    s[i].flux = total(tuse/ppbeam)
    s[i].max = max(tuse)
    s[i].rad_pix_nodc = rms2rad*sqrt(s[i].mommajpix*s[i].momminpix)
    s[i].rad_pix = rms2rad*sqrt(sqrt(s[i].mommajpix^2-bmpix^2)*$
                   sqrt(s[i].momminpix^2-bmpix^2))
    s[i].rad_as = s[i].rad_pix*(psize*3.6d3)
    s[i].rad_as_nodc = s[i].rad_pix_nodc*(psize*3.6d3)
    s[i].rms = median(errs)
    s[i].ppbeam = ppbeam
    s[i].rms2rad = rms2rad
    s[i].pk_s2n = max(tuse/errs)
    s[i].mn_s2n = mean(tuse/errs)
  endfor 

  

  return, s
end
