;+
; ROUTINE:       step_ct
;
; USEAGE:        step_ct, range, inc, cs, nbotclr=nbotclr
;                step_ct, /off
;
; PURPOSE:       Discreetizes color scale at given numerical intervals.
;                NOTE:  the rgb color value of the top color scale index is
;                       not changed.  
;
; INPUT:   
;
;     range      array or vector which specifies range of physical values, 
;                e.g., [amin,amax]
;
;     inc        number scale increment
;
;     cs         a floating point number between -1.0 to +1.0 that
;                translates the color table a fraction of a color step
;                higher (cs > 1) or lower (cs < -1).  It has its most
;                noticeable effect when the number of steps is small,
;                because in this case a single step is usually a
;                significant change in color value.  (default = 0)
;
;    nbotclr     starting color index
;
;     off        restore original unquantized color table, 
;                no other input is required when this keyword is set
;
; EXAMPLE
;                loadct,0
;                tvlct,r,g,b,/get
;                plot,r,xmargin=[10,20],/yst=1
;                color_key,range=[0,255],inc=20
;                range=[0,255]
;                inc=20
;                step_ct,range,inc
;                tvlct,r,g,b,/get
;                oplot,r,li=3
;
;
; AUTHOR:        Paul Ricchiazzi    oct92 
;                Earth Space Research Group
;                UCSB
; REVISIONS:
; 21sep93: fixed case of range spanning zero (see shiftup)
;-
pro step_ct,range,inc,cs,off=off,nbotclr=nbotclr

common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

if keyword_set(r_orig) eq 0 then loadct,0
if keyword_set(nbotclr) eq 0 then nbotclr=0

if keyword_set(off) then begin
  r_curr=r_orig
  g_curr=g_orig
  b_curr=b_orig
  tvlct,r_curr,g_curr,b_curr
  return
endif
; 
amax=max(range)
amin=min(range)

if keyword_set(cs) eq 0 then cs=0.
if amin lt 0. then begin                ; shift to positive range
  shiftup=1+abs(amin)/inc
  amin=amin+shiftup*inc
  amax=amax+shiftup*inc
endif

ncolors=!d.n_colors-nbotclr+1
max_color=!d.n_colors-1

cind=findgen(ncolors)/(ncolors-1)
cind=amin+(amax-amin)*cind
cind=fix(cind/inc)*inc
cind=(nbotclr+(max_color-nbotclr)*(cind-amin)/(amax-amin)) > 0 < max_color

cind=cind + cs*(max_color-nbotclr)*inc/(amax-amin)

;f=findrng(range,ncolors) & for i=0,max_color do print,i,f(i),cind(i)


r_curr=r_orig(cind)
g_curr=g_orig(cind)
b_curr=b_orig(cind)
r_curr(0)=0.
g_curr(0)=0.
b_curr(0)=0.

tvlct,r_curr,g_curr,b_curr
end






