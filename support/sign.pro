function sign, val
;+
; NAME:
;	sign
;
; PURPOSE:
;	Returns the sign of the argument: +1 for > 0, -1 for < 0, 0
;	for 0
;
; CALLING SEQUENCE:
;	result = sign(val)
;
; INPUTS:
;	val: an input numeric matrix.  Can be any dimension.
;
; OUTPUTS:
;	Sign of argument as indicated above.
;
; MODIFICATION HISTORY:
; 	2002/05/17 SG
;-

result = 1 * (val gt 0.) - 1 * (val lt 0.)

return, result

end
