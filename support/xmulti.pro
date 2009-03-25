 function xmulti,p,np=np,xmargin=xmargin,space=space
;+
; routine:      xmulti
;
; purpose:      set up margins for horizontally stacked multi frame plot
;
; input:        
;
;   p           named variable, contains stuff you don't need to know
;               the contents of p are changed after each call
; 
; Keyword input
;
;   np          number of frames in plot, set on first call only
;
;   xmargin     2 element vector specifying overall margin setting 
;               left (0) and right (1) of the multiframe plot
;               if xmargin is not set the left and right margin is taken
;               from !x.margin. This keyword is ignored when NP not set
;
;   space       space between frames of multiframe plots in units of 
;               character width.  This keyword is ignored when NP not set
;
;
; SIDE EFFECTS: Changes the values !p.multi(4) to 0 to enforce row
;               major ordering of plots. Also changes the value of
;               !y.charsize to a very small value to disable y-axis
;               labeling.  The original value of !y.charsize is
;               restored when xmulti is called with no arguments,
;               e.g., p=xmulti()
;               
;
; EXAMPLE:      create a three frame plot stacked horizontally
;
; y1=randf(200,1.5)
; y2=randf(200,2)
; y3=randf(200,2.5)
; y4=randf(200,3)
; 
; !p.multi=[0,3,1]
; plot,y1, xmargin=xmulti(p,np=3,xmargin=[5,3],space=1)
; plot,y2, xmargin=xmulti(p)
; plot,y3, xmargin=xmulti(p) & p=xmulti()
;
;;  Now try a four frame plot with no space between frames
;
; !p.multi=[0,4,1]
; plot,y1,            xmargin=xmulti(p,np=4)
; plot,y2,            xmargin=xmulti(p)
; plot,smooth(y2,5),  xmargin=xmulti(p)
; plot,smooth(y2,7),  xmargin=xmulti(p) & p=xmulti()
;
;;  now try two four frame plots on the same page
;;
;
; !p.multi=[0,4,2]
;
; plot,y1,xmargin=xmulti(p,np=4,space=1) & xl=!x.window(0)
; plot,y2,xmargin=xmulti(p)
; plot,y3,xmargin=xmulti(p) 
; plot,y4,xmargin=xmulti(p) & p=xmulti()
; xl=(!x.window(1)+xl)/2
; yl=!y.window(1)+.5*!y.margin(1)*!d.y_ch_size/float(!d.y_vsize)
; xyouts,xl,yl,'top',align=.5,/norm
;
; plot,y1^2,xmargin=xmulti(p,np=4,space=1)
; plot,y2^2,xmargin=xmulti(p)
; plot,y3^2,xmargin=xmulti(p)
; plot,y4^2,xmargin=xmulti(p) &  p=xmulti()
; yl=!y.window(1)+.5*!y.margin(1)*!d.y_ch_size/float(!d.y_vsize)
; xyouts,xl,yl,'bottom',align=.5,/norm
;
;  author:  Paul Ricchiazzi                            Mar94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;=======================================================================
;
; p =[xmargin(0),xmargin(1),margin_increment, space, np] 
;
;  let l(i)=left margin of plot i
;  let r(i)=right margin of plot i
;
;
;  a multiplot frame plot will have uniform spacing between plots when
;
;
;     r(np-1)=right_margin
;     l(0)=left_margin
;
;     r(i-1) + l(i) = space
;     r(i) + l(i)   = ((np-1)*space+right_margin+left_margin)/np = ds
;
;  which can be solved by substitution, 
;
;     r(0)=ds-l(0)
;     
;     l(i)=space-r(i-1) & r(i)=ds-l(i)       i=1,np-1
;
;
;=======================================================================

if keyword_set(xmargin) eq 0 then xmargin=!x.margin

if keyword_set(np) then begin
  if keyword_set(space) eq 0 then space=0
  !p.multi(4)=0
  ds=float((np-1)*space+total(xmargin))/np
  left=xmargin(0)
  right=ds-left
  p=[left,right,ds,space,np]
endif else begin
  if n_elements(p) eq 0 then begin
    if !y.charsize ne .0001  $
       then !y.charsize=!y.charsize*1000 $
       else !y.charsize=0
    return,0
  endif
  if p(4) ne 0 then begin
    if !y.charsize ne 0.  $
       then !y.charsize=!y.charsize/1000 $
       else !y.charsize=.0001
    p(4)=0.
  endif
  p(0)=p(3)-p(1)
  p(1)=p(2)-p(0)
endelse

return,p(0:1)

end

