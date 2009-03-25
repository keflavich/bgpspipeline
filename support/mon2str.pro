function mon2str, mon, type

;+
; NAME:
;       MON2STR
;
; PURPOSE:
;       Return a string containing a month's name.
;
; CALLING SEQUENCE:
;       mon_name = mon2str(1)
;
; INPUTS:
;       mon      month desired. NOTE:  mon is 1-based (e.g., January = 1)
;
; OPTIONAL INPUTS:
;       type     string defining type of string desired:
;                   undefined:   full string, first letter capitalized
;                                e.g., 'December'
;                   'short':     abbreviated string, uncapitalized; three
;                                letter abbreviations except September
;                                e.g., 'dec', 'sept'
;                'capshort':     abbreviated string, capitalized; three
;                                letter abbreviations e.g., 'Dec', 'Sep'
;
; OUTPUTS:
;       An string is returned.
;
; EXAMPLE:
;      print,mon2str(12)
;      December
;
;      print,mon2str(12,'short')
;      dec
;
;      print,mon2str(9,'short')
;      sept
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


   if (n_elements(type) eq 0) then begin
      monarr = ['January','February', 'March','April', 'May', 'June', $
         'July', 'August', 'September', 'October', 'November', 'December']
   endif else if (type eq 'short') then begin
      monarr = ['jan','feb', 'mar','apr', 'may', 'jun', $
         'jul', 'aug', 'sept', 'oct', 'nov', 'dec']
   endif else if (type eq 'capshort') then begin
      monarr = ['Jan','Feb', 'Mar','Apr', 'May', 'Jun', $
         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
   endif

   return, monarr(mon-1)

end
