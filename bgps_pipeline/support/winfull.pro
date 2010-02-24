pro winfull
;+
; ROUTINE:  winfull
;
; PURPOSE:  create full screen window 
;
; USEAGE:   winfull
;
; INPUT:    
;
; KEYWORD INPUT:
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
; AUTHOR:   Paul Ricchiazzi                        30 May 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-

if !d.name ne 'X' then return
device,get_screen_size=sz
xs=sz(0)
ys=sz(1)
window,/free,xs=xs,ys=ys
return
end
