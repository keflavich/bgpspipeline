 pro princax,xx,yy,xcm,ycm,ev1,ev2,v1,v2,view=view
;+
; NAME:         princax
;
; PURPOSE:      principle axis decomposion of a 2d distribution of points
;
; USEAGE:       princax,xx,yy,ev1,ev2,v1,v2
; 
; INPUTS:       
;  xx, yy       coordinate posititions
;
; KEYWORD INPUTS:
;  view         if set, draw a scatter plot and draw the major and minor
;               axis of the characteristic elipsoid with the half length
;               of the axis equal to the square root of the eigenvalue
;               
; 
; OUTPUTS:      
;  xcm,ycm      coordinates of the center of mass
;
;  ev1,ev2      eigenvalues
;
;  v1,v2        principle axis
;
; PROCEDURE:    solves the following eigenvalue equation
; 
;               A v = L v        where A is the moment of inertia tensor
;                                of the object, and L are the eigenvalues.
;
;                                /  <x^2>  <xy>  \
;                         A =    |               |          
;                                \  <xy>   <y^2> /
;
;                                the angled brackets indicate averages over
;                                the point distribution
; EXAMPLE:      
;
; u=5*randomn(iseed,50)
; v=randomn(iseed,50)
; x=u-v
; y=u+v
; princax,x,y,xcen,ycen,ev1,ev2,v1,v2,/view
;
; AUTHOR:       Paul Ricchiazzi                                nov93
;               Earth Space Research Group, UC Santa Barabara
;
; REVISIONS:    
;
;-
nn=n_elements(xx)

xcm=total(xx)/nn
ycm=total(yy)/nn
;                               find principle axis
x2bar=total((xx-xcm)^2)/nn
y2bar=total((yy-ycm)^2)/nn
xybar=total((xx-xcm)*(yy-ycm))/nn
root=sqrt((x2bar+y2bar)^2-4*(x2bar*y2bar-xybar^2))
ev1=((x2bar+y2bar)+root)/2
ev2=((x2bar+y2bar)-root)/2
vv1=xybar/(ev1-y2bar)
vv2=xybar/(ev2-x2bar)
v1=[1.,vv1]/sqrt(1.+vv1^2)
v2=[vv2,1.]/sqrt(1.+vv2^2)

;print,[[x2bar,xybar],[xybar,y2bar]] # v1, ev1*v1 ; check eigenvectors
;print,[[x2bar,xybar],[xybar,y2bar]] # v2, ev2*v2 ; check eigenvectors

if keyword_set(view) ne 0 then begin
  if nn lt 200 then psym=2 else psym=3
  if nn gt 3000 then color=0 else color=!p.color-1
  plot,xx,yy,psym=psym
  px=v1(0)*sqrt(ev1)
  py=v1(1)*sqrt(ev1)
  oplot,xcm+[-px,px],ycm+[-py,py],color=color,thick=3
  
  px=v2(0)*sqrt(ev2)
  py=v2(1)*sqrt(ev2)
  oplot,xcm+[-px,px],ycm+[-py,py],color=color,thick=3
  legend,[string('v1 =',v1),string('v2 =',v2)],pos=[.1,.8,.4,.95],$
           /box,bg_c=0
endif
return
end










