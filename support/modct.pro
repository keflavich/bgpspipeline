pro modct, ct, low=low, high=high, gamma=gamma, bar=bar, xps=xps,  $
           cvi=cvi,cvf=cvf
;+
; name:
;	modct
;
; purpose:
;	modify the image display color tables so the full range 
;	runs from one color index to another.
;
; category:
;	image processing, point operations.
;
; calling sequence:
;	modct, ct, low=low, high=high, gamma=gamma, ct=ct,bar=bar
;
; input:
;      ct       color table index.  if not supplied current color table
;               is modified.
;
; keyword inputs:
;	low:	starting point of color range interpolation
;               as a fraction of the current color table. 
;               use keyword clrbar to see current table.
;               default=0
;
;	high:	ending point of color range interpolation as
;               a fraction of current color table.
;               default=1. if high<low color table is reversed
;
;	gamma:	gamma correction factor.  if this value is omitted, 0 is 
;		assumed.  gamma correction works by shifting the color indices
;               by a hyperpolic function as follows,
;
;                 new_index = old_index*(gamma-2)/(2*gamma*old_index-gamma-2)
;
;               assuming the old index range is scaled into the range 0 - 1.
;               note that this function returns 0 for old_index=0 and
;               1 for old_index=1.  intermediate values are modified such
;               that the upward color shift obtained by gamma=+g is as large
;               as the downward color shift obtained with gamma=-g.  valid 
;               values of gamma are in the range -2 to 2
;
;   cvi,cvf:    mapping of intital color vector values to final color
;               vector values.  cvi(i) gets mapped to cvf(i) 
;
;               for example
;
;                  cvi=[0,.2,.5,1] & cvf=[0,.1,.3,1]
;
;               maps the colors which used to be indexed at 0,.2,.5,1
;               to new indecies at 0,.1,.3,1 (where "index" means position
;               in color spectrum, scaled from 0 to 1.
;
;       bar:    if set draw a color bar of the specified or default color
;               table and quit
;
;       xps:    if set, use tvlct to load appropriate black and white
;               as foreground/background colors (and vice versa) for ps 
;               and X.
;
; OUTPUTS:
;	No explicit outputs.
;
; COMMON BLOCKS:
;	COLORS:	The common block that contains R, G, and B color
;		tables loaded by LOADCT, HSV, HLS and others.
;
; SIDE EFFECTS:
;	Image display color tables are loaded.
;
; RESTRICTIONS:
;	Common block COLORS must be loaded before calling MODCT.
;
; PROCEDURE:
;	New R, G, and B vectors are created by linearly interpolating
;	the vectors in the common block from Low to High.  Vectors in the 
;	common block are not changed.
;
;	If NO parameters are supplied, the original color tables are
;	restored.
;
; EXAMPLE:
;	Load the STD GAMMA-II color table by entering:
;
;		LOADCT, 5
;
;	Create and display and image by entering:
;
;		TVSCL, DIST(300)
;
;	Now adjust the color table with MODCT.  Make the entire color table
;	fit in the range 0 to 70 by entering:
;
;		MODCT, low=.5,high=1,gam=1
;
; MODIFICATION HISTORY: Based on IDL user_lib procedure STRETCH
; 
;  Modified by Paul Ricchiazzi, ESRG/ICESS/UCSB, 5nov92 to use hyperbolic
;  function for  gamma correction.  This improves the symmetry of the
;   correction.
;-
;
if n_elements(ct) ne 0 then loadct,ct

if keyword_set(bar) then begin
  color_bar,findrng(0,1,11),pos=[0.12,0.1,0.92,0.2]
  return
endif

tvlct,r,g,b,/get

on_error,2                      ;Return to caller if error
nc = !d.table_size              ;# of colors entries in device
if nc eq 0 then message, $
   "Device has static color tables.  Can't modify.'

if n_elements(r) le 0 then begin ;color tables defined?
  r=indgen(nc)
  g=r
  b=r
endif

if n_elements(low) eq 0 then low=0.
if n_elements(high) eq 0 then high=1.
if n_elements(gamma) eq 0 then gamma=0.

if high eq low then return      ;Nonsensical
nc=!d.n_colors

if n_elements(cvi) ne 0 then begin
  p=interpol(cvi,cvf,findrng(0.,1.,nc))
endif else begin
  if gamma eq 0.0 then begin    ;Simple case
    p = findrng(low,high,nc)
  endif else begin              ;Gamma ne 0
    gam=gamma > (-1.99) < 1.99  ;valid gamma values
    p = findrng(0.,1.,nc)
    p = p*(gam-2)/(2*gam*p-gam-2)
    p = low+(high-low)*p
  endelse
endelse

i=fix(p*(nc-1))
tvlct,r(i),g(i),b(i)

if !d.name eq 'X' then begin
  tvlct,0,0,0,0 
  tvlct,255,255,255,!p.color 
endif else begin
  tvlct,255,255,255,0
  tvlct,0,0,0,!p.color
endelse

	return
end

