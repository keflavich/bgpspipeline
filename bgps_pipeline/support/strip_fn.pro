function strip_fn, filename

;+
; NAME:
;       STRIP_FN 
;
; PURPOSE:
;       Return a filename stripped of all directory information.
;
; CALLING SEQUENCE:
;       result = strip_fn(filename)
;
; INPUTS:
;       filename      filename to be stripped.  Can be scalar or vector.
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;       stripped filename.  Same type (vector/scalar) as input filename.
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
;     Jeff Hicke     8/12/93
;
; MODIFICATION HISTORY:
;     JAH  8/13/93   Added filename vector capability.
;
;-
;

   stripped_filename = strarr(n_elements(filename))

   for i=0,(n_elements(filename)-1) do begin
      stripped_filename(i) = filename(i)
      pos_slash = strpos(stripped_filename(i),'/')
   
      while (pos_slash ne -1) do begin
         stripped_filename(i) = strmid(stripped_filename(i),pos_slash+1,   $
            strlen(stripped_filename(i)))
         pos_slash = strpos(stripped_filename(i),'/')
      endwhile

   endfor

   if (n_elements(filename) eq 1) then stripped_filename = stripped_filename(0)

   return,stripped_filename

end
