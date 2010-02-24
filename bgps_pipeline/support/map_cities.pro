pro map_cities,lat,lon,names,file=file,charsize=charsize,color=color
;+
; ROUTINE:  map_cities
;
; PURPOSE:  plot city locations and print city names form cities.dat database
;
; USEAGE:   map_cities
;
; INPUT:    none
;
; KEYWORD INPUT:
;   file    
;     city data base file, each record contains tab delimited values
;     of latitude, longitude and city_name.
;;
;   charsize
;     character size (a multiplier of !p.charsize)
;
;   color
;     color used to draw city mark and name
;
; OUTPUT: none
;
; DISCUSSION:
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;;
;   dcolors
;   map_set3,0,-94.8814,/cyl,/cont,limit=[16.75,-130.05,56.95,-59.71],$
;            /usa,s_color=4
;   
;   map_cities,color=1
;
; AUTHOR:   Paul Ricchiazzi                        25 Apr 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if keyword_set(file) eq 0 then file='/local/idl/maps/cities.dat' 
if keyword_set(charsize) eq 0 then charsize=1
if n_elements(color) eq 0 then color=!p.color

openr,lun,/get_lun,file
n=n_lines(file)
lon=0.
lat=0.
name=''

for i=0,n-1 do begin
  readf,lun,lat,lon,name
  plots,lon,lat,psym=4,color=color
  xyouts,lon,lat,name,charsize=charsize*!p.charsize,color=color
endfor

end
