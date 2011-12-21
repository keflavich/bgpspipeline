;Returns a four-element vector that is the min, max, mean, 
; and median of the given array.
; ;
; ;Written by C. Battersby April 9, 2009
; ;updated by A. Ginsburg April 15th, 2011
;
FUNCTION mmmmm, x, doprint=doprint, dostring=dostring
compile_opt idl2
 On_error,2                              ;Return to caller

 info = [min(x, /nan), max(x, /nan), mean(x, /nan), median(x), stddev(x,/nan), mad(x)]
 if keyword_set(doprint) then begin
     print,"min,max,mean,median,std,mad: ",info
 endif
 if keyword_set(dostring) then begin
     return,string(info,format="(6F10.3)",/print)
 endif

 RETURN, info

END

