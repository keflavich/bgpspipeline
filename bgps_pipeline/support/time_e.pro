pro time_e, t0, prtmsg=prtmsg, t1=t1

; +
; 
; NAME:
;       TIME_E
;
; $Id: time_e.pro,v 1.1 2008/02/23 03:01:35 jaguirre Exp $
;
; PURPOSE:
;
;       Computes the time elapsed between the system time passed it
;       and the current time, and optionally returns the time
;       difference in a variable.  The system time will usually have
;       been initially computed by TIME_S.  This routine is useful for
;       debugging and finding out where a program is spending most of
;       its execution time.
; 
; MODIFICATION HISTORY:
;
; $Log: time_e.pro,v $
; Revision 1.1  2008/02/23 03:01:35  jaguirre
; Added to the archive.
;
;
;-

t1 = systime(/sec)-t0

if keyword_set(prtmsg) then begin
    print,prtmsg,strcompress(systime(/sec)-t0,/rem)+' sec.'
endif else begin
    print,strcompress(systime(/sec)-t0,/rem)+' sec.'
endelse

end
