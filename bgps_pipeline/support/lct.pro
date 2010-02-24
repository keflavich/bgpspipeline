pro lct,index
;+
; ROUTINE:  lct
;
; PURPOSE:  try all predefined color tables
;
; USEAGE:   lct,index
;
; INPUT:    
;   index   if set index specifies the first color table to try
;
; OUTPUT:
;   index   final color table index
;
; DISCUSSION:
;   With each click of the left mouse button a new color table is loaded.
;   The MMB scans up the list of color tables and LMB scans down the list.
;   The RMB exits the procedure.
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;   Loads new color tables
;  
; EXAMPLE:  
;   
;   tvim,replicate(1,2) # indgen(!p.color),/scale,range=[0,!p.color],/asp & lct
;
; AUTHOR:   Paul Ricchiazzi                        30 Aug 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if !d.name ne 'X' then return

if not keyword_set(index) then index=0
names=''
loadct,index,/silent,get_names=names
print,f='($,x,i2,2x,a,a)',index,names(index),string("15b)
blank='                           '
!err=0
device,cursor_standard=16
tvcrs,100,100

while !err ne 4 do begin
  cursor,xdum,ydum,/wait,/device
  if !err eq 1 then index=(index+50-1) mod 50
  if !err eq 2 then index=(index+1) mod 50
  loadct,index,/silent
  print,f='($,x,i2,2x,a,a,a)',index,names(index),blank,string("15b)
  wait,.1
endwhile
device,cursor_standard=30
print,' '
return
end  
