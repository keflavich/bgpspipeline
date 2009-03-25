pro flight_angle,pitch,roll,heading,zenith,azimuth,radians=radians
;+
; ROUTINE:  flight_angle
;
; PURPOSE:  compute zenith and azimuth of a unit vector pointing "up" 
;           in coordinate system attached to an aircraft.
;
; USEAGE:   flight_angle,pitch,roll,heading,zenith,azimuth
;
; INPUT:    
;  pitch    pitch angle (degrees) positive values indicate nose up
;  roll     roll angle (degrees) positive values indicate right wing down
;  heading  compass direction aircraft is pointed. Positive values
;           represent clockwise, with respect to true North.  NOTE:
;           This heading is the direction the airplane is pointed, not
;           the direction it is moving
;
; KEYWORD_INPUT
;
;  radians  if set all input and output angles are in radians
;
; OUTPUT:
;
;  zenith   zenith angle of "up" unit vector
;  azimuth  azimuth angle of "up" unit vector.  Positive values 
;           represent clockwise, with respect to true North.
;
; EXAMPLE:  
; 
;;  compute the solar zenith angle of a airbourne sensor given 
;;  (roll,pitch,heading) = (2,3,45) degrees at 10 am today
;
;   doy=julday()-julday(1,0,1994)                          
;   zensun,doy,12,34.456,-119.813,z,a,/local
;   print,f='(6a13)','z','a','sunzen','sunaz','sunmu','corrected'
;   flight_angle,2.,2.,45.,zen,az
;   print,zen,az,z,a,cos(z*!dtor),muslope(z,a,zen,az)
;   flight_angle,2.,-2.,45.,zen,az
;   print,zen,az,z,a,cos(z*!dtor),muslope(z,a,zen,az)
;   flight_angle,2.,0.,0.,zen,az
;   print,zen,az,z,a,cos(z*!dtor),muslope(z,a,zen,az)
;           
;
; AUTHOR:   Paul Ricchiazzi                        25 Feb 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

; assume aircraft heading north:

if keyword_set(radians) then dtor=1 else dtor=!dtor 

uz=cos(roll*dtor)*cos(pitch*dtor)
ux=sin(roll*dtor)
uy=-cos(roll*dtor)*sin(pitch*dtor)

; now rotate to correct heading

vz=uz
vx=ux*cos(heading*dtor)+uy*sin(heading*dtor)
vy=uy*cos(heading*dtor)-ux*sin(heading*dtor)

zenith=acos(vz)/dtor
azimuth=atan(vx,vy)/dtor

return
end

