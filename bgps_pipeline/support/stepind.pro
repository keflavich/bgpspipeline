function stepind,ic,n1,i1,n2,i2,n3,i3,n4,i4,n5,i5,n6,i6, $
                 nowait=nowait,step=step
;+
; ROUTINE:  stepind
;
; PURPOSE:  step through a sequence of nested indicies
;
; USEAGE:   result=stepind,ic,n1,i1,n2,i2,n3,i3,n4,i4,n5,i5,n6,i6
;
; INPUT:    
;
;   ic      one dimensional index.  incremented or decrimated by
;           LMB or MMB, respectively.  if the starting value of ic
;           ic is -1,  no delay occurs before the plot
;
;   n1      number of elements in first dimension
;   i1      index for first dimension
;   n2      number of elements in second dimension
;   i2      index for second dimension
;
;   etc
;
; KEYWORD INPUT
;
;   nowait  STEPIND returns immediately if button is in down state
;
;   step    a named variable, if set to non-zero value STEP causes
;           STEPIND to return immediately.  The initial value of STEP
;           determines wheather the first call to STEPIND will return
;           incremented indicies (STEP>0) or decremented indicies (step<0)
;           After the STEPIND where loop is started the sign of STEP
;           is toggled by the left or middle mouse buttons.
;   
; OUTPUT:
;   result  logical flag, 0 if RMB is pressed, 1 otherwise
;
;  
; EXAMPLE:  
;
;  ic=-1 & step=1                & x=5*(findgen(360)-180)*!dtor 
;  s=exp(-(x/(360*!dtor))^2)     & phs=10.*!dtor
;
; while stepind(ic,36) do plot,x,s*sin(x+ic*phs),title=string(ic*phs)
;
; while stepind(ic,36,/nowait) do plot,x,s*sin(x+ic*phs),title=string(ic*phs)
;
; while stepind(ic,36,step=step) do plot,x,s*sin(x+ic*phs),title=string(ic*phs)
;    
;
; AUTHOR:   Paul Ricchiazzi                        22 Sep 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

device,cursor_standard=16
if n_elements(n1) eq 0 then n1=1
if n_elements(n2) eq 0 then n2=1
if n_elements(n3) eq 0 then n3=1
if n_elements(n4) eq 0 then n4=1
if n_elements(n5) eq 0 then n5=1
if n_elements(n6) eq 0 then n6=1

ntot=n1*n2*n3*n4*n5*n6

if n_elements(step) eq 0 then step=0
if n_elements(ic) eq 0 then ic=-1

tvcrs,.9*!d.x_vsize,.9*!d.y_vsize
!err=0
if ic ne -1 then begin
  if step ne 0 then begin
    cursor,xd,yd,/device,/nowait
    button=!err
    if button eq 1 or button eq 2 then begin
      step=-step
      cursor,xd,yd,/up
    endif
    if step eq -1 then ic=(ic-1+ntot) mod ntot
    if step eq 1 then ic=(ic+1) mod ntot
    device,cursor_standard=30
    if button eq 4 then return,0
  endif else begin
    if keyword_set(nowait) then begin
      cursor,xd,yd,/device
      button=!err
    endif else begin
      cursor,xd,yd,/wait,/device
      button=!err
      cursor,xd,yd,/up,/device
    endelse
    if n_elements(ic) eq 0 then ic=ntot-1
    if button eq 1 then ic=(ic-1+ntot) mod ntot
    if button eq 2 then ic=(ic+1) mod ntot
  endelse
endif else begin
  button=1
  ic=0
endelse

i1=ic mod n1 
i2=(ic/n1) mod n2 
i3=(ic/(n1*n2)) mod n3 
i4=(ic/(n1*n2*n3)) mod n4 
i5=(ic/(n1*n2*n3*n4)) mod n5 
i6=(ic/(n1*n2*n3*n4*n5)) mod n6 

device,cursor_standard=30

return,button ne 4

end
