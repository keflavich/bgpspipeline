 pro hilite, im,select,rate,keep=keep,zoom=zoom
;+
; ROUTINE:     hilite,im,select
;
; EXAMPLE:     hilite,avhrr1,where(avhrr3-avhrr4 lt 5.)
;
; PURPOSE:     To hilite a region which satifies a specified set of 
;              conditions
;
; INPUT:       im          2-D image array (any type but string)
;              select      Index array of points to hilite.  These may be
;                          generated with the WHERE proceedure.
;              rate        rate of flicker
;
; KEYWORD INPUT:
;              keep        do not destroy window on exit
;              zoom        2 element vector which specifies zoom factor
;                          in x and y direction
;
; OUTPUT:                  NONE
; COMMON BLOCKS:           NONE
; SIDE EFFECTS:            Creates and uses a new window 
; 
; PROCEEDURE:  Selected region is hilighted by use of the FLICK proceedure.
;
; EXAMPLE
;
;    c=cmplxgen(100,100,/cent)/20
;    s=sin(float(c+c^2))
;    mve,c
;    hilite,s,where(float(c+c^4) gt 1. and imaginary(c+c^4) lt 1.),zoom=2
;
;  author:  Paul Ricchiazzi                            sep92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
sz=size(im)
ws=!d.window
if keyword_set(rate) eq 0 then rate=2
sz=size(im)
nn=sz(1:2)
im1=bytscl(im)
im2=im1
im2(select)=(im1(select)+128) mod 256
if n_elements(zoom) ne 0 then begin
  nn=nn*zoom
  im1=congrid(im1,nn(0),nn(1))
  im2=congrid(im2,nn(0),nn(1))
endif

window,/free,xs=nn(0),ys=nn(1),title='flick image'

flick,im2,im1,rate
if keyword_set(keep) ne 0 then tv,im2 else wdelete,!d.window 
if ws ge 0 then wset,ws
return
end



