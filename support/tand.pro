function tand, angle

;+
; NAME:
;       TAND
;
; PURPOSE:
;       Return the tangent of an angle specified in degrees rather than radians.
;
; CALLING SEQUENCE:
;       x = tand(deg)
;
; INPUTS:
;       angle   angle in degrees
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       Tangent of angle returned.
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
;     Jeff Hicke     Earth Space Research Group, UCSB  12/07/93
;
; MODIFICATION HISTORY:
;
;-
;

   return, tan(angle*!dtor)

end
