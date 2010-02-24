pro ei

;+
; NAME:
;       EI
;
; PURPOSE:
;       Set the system variable to allow for large pasting of data using
;       X.  Only necessary for the alphas.  This has the side effect of 
;       not allowing use of the editing (arrow) keys.  This procedure
;       toggles this ability on and off.  NOTE:  This is probably a bug
;       in IDL and therefore the need for this procedure will disappear in
;       the near future.
;
; CALLING SEQUENCE:
;       ei
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; EXAMPLE:
;     ei
;     ... paste in large amts of data ...
;     ei
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
;     Jeff Hicke     Earth Space Research Group, UCSB  1/04/94
;
; MODIFICATION HISTORY:
;
;     Added change of prompt  Jeff Hicke   05/20/94
;-
;

   !edit_input = ( (!edit_input < 1) + 1) mod 2

   if (!edit_input eq 1)   $
   then !prompt = 'IDL> '  $
   else !prompt = 'IDL_EI> '

end
