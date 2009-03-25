function kdist, l, b, v, near = near, far = far, $
                  r0 = r0, v0 = v0, rgal = rgal, $
                dynamical = dynamical, kinematic = kinematic, $
                regular = regular
;+
; NAME:
;   KINDIST 
; PURPOSE:
;   To return the distance to an object given l,b,v
;
; CALLING SEQUENCE:
;   dist = KDIST (L, B, V)
;
; INPUTS:
;   L, B -- Galactic Longitude and Latitude (decimal degrees)
;   V - Velocity w.r.t. LSR in km/s
; KEYWORD PARAMETERS:
;   /NEAR, /FAR -- Report the near/far kinematic distances for Q1 and
;                  Q4 data.
;   RO, VO -- Force values for galactocentric distance for sun and
;             velocity of the LSR around the GC.  Default to 8.4 kpc
;             and 254 km/s (Reid et al., 2009)
;   RGAL -- Named keyword containding galactocentric radius of sources.
;   /DYNAMICAL -- Use the dynamical definition of the LSR
;   /KINEMATIC -- Use the kinematic definition of the LSR (default)
;   /REGULAR -- Do not apply the rotation correction for High mass
;               star forming regions.
; OUTPUTS:
;   DIST -- the kinematic distance in units of R0 (defaults to pc).
;
; MODIFICATION HISTORY:
;
;       Fri Feb 27 00:47:18 2009, Erik <eros@orthanc.local>
;		 Adapted from kindist.pro
;-


  if n_elements(r0) eq 0 then r0 = 8.4d3
  if n_elements(v0) eq 0 then v0 = 2.54d2

  if keyword_set(regular) then vs = 0.0 else vs=15.0

  if (not keyword_set(dynamical)) or keyword_set(kinematic)  then begin
     solarmotion_ra = ((18+03/6d1+50.29/3.6d3)*15)
     solarmotion_dec = (30+0/6d1+16.8/3.6d3)
     solarmotion_mag = 20.0
  endif else begin
     solarmotion_ra = ((17+49/6d1+58.667/3.6d3)*15)
     solarmotion_dec = (28+7/6d1+3.96/3.6d3)
     solarmotion_mag = 16.55294
  endelse

  euler, l, b, ra, dec, 2
  gcirc, 2, solarmotion_ra, solarmotion_dec, ra, dec, theta
  vhelio = v-solarmotion_mag*cos(theta/206265.)
  
; UVW from Dehnen and Binney
  bigu = 10.0
  bigv = 5.23
  bigw = 7.17

  v = vhelio+(bigu*cos(l*!dtor)+bigv*sin(l*!dtor))*cos(b*!dtor)+$
      bigw*sin(b*!dtor)

; This is r/r0
  null = (v0/(v0-vs)+v/((v0-vs)*sin(l*!dtor)*cos(b*!dtor)))^(-1)
  
;  The > 0 traps things near the tangent point and sets them to the
;  tangent distance.  So quietly.  Perhaps this should pitch a flag?
  radical = sqrt(((cos(l*!dtor))^2-(1-null^2)) > 0)
  
  fardist = r0*(cos(l*!dtor)+radical)/(cos(b*!dtor))
  
  neardist = r0*(cos(l*!dtor)-radical)/(cos(b*!dtor))
  rgal = null*r0
  ind = where(abs(l-180) lt 90, ct)
  if ct gt 0 then neardist[ind] = fardist[ind]

  if (not keyword_set(near)) then dist = fardist else dist = neardist


  return, abs(dist)
end

