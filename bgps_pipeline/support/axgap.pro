pro axgap,pos,one=one,size=size,skew=skew,gap=gap
;+
; ROUTINE:  axgap,pos
;
; PURPOSE:  draw a "gap symbol" to indicate a gap in the axis number scale.
;
; USEAGE:   axgap,pos
;
; INPUT:    
;   pos     two element vector indicating x,y data coordinates of the
;           axis break
;
; KEYWORD INPUT:
;   one     gap symbol drawn on one axis only
;
;   size    size of gap symbol (default = 1, which corresponds to size
;           of default minor tick marks)
;
;   skew    control skewness of gap symbol (default 0)
;
;   gap     controls gap size (default 1)
;
; OUTPUT:
;   none
;
; DISCUSSION:
;   
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE: 
;
;   y=smooth(randomn(iseed,100),5)
;   plot,y,xticks=5,xtickn=['1','2','3','4','5','20']
;   axgap
;
; AUTHOR:   Paul Ricchiazzi                        31 Aug 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

; what axis ?

if keyword_set(pos) then begin
  xbrk=pos(0)  
  ybrk=pos(1)
  prnt=0
endif else begin
  tvcrs,.5*(!x.crange(0)+!x.crange(1)), $
        .5*(!y.crange(0)+!y.crange(1)),/data
  device,cursor_standard=33
  cursor,xbrk,ybrk,/up,/data
  device,cursor_standard=30
  prnt=1
endelse

val=min([abs(xbrk-!x.crange)/(!x.crange(1)-!x.crange(0)), $
         abs(ybrk-!y.crange)/(!y.crange(1)-!y.crange(0))],k)

if not keyword_set(size) then size=1
szx=size*(!x.crange(1)-!x.crange(0))/200.
szy=size*(!y.crange(1)-!y.crange(0))/200.

if n_elements(skew) eq 0 then skew=0 
if n_elements(gap) eq 0 then gap=1

vsym1=[ 0, 0,   .7, 2,   .7, -.7,-2]
usym1=[-2,-1,-1.5,-1,-1.5,-.5,-1]+.5*skew*vsym1+(1-gap)
usym2=-usym1
vsym2=-vsym1
usym0=[-1,1,1,-1,-1]*max(usym2)
vsym0=[-2,-2,2,2,-2]*1.1

if k ge 2 then begin
  ybrk=!y.crange(k-2)
  polyfill,xbrk+usym0*szx,ybrk+vsym0*szy,color=!p.background
  plots,xbrk+usym1*szx,ybrk+vsym1*szy
  plots,xbrk+usym2*szx,ybrk+vsym2*szy
  if not keyword_set(one) then begin
    ybrk=!y.crange(0)+!y.crange(1)-ybrk
    polyfill,xbrk+usym0*szx,ybrk+vsym0*szy,color=!p.background
    plots,xbrk+usym1*szx,ybrk+vsym1*szy
    plots,xbrk+usym2*szx,ybrk+vsym2*szy
    ybrk=!y.crange(0)+!y.crange(1)-ybrk
  endif
endif else begin
  xbrk=!x.crange(k)
  polyfill,xbrk+vsym0*szx,ybrk+usym0*szy,color=!p.background
  plots,xbrk+vsym1*szx,ybrk+usym1*szy
  plots,xbrk+vsym2*szx,ybrk+usym2*szy
  if not keyword_set(one) then begin
    xbrk=!x.crange(0)+!x.crange(1)-xbrk
    polyfill,xbrk+vsym0*szx,ybrk+usym0*szy,color=!p.background
    plots,xbrk+vsym1*szx,ybrk+usym1*szy
    plots,xbrk+vsym2*szx,ybrk+usym2*szy
    xbrk=!x.crange(0)+!x.crange(1)-xbrk
  endif
endelse  

if prnt then print,strcompress(string(',[',xbrk,',',ybrk,']'),/remove_all)
return
end
