function repchr,n,c
;+
; ROUTINE:    repchr
;
; PURPOSE:    produces a string composed of repititions of a given character
;
; USEAGE:     result=repchr(n,c)
;
; INPUT:
;    n        number of repititions
;    c        character to repeat
;
; EXAMPLE:
;             print,repchr(20,'-')
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

strng=bytarr(n)
if n_elements(c) gt 0 then strng(*)=byte(c) else strng(*)=32b
return,string(strng)
end
