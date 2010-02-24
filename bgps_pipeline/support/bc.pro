pro bc
;+
; NAME:
;        bc
;
; PURPOSE:
;        wall to wall cross hairs to help read numbers off of plot
;        axis. The graphics function is set to 6 for eXclusive OR.
;        This allows the cross hairs to be drawn and erased without
;        disturbing the contents of the window.  Hit RMB to exit
;
; CALLING SEQUENCE:
;        bc
;
; INPUTS/OUTPUTS: none
;
; RESTRICTIONS:
;        Works only with window system drivers.
;
; CATEGORY:
;        Interactive graphics.
;
;
; author   Paul Ricchiazzi      April, 1993
;-

device, cursor_standard=33,get_graphics = old, set_graphics = 6   ;Set xor
!err=0
ox=!d.x_vsize/2
oy=!d.y_vsize/2
tvcrs,ox,oy
plots,[0,!d.x_vsize],[oy,oy],/device
plots,[ox,ox],[0,!d.y_vsize],/device
while !err ne 4 do begin 
  cursor,x,y,/nowait,/device
  if x ne ox or y ne oy then begin
    plots,[0,!d.x_vsize],[oy,oy],/device
    plots,[ox,ox],[0,!d.y_vsize],/device 
    plots,[0,!d.x_vsize],[y,y],/device
    plots,[x,x],[0,!d.y_vsize],/device
    wait,.1
    ox=x
    oy=y
  endif
endwhile
plots,[0,!d.x_vsize],[y,y],/device         ; erase cross hairs
plots,[x,x],[0,!d.y_vsize],/device
device,set_graphics=old,cursor_standard=30
return
end
