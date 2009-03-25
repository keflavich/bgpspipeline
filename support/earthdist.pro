function earthdist,lat1,lon1,lat2,lon2

;+
; NAME:
;       EARTHDIST
;
; PURPOSE:
;       Calculate the great circle distance (in km) based on lats and lons.  
;
; CALLING SEQUENCE:
;       dist = earthdist(lat1,lon1,lat2,lon2)
;
; INPUTS:
;      lat1        latitude of first point
;      lon1        longitude of first point
;      lat2        latitude of second point
;      lon2        longitude of second point
;
; KEYWORD INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       Distance along great circle returned.
;
; OPTIONAL OUTPUTS:
;
; EXAMPLE:
;  
;      print,earthdist(0,0,0,1)
;      111.189
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
;     Jeff Hicke     Earth Space Research Group, UCSB  4/05/94
;
; MODIFICATION HISTORY:
;
;-
;

   colat1 = 90. - lat1
   colat2 = 90. - lat2

   cossza = cosd(colat1)
   cosvza = cosd(colat2)

   phi = abs(lon1 - lon2)

   great_circle_angle = acosd(cosscatang(cossza,cosvza,phi))

   return, 6371 * great_circle_angle*!DTOR


end
