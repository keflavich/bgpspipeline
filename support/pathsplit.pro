; 
; Split a string into "path" and "suffix"
; should be equivalent to Python's os.path.split command
; note that it DOES return the trailing "/" and it only splits on "/"
;
; KEYWORDS:
;   return_filename - instead of returning the path prefix, return the whole filename
;
function pathsplit,str,return_filename=return_filename

    splitpoints = strsplit(str,'/')
    last_slash = splitpoints[n_elements(splitpoints)-1]

    if keyword_set(return_filename) then begin
      return,strmid(str,last_slash)
    endif else begin
      return,strmid(str,0,last_slash)
    endelse
end
