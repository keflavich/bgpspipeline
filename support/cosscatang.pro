function cosscatang, cossza, cosvza, phi

;+
; NAME:
;       COSSCATANG
;
; PURPOSE:
;       Return the scattering angle of the incident and emerging rays.
;       NOTE:  the scattering angle is defined as 180 degrees when
;       sza = vza = 0 and phi = 180.
;
; CALLING SEQUENCE:
;       cos_omega = cosscatang(cossza, cosvza, phi)
;
; INPUTS:
;       cossza    cosine of solar (or incident) zenith angle 
;       cosvza    cosine of viewing (or emergin or satellite) zenith angle 
;       phi       relative azimuth angle; this is defined as the difference
;                 between the solar azimuth angle and the viewing azimuth
;                 angle; when sat, sun are in the same position in
;                 the sky, phi = 0
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       The scattering angle is returned.
;
; EXAMPLE:
; IDL> print,acosd(cosscatang(cosd(60),cosd(60),0))
;       0.00000
; IDL> print,acosd(cosscatang(cosd(60),cosd(60),180))
;       120.000
;
; PROCEDURE
;
; COMMON BLOCKS:
;       None.
;
; NOTES
;
; REFERENCES
; 
; AUTHOR and DATE:
;     Jeff Hicke     Earth Space Research Group, UCSB  1/04/94
;
; MODIFICATION HISTORY:
;
;-
;

   radian_phi = phi * !dtor

   return, cossza*cosvza +    $
              sin(acos(cossza))*sin(acos(cosvza))*cos(radian_phi)

end
