function cosd, angle

;+
; NAME:
;       COSD
;
; PURPOSE:
;       Return the cosine of an angle specified in degrees rather than radians.
;
; CALLING SEQUENCE:
;       x = cosd(deg)
;
; INPUTS:
;       angle   angle in degrees
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       Cosine of angle returned.
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

   return, cos(angle*!dtor)

end
