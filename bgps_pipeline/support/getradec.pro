pro getradec,alt1,az1,lat1,ha,dec
;This program outputs ha/dec coodinates when alt/az coordinates are given
;
; ha is between -12 and +12 hrs
;
;HISTORY
; 2003/03/03 GL - Created
; 2003/03/10 GL - correctly converted ha to hours
; 2003/06/19 GL - converted to double precision
; 2004/04/14 SG - Routine was not dealing correctly when cos(ha) < 0

;From Astronomical Almanac (1999) pB61

alt=double(alt1)
az=double(az1)
lat=double(lat1)

radeg=180.0/!dpi
dtor=!dpi/180.0

dec=radeg*ASIN(SIN(dtor*alt)*SIN(dtor*lat)+COS(dtor*alt)*COS(dtor*az)*COS(dtor*lat))
sinha=-COS(dtor*alt)*SIN(dtor*az)/COS(dtor*dec)
cosha= COS(dtor*lat)*SIN(dtor*alt)-SIN(dtor*lat)*cos(dtor*alt)*cos(dtor*az)

; get correct quadrant for ha
ha = asin(sinha)
ha = ha * (cosha ge 0.) + (!PI - ha) * (cosha lt 0.)

ha=!RADEG * ha/15.0	;convert to hours


return
end
