function acosd, value

;+
; NAME:
;       ACOSD
;
; PURPOSE:
;       Return the inverse cosine of a value, in degrees rather then radians.
;
; CALLING SEQUENCE:
;       deg = acosd(x)
;
; INPUTS:
;       value      cosine of angle 
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

   return, acos(value)/!dtor

end
