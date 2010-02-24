function day2jul,mon,day,year

;
;  REQUIRED INPUTS:
;         mon         ranges from 1-12
;         day         ranges from 1-31
;         year        
;
;  OUTPUTS:
;         julday      Julian day, ranges from 1-365(366)
;
;  AUTHOR:
;         Jeff Hicke
;
;  DATE:
;         11/16/93
;

   jday = ymd2jd(year,mon,day) - ymd2jd(year,1,1) + 1.

   return,jday

end
