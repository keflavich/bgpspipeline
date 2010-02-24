pro swath,image,lon,lat,thick=thick,range=range,nlevels=nlevels, $
          colors=colors, outline=outline
;+
; ROUTINE:  swath
;
; PURPOSE:  plot raw data (not on a regular lat-lon grid) from a satellite
;           pass on a predifined ploting grid (usually setup by map_set)
;
; USEAGE:   swath,image,lon,lat,thick=thick,nlevels=nlevels, $
;           colors=colors,outline=outline
;
; INPUT:    
;
;  image
;    two dimensional satellite data field.  the first index 
;    corresponds to cross-track sample number and the second 
;    to the along-track line number.
;
;  lon
;    longitude array, same size as image
;
;  lat
;    latitude array, same size as image
;
; KEYWORD INPUT:
;  thick
;    thickness of lines used to fill lines in swath
;    (The default is 3 for "X" and 10 for "ps")
;
;  colors
;   discreet set of colors used for each level in LEVELS.  
;
;  nlevels
;    number of contour level values (if not set continuous colors are used)
;
;  range
;    physical range of image (2 element vector)
;
;  outline
;    color index used to draw swath outline. If not set, a swath
;    outline is not drawn. 
;
; KEYWORD OUTPUT:
;  colors 
;    a vector of color indicies which can be used as input to
;    color_key. This is required to coordinate the color key with the
;    discreet colors drawn by SWATH. It is not required when nlevels
;    is not set.  COLORS is returned if the input value of COLORS is a
;    named variable with 0 or 1 elements.
;
; DISCUSSION:
;    Each individual satellite line is drawn as a separate call
;    to PLOTS.  Hence, there may be gaps between lines.  This
;    can be controlled by adjusting the thickness of the drawn
;    lines.  If the the printer has greater resolution than the
;    screen or if the number of lines is not large, you may have to
;    increase THICK to avoid getting gaps between lines on your
;    hardcopy.
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
; y=findrng(-8500,8500,400)     ; satelite data coordinates (400 lines)
; x=findrng(-1012,1012,100)     ;                           (100 samples)
; gengrid,x,y
; incl=98                       ; orbital inclination
; az=atan(x,y)/!dtor            ; azimuth (clockwise around track direction)
; az=(az+90-incl+360) mod 360
; rng=sqrt(x^2+y^2)             ; range   (from equator crossing)
; compass,0,0,rng,az,alat,alon,/to_latlon 
; range=[0,1]
; colors=0
;
; map_set,0,0,/orth,pos=boxpos(/asp)
; for i=0,5 do swath,abs(sin(!pi*x/2000)*sin(!pi*y/2000)), $
;     alon+25*i-50,alat,nlev=11,colors=colors,/outline
; map_continents
; map_grid
; color_key,range=range,colors=colors
;  
; map_set,0,0,/cyl,pos=boxpos(/asp)
; for i=0,5 do swath,abs(sin(!pi*x/2000)*sin(!pi*y/2000)), $
;     alon+30*i-60,alat,nlev=11,colors=colors,outline=255
; map_continents
; map_grid
; color_key,range=range,colors=colors
; 
;
; AUTHOR:   Paul Ricchiazzi                        20 Dec 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

if (keyword_set(thick) eq 0) then begin
  if !d.name eq 'X' then thick=3 else thick=10
endif

sz=size(image)

if not keyword_set(range) then range=[min(image,max=mx),mx]

nclrs=n_elements(colors)

if not keyword_set(nlevels) then begin
  if nclrs gt 1 then nlevels=nclrs+1 else nlevels=!d.n_colors-2
  if nclrs le 1 then colors=indgen(!d.n_colors-2)+1
endif else begin
  if nclrs le 1 then  $
     colors=fix((!d.n_colors-2)*(1+findgen(nlevels-1))/(nlevels-1))
endelse

for j=0,(sz(2)-1) do begin
  cvec=float(image(*,j)-range(0))/(range(1)-range(0))
  cvec=fix(cvec*nlevels) > 0 < (nlevels-1)
  plots,lon(*,j),lat(*,j),color=colors(cvec),thick=thick
endfor

if n_elements(outline) gt 0 then begin
  jx=sz(1)-1
  jy=sz(2)-1
  oplot,lon(0,*),lat(0,*),color=outline,thick=thick
  oplot,lon(jx,*),lat(jx,*),color=outline,thick=thick
  oplot,lon(*,0),lat(*,0),color=outline,thick=thick
  oplot,lon(*,jy),lat(*,jy),color=outline,thick=thick
endif

return
end

