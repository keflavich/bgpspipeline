pro time_s, message, t0, no_sticky = no_sticky

; +
; 
; NAME:
;	TIME_S
;
; $Id: time_s.pro,v 1.1 2008/02/23 03:01:35 jaguirre Exp $
;
; PURPOSE:
;
;       Records the system time t0 and optionally prints a message.
;       The time elapsed between a call to TIME_S and a subsequent
;       call to TIME_E can be measured by passing TIME_E the same
;       system time t0.  This routine is useful for debugging and
;       finding out where a program is spending most of its execution
;       time.
; 
; MODIFICATION HISTORY:
;
; $Log: time_s.pro,v $
; Revision 1.1  2008/02/23 03:01:35  jaguirre
; Added to the archive.
;
;
;-

if keyword_set(no_sticky) then begin

    print, message
    t0 = systime(/sec)

endif else begin

    print, message, format = '(a,$)'
    t0 = systime(/sec)

endelse

end
