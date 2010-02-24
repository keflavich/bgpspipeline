pro jul2day,julday,year,mon,day,outyear

;+
; NAME:
;       JUL2DAY
;
; PURPOSE:
;       Convert the inputted Julian day of year to year, month, day.
;
; CALLING SEQUENCE:
;       jul2day,julday,year,mon,day
;
; INPUTS:
;         julday      Julian day, ranges from 1-365(366)
;         year
;
; KEYWORD INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;         mon         ranges from 1-12
;         day         ranges from 1-31
;
; OPTIONAL OUTPUTS:
;         outyear     output year; if different from input year (when julday
;                     > 365/366 or < 1)
;
; EXAMPLE:
;
; PROCEDURE
;
; COMMON BLOCKS:
;       None.
;
; NOTES
;         The input variable julday can be zero or negative.  Zero indicates
;         the last day of the previous year (12/31), -1 indicates 12/30,
;         and so on.
;
; REFERENCES
; 
; AUTHOR and DATE:
;     Jeff Hicke     Earth Space Research Group, UCSB  10/25/92
;
; MODIFICATION HISTORY:
;
;-
;

   jday = long(julday) + ymd2jd(year-1,12,31)
   jd2ymd, jday, outyear, mon, day

end
