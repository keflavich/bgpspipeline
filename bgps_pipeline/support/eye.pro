pro eye,x0,y0,angle=angle,size=size,color=color,icolor=icolor, $
        data=data,device=device
;+
; ROUTINE:  eye
;
; PURPOSE:  draw an eye symbol to show observer position and look direction
;
; USEAGE:   eye,x0,y0,angle=angle,size=size,color=color,icolor=icolor,$
;               data=data,device=device
;
; INPUT:    
;  x0,y0    coordinates of eye symbol position (normal coordinates by default)
;
; KEYWORD INPUT:
;  angle    angle of symbol wrt due right alignment
;  size     symbol size
;  color    color index used to draw eye outline
;  icolor   color index used to draw iris
;  data     if set, x0,y0 in data coordinates
;  device   if set, x0,y0 in device coordinates
;
; EXAMPLE:  
;   
;
;  plot,[0,1],/nodata
;  arrow,0,1,.5,.5,/data
;  eye,.55,.45,/data,size=3,angle=135
;
;; here is a interactive method to place the eye symbol
;
;  !err=0 & angle=0 & x=.5 & y=.5
;  tvcrs,.5,.5,/norm & while !err ne 4 do begin &$
;   !err=0 &$
;   eye,x,y,angle=angle,size=5,color=0 &$
;   cursor,x,y,/norm,/nowait  &$
;   if !err eq 1 then angle=angle-5 &$
;   if !err eq 2 then angle=angle+5 &$
;   eye,x,y,angle=angle,size=5 &$
;   wait,.05 &$
; endwhile
; cmdstr=string(f='("eye,",2(g10.3,","),"angle=",g10.3)',x,y,angle)
; print,strcompress(cmdstr,/remove_all)
;
; AUTHOR:   Paul Ricchiazzi                        10 Dec 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if n_params() eq 0 then xhelp,'eye'

if not keyword_set(x0) then x0=.5
if not keyword_set(y0) then y0=.5

if keyword_set(size) then sz=size*.01 else sz=.01
if n_elements(angle) eq 0 then angle=0.
if n_elements(color) eq 0 then color=!p.color
if n_elements(icolor) eq 0 then icolor=color

case 1 of
  keyword_set(data): ct=convert_coord(x0,y0,/data,/to_norm)
  keyword_set(device): ct=convert_coord(x0,y0,/device,/to_norm)
  else:
endcase

if keyword_set(ct) then begin
  x0=ct(0)
  y0=ct(1)
endif

angop=50
lenhi=sz
lenlo=sz
lball=.8*sz
liris=.1*sz
xl=x0+[lenhi*cos((angle-.5*angop)*!dtor),0.,lenlo*cos((angle+.5*angop)*!dtor)]
yl=y0+[lenhi*sin((angle-.5*angop)*!dtor),0.,lenlo*sin((angle+.5*angop)*!dtor)]
plots,xl,yl,/norm,color=color


; draw eye ball

nball=11
sang=findrng(angle-.5*angop,angle+.5*angop,nball)*!dtor
xb=x0+lball*cos(sang)
yb=y0+lball*sin(sang)
plots,xb,yb,/norm,color=color

; draw iris

nbm=(nball-1)/2

nbc=1
rfac=1.1
xx=x0+rfac*(xb(nbm)-x0)
yy=y0+rfac*(yb(nbm)-y0)
r=sqrt((xx-xb(nbc))^2+(yy-yb(nbc))^2)
dot=(xx-x0)*(xx-xb(nbc))+(yy-y0)*(yy-yb(nbc))
rb=sqrt((xx-x0)^2+(yy-y0)^2)
dot=dot/(r*rb)

iang=!pi+angle*!dtor+findrng(acos(dot),-acos(dot), 21)

xi=xx+r*cos(iang)
yi=yy+r*sin(iang)

nbc=3
rfac=1.1
xx=x0+rfac*(xb(nbm)-x0)
yy=y0+rfac*(yb(nbm)-y0)
r=sqrt((xx-xb(nbc))^2+(yy-yb(nbc))^2)
dot=(xx-x0)*(xx-xb(nbc))+(yy-y0)*(yy-yb(nbc))
rb=sqrt((xx-x0)^2+(yy-y0)^2)
dot=dot/(r*rb)

iang=!pi+angle*!dtor+findrng(acos(dot),-acos(dot), 21)

xi=[reverse(xi),xx+r*cos(iang)]
yi=[reverse(yi),yy+r*sin(iang)]

polyfill,xi,yi,/norm,color=icolor

return
end
