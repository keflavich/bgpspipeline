pro getaltaz,dec1,lat1,ha1,alt,az
;This program outputs altaz coodinates when ra/dec coordinates are given
;HISTORY
; 2003/01/24 GL allowed 2d array to be inputted
; 2003/01/28 SG Redo conversion to ensure az is in correct quadrant
; 2003/01/29 SG Fix problem with writing az to az
; 2003/06/19 GL converted to double precision; made all az values positive

dtor=!dpi/180.0
radeg=180.0/!dpi

dec = DTOR * dec1
lat = DTOR * lat1
ha = DTOR * 15.0 * ha1

alt = asin( sin(dec)*sin(lat) + cos(dec)*cos(ha)*cos(lat) )
sinaz = - cos(dec)*sin(ha)/cos(alt)
cosaz = ( sin(dec)*cos(lat) - cos(dec)*cos(ha)*sin(lat) ) /  cos(alt)

; now figure out which quadrant az is in and finish conversion
; first get a coordinate in first two quadrants
az = acos( cosaz)

; then change sign if necessary
; for some reason, you can't just write directly into the az 
; variable -- you get all zeros!
temp = az * ( double(sinaz ge 0.) - double(sinaz lt 0.) )
az = temp

alt = RADEG * alt
az = RADEG * az

;if source is transiting, it is possible to have both positive and negative az values
;make all az values positive
valid_neg=where(az lt 0.0,nvalid_neg)
if nvalid_neg gt 0 then az(valid_neg)=az(valid_neg)+360.0

return
end
