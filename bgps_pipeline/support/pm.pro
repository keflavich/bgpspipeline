pro pm, row, col

;+
; NAME:
;       PM
;
; PURPOSE:
;       Shorthand way of setting !p.multi.
;
; CALLING SEQUENCE:
;       PM,1,2
;
; INPUTS:
;
; OPTIONAL INPUTS:
;   row     Sets number of plots per row
;   col     Sets number of plots per col
;
; OUTPUTS:
;
; PROCEDURE
;
; COMMON BLOCKS:
;       None.
;
; NOTES
;
; REFERENCES
; 
; AUTHOR and DATE:
;     Jeff Hicke     Earth Space Research Group, UCSB  12/03/93
;
; MODIFICATION HISTORY:
;
;-
;

  if (n_elements(row) eq 0) then row = 0
  if (n_elements(col) eq 0) then col = 0

  !p.multi=[0,row,col]

end
