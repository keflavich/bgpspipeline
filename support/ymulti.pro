 function ymulti,p,np=np,ymargin=ymargin,space=space
;+
; routine:      ymulti
;
; purpose:      set up margins for vertically stacked multi frame plot 
;
; input:        
;
;   p           named variable, contains stuff you don't need to know
;               the contents of p are changed after each call
; 
; Keyword input
;
;   np          number of frames in plot, set on first call only (see examples)
;
;   ymargin     2 element vector specifying overall margin setting 
;               below (0) and above (1) multiframe plot
;               if ymargin is not set the top and bot margin is taken
;               from !y.margin.  This keyword is ignored when NP not set
;
;   space       the separation distance between frames of a multiframe
;               plot in units of the character height. This keyword is
;               ignored when NP not set. Default is no space between plots
;
;
; SIDE EFFECTS: Changes the value of !p.multi(4) to enforce column
;               major ordering of plots.  To reinsate the default row
;               major ordering, set !p.multi=0 or !p.multi(4)=0.  Also
;               changes the value of !x.charsize to a very small value
;               to disable x-axis labeling on the upper frames.  On
;               the bottom frame of a multi-frame plot !x.charsize is
;               restored to its original value.
;
; EXAMPLE:      create a three frame plot
;
; y1=smooth(randomu(iseed,200),3)
; y2=smooth(y1,11)
; y3=smooth(randomu(iseed,200),11)
; y4=smooth(y3,3)
; 
; !p.multi=[0,1,3]
; plot,y1,ymargin=ymulti(p,np=3,ymargin=[5,3],space=1)
; plot,y2,ymargin=ymulti(p)
; plot,y3,ymargin=ymulti(p)
;
;;  Now try a four frame plot with no space between frames
;
; !p.multi=[0,1,4]
; plot,y1, ymargin=ymulti(p,np=4)
; plot,y2, ymargin=ymulti(p)
; plot,y3, ymargin=ymulti(p)
; plot,y4, ymargin=ymulti(p) 
;
;;  Now try a multi-column plot
;
; !p.multi=[0,2,4] 
;
; plot,y1,title='top left',ymar=ymulti(p,np=2)
; plot,y2,ymargin=ymulti(p)
;
; plot,y3, title='bottom left',ymar=ymulti(p,np=2)
; plot,y4, ymargin=ymulti(p)
;
; plot,y1*y1, title='top right',ymar=ymulti(p,np=2)
; plot,y2*y2, ymargin=ymulti(p)
;
; plot,y3^2,  title='bottom right',ymar=ymulti(p,np=2)
; plot,y4^2,  ymargin=ymulti(p)
;
;
; AUTHOR        Paul Ricchiazzi                                    mar94
;               Institute for Computational Earth System Science
;               Univerity of California, Santa Barbara
;-
;=======================================================================
;
; p =[ymargin(0),ymargin(1),margin_increment, space, n] 
;
;  let b(i)=bottom margin of plot i
;  let t(i)=top margin of plot i
;
;
;  a multiplot frame plot will have uniform spacing between plots when
;
;
;     t(0)=top_margin
;     b(np-1)=bot_margin
;
;     t(i) + b(i-1) = space
;     t(i) + b(i)   = ((np-1)*space+top_margin+bot_margin)/np = ds
;
;  which can be solved by substitution, 
;
;     b(0)=ds-t(0)
;     
;     t(i)=space-b(i-1) & b(i)=ds-t(i)       i=1,np-1
;
;
;=======================================================================

if keyword_set(ymargin) eq 0 then ymargin=!y.margin

if keyword_set(np) then begin
  if keyword_set(space) eq 0 then space=0
  !p.multi(4)=1
  if !x.charsize ne 0  $
     then !x.charsize=!x.charsize/1000  $
     else !x.charsize=.0001
  ds=float((np-1)*space+total(ymargin))/np
  top=ymargin(1)
  bot=ds-top
  p=[bot,top,ds,space,np-1]
endif else begin
  if p(4) eq 1 then begin
    if !x.charsize ne .0001 $
       then !x.charsize=!x.charsize*1000.  $
       else !x.charsize=0
  endif    
  p(4)=p(4)-1
  p(1)=p(3)-p(0)
  p(0)=p(2)-p(1)
endelse

return,p(0:1)

end



