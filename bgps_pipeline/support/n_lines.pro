function n_lines,file
;+
; ROUTINE:  numlines
;
; PURPOSE:  count number of lines in a file
;
; USEAGE:   result=numlines(file)
;
; INPUT:    
;   file    file name
;
; OUTPUT:
;   result  number of lines in file
;
; EXAMPLE: 
;
;  print,n_lines('/local/idl/user_contrib/esrg/n_lines.pro') 
;
; AUTHOR:   Paul Ricchiazzi                        29 Feb 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

spawn,['wc',file],result,/noshell
nl=0L
if result(0) ne '' then reads,result,nl
return,nl
end
