pro endps,notime=notime

;+
; NAME:
;       ENDPS
;
; PURPOSE:
;         close postscript file, reopen display
;
; CALLING SEQUENCE:
;       ENDPS
;
; INPUTS:
;
; KEYWORD INPUTS:
;        notime     don't timestamp
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; EXAMPLE:
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
;     Jeff Hicke     Earth Space Research Group, UCSB  9/22/92
;
; MODIFICATION HISTORY:
;
;-
;

if (keyword_set(notime) eq 0) then timestamp

device,/close_file
set_plot,'X'

!p.font = -1

end
