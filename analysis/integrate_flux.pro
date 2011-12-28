;
;
; integrate_flux.pro
;
; Integrate the flux under a 2-dimensional gaussian
;
;
FUNCTION integrate_flux, mapin, center, rad

  
  ; find indices of aperture
  size = size(mapin)
  xcen=center[0]
  ycen=center[1]
  r2 = float(rad)^2
  xsz = size[1] & ysz=size[2]
  xd2 = (findgen(xsz) - xcen)^2
  yd2 = (findgen(ysz) - ycen)^2
  distances2 = replicate(2.0*r2, xsz, ysz)
  xmin = min(where(xd2 LE r2)) -1 > 0
  xmax = (max(where(xd2 LE r2)) +1) < (xsz-1)
  ymin = min(where(yd2 LE r2)) -1 > 0
  ymax = (max(where(yd2 LE r2))) +1 < (ysz-1)
  
  FOR iy=ymin, ymax DO BEGIN
    distances2(xmin:xmax, iy) = xd2(xmin:xmax) + yd2(iy)
  ENDFOR

  distance = sqrt(distances2)-0.5
  within = distance LE rad
  aperture = distance(where(within))
  frac = ( (rad - aperture) < 1) > 0   ; to count fraction of pixels on edges
  total = total( mapin( where( within) ) * frac )

  return, total

END
  
