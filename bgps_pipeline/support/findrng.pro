 function findrng,x1,x2,x3,dx=dx
;+
; useage:      findrng,x1,x2,x3
; purpose:     generates x3 floating point numbers 
;                 spanning range x1 to x2 
;
; KEYWORD
;   dx     if set ignor x3 and compute number of elements with 1+(x2-x1)/dx
;           where dx is the increment
; 
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
if n_elements(x1) eq 2 then begin
  if keyword_set(dx) then nel=1+(x1(1)-x1(0))/dx else nel=x2
  return,x1(0)+(x1(1)-x1(0))*findgen(nel)/(nel-1)
endif else begin
  if keyword_set(dx) then nel=1+(x2-x1)/dx else nel=x3
  return,x1+(x2-x1)*findgen(nel)/(nel-1)
endelse
end
