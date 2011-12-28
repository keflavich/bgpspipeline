; takes the bgps struct and a galactic longitude/latitude and returns
; the position in the struct that is closest to that location
; example:
;   restore,'bgps.v10.dat'
;   closest_object = bgps[closest(lon,lat,bgps)]
;   print,closest_object.rad_as_nodc
function closest,glon,glat,bgps
	
	d = sqrt((bgps.glon-glon)^2+(bgps.glat-glat)^2)
	m = min(d,a)

	return,a
end
