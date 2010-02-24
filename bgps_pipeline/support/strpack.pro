function strpack,input,format=format
   
;+
; PURPOSE:
;       Convert to string by executing STRING and STRCOMPRESS
;
; INPUTS:
;       input     variable (any type) to be converted to string
;
; OPTIONAL INPUTS:
;       format    optional format statement ala FORTRAN
;
; OUTPUTS:
;       Returns string, compressed.
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
;     Jeff Hicke     06/24/93
;
; MODIFICATION HISTORY:
;
;-
;

   if (keyword_set(format) eq 0) $
   then return,strcompress(string(input),/remove_all)  $
   else return,strcompress(string(input,format=format),/remove_all)

end
