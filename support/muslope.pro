function muslope, sunzen,sunaz,nrmzen,nrmaz
;+
; ROUTINE:  muslope
;
; PURPOSE:  compute dot product of surface normal to incomming solar ray
;
; USEAGE:   result=muslope(sunzen,sunaz,nrmzen,nrmaz)
;
; INPUT:    
;
;   sunzen  solar zenith angle (degrees)
;
;   sunaz   solar azimuth angle (clockwise from due north, degrees) 
;
;   nrmzen  zenith angle of surface normal vector
;           (nrmzen=0 for a horizontal surface)
;
;   nrmaz   azimuth angle of surface normal vector (nrmaz=45 degrees
;           for a surface that slopes down in the north-east direction)
;
; OUTPUT:
;   result  the dot product of the surface-to-sun unit vector
;           and the surface normal unit vector. 
;
; EXAMPLE:  
;
;;  find the solar zenith and azimuth for 3 pm, january 8
;
;   zensun,8,15.,34.456,-119.813,sunzen,sunaz,/local
;
;;  compute surface solar flux onto a surface inclined
;;  5 degrees to the north-east
;
;   print,f='(3a15/3g15.4)','solar zenith','cos(sunzen)','muslope', $
;      sunzen,cos(sunzen*!dtor),muslope(sunzen,sunaz,5.,45.)
;
; AUTHOR:   Paul Ricchiazzi                        08 Jan 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
zs=cos(sunzen*!dtor)
ys=sin(sunzen*!dtor)*cos(sunaz*!dtor)
xs=sin(sunzen*!dtor)*sin(sunaz*!dtor)
zv=cos(nrmzen*!dtor)
yv=sin(nrmzen*!dtor)*cos(nrmaz*!dtor)
xv=sin(nrmzen*!dtor)*sin(nrmaz*!dtor)

return,xs*xv+ys*yv+zs*zv

end
