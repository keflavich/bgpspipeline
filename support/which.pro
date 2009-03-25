function which, file_in
;+
; $Log: which.pro,v $
; Revision 1.1  2003/10/22 09:29:55  observer
; *** empty log message ***
;
; Revision 1.1  2003/10/22 09:19:31  observer
; *** empty log message ***
;
; Revision 1.1.1.1  2001/09/29 00:01:04  observer
; Initial import
;
; $Id: which.pro,v 1.1 2003/10/22 09:29:55 observer Exp $
; looks for the routine file_in and returns the full path to the file
; 
; file_in = string, name of procedure or function
;           must be in the idl search path
;           may end in '.pro', but need not
; file_out = string, full path of the routine, empty if nothing found
;
; SG 2000/07/25
;-

common USER_COMMON

file_out = ''

ntemp = strlen(file_in)
if (ntemp ge 4) then begin
   if (strmid(file_in,ntemp-4,4) eq '.pro') then begin
      file_in = strmid(file_in,0,ntemp-4)
   endif
endif

path_temp = str_sep(!PATH,IDL_PATHSEP)

found = 0
k = 0
repeat begin
   search_in = path_temp[k] + IDL_FILESEP + file_in + '.pro'
;   print, search_in
   file_out = findfile(search_in)
;   print, file_out
   temp = strlen(file_out)
   temp = temp[0]
   if temp ne 0 then begin
      found = 1
   endif
   k = k + 1
endrep until (found OR k GE n_elements(path_temp))

; do this to convert to a string from string array
file_out = file_out[0]
   
return, file_out

end
