pro plot_cycle,nx,ny,icycle,i
;+
; ROUTINE
;   plot_cycle
;
; PURPOSE:
;   set the position of new plots so that they fill the frame in a given
;   order.  New plots cause only a single subframe to be overwritten.  Old
;   frames are left for comparison.
;
; USEAGE:	
;   plot_cycle,nx,ny,icycle,i
;
; INPUT:
;   nx       
;    number of horizontal frames
;
;   ny
;     number of vertical frames 
;
;   icycle
;     index array specifying the order frames are overwritten, upper left
;     frame is 1.
;
;   i
;     index into icycle (incremented after each call)
;
; OUTPUT: i
;
; EXAMPLE:	
;
;     !p.multi=[0,1,2]
;     f=randata(128,128,s=3)
;     tvim,f,/interp
;     xw=!x.window & xr=!x.crange
;     yw=!y.window & yr=!y.crange
;      
;     x1=60 & x2=80 & y1=60 & y2=80
;     !p.charsize=2
;     while y1 gt 0 do begin &$
;       plot_cycle,2,4,[5,6,7,8],i &$
;       xx=x1+indgen(x2-x1+1) &$
;       yy=y1+indgen(y2-y1+1) &$
;       contour,f(x1:x2,y1:y2),xx,yy &$
;       wait,.5 &$
;       curbox,x1,x2,y1,y2,xw,yw,xr,yr,/init,inc=4,/mess &$
;     endwhile
;      
;      
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            date>
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if not keyword_set(i) then i=0 else i = i mod n_elements(icycle)
jj=icycle(i)-1
ix=jj mod nx
iy=ny-1-(jj / nx)
polyfill,float(ix+[0,0,1,1,0])/nx,float(iy+[0,1,1,0,0])/ny,color=0,/norm
!p.multi=[nx*ny-jj,nx,ny]
i=(i+1) mod n_elements(icycle)

end
