function redundant,array,count,all=all,non=non,indecies=indecies
;+
; ROUTINE:	    redundant
;
; PURPOSE:	    returns the indicies of elements array which are non-unique
;
; USEAGE:	    result=redundant(array)
;
; INPUT:       
;   array           a vector array
;
;
; KEYWORD INPUT:
;
;   all             if set, return all elements which appear more than
;                   once. The default is to return all but one of the
;                   replicated elements
;
;   non             If set, return all non-redundant elements.  If ALL
;                   is also set, return those elements which appear
;                   only once, (i.e., all replicated items are left off
;                   the list).
;
;   indecies        If set return array indecies instead of the array 
;                   elements.
; EXAMPLE:
;;
;           array=[1,2,3,1,4,2,3,3,5]
;
;           print,array
;;       1       2       3       1       4       2       3       3       5
;
;           print,redundant(array)
;        1       2       3       3
;
;           print,redundant(array,/non)
;;       1       4       2       3       5
;
;           print,redundant(array,/all)
;;       1       2       3       1       2       3       3
;
;           print,redundant(array,/all,/non)
;;       4       5
;
;           print,redundant(array,/all,/non,/indecies)
;        4       8
;
;
;  author:  Paul Ricchiazzi                            feb95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;


nn=n_elements(array)
sord=sort(array)

case 1 of
  keyword_set(all) and keyword_set(non): begin
    rr=where((array(sord) ne shift(array(sord),-1)) and $
              (array(sord) ne shift(array(sord),1)) ,count)
  end
  keyword_set(all): begin
    rr=where((array(sord) eq shift(array(sord),-1)) or $
             (array(sord) eq shift(array(sord),1)) ,count)
  end
  keyword_set(non): begin
    rr=where((array(sord) ne shift(array(sord),-1)),count)
  end
  else: begin
    rr=where(array(sord) eq shift(array(sord),-1),count)
  end
endcase

if count eq 0 then begin

  return,[-1]

endif else begin

  rrr=sord(rr)
  if keyword_set(indecies) then begin
    return,rrr(sort(rrr))
  endif else begin
    return,array(rrr(sort(rrr)))
  endelse    

endelse

end
