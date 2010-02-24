 function degrade,u,max=max,min=min
;+
; FUNCTION      degrade
;
; PURPOSE:      degrade image resolution by a factor of two
;
; USEAGE:       result=degrade(array)
; 
; INPUT:   
;   array       an image array of dimension NX x NY, where both nx
;               ny are divisible by 2. If nx or ny are not divisible by
;               2 a subimage is extracted that leaves off the last row 
;               or column and is divisible by 2 in both directions.
;
; KEYWORD INPUT:
;
;   min         if set the returned value for each superpixel is the min
;               of each of the four subpixels
;
;   max         if set the returned value for each superpixel is the max
;               of each of the four subpixels
;
; output:
;   result      image array of dimension NX/2 x NY/2 composed of 2 x 2 
;               superpixel averages of u (except if MIN or MAX keyword is
;               set, see above)
;
; AUTHOR:       Paul Ricchiazzi                        26 May 95
;               Institute for Computational Earth System Science
;               University of California, Santa Barbara 
;-
sz=size(u)
nxo=sz(1)
nyo=sz(2)

nx=(nxo/2)*2
ny=(nyo/2)*2

if nx ne nxo or ny ne nyo then u=u(0:nx-1,0:ny-1)

ix=indgen(nx/2)*2
iy=indgen(ny/2)*2
gengrid,ix,iy
if keyword_set(max) then return,u(ix,iy)>u(ix,iy+1)>u(ix+1,iy)>u(ix+1,iy+1)
if keyword_set(min) then return,u(ix,iy)<u(ix,iy+1)<u(ix+1,iy)<u(ix+1,iy+1)
return,.25*(u(ix,iy)+u(ix,iy+1)+u(ix+1,iy)+u(ix+1,iy+1))
end
