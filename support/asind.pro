function asind, value

;+
; NAME:
;       ASIND
;
; PURPOSE:
;       Return the inverse sine of a value, in degrees rather then radians.
;
; CALLING SEQUENCE:
;       deg = asind(x)
;
; INPUTS:
;       value      sine of angle 
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       Angle in degrees returned.
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

   return, asin(value)/!dtor

end
