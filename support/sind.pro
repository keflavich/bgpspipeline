function sind, angle

;+
; NAME:
;       SIND
;
; PURPOSE:
;       Return the sine of an angle specified in degrees rather than radians.
;
; CALLING SEQUENCE:
;       x = sind(deg)
;
; INPUTS:
;       angle   angle in degrees
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       Sine of angle returned.
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

   return, sin(angle*!dtor)

end
