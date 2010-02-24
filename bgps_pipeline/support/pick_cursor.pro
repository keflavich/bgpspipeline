 PRO pick_cursor
;+
; routine:   pick_cursor
; useage:    pick_cursor
; inputs:    none
; outputs:   none
; side effects:
;            changes the graphics cursor
;
; procedure  cycle through different cursor types by hitting the
;            the left or middle mouse button.  Hit the right mouse button
;            to exit
; 
;  author:  Paul Ricchiazzi                            aug93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

!err = 0
tvcrs,100,100
i = 0
imax = 152
WHILE !err NE 4 DO begin
  cursor,x,y,/wait
  IF !err EQ 1 THEN i = i-1
  IF !err EQ 2 THEN i = i+1
  IF i GT imax THEN i = 0
  IF i LT 0 THEN i = imax
  device,cursor_standard = i
  print,f='(i3,a,$)',i,string("15b)
  wait,.2
ENDWHILE
print,f='(i3,a,$)',i
END
