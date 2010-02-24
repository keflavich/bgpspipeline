pro cloud_art,pos,bumps=bumps
;+
; ROUTINE:  cloud_art
;
; PURPOSE:  draw an idealized cloud
;
; USEAGE:   cloud_art,pos,bumps=bumps
;
; INPUT:    
;  pos      normal coordinates of cloud frame, [xll,yll,xur,yur]
;           where ll=lower left corner and ur=upper right corner
;
;
; KEYWORD INPUT:
;  bumps    number of bumps on upper side of cloud. (default=6)
;  
;
; OUTPUT:
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
;
;    w8x11
;    cloud_art,[.1,.8,.9,.9],bumps=8
;
; AUTHOR:   Paul Ricchiazzi                        15 Mar 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if not keyword_set(bumps) then bumps=6.
if not keyword_set(pos) then begin
  pos=boxpos(/cur)
  print,f='(a,4(f4.2,a))','[',pos(0),',',pos(1),',',pos(2),',',pos(3),']'
endif

plot,[0,bumps+1],[0,2],/nodata,xstyle=5,ystyle=5,pos=pos
r=1
xs=bumps

ang=[-90,120]

deg=ang(0)+findgen(1+(ang(1)-ang(0))/10)*10
xc=r*cos(deg*!dtor)
yc=r*sin(deg*!dtor)

xoff=xs
oplot,xc+xoff,yc+r,/noclip

ang=[30,120]
deg=ang(0)+findgen(1+(ang(1)-ang(0))/10)*10
xc=r*cos(deg*!dtor)
yc=r*sin(deg*!dtor)

for xoff=xs,2*r,-r do oplot,xc+xoff,yc+r,/noclip

ang=[30,270]
deg=ang(0)+findgen(1+(ang(1)-ang(0))/10)*10
xc=r*cos(deg*!dtor)
yc=r*sin(deg*!dtor)
oplot,xc+xoff,yc+r,/noclip

oplot,[xoff,xs],[0,0]
end
