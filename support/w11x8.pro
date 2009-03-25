pro w11x8,free=free
;+
; ROUTINE:  w11x8
;
; PURPOSE:  create a window which approximates the aspect ratio of a
;           8.5 x 11 piece of paper in landscape orientation
;
; USEAGE:   w11x8
;
; INPUT:    none
;
; KEYWORD INPUT:
;  free     if set, window,/free is used to create a new window
;
; EXAMPLE:  
;
;    w11x8
;    plot,dist(20)   
;
; AUTHOR:   Paul Ricchiazzi                        03 Aug 93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

if !d.name ne 'X' then return
device,get_screen_size=sz
xs=sz(1)-30
ys=fix(8.5*xs/11.)
case 1 of 
 keyword_set(free): window,/free,xs=xs,ys=ys
 !d.window eq -1:   window,0,xs=xs,ys=ys 
 else:              window,!d.window,xs=xs,ys=ys
endcase
return
end
