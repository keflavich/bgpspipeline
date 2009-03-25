 function cmplxgen,nx,ny,center=center
;+
; ROUTINE:      cmplxgen
;
; USEAGE:       result=cmplxgen(nx,ny[,/center])
;
; INPUT:
;   nx,ny       dimensions of output
; 
; KEYWORD INPUT:
;   center      if set RESULT is shifted so that the (0,0) point
;               is the central element of the complex array
;
; OUTPUT:     
;               float(result)     = array of column indecies
;               imaginary(result) = array of row indecies
;
; EXAMPLE:      r=cmplxgen(4,3)
;
;                          0 1 2 3                      0 0 0 0
;               float(r) = 0 1 2 3       imaginary(r) = 1 1 1 1
;                          0 1 2 3                      2 2 2 2
;
; AUTHOR:       Paul Ricchiazzi              oct92
;               Earth Space Research Group,  UCSB
;-
ix=indgen(nx)
iy=indgen(ny)
ix=ix # replicate(1,ny)
iy=replicate(1,nx) # iy
if keyword_set(center) then begin
  return,complex(ix,iy)-complex(nx,ny)/2
endif else begin
  return,complex(ix,iy)
endelse
end
