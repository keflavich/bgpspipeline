pro thick,thck,cthck
;+
; ROUTINE:    thick
;
; PURPOSE:    thicken lines and characters on postscript output.
;
; USEAGE:     thick,thck,cthck
;
; INPUT:      thck        the thickening factor.
;                         if not set all graphics system variables
;                         related to line thickness are set to 1
;
;             cthck       character thickening factor, if CTHCK is not
;                         not set or equal to zero then it defaults to 
;                         1+.5*(thck-1) if not set.
;
;
; OUTPUT:     none
;
; SIDE EFFECTS:  changes the values of system varaibles as follows
;
;            !p.charthick=cthck
;
;            !p.thick=thck
;            !x.thick=thck
;            !y.thick=thck
;
;
; PROCEDURE:  a thickening factor of 3 is a good value to use for
;             plots on the Phaser color printer.  and 5 is good for
;             very bold lines.  2 is good enough for the low resolution
;             printers
;  
;  author:  Paul Ricchiazzi                            feb94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if !d.name eq 'X' then begin
  thk=1 
  !p.thick=thk
  !p.charthick=thk
  !x.thick=thk
  !y.thick=thk
endif else begin
  if keyword_set(thck) eq 0 then thck=3
  if not keyword_set(cthck) then cthck=.5*(thck-1.)+1.
  !p.charthick=cthck
  !p.thick=thck
  !x.thick=thck
  !y.thick=thck
endelse

end
