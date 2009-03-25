 pro wselect
;+
; ROUTINE:    wselect
;
; PURPOSE:    wset to window selected by a mouse click
;
; USEAGE:     wselect
;
; INPUT:      none
;
; OUTPUT:     none
;
;  author:  Paul Ricchiazzi                            11jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
device,window_state=ws
nw=n_elements(ws)
chosen=-1
repeat begin
  for i=0,nw-1 do begin
    if ws(i) eq 1 then begin
      wset,i
      cursor,xdum,ydum,/device,/nowait
      if !err ne 0 then chosen=i
    endif
  endfor
endrep until chosen ne -1
wset,chosen
cursor,xdum,ydum,/device,/up
end
