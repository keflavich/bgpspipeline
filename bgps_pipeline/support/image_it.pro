pro image_it,image,lat,lon,thick=thick
; This routine plots an image onto a predifined coordinate system.
; The calling order would be
; map_set,/cont
; image_it,bytscl(image),lat,lon
; map_set,/cont

;
;Notice I used the bytscl of image, to take up the full color map

if (keyword_set(thick) eq 0) then  thick=3

sz=size(image)
for j=0,(sz(2)-1) do plots,lon(*,j),lat(*,j),color=image(*,j),thick=thick
return
end
