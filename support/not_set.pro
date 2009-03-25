function not_set, array1, array2, maxarr=maxarr

;+
; NAME:
;       NOT_SET
;
;  otherwise known as 'set...NOT!' thanks to Paul Ricchiazzi
;
; PURPOSE:
;       Return the values of array2 that are not in array1.  If array2 
;       not defined, use lindgen(max(array1+1))
;
; CATEGORY:
;       Array manipulation.
;
; CALLING SEQUENCE:
;       array3 = not_set(array1, array2)
;
; INPUTS:
;       array1     
;
; OPTIONAL INPUTS:
;       array2       See PURPOSE.
;       maxarr       If array2 not defined, use this length rather 
;                    than max(array1+1))    
;
; OUTPUTS:
;       See PURPOSE.
;
; EXAMPLE:
;     x = [0,2,3,4,6,7,9]
;     y = [3,6,10,12,20]
;
;     print,intersect(x,y)
;      3       6
;
;     print,intersect(x,y,/xor_flag)
;      0       2       4       7       9      10      12      20
;
;     print,not_set(x,y)
;       0       2       4       7       9     
;
;     print,not_set(x)
;           1           5           8
;
;     print,not_set(x,maxarr=15)
;           1           5           8          10          11          12
;         13          14
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

    if (n_elements(array2) eq 0) then begin
       if (n_elements(maxarr) eq 0) then maxarr = max(array1+1)
       array2 = lindgen(maxarr)
       return, intersect(array1,array2,/xor_flag) 
    endif else begin
       xor_set = intersect(array1,array2,/xor_flag) 
       return,intersect(array1,xor_set)
    endelse

end
