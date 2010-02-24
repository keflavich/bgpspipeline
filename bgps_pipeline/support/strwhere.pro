function strwhere,starr,wildcard,orchar=orchar
;+
; ROUTINE:  strwhere
;
; PURPOSE:  a "where" operator for strings matching a set of string 
;           wild cards
;
; USEAGE:   result=strwhere(starr,wildcard)
;
; INPUT:    
;   starr   an array of strings                   
;
; wildcard  wild card specifier composed of regular and special
;           characters.  The special characters are  asterisk '*'
;           and vertical bar '|'.  The asterisk matches any number of
;           characters the vertical bar indicates an "or" operation
;           between different wild card specifications.
;
; KEYWORD INPUT:
;
;   orchar  character used to indicate "or" wildcard operation.
;           (default = '|')
;
; OUTPUT:
;   result  an index array such that starr(result) = those elements of
;           STARR that match the wild card specification in WILDCARD
;   
;
; EXAMPLE:  
;
;  f=findfile(/home/paul/arm/arese/bsrn/sgpbsrnC1.a1.*.cdf)
;  clrdays='*1018*|*1022*|*1030*'
;  print,f(strwhere(f,clrdays))
;
; AUTHOR:   Paul Ricchiazzi                        14 Jan 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if not keyword_set(orchar) then orchar='|'
wild=str_sep(wildcard,orchar)
ns=n_elements(starr)
nt=n_elements(wild)
ii=[0]

for is=0,ns-1 do begin
  itest=0
  for it=0,nt-1 do begin
    itest=itest > strmatch(starr(is),wild(it))
  endfor
  if itest eq 1 then ii=[ii,is]
endfor
return,ii(1:*)
end
