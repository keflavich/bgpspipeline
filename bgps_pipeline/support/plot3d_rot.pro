pro plot3d_rot,xx,yy,zz,continuous=continuous,title=title,dang=dang,cang=cang
;+
; ROUTINE:  plot3d_rot
;
; PURPOSE:  plot a 3-D trajectory and rotate plot interactively
;
; USEAGE:   plot3d_rot,xx,yy,zz
;
; INPUT:    
;   xx,yy,zz
;     vector trajectory of path
;
; KEYWORD INPUT:
;
;   title
;     title string
;
;   dang
;     angle increment between successive rotations (default=5)
;
;   cang
;     constant angle of rotation of the xyz coordinate axis about z-axis.
;     (default=30)
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
;  x=randf(30,3)
;  y=randf(30,3)
;  z=randf(30,3)
;
;  plot3d_rot,x,y,z
;
;  plot3d_rot,x,y,z,/continuous
;
;
; AUTHOR:   Paul Ricchiazzi                        11 Apr 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if n_elements(title) eq 0 then title=''

clrmin=.3               ; min color index as a  fraction of !d.n_colors

if n_elements(dang) eq 0 then dang=5.
if n_elements(cang) eq 0 then cang=30.

csa=cos(cang*!dtor)
ssa=sin(cang*!dtor)

zmn=min(zz,max=zmx)
xmn=min(xx,max=xmx)
ymn=min(yy,max=ymx)

z=[[zmn,zmx],[zmn,zmx]]
x=[[xmn,xmx],[xmn,xmx]]
y=[[ymn,ymn],[ymx,ymx]]

; window,xsize=300,ysize=300

step=keyword_set(continuous)

surface,z,x,y,/nodata,az=cang,/save 

xbar=total(xx)/n_elements(xx)
ybar=total(yy)/n_elements(yy)
fmax=max([abs(xx-xbar),abs(yy-ybar)])
fmin=-fmax

xxx=xx
yyy=yy
angle=0.
putstr,string(f='(a,f4.0)',angle),.0,.0,/subnorm
front=xxx*csa-yyy*ssa
fac=sqrt(((front-fmin)/(fmax-fmin))>0.<1.)
color=!d.n_colors*(clrmin*(1.-fac)+fac)
plots,xxx,yyy,zz,/t3d,color=color 

nsteps=fix(360/dang)

ii=-1
while stepind(ii,nsteps,/nowait,step=step) do begin 
  plots,[xbar,xbar],[ybar,ybar],[zmn,zmx],/t3d,color=clrmin*!d.n_colors
  putstr,string(f='(a,f4.0)',angle),.0,.0,/subnorm,color=0
  plots,xxx,yyy,zz,/t3d,color=0
  angle=ii*dang
  sn=sin(angle*!dtor)
  cn=cos(angle*!dtor)
  xxx=(xx-xbar)*cn-(yy-ybar)*sn+xbar
  yyy=(xx-xbar)*sn+(yy-ybar)*cn+ybar
  front=-yyy*csa-xxx*ssa
  fac=sqrt(((front-fmin)/(fmax-fmin))>0.<1.)
  color=!d.n_colors*(clrmin*(1.-fac)+fac)
  putstr,string(f='(a,f4.0)',angle),.0,.0,/subnorm
  plots,xxx,yyy,zz,/t3d,color=color 
  wait,.05
endwhile
plots,[xbar,xbar],[ybar,ybar],[zmn,zmx],/t3d,color=0

end














